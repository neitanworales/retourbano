<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Services/RegistrationService.php';
require_once __DIR__ . '/../Services/EmailService.php';
require_once __DIR__ . '/../Repository/UserRepository.php';
require_once __DIR__ . '/../Repository/EventRepository.php';
require_once __DIR__ . '/../Repository/PaymentRepository.php';
require_once __DIR__ . '/../Repository/EventRegistrationRepository.php';
require_once __DIR__ . '/../Models/User.php';

class RegistrationController extends BaseController
{
    private $registrationService;
    private $users;
    private $events;
    private $payments;
    private $eventRegistrations;
    private $email;

    public function __construct()
    {
        $this->registrationService = new RegistrationService();
        $this->users = new UserRepository();
        $this->events = new EventRepository();
        $this->payments = new PaymentRepository();
        $this->eventRegistrations = new EventRegistrationRepository();
        $this->email = new EmailService();
    }

    public function register($request)
    {
        $eventId = $this->parseEventId($request);
        $userId = isset($request['user_id']) ? (int) $request['user_id'] : 0;
        $reinscription = isset($request['reinscription']) ? (int) $request['reinscription'] : 0;

        $requiresLodging = $this->parseOptionalBoolean($request, 'requires_lodging');
        if ($requiresLodging === null) {
            $requiresLodging = $this->parseOptionalBoolean($request, 'hospedaje');
        }
        $requiresLodging = $requiresLodging === null ? 0 : (int) $requiresLodging;

        $roomCode = isset($request['room_code']) ? trim((string) $request['room_code']) : null;
        $reasons = isset($request['reasons']) ? trim((string) $request['reasons']) : (isset($request['razones']) ? trim((string) $request['razones']) : null);

        if ($eventId <= 0) {
            return $this->fail('event_id or id_campamento is required', 422);
        }

        if ($userId <= 0) {
            $userOrError = $this->resolveOrCreatePublicUser($request);
            if (is_array($userOrError) && isset($userOrError['error'])) {
                return $this->fail($userOrError['error'], 400, $userOrError);
            }
            $userId = (int) $userOrError;
        }

        $result = $this->registrationService->register($userId, $eventId, $requiresLodging, $roomCode, $reasons, false);
        if (isset($result['error'])) {
            return $this->fail($result['error'], 400, $result);
        }

        return $this->ok($result, 'registration created');
    }

