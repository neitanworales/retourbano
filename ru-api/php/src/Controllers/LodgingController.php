<?php

require_once __DIR__ . '/../Services/LodgingService.php';

class LodgingController extends BaseController
{
    private $lodgingService;

    public function __construct()
    {
        $this->lodgingService = new LodgingService();
    }

    /**
     * GET /api/v1/lodging/registrations
     * Get registrations filtered by lodging requirement
     * Query params: event_id, with_lodging (optional, defaults to all)
     */
    public function getRegistrationsByLodging($request)
    {
        try {
            $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
            $withLodging = isset($request['with_lodging']) ? $this->parseOptionalBoolean($request, 'with_lodging') : null;

            if ($eventId <= 0) {
                return $this->fail('event_id is required and must be positive', 422);
            }

            $registrations = $this->lodgingService->getRegistrationsByLodging($eventId, $withLodging);
            $items = array_map(function ($registration) {
                return $registration->toArray();
            }, $registrations);

            return $this->ok(array('registrations' => $items), 'lodging registrations');
        } catch (Exception $e) {
            error_log('[LodgingController] Error in getRegistrationsByLodging: ' . $e->getMessage());
            return $this->fail('Error fetching registrations: ' . $e->getMessage(), 500);
        }
    }

    /**
     * GET /api/v1/lodging/rooms
     * Get all rooms with their occupants for an event
     * Query params: event_id
     */
    public function getRoomsList($request)
    {
        try {
            $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;

            if ($eventId <= 0) {
                return $this->fail('event_id is required and must be positive', 422);
            }

            $rooms = $this->lodgingService->getRoomsList($eventId);

            return $this->ok(array('rooms' => $rooms), 'rooms list');
        } catch (Exception $e) {
            error_log('[LodgingController] Error in getRoomsList: ' . $e->getMessage());
            return $this->fail('Error fetching rooms: ' . $e->getMessage(), 500);
        }
    }

    /**
     * GET /api/v1/lodging/unassigned
     * Get registrations without room assignment
     * Query params: event_id
     */
    public function getUnassignedRegistrations($request)
    {
        try {
            $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;

            if ($eventId <= 0) {
                return $this->fail('event_id is required and must be positive', 422);
            }

            $registrations = $this->lodgingService->getUnassignedRegistrations($eventId);
            $items = array_map(function ($registration) {
                return $registration->toArray();
            }, $registrations);

            return $this->ok(array('registrations' => $items), 'unassigned registrations');
        } catch (Exception $e) {
            error_log('[LodgingController] Error in getUnassignedRegistrations: ' . $e->getMessage());
            return $this->fail('Error fetching unassigned registrations: ' . $e->getMessage(), 500);
        }
    }

    /**
     * PATCH /api/v1/lodging/room-assignment
     * Update room assignment for a registration
     * Body: { registration_id, room_code }
     */
    public function updateRoomAssignment($request)
    {
        try {
            $registrationId = isset($request['registration_id']) ? (int) $request['registration_id'] : 0;
            $roomCode = isset($request['room_code']) ? trim((string) $request['room_code']) : '';

            if ($registrationId <= 0) {
                return $this->fail('registration_id is required and must be positive', 422);
            }

            if ($roomCode === '') {
                return $this->fail('room_code is required and cannot be empty', 422);
            }

            if (strlen($roomCode) > 50) {
                return $this->fail('room_code cannot exceed 50 characters', 422);
            }

            $success = $this->lodgingService->updateRoomAssignment($registrationId, $roomCode);

            if (!$success) {
                return $this->fail('Failed to update room assignment', 500);
            }

            return $this->ok(array(), 'Room assignment updated successfully');
        } catch (Exception $e) {
            error_log('[LodgingController] Error in updateRoomAssignment: ' . $e->getMessage());
            return $this->fail('Error updating room assignment: ' . $e->getMessage(), 500);
        }
    }

    /**
     * PATCH /api/v1/lodging/lodging-requirement
     * Update lodging requirement for a registration
     * Body: { registration_id, requires_lodging }
     */
    public function updateLodgingRequirement($request)
    {
        try {
            $registrationId = isset($request['registration_id']) ? (int) $request['registration_id'] : 0;
            $requiresLodging = isset($request['requires_lodging']) ? $this->parseOptionalBoolean($request, 'requires_lodging') : null;

            if ($registrationId <= 0) {
                return $this->fail('registration_id is required and must be positive', 422);
            }

            if ($requiresLodging === null) {
                return $this->fail('requires_lodging is required and must be a boolean', 422);
            }

            $success = $this->lodgingService->updateLodgingRequirement($registrationId, $requiresLodging);

            if (!$success) {
                return $this->fail('Failed to update lodging requirement', 500);
            }

            return $this->ok(array(), 'Lodging requirement updated successfully');
        } catch (Exception $e) {
            error_log('[LodgingController] Error in updateLodgingRequirement: ' . $e->getMessage());
            return $this->fail('Error updating lodging requirement: ' . $e->getMessage(), 500);
        }
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
