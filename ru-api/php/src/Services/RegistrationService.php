<?php

require_once __DIR__ . '/../Models/EventRegistration.php';
require_once __DIR__ . '/../Repository/EventRepository.php';
require_once __DIR__ . '/../Repository/EventRegistrationRepository.php';
require_once __DIR__ . '/../Repository/UserRepository.php';
require_once __DIR__ . '/EmailService.php';

class RegistrationService
{
    private $events;
    private $registrations;
    private $users;
    private $email;

    public function __construct()
    {
        $this->events = new EventRepository();
        $this->registrations = new EventRegistrationRepository();
        $this->users = new UserRepository();
        $this->email = new EmailService();
    }

    public function register($userId, $eventId, $requiresLodging = 0, $roomCode = null, $reasons = null, $legacyRegistrationId = null)
    {
        $event = $this->events->findModelById((int) $eventId);
        if (!$event) {
            return array('error' => 'Event not found');
        }

        if ((int) $event->is_active !== 1) {
            return array('error' => 'Event is not active');
        }

        $existing = $this->registrations->findByEventAndUser((int) $eventId, (int) $userId);
        if ($existing) {
            return array('error' => 'User is already registered for this event', 'registration_id' => (int) $existing->id);
        }

        $registration = new EventRegistration(array(
            'legacy_registration_id' => $legacyRegistrationId,
            'event_id' => (int) $eventId,
            'user_id' => (int) $userId,
            'event_year' => $event->event_year,
            'registration_status' => 'A',
            'is_confirmed' => 0,
            'attendance_confirmed' => 0,
            'is_staff' => 0,
            'is_admin' => 0,
            'is_followup' => 0,
            'welcome_email_sent' => 0,
            'email_confirmed' => 0,
            'requires_lodging' => (int) $requiresLodging,
            'room_code' => $roomCode,
            'reasons' => $reasons,
        ));

        $id = $this->registrations->create($registration);

        $user = $this->users->findModelById((int) $userId);
        if ($user) {
            $emailSent = $this->email->sendRegistrationEmail($user, $event, $requiresLodging, $reasons) ? 1 : 0;
            if ($emailSent) {
                $this->registrations->updateFields((int) $id, array('welcome_email_sent' => 1));
            }
        }

        return array(
            'id' => (int) $id,
            'event_id' => (int) $eventId,
            'user_id' => (int) $userId,
            'registration_status' => 'A',
        );
    }

    public function updateStatus($registrationId, $status)
    {
        return $this->registrations->updateStatus((int) $registrationId, $status);
    }

    public function updateFields($registrationId, $fields)
    {
        return $this->registrations->updateFields((int) $registrationId, is_array($fields) ? $fields : array());
    }

    public function getById($registrationId)
    {
        return $this->registrations->findModelById((int) $registrationId);
    }

    public function getByEvent($eventId, $limit = 100, $offset = 0, $filters = array())
    {
        return $this->registrations->findByEvent((int) $eventId, (int) $limit, (int) $offset, $filters);
    }

    public function getByUser($userId, $limit = 100, $offset = 0)
    {
        return $this->registrations->findByUser((int) $userId, (int) $limit, (int) $offset);
    }
}
