<?php

require_once __DIR__ . '/BaseRepository.php';
require_once __DIR__ . '/../Models/EventRegistration.php';

class EventRegistrationRepository extends BaseRepository
{
    protected $table = 'event_registrations';

    public function findModelById($id)
    {
        $row = $this->findById($id);
        return $row ? new EventRegistration($row) : null;
    }

    public function findByLegacyId($legacyId)
    {
        $sql = 'SELECT * FROM event_registrations WHERE legacy_registration_id = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $legacyId);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? new EventRegistration($row) : null;
    }

    public function findByEventAndUser($eventId, $userId)
    {
        $sql = 'SELECT * FROM event_registrations WHERE event_id = ? AND user_id = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('ii', $eventId, $userId);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? new EventRegistration($row) : null;
    }

    public function create(EventRegistration $registration)
    {
        $sql = 'INSERT INTO event_registrations (legacy_registration_id, event_id, user_id, event_year, registration_status, is_confirmed, attendance_confirmed, is_staff, is_admin, is_followup, requires_lodging, room_code)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param(
            'iiiisiiiiiss',
            $registration->legacy_registration_id,
            $registration->event_id,
            $registration->user_id,
            $registration->event_year,
            $registration->registration_status,
            $registration->is_confirmed,
            $registration->attendance_confirmed,
            $registration->is_staff,
            $registration->is_admin,
            $registration->is_followup,
            $registration->requires_lodging,
            $registration->room_code
        );

        $stmt->execute();
        $id = $this->db->insert_id;
        $stmt->close();

        return $id;
    }

    public function updateStatus($id, $status)
    {
        $sql = 'UPDATE event_registrations SET registration_status = ? WHERE id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('si', $status, $id);
        $ok = $stmt->execute();
        $stmt->close();

        return $ok;
    }

    public function findByEvent($eventId, $limit = 100, $offset = 0)
    {
        $sql = 'SELECT * FROM event_registrations WHERE event_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('iii', $eventId, $limit, $offset);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new EventRegistration($row);
        }, $rows);
    }

    public function findByUser($userId, $limit = 100, $offset = 0)
    {
        $sql = 'SELECT * FROM events e
                LEFT JOIN event_registrations er ON er.event_id = e.id 
                WHERE er.user_id = ? AND e.is_active = 0 ORDER BY e.event_year DESC LIMIT ? OFFSET ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('iii', $userId, $limit, $offset);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new Event($row);
        }, $rows);
    }
}
