<?php

require_once __DIR__ . '/../Repository/EventRegistrationRepository.php';

class LodgingService
{
    private $registrationRepository;
    private $logFile;

    public function __construct()
    {
        $this->registrationRepository = new EventRegistrationRepository();
        $this->logFile = __DIR__ . '/../../logs/lodging.log';
        $this->ensureLogDirectory();
        
    }

    private function ensureLogDirectory()
    {
        $logDir = dirname($this->logFile);
        if (!is_dir($logDir)) {
            @mkdir($logDir, 0755, true);
        }
    }

    private function log($message, $level = 'INFO', $context = array())
    {
        $timestamp = date('Y-m-d H:i:s');
        $contextStr = !empty($context) ? ' | ' . json_encode($context) : '';
        $logMessage = "[$timestamp] [$level] $message$contextStr\n";
        @file_put_contents($this->logFile, $logMessage, FILE_APPEND);
    }

    /**
     * Get registrations filtered by lodging requirement
     * @param int $eventId
     * @param int|null $requiresLodging 1 for with lodging, 0 for without, null for all
     */
    public function getRegistrationsByLodging($eventId, $requiresLodging = null)
    {
        if ($eventId <= 0) {
            $this->log('Invalid event ID', 'ERROR', array('event_id' => $eventId));
            throw new Exception('Invalid event ID');
        }

        $filters = array('event_id' => $eventId);

        if ($requiresLodging !== null) {
            if (!in_array($requiresLodging, array(0, 1))) {
                $this->log('Invalid lodging requirement value', 'ERROR', array('requires_lodging' => $requiresLodging));
                throw new Exception('Invalid lodging requirement value');
            }
            $filters['requires_lodging'] = $requiresLodging;
        }

        $this->log('Fetching registrations by lodging', 'INFO', array('event_id' => $eventId, 'requires_lodging' => $requiresLodging));
        $registrations = $this->registrationRepository->findByFilters($filters);
        $this->log('Registrations fetched successfully', 'INFO', array('count' => count($registrations)));

        return $registrations;
    }

    /**
     * Get all rooms with their occupants
     */
    public function getRoomsList($eventId)
    {
        if ($eventId <= 0) {
            $this->log('Invalid event ID for rooms list', 'ERROR', array('event_id' => $eventId));
            throw new Exception('Invalid event ID');
        }

        $this->log('Fetching rooms list', 'INFO', array('event_id' => $eventId));

        $registrations = $this->registrationRepository->findByFilters(array(
            'event_id' => $eventId,
            'requires_lodging' => 1,
            'room_code_not_null' => true
        ));

        $roomsMap = array();

        foreach ($registrations as $registration) {
            
            $roomCode = $registration->room_code;

            if (!isset($roomsMap[$roomCode])) {
                $roomsMap[$roomCode] = array(
                    'room_code' => $roomCode,
                    'occupants_count' => 0,
                    'registrations' => array()
                );
            }

            $roomsMap[$roomCode]['occupants_count']++;
            $roomsMap[$roomCode]['registrations'][] = $registration->toArray();

            
        }

        $rooms = array_values($roomsMap);
        $this->log('Rooms list fetched successfully', 'INFO', array('total_rooms' => count($rooms)));

        return $rooms;
    }

    /**
     * Get registrations without room assignment
     */
    public function getUnassignedRegistrations($eventId)
    {
        if ($eventId <= 0) {
            $this->log('Invalid event ID for unassigned registrations', 'ERROR', array('event_id' => $eventId));
            throw new Exception('Invalid event ID');
        }

        $this->log('Fetching unassigned registrations', 'INFO', array('event_id' => $eventId));
        $registrations = $this->registrationRepository->findByFilters(array(
            'event_id' => $eventId,
            'requires_lodging' => 1,
            'room_code_null' => true
        ));
        $this->log('Unassigned registrations fetched', 'INFO', array('count' => count($registrations)));

        return $registrations;
    }

    /**
     * Update room assignment
     */
    public function updateRoomAssignment($registrationId, $roomCode)
    {
        if ($registrationId <= 0) {
            $this->log('Invalid registration ID', 'ERROR', array('registration_id' => $registrationId));
            throw new Exception('Invalid registration ID');
        }

        if (empty(trim($roomCode))) {
            $this->log('Room code cannot be empty', 'ERROR', array('registration_id' => $registrationId));
            throw new Exception('Room code cannot be empty');
        }

        // Validate registration exists
        $registration = $this->registrationRepository->findModelById($registrationId);
        if (!$registration) {
            $this->log('Registration not found', 'ERROR', array('registration_id' => $registrationId));
            throw new Exception('Registration not found');
        }

        $this->log('Updating room assignment', 'INFO', array(
            'registration_id' => $registrationId,
            'new_room_code' => $roomCode,
            'old_room_code' => $registration->room_code
        ));

        $success = $this->registrationRepository->updateFields($registrationId, array(
            'room_code' => $roomCode
        ));

        if ($success) {
            $this->log('Room assignment updated successfully', 'INFO', array('registration_id' => $registrationId));
        } else {
            $this->log('Failed to update room assignment', 'ERROR', array('registration_id' => $registrationId));
        }

        return $success;
    }

    /**
     * Update lodging requirement
     */
    public function updateLodgingRequirement($registrationId, $requiresLodging)
    {
        if ($registrationId <= 0) {
            $this->log('Invalid registration ID', 'ERROR', array('registration_id' => $registrationId));
            throw new Exception('Invalid registration ID');
        }

        if (!in_array($requiresLodging, array(0, 1))) {
            $this->log('Invalid lodging requirement value', 'ERROR', array('requires_lodging' => $requiresLodging));
            throw new Exception('Invalid lodging requirement value');
        }

        // Validate registration exists
        $registration = $this->registrationRepository->findModelById($registrationId);
        if (!$registration) {
            $this->log('Registration not found', 'ERROR', array('registration_id' => $registrationId));
            throw new Exception('Registration not found');
        }

        $this->log('Updating lodging requirement', 'INFO', array(
            'registration_id' => $registrationId,
            'new_value' => $requiresLodging,
            'old_value' => $registration->requires_lodging
        ));

        $success = $this->registrationRepository->updateFields($registrationId, array(
            'requires_lodging' => (int) $requiresLodging
        ));

        if ($success) {
            $this->log('Lodging requirement updated successfully', 'INFO', array('registration_id' => $registrationId));
        } else {
            $this->log('Failed to update lodging requirement', 'ERROR', array('registration_id' => $registrationId));
        }

        return $success;
    }
}
