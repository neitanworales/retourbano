<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Services/RegistrationService.php';
require_once __DIR__ . '/../Repository/UserRepository.php';
require_once __DIR__ . '/../Repository/PaymentRepository.php';

class RegistrationController extends BaseController
{
    private $registrationService;
    private $users;
    private $payments;

    public function __construct()
    {
        $this->registrationService = new RegistrationService();
        $this->users = new UserRepository();
        $this->payments = new PaymentRepository();
    }

    public function register($request)
    {
        $userId = isset($request['user_id']) ? (int) $request['user_id'] : 0;
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $requiresLodging = isset($request['requires_lodging']) ? (int) $request['requires_lodging'] : 0;
        $roomCode = isset($request['room_code']) ? trim($request['room_code']) : null;
        $reasons = isset($request['reasons']) ? trim($request['reasons']) : (isset($request['razones']) ? trim($request['razones']) : null);

        if ($userId <= 0 || $eventId <= 0) {
            return $this->fail('user_id and event_id are required', 422);
        }

        $result = $this->registrationService->register($userId, $eventId, $requiresLodging, $roomCode, $reasons);
        if (isset($result['error'])) {
            return $this->fail($result['error'], 400, $result);
        }

        return $this->ok($result, 'registration created');
    }

    public function updateStatus($request)
    {
        $registrationId = isset($request['registration_id']) ? (int) $request['registration_id'] : 0;
        if ($registrationId <= 0) {
            return $this->fail('registration_id is required', 422);
        }

        $updates = array();

        if (isset($request['status'])) {
            $status = trim((string) $request['status']);
            if ($status !== '') {
                $updates['registration_status'] = $status;
            }
        }

        $isConfirmed = $this->parseOptionalBoolean($request, 'is_confirmed');
        if ($isConfirmed !== null) {
            $updates['is_confirmed'] = (int) $isConfirmed;
        }

        $attendanceConfirmed = $this->parseOptionalBoolean($request, 'attendance_confirmed');
        if ($attendanceConfirmed !== null) {
            $updates['attendance_confirmed'] = (int) $attendanceConfirmed;
        }

        $isFollowup = $this->parseOptionalBoolean($request, 'is_followup');
        if ($isFollowup !== null) {
            $updates['is_followup'] = (int) $isFollowup;
        }

        $welcomeEmailSent = $this->parseOptionalBoolean($request, 'welcome_email_sent');
        if ($welcomeEmailSent !== null) {
            $updates['welcome_email_sent'] = (int) $welcomeEmailSent;
        }

        $emailConfirmed = $this->parseOptionalBoolean($request, 'email_confirmed');
        if ($emailConfirmed !== null) {
            $updates['email_confirmed'] = (int) $emailConfirmed;
        }

        if (empty($updates)) {
            return $this->fail('At least one field is required: status, is_confirmed, attendance_confirmed, is_followup, welcome_email_sent, email_confirmed', 422);
        }

        $ok = $this->registrationService->updateFields($registrationId, $updates);
        if (!$ok) {
            return $this->fail('could not update registration', 500);
        }

        return $this->ok(array('registration_id' => $registrationId, 'updated' => $updates), 'registration updated');
    }

    public function getById($request)
    {
        $registrationId = isset($request['registration_id']) ? (int) $request['registration_id'] : 0;
        if ($registrationId <= 0) {
            return $this->fail('registration_id is required', 422);
        }

        $registration = $this->registrationService->getById($registrationId);
        if (!$registration) {
            return $this->fail('registration not found', 404);
        }

        $item = $this->attachUserToItem($registration->toArray());
        $item = $this->attachPaymentsToItem($item);
        return $this->ok(array('registration' => $item), 'registration found');
    }

    public function getByEvent($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $limit = isset($request['limit']) ? (int) $request['limit'] : 100;
        $offset = isset($request['offset']) ? (int) $request['offset'] : 0;

        if ($eventId <= 0) {
            return $this->fail('event_id is required', 422);
        }

        $filters = array(
            'is_staff' => $this->parseOptionalBoolean($request, 'is_staff'),
            'is_admin' => $this->parseOptionalBoolean($request, 'is_admin'),
            'is_followup' => $this->parseOptionalBoolean($request, 'is_followup'),
            'registration_status' => isset($request['registration_status']) ? trim((string) $request['registration_status']) : null,
        );

        $registrations = $this->registrationService->getByEvent($eventId, $limit, $offset, $filters);
        $items = array_map(function ($registration) {
            $item = $this->attachUserToItem($registration->toArray());
            return $this->attachPaymentsToItem($item);
        }, $registrations);

        return $this->ok(array('registrations' => $items), 'registrations by event');
    }

    public function getByUser($request)
    {
        $userId = isset($request['user_id']) ? (int) $request['user_id'] : 0;
        $limit = isset($request['limit']) ? (int) $request['limit'] : 100;
        $offset = isset($request['offset']) ? (int) $request['offset'] : 0;

        if ($userId <= 0) {
            return $this->fail('user_id is required', 422);
        }

        $registrations = $this->registrationService->getByUser($userId, $limit, $offset);
        $items = array_map(function ($registration) {
            $item = $this->attachUserToItem($registration->toArray());
            return $this->attachPaymentsToItem($item);
        }, $registrations);

        return $this->ok(array('registrations' => $items), 'registrations by user');
    }

    private function attachUserToItem($item)
    {
        if (!is_array($item) || !isset($item['user_id'])) {
            return $item;
        }

        $userId = (int) $item['user_id'];
        if ($userId <= 0) {
            $item['user'] = null;
            return $item;
        }

        static $cache = array();
        if (!array_key_exists($userId, $cache)) {
            $user = $this->users->findModelById($userId);
            $cache[$userId] = $user ? $user->toArray() : null;
        }

        $item['user'] = $cache[$userId];
        return $item;
    }

    private function attachPaymentsToItem($item)
    {
        if (!is_array($item) || !isset($item['id'])) {
            return $item;
        }

        $registrationId = (int) $item['id'];
        if ($registrationId <= 0) {
            $item['pagos'] = array();
            return $item;
        }

        static $cache = array();
        if (!array_key_exists($registrationId, $cache)) {
            $payments = $this->payments->findByRegistrationId($registrationId);
            $cache[$registrationId] = array_map(function ($payment) {
                return $payment->toArray();
            }, $payments);
        }

        $item['pagos'] = $cache[$registrationId];
        $item['pagado'] = array_reduce($item['pagos'], function ($total, $payment) {
            $amount = isset($payment['amount']) ? (float) $payment['amount'] : 0;
            return $total + $amount;
        }, 0.0);
        return $item;
    }

    private function parseOptionalBoolean($request, $key)
    {
        if (!isset($request[$key])) {
            return null;
        }

        $value = $request[$key];
        if (is_bool($value)) {
            return $value ? 1 : 0;
        }

        $normalized = strtolower(trim((string) $value));
        if (in_array($normalized, array('1', 'true', 'yes', 'on'), true)) {
            return 1;
        }

        if (in_array($normalized, array('0', 'false', 'no', 'off'), true)) {
            return 0;
        }

        return null;
    }
}
