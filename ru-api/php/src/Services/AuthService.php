<?php

require_once __DIR__ . '/../Repository/UserRepository.php';
require_once __DIR__ . '/../Repository/AuthTokenRepository.php';
require_once __DIR__ . '/../Repository/UserRoleRepository.php';

class AuthService
{
    private $users;
    private $tokens;
    private $roles;

    public function __construct()
    {
        $this->users = new UserRepository();
        $this->tokens = new AuthTokenRepository();
        $this->roles = new UserRoleRepository();
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

        $userRoles = $this->roles->getRolesByUserId((int) $user->id);

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
            'roles' => $userRoles,
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
        $user = $this->users->findByEmail($email);

        // Avoid account enumeration. Always return a valid-shaped response.
        if ($user) {
            $token = bin2hex(random_bytes(32));
            $this->tokens->createPasswordResetToken((int) $user->id, $token, $expiresAt);
            $this->sendPasswordResetEmail($user, $token, $expiresAt);
        }

        return array(
            'expires_at' => $expiresAt,
            'email_sent' => true,
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

    private function sendPasswordResetEmail($user, $token, $expiresAt)
    {
        $to = isset($user->email) ? $user->email : null;
        if (!$to) {
            return false;
        }

        $subject = 'Recuperacion de contrasena - Reto Urbano';
        $resetUrl = $this->buildPasswordResetUrl($token);
        $safeName = isset($user->display_name) && $user->display_name !== ''
            ? $user->display_name
            : (isset($user->full_name) ? $user->full_name : 'participante');

        $message = '<html><body style="font-family: Arial, sans-serif; color: #222;">'
            . '<h2>Recuperacion de contrasena</h2>'
            . '<p>Hola ' . htmlspecialchars($safeName, ENT_QUOTES, 'UTF-8') . ',</p>'
            . '<p>Recibimos una solicitud para restablecer tu contrasena.</p>'
            . '<p><a href="' . htmlspecialchars($resetUrl, ENT_QUOTES, 'UTF-8') . '">Haz clic aqui para cambiar tu contrasena</a></p>'
            . '<p>Este enlace expira el: <strong>' . htmlspecialchars($expiresAt, ENT_QUOTES, 'UTF-8') . '</strong></p>'
            . '<p>Si no solicitaste este cambio, puedes ignorar este correo.</p>'
            . '<p>Equipo Reto Urbano</p>'
            . '</body></html>';

        $headers = "From: Reto Urbano <reto@ywampachuca.org>\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=UTF-8\r\n";

        $sent = @mail($to, $subject, $message, $headers);
        if (!$sent) {
            error_log('Password reset email failed for: ' . $to);
        }

        return $sent;
    }

    private function buildPasswordResetUrl($token)
    {
        $baseUrl = getenv('PASSWORD_RESET_URL_BASE');
        if (!$baseUrl) {
            $baseUrl = 'https://events.local/recovery-password';
        }

        $separator = (strpos($baseUrl, '?') === false) ? '?' : '&';
        return $baseUrl . $separator . 'token=' . urlencode($token);
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

    public function userHasAnyRole($userId, $allowedRoles)
    {
        $allowed = array_map(function ($role) {
            return strtolower(trim((string) $role));
        }, (array) $allowedRoles);

        $currentRoles = $this->roles->getRolesByUserId((int) $userId);
        if (empty($currentRoles) || empty($allowed)) {
            return false;
        }

        // "super" acts as a global privileged role for role-protected endpoints.
        if (in_array('super', $currentRoles, true)) {
            return true;
        }

        $roleAliases = array(
            'admin' => array('admin', 'administrador', 'administrator'),
            'staff' => array('staff', 'lider', 'leader'),
        );

        $expandedAllowed = array();
        foreach ($allowed as $role) {
            if (isset($roleAliases[$role])) {
                $expandedAllowed = array_merge($expandedAllowed, $roleAliases[$role]);
            } else {
                $expandedAllowed[] = $role;
            }
        }

        $expandedAllowed = array_values(array_unique($expandedAllowed));

        foreach ($currentRoles as $role) {
            if (in_array($role, $expandedAllowed, true)) {
                return true;
            }
        }

        return false;
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
