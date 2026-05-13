<?php
/**
 * Registration Controller
 * 
 * Handles registration and user profile endpoints
 * 
 * @version 1.0
 * @author Neitan
 */

class RegistrationController extends Controller
{
    private $registrationService;
    private $userRepository;

    /**
     * Initialize controller
     */
    public function __construct()
    {
        require_once __DIR__ . '/../Database/Connection.php';
        require_once __DIR__ . '/../Core/Exception.php';
        require_once __DIR__ . '/../Repository/Repository.php';
        require_once __DIR__ . '/../Repository/UserRepository.php';
        require_once __DIR__ . '/../Repository/CampamentoRepository.php';
        require_once __DIR__ . '/../Core/Service.php';
        require_once __DIR__ . '/../Services/RegistrationService.php';

        $config = require __DIR__ . '/../../config/Database.php';
        $connection = Connection::getInstance($config);
        $this->userRepository = new UserRepository($connection);
        $campamentoRepository = new CampamentoRepository($connection);
        $this->registrationService = new RegistrationService($this->userRepository, $campamentoRepository);
    }

    /**
     * Register user with campamento
     * POST /api/v1/registration/register
     * 
     * @return void
     */
    public function register()
    {
        try {
            $input = $this->getInput();
            $campamentoId = $input['campamentoId'] ?? $this->getParam('campamentoId');

            if (!$campamentoId) {
                throw new ValidationException('Campamento is required', ['campamentoId' => 'Required field']);
            }

            $result = $this->registrationService->registerWithCampamento($input, $campamentoId);

            $this->created($result, 'Registration successful');
        } catch (ValidationException $e) {
            $this->validationError($e->errors ?? [], $e->getMessage());
        } catch (ResourceExistsException $e) {
            $this->error($e->getMessage(), 409, 'CONFLICT');
        } catch (NotFoundException $e) {
            $this->notFound($e->getMessage());
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }

    /**
     * Get user profile
     * GET /api/v1/registration/profile/{id}
     * 
     * @return void
     */
    public function getProfile()
    {
        try {
            $userId = $this->getParam('id');

            if (!$userId) {
                throw new ValidationException('User ID is required', ['id' => 'Required']);
            }

            $user = $this->userRepository->getFormatted($userId);

            if (!$user) {
                throw new NotFoundException('User not found');
            }

            $this->success($user, 200, 'Profile retrieved successfully');
        } catch (NotFoundException $e) {
            $this->notFound($e->getMessage());
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }

    /**
     * Update user profile
     * PUT /api/v1/registration/profile/{id}
     * 
     * @return void
     */
    public function updateProfile()
    {
        try {
            $userId = $this->getParam('id');
            $input = $this->getInput();

            if (!$userId) {
                throw new ValidationException('User ID is required', ['id' => 'Required']);
            }

            $this->registrationService->updateProfile($userId, $input);

            $user = $this->userRepository->find($userId);
            $this->success($user, 200, 'Profile updated successfully');
        } catch (ValidationException $e) {
            $this->validationError($e->errors ?? [], $e->getMessage());
        } catch (NotFoundException $e) {
            $this->notFound($e->getMessage());
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }

    /**
     * Re-register user in campamento
     * POST /api/v1/registration/reregister
     * 
     * @return void
     */
    public function reregister()
    {
        try {
            $input = $this->getInput();
            $userId = $input['userId'] ?? $this->getParam('userId');
            $campamentoId = $input['campamentoId'] ?? $this->getParam('campamentoId');

            if (!$userId || !$campamentoId) {
                throw new ValidationException('User and Campamento are required', ['userId' => 'Required', 'campamentoId' => 'Required']);
            }

            $this->registrationService->reregisterInCampamento($userId, $campamentoId);

            $this->success(null, 200, 'Re-registration successful');
        } catch (ValidationException $e) {
            $this->validationError($e->errors ?? [], $e->getMessage());
        } catch (NotFoundException $e) {
            $this->notFound($e->getMessage());
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }

    /**
     * Confirm email
     * POST /api/v1/registration/confirm-email
     * 
     * @return void
     */
    public function confirmEmail()
    {
        try {
            $input = $this->getInput();
            $userId = $input['userId'] ?? $this->getParam('userId');
            $code = $input['code'] ?? $this->getParam('code');

            if (!$userId || !$code) {
                throw new ValidationException('User ID and confirmation code are required', ['userId' => 'Required', 'code' => 'Required']);
            }

            $this->registrationService->confirmEmail($userId, $code);

            $this->success(null, 200, 'Email confirmed successfully');
        } catch (ValidationException $e) {
            $this->validationError($e->errors ?? [], $e->getMessage());
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }

    /**
     * Get user registrations
     * GET /api/v1/registration/my-registrations/{id}
     * 
     * @return void
     */
    public function getRegistrations()
    {
        try {
            $userId = $this->getParam('id');

            if (!$userId) {
                throw new ValidationException('User ID is required', ['id' => 'Required']);
            }

            $registrations = $this->registrationService->getUserRegistrations($userId);

            $this->success($registrations, 200, 'Registrations retrieved successfully');
        } catch (ValidationException $e) {
            $this->validationError($e->errors ?? [], $e->getMessage());
        } catch (Exception $e) {
            $this->error($e->getMessage(), 500);
        }
    }
}
?>