    public function update($request)
    {
        $userId = isset($request['user_id']) ? (int) $request['user_id'] : (isset($request['id']) ? (int) $request['id'] : 0);
        $eventId = $this->parseEventId($request);

        if ($userId <= 0) {
            return $this->fail('id or user_id is required', 422);
        }

        $user = $this->users->findModelById($userId);
        if (!$user) {
            return $this->fail('user not found', 404);
        }

        $this->fillUserFromRequest($user, $request, true);
        $saved = $this->users->update($user);
        if (!$saved) {
            return $this->fail('could not update user', 500);
        }

        $registrationId = null;
        if ($eventId > 0) {
            $existing = $this->eventRegistrations->findByEventAndUser($eventId, $userId);
            if (!$existing) {
                $requiresLodging = $this->parseOptionalBoolean($request, 'requires_lodging');
                if ($requiresLodging === null) {
                    $requiresLodging = $this->parseOptionalBoolean($request, 'hospedaje');
                }
                $requiresLodging = $requiresLodging === null ? 0 : (int) $requiresLodging;

                $roomCode = isset($request['room_code']) ? trim((string) $request['room_code']) : null;
                $reasons = isset($request['reasons']) ? trim((string) $request['reasons']) : (isset($request['razones']) ? trim((string) $request['razones']) : null);
                $reinscription = true;

                $registerResult = $this->registrationService->register($userId, $eventId, $requiresLodging, $roomCode, $reasons, true);
                if (isset($registerResult['error'])) {
                    return $this->fail($registerResult['error'], 400, $registerResult);
                }
                $registrationId = isset($registerResult['id']) ? (int) $registerResult['id'] : null;
            } else {
                $registrationId = (int) $existing->id;

                $updates = array();
                $requiresLodging = $this->parseOptionalBoolean($request, 'requires_lodging');
                if ($requiresLodging === null) {
                    $requiresLodging = $this->parseOptionalBoolean($request, 'hospedaje');
                }
                if ($requiresLodging !== null) {
                    $updates['requires_lodging'] = (int) $requiresLodging;
                }

                $reasons = isset($request['reasons']) ? trim((string) $request['reasons']) : (isset($request['razones']) ? trim((string) $request['razones']) : null);
                if ($reasons !== null && $reasons !== '') {
                    $updates['reasons'] = $reasons;
                }

                if (!empty($updates)) {
                    $this->registrationService->updateFields($registrationId, $updates);
                }
            }
        }

        return $this->ok(
            array(
                'user_id' => $userId,
                'event_id' => $eventId > 0 ? $eventId : null,
                'registration_id' => $registrationId,
            ),
            'Registro añadido/actualizado exitosamente'
        );
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

        $welcomeEmailSent = $this->parseOptionalInteger($request, 'welcome_email_sent');
        if ($welcomeEmailSent !== null) {
            $updates['welcome_email_sent'] = (int) $welcomeEmailSent;
        }

        $emailConfirmed = $this->parseOptionalInteger($request, 'email_confirmed');
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

    public function resendWelcomeEmail($request)
    {
        $registrationId = isset($request['registration_id']) ? (int) $request['registration_id'] : 0;
        if ($registrationId <= 0) {
            return $this->fail('registration_id is required', 422);
        }

        $result = $this->registrationService->sendWelcomeEmail($registrationId);
        if (isset($result['error'])) {
            return $this->fail($result['error'], 400, $result);
        }

        return $this->ok($result, 'welcome email sent');
    }

    public function sendConfirmationInfoEmail($request)
    {
        $registrationId = isset($request['registration_id']) ? (int) $request['registration_id'] : 0;
        if ($registrationId <= 0) {
            return $this->fail('registration_id is required', 422);
        }

        $result = $this->registrationService->sendConfirmationInfoEmail($registrationId);
        if (isset($result['error'])) {
            return $this->fail($result['error'], 400, $result);
        }

        return $this->ok($result, 'confirmation info email sent');
    }

    public function delete($request)
    {
        $registrationId = isset($request['registration_id']) ? (int) $request['registration_id'] : 0;
        if ($registrationId <= 0) {
            return $this->fail('registration_id is required', 422);
        }

        $result = $this->registrationService->delete($registrationId);
        if (isset($result['error'])) {
            $code = $result['error'] === 'registration not found' ? 404 : 500;
            return $this->fail($result['error'], $code, $result);
        }

        return $this->ok($result, 'registration deleted');
    }

    public function requestReenrollmentCode($request)
    {
        $email = isset($request['email']) ? trim((string) $request['email']) : '';
        if ($email === '') {
            return $this->fail('email is required', 422);
        }

        $eventId = $this->parseEventId($request);
        $user = $this->users->findByEmail($email);
        if (!$user) {
            return $this->fail("No se encontro este correo: $email - favor de validar.", 404);
        }

        $verificationCode = bin2hex(random_bytes(4));
        $updated = $this->users->updateVerificationCode((int) $user->id, $verificationCode);
        if (!$updated) {
            return $this->fail('could not generate verification code', 500);
        }

        $sent = $this->sendReenrollmentCodeEmail($user, $verificationCode, $eventId > 0 ? $eventId : null);
        if (!$sent) {
            return $this->fail("Error al enviar correo de verificacion a $email", 500);
        }

        return $this->ok(
            array('email' => $email),
            "Se envio correo de verificacion a $email, recuerda revisar tu bandeja de SPAM o correo no deseado"
        );
    }

    public function validateReenrollmentCode($request)
    {
        $code = isset($request['code']) ? trim((string) $request['code']) : '';
        if ($code === '' && isset($request['codigo'])) {
            $code = trim((string) $request['codigo']);
        }
        $eventId = $this->parseEventId($request);

        if ($code === '') {
            return $this->fail('code is required', 422);
        }

        if ($eventId <= 0) {
            return $this->fail('event_id or id_campamento is required', 422);
        }

        $user = $this->users->findByVerificationCode($code);
        if (!$user) {
            return $this->fail("Not found $code", 404);
        }

        $existingRegistration = null;
        $alreadyRegistered = false;

        $existingRegistration = $this->eventRegistrations->findByEventAndUser($eventId, (int) $user->id);
        $alreadyRegistered = $existingRegistration ? true : false;

        $registrationPayload = null;
        if ($existingRegistration) {
            $registrationPayload = $this->attachUserToItem($existingRegistration->toArray());
        }

        return $this->ok(
            array(
                'user' => $user->toArray(),
                'already_registered' => $alreadyRegistered,
                'registration' => $registrationPayload,
            ),
            'Ok'
        );
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
            $item = $this->attachPaymentsToItem($item);
            return $this->attachPreviousEventsToItem($item);
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

    private function attachPreviousEventsToItem($item)
    {
        if (!is_array($item) || !isset($item['user_id'])) {
            return $item;
        }

        $userId = (int) $item['user_id'];
        if ($userId <= 0) {
            $item['previous_events'] = array();
            return $item;
        }

        $events = $this->eventRegistrations->findByUser($userId, 20, 0);
        $item['previous_events'] = array_map(function ($event) {
            return $event->toArray();
        }, $events);
        return $item;
    }

    private function resolveOrCreatePublicUser($request)
    {
        $email = isset($request['email']) ? trim((string) $request['email']) : '';
        $fullName = isset($request['nombre']) ? trim((string) $request['nombre']) : (isset($request['full_name']) ? trim((string) $request['full_name']) : '');

        if ($email === '' || $fullName === '') {
            return array('error' => 'nombre and email are required');
        }

        $isTutor = $this->parseOptionalBoolean($request, 'tutor') === 1;
        $existingUser = $this->users->findByEmail($email);

        if ($existingUser && !$isTutor) {
            return array('error' => 'Ya existe un registro con ese correo electronico, por favor intenta reinscribirte');
        }

        if ($existingUser) {
            return (int) $existingUser->id;
        }

        $newUser = new User();
        $this->fillUserFromRequest($newUser, $request, false);
        $newUser->user_status = $newUser->user_status ? $newUser->user_status : 'A';
        $newUser->password_hash = isset($newUser->password_hash) ? $newUser->password_hash : '';
        $newUser->verification_code = isset($newUser->verification_code) ? $newUser->verification_code : '';

        $createdId = $this->users->create($newUser);
        return $createdId > 0 ? (int) $createdId : array('error' => 'could not create user');
    }

    private function fillUserFromRequest($user, $request, $keepExistingWhenEmpty = true)
    {
        $fullName = isset($request['nombre']) ? trim((string) $request['nombre']) : (isset($request['full_name']) ? trim((string) $request['full_name']) : '');
        if ($fullName !== '' || !$keepExistingWhenEmpty) {
            $user->full_name = $fullName;
        }

        $displayName = isset($request['nick']) ? trim((string) $request['nick']) : (isset($request['display_name']) ? trim((string) $request['display_name']) : '');
        if ($displayName !== '' || !$keepExistingWhenEmpty) {
            $user->display_name = $displayName;
        }

        $email = isset($request['email']) ? trim((string) $request['email']) : '';
        if ($email !== '' || !$keepExistingWhenEmpty) {
            $user->email = $email;
        }

        $birthDate = $this->normalizeBirthDate($request);
        if ($birthDate !== null || !$keepExistingWhenEmpty) {
            $user->birth_date = $birthDate;
        }

        if (isset($request['edad']) || isset($request['age']) || !$keepExistingWhenEmpty) {
            $ageRaw = isset($request['edad']) ? $request['edad'] : (isset($request['age']) ? $request['age'] : null);
            $user->age = $ageRaw === null || $ageRaw === '' ? null : (int) $ageRaw;
        }

        $gender = isset($request['sexo']) ? trim((string) $request['sexo']) : (isset($request['gender']) ? trim((string) $request['gender']) : '');
        if ($gender !== '' || !$keepExistingWhenEmpty) {
            $user->gender = $gender;
        }

        $shirtSize = isset($request['talla']) ? trim((string) $request['talla']) : (isset($request['shirt_size']) ? trim((string) $request['shirt_size']) : '');
        if ($shirtSize !== '' || !$keepExistingWhenEmpty) {
            $user->shirt_size = $shirtSize;
        }

        $comingFrom = isset($request['vienesDe']) ? trim((string) $request['vienesDe']) : (isset($request['coming_from']) ? trim((string) $request['coming_from']) : '');
        if ($comingFrom !== '' || !$keepExistingWhenEmpty) {
            $user->coming_from = $comingFrom;
        }

        $allergies = isset($request['alergias']) ? trim((string) $request['alergias']) : (isset($request['allergies']) ? trim((string) $request['allergies']) : '');
        if ($allergies !== '' || !$keepExistingWhenEmpty) {
            $user->allergies = $allergies;
        }

        $guardianPhone = isset($request['tutorTelefono']) ? trim((string) $request['tutorTelefono']) : (isset($request['guardian_phone']) ? trim((string) $request['guardian_phone']) : '');
        if ($guardianPhone !== '' || !$keepExistingWhenEmpty) {
            $user->guardian_phone = $guardianPhone;
        }

        $guardianName = isset($request['tutorNombre']) ? trim((string) $request['tutorNombre']) : (isset($request['guardian_name']) ? trim((string) $request['guardian_name']) : '');
        if ($guardianName !== '' || !$keepExistingWhenEmpty) {
            $user->guardian_name = $guardianName;
        }

        $church = isset($request['iglesia']) ? trim((string) $request['iglesia']) : (isset($request['church']) ? trim((string) $request['church']) : '');
        if ($church !== '' || !$keepExistingWhenEmpty) {
            $user->church = $church;
        }

        $medications = isset($request['medicamentos']) ? trim((string) $request['medicamentos']) : (isset($request['medications']) ? trim((string) $request['medications']) : '');
        if ($medications !== '' || !$keepExistingWhenEmpty) {
            $user->medications = $medications;
        }

        $whatsapp = isset($request['whatsapp']) ? trim((string) $request['whatsapp']) : '';
        if ($whatsapp !== '' || !$keepExistingWhenEmpty) {
            $user->whatsapp = $whatsapp;
        }

        $phone = isset($request['telefono']) ? trim((string) $request['telefono']) : (isset($request['phone']) ? trim((string) $request['phone']) : '');
        if ($phone !== '' || !$keepExistingWhenEmpty) {
            $user->phone = $phone;
        }

        $acceptedPolicies = $this->parseOptionalBoolean($request, 'aceptaPoliticas');
        if ($acceptedPolicies === null) {
            $acceptedPolicies = $this->parseOptionalBoolean($request, 'accepted_policies');
        }
        if ($acceptedPolicies !== null || !$keepExistingWhenEmpty) {
            $user->accepted_policies = $acceptedPolicies === null ? 0 : (int) $acceptedPolicies;
        }

        $facebook = isset($request['facebook']) ? trim((string) $request['facebook']) : '';
        if ($facebook !== '' || !$keepExistingWhenEmpty) {
            $user->facebook = $facebook;
        }

        $instagram = isset($request['instagram']) ? trim((string) $request['instagram']) : '';
        if ($instagram !== '' || !$keepExistingWhenEmpty) {
            $user->instagram = $instagram;
        }

        $guardianEmail = isset($request['emailTutor']) ? trim((string) $request['emailTutor']) : (isset($request['guardian_email']) ? trim((string) $request['guardian_email']) : '');
        if ($guardianEmail !== '' || !$keepExistingWhenEmpty) {
            $user->guardian_email = $guardianEmail;
        }

        $legacyUserId = null;
        if (isset($request['legacy_user_id'])) {
            $legacyUserId = (int) $request['legacy_user_id'];
        } elseif (isset($request['id_guerrero'])) {
            $legacyUserId = (int) $request['id_guerrero'];
        } elseif (isset($request['legacyUserId'])) {
            $legacyUserId = (int) $request['legacyUserId'];
        }

        if ($legacyUserId !== null && $legacyUserId > 0) {
            $user->legacy_user_id = $legacyUserId;
        } elseif (!$keepExistingWhenEmpty) {
            $user->legacy_user_id = null;
        }
    }

    private function parseEventId($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        if ($eventId > 0) {
            return $eventId;
        }

        return isset($request['id_campamento']) ? (int) $request['id_campamento'] : 0;
    }

    private function sendReenrollmentCodeEmail($user, $code, $eventId = null)
    {
        $event = ($eventId !== null && (int) $eventId > 0)
            ? $this->events->findModelById((int) $eventId)
            : null;

        return $this->email->sendReenrollmentEmail($user, $event, $code);
    }

    private function normalizeBirthDate($request)
    {
        if (isset($request['year']) && isset($request['month']) && isset($request['day'])) {
            $year = (int) $request['year'];
            $month = (int) $request['month'];
            $day = (int) $request['day'];
            if ($year > 0 && $month > 0 && $day > 0 && checkdate($month, $day, $year)) {
                return sprintf('%04d-%02d-%02d', $year, $month, $day);
            }
        }

        $raw = isset($request['fechaNac']) ? trim((string) $request['fechaNac']) : (isset($request['birth_date']) ? trim((string) $request['birth_date']) : '');
        if ($raw === '') {
            return null;
        }

        $timestamp = strtotime($raw);
        if ($timestamp === false) {
            return null;
        }

        return date('Y-m-d', $timestamp);
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

    private function parseOptionalInteger($request, $key)
    {
        if (!isset($request[$key])) {
            return null;
        }

        $value = $request[$key];
        if (is_int($value)) {
            return $value;
        }

        if (is_bool($value)) {
            return $value ? 1 : 0;
        }

        if (is_numeric($value)) {
            return (int) $value;
        }

        return null;
    }
}
