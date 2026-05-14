<?php

require_once __DIR__ . '/../Repository/UserRepository.php';
require_once __DIR__ . '/../Repository/AuthTokenRepository.php';

class AuthService
{
    private $users;
    private $tokens;

    public function __construct()
    {
        $this->users = new UserRepository();
        $this->tokens = new AuthTokenRepository();
    }

    public function login($email, $plainPassword)
    {
        $user = $this->users->findByEmail($email);
        if (!$user) {
            return null;
        }

        if (!$this->verifyAndUpgradePassword($user, $plainPassword)) {
            return null;
        }

        $token = bin2hex(random_bytes(32));
        $expiresAt = date('Y-m-d H:i:s', strtotime('+7 days'));
        $this->tokens->createToken((int) $user->id, $token, $expiresAt);

        return array(
            'token' => $token,
            'expires_at' => $expiresAt,
            'user' => array(
                'id' => (int) $user->id,
                'full_name' => $user->full_name,
                'display_name' => $user->display_name,
                'email' => $user->email,
                'user_status' => $user->user_status,
            ),
        );
    }

    public function validateToken($token)
    {
        $tokenRow = $this->tokens->findActiveToken($token);
        if (!$tokenRow) {
            return null;
        }

        return $this->users->findModelById((int) $tokenRow['user_id']);
    }

    public function logout($token)
    {
        return $this->tokens->revokeByToken($token);
    }

    public function requestPasswordReset($email)
    {
        $expiresAt = date('Y-m-d H:i:s', strtotime('+30 minutes'));
        $token = bin2hex(random_bytes(32));
        $user = $this->users->findByEmail($email);

        // Avoid account enumeration. Always return a valid-shaped response.
        if ($user) {
            $this->tokens->createPasswordResetToken((int) $user->id, $token, $expiresAt);
        }

        return array(
            'reset_token' => $token,
            'expires_at' => $expiresAt,
        );
    }

    public function resetPasswordByToken($token, $newPassword)
    {
        $tokenRow = $this->tokens->findActivePasswordResetToken($token);
        if (!$tokenRow) {
            return false;
        }

        $updated = $this->updatePassword((int) $tokenRow['user_id'], $newPassword);
        if (!$updated) {
            return false;
        }

        $this->tokens->consumePasswordResetToken($token);
        return true;
    }

    public function hashPassword($plainPassword)
    {
        return password_hash($plainPassword, PASSWORD_BCRYPT, ['cost' => 12]);
    }

    public function updatePassword($userId, $newPassword)
    {
        $hash = $this->hashPassword($newPassword);
        return $this->users->updatePasswordHash((int) $userId, $hash);
    }

    private function verifyAndUpgradePassword($user, $plainPassword)
    {
        $storedHash = isset($user->password_hash) ? $user->password_hash : null;
        if (!$storedHash) {
            return false;
        }

        if (password_verify($plainPassword, $storedHash)) {
            if (password_needs_rehash($storedHash, PASSWORD_BCRYPT, array('cost' => 12))) {
                $this->users->updatePasswordHash((int) $user->id, $this->hashPassword($plainPassword));
            }
            return true;
        }

        if ($this->isLegacyPasswordMatch($plainPassword, $storedHash)) {
            $this->users->updatePasswordHash((int) $user->id, $this->hashPassword($plainPassword));
            return true;
        }

        return false;
    }

    private function isLegacyPasswordMatch($plainPassword, $storedHash)
    {
        // Transitional compatibility for legacy records before full migration.
        if (hash_equals($storedHash, $plainPassword)) {
            return true;
        }

        if (hash_equals($storedHash, md5($plainPassword))) {
            return true;
        }

        if (hash_equals($storedHash, sha1($plainPassword))) {
            return true;
        }

        return false;
    }
}
