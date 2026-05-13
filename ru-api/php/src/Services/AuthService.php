<?php
/**
 * Authentication Service
 * 
 * Handles authentication logic
 * 
 * @version 1.0
 * @author Neitan
 */

class AuthService extends Service
{
    /**
     * Login user
     * 
     * @param string $email
     * @param string $password
     * @return array|null
     * @throws ValidationException
     * @throws AuthenticationException
     */
    public function login($email, $password)
    {
        // Validate input
        $errors = $this->validateRequired(['email' => $email, 'password' => $password], ['email', 'password']);
        if (!empty($errors)) {
            throw new ValidationException('Validation failed', $errors);
        }

        if (!$this->validateEmail($email)) {
            throw new ValidationException('Invalid email format', ['email' => 'Invalid email']);
        }

        // Find user
        $user = $this->repository->findByEmail($email);
        if (!$user) {
            throw new AuthenticationException('Invalid credentials');
        }

        // Verify password (implement your password verification)
        if (!$this->verifyPassword($password, $user['password'] ?? '')) {
            throw new AuthenticationException('Invalid credentials');
        }

        // Get user with roles
        $user = $this->repository->getUserWithRoles($user['id']);

        // Generate token
        $token = $this->generateToken($user['id']);

        return [
            'user' => $user,
            'token' => $token
        ];
    }

    /**
     * Register user
     * 
     * @param array $data
     * @return int User ID
     * @throws ValidationException
     * @throws ResourceExistsException
     */
    public function register($data)
    {
        // Validate required fields
        $required = ['nombre', 'email'];
        $errors = $this->validateRequired($data, $required);

        if (!empty($data['email']) && !$this->validateEmail($data['email'])) {
            $errors['email'] = 'Invalid email format';
        }

        if (!empty($errors)) {
            throw new ValidationException('Validation failed', $errors);
        }

        // Check if email already exists
        if ($this->repository->emailExists($data['email'])) {
            throw new ResourceExistsException('Email already registered');
        }

        // Hash password if provided
        if (!empty($data['password'])) {
            $data['password'] = password_hash($data['password'], PASSWORD_BCRYPT);
        }

        // Add registration timestamp
        $data['fechahora_registro'] = date('Y-m-d H:i:s');

        // Insert user
        $userId = $this->repository->create($data);

        return $userId;
    }

    /**
     * Logout user
     * 
     * @param int $userId
     * @param string $token
     * @return bool
     */
    public function logout($userId, $token)
    {
        // TODO: Implement token blacklist or session invalidation
        return true;
    }

    /**
     * Verify password
     * 
     * @param string $password
     * @param string $hash
     * @return bool
     */
    private function verifyPassword($password, $hash)
    {
        // Use password_verify for hashed passwords
        // For backward compatibility, also check plain text (NOT RECOMMENDED FOR PRODUCTION)
        return password_verify($password, $hash) || $password === $hash;
    }

    /**
     * Generate authentication token
     * 
     * @param int $userId
     * @return string
     */
    private function generateToken($userId)
    {
        // TODO: Implement JWT token generation
        // For now, return simple token
        $payload = [
            'userId' => $userId,
            'iat' => time(),
            'exp' => time() + TOKEN_EXPIRY
        ];

        // Simple token generation (replace with proper JWT)
        $token = bin2hex(random_bytes(32));
        // Save token to database
        // $this->saveToken($userId, $token);

        return $token;
    }

    /**
     * Request password reset
     * 
     * @param string $email
     * @return bool
     * @throws NotFoundException
     */
    public function requestPasswordReset($email)
    {
        $user = $this->repository->findByEmail($email);

        if (!$user) {
            throw new NotFoundException('User not found');
        }

        // Generate reset token
        $resetToken = bin2hex(random_bytes(32));
        $resetExpiry = date('Y-m-d H:i:s', time() + 3600); // 1 hour expiry

        // TODO: Save reset token to database
        // Update user with reset token and expiry
        // $this->repository->update($user['id'], [
        //     'password_reset_token' => $resetToken,
        //     'password_reset_expiry' => $resetExpiry
        // ]);

        // TODO: Send reset email with token
        return true;
    }

    /**
     * Reset password with token
     * 
     * @param string $token
     * @param string $newPassword
     * @return bool
     * @throws ValidationException
     * @throws NotFoundException
     */
    public function resetPassword($token, $newPassword)
    {
        if (empty($newPassword) || strlen($newPassword) < 6) {
            throw new ValidationException('Password must be at least 6 characters', ['password' => 'Password too short']);
        }

        // TODO: Find user by reset token
        // Verify token hasn't expired
        // Update password
        // Clear reset token

        return true;
    }

    /**
     * Change password
     * 
     * @param int $userId
     * @param string $currentPassword
     * @param string $newPassword
     * @return bool
     * @throws AuthenticationException
     * @throws ValidationException
     */
    public function changePassword($userId, $currentPassword, $newPassword)
    {
        $user = $this->repository->find($userId);

        if (!$user) {
            throw new NotFoundException('User not found');
        }

        // Verify current password
        if (!$this->verifyPassword($currentPassword, $user['password'] ?? '')) {
            throw new AuthenticationException('Current password is incorrect');
        }

        if (empty($newPassword) || strlen($newPassword) < 6) {
            throw new ValidationException('Password must be at least 6 characters', ['password' => 'Password too short']);
        }

        // Hash and update password
        $hashedPassword = password_hash($newPassword, PASSWORD_BCRYPT);
        $this->repository->updatePassword($userId, $hashedPassword);

        return true;
    }
}
?>
