<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Services/RegistrationService.php';

class RegistrationController extends BaseController
{
    private $registrationService;

    public function __construct()
    {
        $this->registrationService = new RegistrationService();
    }

    public function register($request)
    {
        $userId = isset($request['user_id']) ? (int) $request['user_id'] : 0;
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $requiresLodging = isset($request['requires_lodging']) ? (int) $request['requires_lodging'] : 0;
        $roomCode = isset($request['room_code']) ? trim($request['room_code']) : null;

        if ($userId <= 0 || $eventId <= 0) {
            return $this->fail('user_id and event_id are required', 422);
        }

        $result = $this->registrationService->register($userId, $eventId, $requiresLodging, $roomCode);
        if (isset($result['error'])) {
            return $this->fail($result['error'], 400, $result);
        }

        return $this->ok($result, 'registration created');
    }

    public function updateStatus($request)
    {
        $registrationId = isset($request['registration_id']) ? (int) $request['registration_id'] : 0;
        $status = isset($request['status']) ? trim($request['status']) : '';

        if ($registrationId <= 0 || $status === '') {
            return $this->fail('registration_id and status are required', 422);
        }

        $ok = $this->registrationService->updateStatus($registrationId, $status);
        if (!$ok) {
            return $this->fail('could not update registration status', 500);
        }

        return $this->ok(array('registration_id' => $registrationId, 'status' => $status), 'status updated');
    }
}
