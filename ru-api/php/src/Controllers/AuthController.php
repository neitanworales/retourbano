<?php
/**
 * Authentication Controller
 * 
 * Handles authentication endpoints
 * 
 * @version 1.0
 * @author Neitan
 */

class AuthController extends Controller
{
    private $authService;

    /**
     * Initialize controller
     */
    public function __construct()
    {
        require_once __DIR__ . '/../Database/Connection.php';
        require_once __DIR__ . '/../Core/Exception.php';
        require_once __DIR__ . '/../Repository/Repository.php';
        require_once __DIR__ . '/../Repository/UserRepository.php';
        require_once __DIR__ . '/../Core/Service.php';
        require_once __DIR__ . '/../Services/AuthService.php';

        $config = require __DIR__ . '/../../config/Database.php';
        $connection = Connection::getInstance($config);
        $userRepository = new UserRepository($connection);
        $this->authService = new AuthService($userRepository);
    }

    /**
     * Login endpoint
     * POST /api/v1/auth/login
     * 
     * @return void
     */
    public function login()
    {
        try {
            $input = $this->getInput();

            $result = $this->authService->login($input['email'] ?? '', $input['password'] ?? '');

            $this->success($result, 200, 'Login successful');
        } catch (ValidationException $e) {
            $this->validationError($e->errors ?? [], $e->getMessage());
        } catch (AuthenticationException $e) {
            $this->unauthorized($e->getMessage());
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }

    /**
     * Register endpoint
     * POST /api/v1/auth/register
     * 
     * @return void
     */
    public function register()
    {
        try {
            $input = $this->getInput();

            $userId = $this->authService->register($input);

            $this->created(['id' => $userId], 'User registered successfully');
        } catch (ValidationException $e) {
            $this->validationError($e->errors ?? [], $e->getMessage());
        } catch (ResourceExistsException $e) {
            $this->error($e->getMessage(), 409, 'CONFLICT');
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }

    /**
     * Logout endpoint
     * POST /api/v1/auth/logout
     * 
     * @return void
     */
    public function logout()
    {
        try {
            $input = $this->getInput();
            $userId = $input['userId'] ?? null;

            if (!$userId) {
                throw new ValidationException('userId is required', ['userId' => 'Required field']);
            }

            $this->authService->logout($userId, null);

            $this->success(null, 200, 'Logout successful');
        } catch (ValidationException $e) {
            $this->validationError($e->errors ?? [], $e->getMessage());
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }

    /**
     * Request password reset
     * POST /api/v1/auth/forgot-password
     * 
     * @return void
     */
    public function forgotPassword()
    {
        try {
            $input = $this->getInput();

            $this->authService->requestPasswordReset($input['email'] ?? '');

            $this->success(null, 200, 'Reset link sent to your email');
        } catch (NotFoundException $e) {
            // Don't reveal if email exists
            $this->success(null, 200, 'If email exists, reset link will be sent');
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }

    /**
     * Reset password
     * POST /api/v1/auth/reset-password
     * 
     * @return void
     */
    public function resetPassword()
    {
        try {
            $input = $this->getInput();

            $this->authService->resetPassword(
                $input['token'] ?? '',
                $input['password'] ?? ''
            );

            $this->success(null, 200, 'Password reset successful');
        } catch (ValidationException $e) {
            $this->validationError($e->errors ?? [], $e->getMessage());
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }

    /**
     * Change password
     * PUT /api/v1/auth/change-password
     * 
     * @return void
     */
    public function changePassword()
    {
        try {
            // TODO: Get user ID from authenticated token
            $userId = $this->getParam('userId');

            $input = $this->getInput();

            if (!$userId) {
                throw new AuthenticationException('User not authenticated');
            }

            $this->authService->changePassword(
                $userId,
                $input['currentPassword'] ?? '',
                $input['newPassword'] ?? ''
            );

            $this->success(null, 200, 'Password changed successfully');
        } catch (ValidationException $e) {
            $this->validationError($e->errors ?? [], $e->getMessage());
        } catch (AuthenticationException $e) {
            $this->unauthorized($e->getMessage());
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }
}
?>
