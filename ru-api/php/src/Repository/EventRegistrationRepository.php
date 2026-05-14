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
        $sql = 'INSERT INTO event_registrations (legacy_registration_id, event_id, user_id, event_year, registration_status, is_confirmed, attendance_confirmed, is_staff, is_admin, is_followup, requires_lodging, room_code, reasons)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param(
            'iiiisiiiiisss',
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
            $registration->room_code,
            $registration->reasons
        );

        $stmt->execute();
        $id = $this->db->insert_id;
        $stmt->close();

        return $id;
    }

    public function updateRolesByUserAndEvent($userId, $eventId, $isStaff, $isAdmin)
    {
        $sql = 'UPDATE event_registrations SET is_staff = ?, is_admin = ?, updated_at = NOW() WHERE user_id = ? AND event_id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('iiii', $isStaff, $isAdmin, $userId, $eventId);
        $stmt->execute();
        $affected = (int) $stmt->affected_rows;
        $stmt->close();

        return $affected;
    }

    public function userHasAnyStaffRegistration($userId)
    {
        return $this->userHasAnyFlagRegistration($userId, 'is_staff');
    }

    public function userHasAnyAdminRegistration($userId)
    {
        return $this->userHasAnyFlagRegistration($userId, 'is_admin');
    }

    private function userHasAnyFlagRegistration($userId, $flagColumn)
    {
        if (!in_array($flagColumn, array('is_staff', 'is_admin'), true)) {
            return false;
        }

        $sql = "SELECT 1 FROM event_registrations WHERE user_id = ? AND $flagColumn = 1 LIMIT 1";
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $userId);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? true : false;
    }

    public function updateStatus($id, $status)
    {
        return $this->updateFields($id, array('registration_status' => $status));
    }

    public function updateFields($id, $fields)
    {
        $allowed = array(
            'registration_status' => 's',
            'is_confirmed' => 'i',
            'attendance_confirmed' => 'i',
            'is_followup' => 'i',
            'welcome_email_sent' => 'i',
            'email_confirmed' => 'i',
            'requires_lodging' => 'i',
            'room_code' => 's',
            'reasons' => 's',
        );

        $setParts = array();
        $types = '';
        $params = array();

        foreach ($fields as $column => $value) {
            if (!array_key_exists($column, $allowed)) {
                continue;
            }
            $setParts[] = "$column = ?";
            $types .= $allowed[$column];
            $params[] = $allowed[$column] === 'i' ? (int) $value : (string) $value;
        }

        if (empty($setParts)) {
            return false;
        }

        $sql = 'UPDATE event_registrations SET ' . implode(', ', $setParts) . ', updated_at = NOW() WHERE id = ?';
        $types .= 'i';
        $params[] = (int) $id;

        $stmt = $this->db->prepare($sql);

        $bindParams = array($types);
        foreach ($params as $key => $value) {
            $bindParams[] = &$params[$key];
        }

        call_user_func_array(array($stmt, 'bind_param'), $bindParams);
        $ok = $stmt->execute();
        $stmt->close();

        return $ok;
    }

    public function findByEvent($eventId, $limit = 100, $offset = 0, $filters = array())
    {
        $filters = is_array($filters) ? $filters : array();

        $sql = 'SELECT * FROM event_registrations WHERE event_id = ?';
        $types = 'i';
        $params = array((int) $eventId);

        if (array_key_exists('is_staff', $filters) && $filters['is_staff'] !== null) {
            $sql .= ' AND is_staff = ?';
            $types .= 'i';
            $params[] = (int) $filters['is_staff'];
        }

        if (array_key_exists('is_admin', $filters) && $filters['is_admin'] !== null) {
            $sql .= ' AND is_admin = ?';
            $types .= 'i';
            $params[] = (int) $filters['is_admin'];
        }

        if (array_key_exists('is_followup', $filters) && $filters['is_followup'] !== null) {
            $sql .= ' AND is_followup = ?';
            $types .= 'i';
            $params[] = (int) $filters['is_followup'];
        }

        if (array_key_exists('registration_status', $filters) && $filters['registration_status'] !== null && $filters['registration_status'] !== '') {
            $sql .= ' AND registration_status = ?';
            $types .= 's';
            $params[] = trim((string) $filters['registration_status']);
        }

        $sql .= ' ORDER BY created_at DESC LIMIT ? OFFSET ?';
        $types .= 'ii';
        $params[] = (int) $limit;
        $params[] = (int) $offset;

        $stmt = $this->db->prepare($sql);

        $bindParams = array($types);
        foreach ($params as $key => $value) {
            $bindParams[] = &$params[$key];
        }

        call_user_func_array(array($stmt, 'bind_param'), $bindParams);
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
