<?php
/**
 * Registration Service
 * 
 * Handles user registration logic
 * 
 * @version 1.0
 * @author Neitan
 */

class RegistrationService extends Service
{
    private $campamentoRepository;
    private $emailService;

    /**
     * Initialize with repositories
     * 
     * @param UserRepository $userRepository
     * @param CampamentoRepository $campamentoRepository
     */
    public function __construct(
        UserRepository $userRepository,
        CampamentoRepository $campamentoRepository
    ) {
        parent::__construct($userRepository);
        $this->campamentoRepository = $campamentoRepository;
        // Initialize email service (will be injected in future)
    }

    /**
     * Register new user with campamento
     * 
     * @param array $data
     * @param int $campamentoId
     * @return array New user data
     * @throws ValidationException
     * @throws NotFoundException
     * @throws ResourceExistsException
     */
    public function registerWithCampamento($data, $campamentoId)
    {
        // Validate campamento exists
        $campamento = $this->campamentoRepository->find($campamentoId);
        if (!$campamento) {
            throw new NotFoundException('Campamento not found');
        }

        // Validate required fields
        $required = ['nombre', 'email', 'edad', 'sexo'];
        $errors = $this->validateRequired($data, $required);

        if (!empty($data['email']) && !$this->validateEmail($data['email'])) {
            $errors['email'] = 'Invalid email format';
        }

        if (!empty($errors)) {
            throw new ValidationException('Validation failed', $errors);
        }

        // Check email not already registered
        if ($this->repository->emailExists($data['email'])) {
            throw new ResourceExistsException('Email already registered');
        }

        // Validate age
        if (!empty($data['fechaNac'])) {
            $age = $this->calculateAge($data['fechaNac']);
            if ($age < 10) {
                throw new ValidationException('User must be at least 10 years old', ['fechaNac' => 'Age too young']);
            }
        }

        // Add default values
        $data['status'] = 'activo';
        $data['staff'] = 0;
        $data['admin'] = 0;
        $data['confirmado'] = 0;
        $data['asistencia'] = 0;
        $data['seguimiento'] = 0;
        $data['emailEnviado'] = 0;
        $data['emailConfirmado'] = 0;
        $data['hospedaje'] = $data['hospedaje'] ?? 0;
        $data['fechahora_registro'] = date('Y-m-d H:i:s');

        // Create user
        $userId = $this->repository->create($data);

        // Register in campamento
        $this->assignCampamento($userId, $campamentoId, date('Y'));

        // TODO: Send confirmation email
        // $this->emailService->sendConfirmationEmail($data['email'], $userId);

        return [
            'id' => $userId,
            'nombre' => $data['nombre'],
            'email' => $data['email'],
            'message' => 'Registration successful. Please check your email to confirm.'
        ];
    }

    /**
     * Re-register user in campamento
     * 
     * @param int $userId
     * @param int $campamentoId
     * @return bool
     * @throws NotFoundException
     */
    public function reregisterInCampamento($userId, $campamentoId)
    {
        // Verify user exists
        $user = $this->repository->find($userId);
        if (!$user) {
            throw new NotFoundException('User not found');
        }

        // Verify campamento exists
        $campamento = $this->campamentoRepository->find($campamentoId);
        if (!$campamento) {
            throw new NotFoundException('Campamento not found');
        }

        // Assign to campamento
        return $this->assignCampamento($userId, $campamentoId, date('Y'));
    }

    /**
     * Assign user to campamento
     * 
     * @param int $userId
     * @param int $campamentoId
     * @param int $year
     * @return bool
     */
    private function assignCampamento($userId, $campamentoId, $year)
    {
        // TODO: Insert into campamento_guerreros table
        // $sql = "INSERT INTO campamento_guerreros (id_guerrero, id_campamento, año) VALUES (?, ?, ?)";
        // return $this->repository->query($sql, [$userId, $campamentoId, $year]);

        return true;
    }

    /**
     * Confirm user email
     * 
     * @param int $userId
     * @param string $confirmationCode
     * @return bool
     * @throws ValidationException
     */
    public function confirmEmail($userId, $confirmationCode)
    {
        // TODO: Verify confirmation code
        // Update emailConfirmado status
        $this->repository->update($userId, ['emailConfirmado' => 1]);

        return true;
    }

    /**
     * Update user profile
     * 
     * @param int $userId
     * @param array $data
     * @return bool
     * @throws NotFoundException
     * @throws ValidationException
     */
    public function updateProfile($userId, $data)
    {
        $user = $this->repository->find($userId);
        if (!$user) {
            throw new NotFoundException('User not found');
        }

        // Validate email if provided
        if (!empty($data['email']) && $data['email'] !== $user['email']) {
            if (!$this->validateEmail($data['email'])) {
                throw new ValidationException('Invalid email', ['email' => 'Invalid email format']);
            }

            if ($this->repository->emailExists($data['email'], $userId)) {
                throw new ValidationException('Email already in use', ['email' => 'Email already registered']);
            }
        }

        // Filter updateable fields
        $updateableFields = ['nombre', 'fechaNac', 'edad', 'sexo', 'talla', 'vienesDe', 'alergias', 'razones', 'tutorNombre', 'tutorTelefono', 'iglesia', 'email', 'whatsapp', 'telefono', 'facebook', 'instagram', 'medicamentos'];

        $updateData = [];
        foreach ($updateableFields as $field) {
            if (isset($data[$field])) {
                $updateData[$field] = $data[$field];
            }
        }

        if (empty($updateData)) {
            throw new ValidationException('No valid fields to update', []);
        }

        return $this->repository->update($userId, $updateData) > 0;
    }

    /**
     * Calculate age from birth date
     * 
     * @param string $birthDate (format: Y-m-d)
     * @return int
     */
    private function calculateAge($birthDate)
    {
        try {
            $birth = new DateTime($birthDate);
            $today = new DateTime('today');
            $age = $today->diff($birth)->y;
            return $age;
        } catch (Exception $e) {
            return 0;
        }
    }

    /**
     * Get user registrations
     * 
     * @param int $userId
     * @return array
     */
    public function getUserRegistrations($userId)
    {
        // TODO: Join with campamento_guerreros and campamentos tables
        // $sql = "SELECT c.*, cg.año FROM campamento_guerreros cg
        //         JOIN campamentos c ON cg.id_campamento = c.id
        //         WHERE cg.id_guerrero = ? ORDER BY cg.año DESC";
        // return $this->repository->query($sql, [$userId])->fetchAll();

        return [];
    }
}
?>
