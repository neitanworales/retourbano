<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Services/AuthService.php';
require_once __DIR__ . '/../Repository/UserRoleRepository.php';
require_once __DIR__ . '/../Repository/ActivityLogRepository.php';

class AuthController extends BaseController
{
    private $authService;
    private $userRoles;
    private $activityLog;

    public function __construct()
    {
        $this->authService = new AuthService();
        $this->userRoles = new UserRoleRepository();
        $this->activityLog = new ActivityLogRepository();
    }

    public function login($request)
    {
        $email = isset($request['email']) ? trim($request['email']) : '';
        $password = isset($request['password']) ? $request['password'] : '';

        if ($email === '' || $password === '') {
            return $this->fail('email and password are required', 422);
        }

        $result = $this->authService->login($email, $password);
        if (!$result) {
            return $this->fail('invalid credentials', 401);
        }

        $userId = isset($result['user']['id']) ? (int) $result['user']['id'] : 0;
        if ($userId > 0) {
            $this->activityLog->createEntry($userId, 'auth.login', null, 'Inicio de sesion exitoso', array(
                'actor_user_id' => $userId,
                'entity_type' => 'user',
                'entity_id' => $userId,
                'source' => 'api.v1.auth',
                'metadata' => array('email' => $email),
            ));
        }

        return $this->ok($result, 'login successful');
    }

    public function validate($request)
    {
        $token = isset($request['token']) ? trim($request['token']) : '';
        if ($token === '') {
            return $this->fail('token is required', 422);
        }

        $user = $this->authService->validateToken($token);
        if (!$user) {
            return $this->fail('invalid or expired token', 401);
        }

        $roles = $this->userRoles->getRolesByUserId((int) $user->id);

        return $this->ok(array(
            'user' => $user->toArray(),
            'roles' => $roles
        ), 'token valid');
    }

    public function logout($request)
    {
        $token = isset($request['token']) ? trim($request['token']) : '';
        if ($token === '') {
            return $this->fail('token is required', 422);
        }

        $user = $this->authService->validateToken($token);
        $this->authService->logout($token);

        if ($user && isset($user->id)) {
            $this->activityLog->createEntry((int) $user->id, 'auth.logout', null, 'Cierre de sesion', array(
                'actor_user_id' => (int) $user->id,
                'entity_type' => 'user',
                'entity_id' => (int) $user->id,
                'source' => 'api.v1.auth',
            ));
        }

        return $this->ok(array(), 'logout successful');
    }

    public function forgotPassword($request)
    {
        $email = isset($request['email']) ? trim($request['email']) : '';
        if ($email === '') {
            return $this->fail('email is required', 422);
        }

        $this->authService->requestPasswordReset($email);

        return $this->ok(
            array(),
            'Si el email existe, se enviaron las instrucciones para restablecer la contraseña'
        );
    }

    public function validateResetToken($request)
    {
        $token = isset($request['token']) ? trim($request['token']) : '';
        if ($token === '') {
            return $this->fail('token is required', 422);
        }

        $tokenRow = $this->authService->validatePasswordResetToken($token);
        if (!$tokenRow) {
            return $this->fail('invalid or expired reset token', 401);
        }

        return $this->ok(array(
            'valid' => true,
            'expires_at' => isset($tokenRow['expires_at']) ? $tokenRow['expires_at'] : null,
        ), 'reset token valid');
    }

    public function resetPassword($request)
    {
        $token = isset($request['token']) ? trim($request['token']) : '';
        $newPassword = isset($request['new_password']) ? $request['new_password'] : '';

        if ($token === '' || $newPassword === '') {
            return $this->fail('token and new_password are required', 422);
        }

        if (!$this->isStrongPassword($newPassword)) {
            return $this->fail('new_password must be at least 12 chars and include uppercase, lowercase, number, special char, and no spaces', 422);
        }

        $tokenRow = $this->authService->validatePasswordResetToken($token);

        $ok = $this->authService->resetPasswordByToken($token, $newPassword);
        if (!$ok) {
            return $this->fail('invalid or expired reset token', 401);
        }

        if ($tokenRow && isset($tokenRow['user_id'])) {
            $this->activityLog->createEntry((int) $tokenRow['user_id'], 'auth.password_reset', null, 'Contrasena restablecida con token', array(
                'actor_user_id' => (int) $tokenRow['user_id'],
                'entity_type' => 'user',
                'entity_id' => (int) $tokenRow['user_id'],
                'source' => 'api.v1.auth',
            ));
        }

        return $this->ok(array(), 'password updated successfully');
    }

    private function isStrongPassword($password)
    {
        if (!is_string($password) || strlen($password) < 12) {
            return false;
        }

        if (preg_match('/\s/', $password)) {
            return false;
        }

        return preg_match('/[A-Z]/', $password)
            && preg_match('/[a-z]/', $password)
            && preg_match('/[0-9]/', $password)
            && preg_match('/[^A-Za-z0-9]/', $password);
    }
}
