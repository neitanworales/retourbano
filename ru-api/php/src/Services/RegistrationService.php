<?php

require_once __DIR__ . '/../Models/EventRegistration.php';
require_once __DIR__ . '/../Repository/EventRepository.php';
require_once __DIR__ . '/../Repository/EventRegistrationRepository.php';

class RegistrationService
{
    private $events;
    private $registrations;

    public function __construct()
    {
        $this->events = new EventRepository();
        $this->registrations = new EventRegistrationRepository();
    }

    public function register($userId, $eventId, $requiresLodging = 0, $roomCode = null)
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
            'legacy_registration_id' => null,
            'event_id' => (int) $eventId,
            'user_id' => (int) $userId,
            'event_year' => $event->event_year,
            'registration_status' => 'active',
            'is_confirmed' => 0,
            'attendance_confirmed' => 0,
            'is_staff' => 0,
            'is_admin' => 0,
            'is_followup' => 0,
            'requires_lodging' => (int) $requiresLodging,
            'room_code' => $roomCode,
        ));

        $id = $this->registrations->create($registration);

        return array(
            'id' => (int) $id,
            'event_id' => (int) $eventId,
            'user_id' => (int) $userId,
            'registration_status' => 'active',
        );
    }

    public function updateStatus($registrationId, $status)
    {
        return $this->registrations->updateStatus((int) $registrationId, $status);
    }

    public function getById($registrationId)
    {
        return $this->registrations->findModelById((int) $registrationId);
    }

    public function getByEvent($eventId, $limit = 100, $offset = 0)
    {
        return $this->registrations->findByEvent((int) $eventId, (int) $limit, (int) $offset);
    }

    public function getByUser($userId, $limit = 100, $offset = 0)
    {
        return $this->registrations->findByUser((int) $userId, (int) $limit, (int) $offset);
    }
}
