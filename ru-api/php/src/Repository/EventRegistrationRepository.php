<?php

require_once __DIR__ . '/BaseRepository.php';
require_once __DIR__ . '/../Models/EventRegistration.php';

class EventRegistrationRepository extends BaseRepository
{
    protected $table = 'event_registrations';

    private function getActiveRegistrationCondition($registrationAlias = 'er')
    {
        return "($registrationAlias.registration_status IS NULL OR $registrationAlias.registration_status NOT IN ('B', 'inactive'))";
    }

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
        $sql = 'INSERT INTO event_registrations (event_id, user_id, event_year, registration_status, is_confirmed, attendance_confirmed, is_staff, is_admin, is_followup, welcome_email_sent, email_confirmed, requires_lodging, room_code, reasons)
            VALUES (?, ?, ?, \'A\', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param(
            'iiiiiiiiiiiss',
            $registration->event_id,
            $registration->user_id,
            $registration->event_year,
            $registration->is_confirmed,
            $registration->attendance_confirmed,
            $registration->is_staff,
            $registration->is_admin,
            $registration->is_followup,
            $registration->welcome_email_sent,
            $registration->email_confirmed,
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

    public function incrementWelcomeEmailSent($id)
    {
        $sql = 'UPDATE event_registrations
                SET welcome_email_sent = COALESCE(welcome_email_sent, 0) + 1,
                    updated_at = NOW()
                WHERE id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $id);
        $ok = $stmt->execute();
        $stmt->close();

        if (!$ok) {
            return false;
        }

        $registration = $this->findModelById($id);
        if (!$registration) {
            return false;
        }

        return (int) $registration->welcome_email_sent;
    }

    public function incrementConfirmationEmailSent($id)
    {
        $sql = 'UPDATE event_registrations
                SET email_confirmed = COALESCE(email_confirmed, 0) + 1,
                    updated_at = NOW()
                WHERE id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $id);
        $ok = $stmt->execute();
        $stmt->close();

        if (!$ok) {
            return false;
        }

        $registration = $this->findModelById($id);
        if (!$registration) {
            return false;
        }

        return (int) $registration->email_confirmed;
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

        //echo "SQL: $sql\n";
        //echo "Params: " . implode(', ', $params) . "\n";

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

    /**
     * Flexible query builder for complex filters
     * @param array $filters Key-value pairs of filters (e.g., event_id, requires_lodging, room_code_null, etc.)
     */
    public function findByFilters($filters = array())
    {
        $sql = 'SELECT * FROM event_registrations WHERE 1=1';
        $types = '';
        $params = array();

        if (array_key_exists('event_id', $filters) && $filters['event_id'] !== null) {
            $sql .= ' AND event_id = ?';
            $types .= 'i';
            $params[] = (int) $filters['event_id'];
        }

        if (array_key_exists('user_id', $filters) && $filters['user_id'] !== null) {
            $sql .= ' AND user_id = ?';
            $types .= 'i';
            $params[] = (int) $filters['user_id'];
        }

        if (array_key_exists('requires_lodging', $filters) && $filters['requires_lodging'] !== null) {
            $sql .= ' AND requires_lodging = ?';
            $types .= 'i';
            $params[] = (int) $filters['requires_lodging'];
        }

        if (array_key_exists('registration_status', $filters) && $filters['registration_status'] !== null) {
            $sql .= ' AND registration_status = ?';
            $types .= 's';
            $params[] = trim((string) $filters['registration_status']);
        }

        if (array_key_exists('is_staff', $filters) && $filters['is_staff'] !== null) {
            $sql .= ' AND is_staff = ?';
            $types .= 'i';
            $params[] = (int) $filters['is_staff'];
        }

        // Handle room_code_null and room_code_not_null special filters
        if (array_key_exists('room_code_null', $filters) && $filters['room_code_null'] === true) {
            $sql .= ' AND (room_code IS NULL OR room_code = "")';
        }

        if (array_key_exists('room_code_not_null', $filters) && $filters['room_code_not_null'] === true) {
            $sql .= ' AND room_code IS NOT NULL AND room_code != ""';
        }

        $sql .= ' ORDER BY created_at DESC';

        $stmt = $this->db->prepare($sql);

        if (!empty($params)) {
            $bindParams = array($types);
            foreach ($params as $key => $value) {
                $bindParams[] = &$params[$key];
            }
            call_user_func_array(array($stmt, 'bind_param'), $bindParams);
        }

        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new EventRegistration($row);
        }, $rows);
    }

    public function findByUser($userId, $limit = 100, $offset = 0, $includeActive = false)
    {
        $sql = 'SELECT e.*, 
                   er.id AS registration_id,
                   er.user_id AS user_id,
                   er.event_id AS event_id,
                   er.registration_status AS registration_status,
                   CASE WHEN er.id IS NULL THEN 0 ELSE 1 END AS is_registered
            FROM events e
            LEFT JOIN event_registrations er ON er.event_id = e.id 
                WHERE er.user_id = ?';

        if (!$includeActive) {
            $sql .= ' AND e.is_active = 0';
        }

        $sql .= ' ORDER BY e.is_active DESC, e.event_year DESC, e.start_at DESC LIMIT ? OFFSET ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('iii', $userId, $limit, $offset);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new Event($row);
        }, $rows);
    }

    public function findLatestEventSummaryByUserIds($userIds)
    {
        $userIds = array_values(array_unique(array_map('intval', is_array($userIds) ? $userIds : array())));
        if (empty($userIds)) {
            return array();
        }

        $placeholders = implode(',', array_fill(0, count($userIds), '?'));
        $sql = "SELECT er.user_id,
                       e.id AS event_id,
                       e.title,
                       e.event_year,
                       e.is_active,
                       e.start_at,
                       er.registration_status,
                       er.created_at AS registration_created_at,
                       er.id AS registration_id
                FROM event_registrations er
                INNER JOIN events e ON e.id = er.event_id
                INNER JOIN (
                    SELECT er2.user_id,
                           MAX(COALESCE(er2.created_at, e2.start_at, '1970-01-01 00:00:00')) AS latest_marker,
                           MAX(er2.id) AS latest_registration_id
                    FROM event_registrations er2
                    INNER JOIN events e2 ON e2.id = er2.event_id
                    WHERE er2.user_id IN ($placeholders)
                    GROUP BY er2.user_id
                ) latest ON latest.user_id = er.user_id
                       AND COALESCE(er.created_at, e.start_at, '1970-01-01 00:00:00') = latest.latest_marker
                       AND er.id = latest.latest_registration_id
                WHERE er.user_id IN ($placeholders)";

        $stmt = $this->db->prepare($sql);
        $types = str_repeat('i', count($userIds) * 2);
        $params = array_merge($userIds, $userIds);
        $stmt->bind_param($types, ...$params);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        $result = array();
        foreach ($rows as $row) {
            $result[(int) $row['user_id']] = $this->mapEventSummaryRow($row);
        }

        return $result;
    }

    public function findActiveEventSummariesByUserIds($userIds)
    {
        $userIds = array_values(array_unique(array_map('intval', is_array($userIds) ? $userIds : array())));
        if (empty($userIds)) {
            return array();
        }

        $placeholders = implode(',', array_fill(0, count($userIds), '?'));
        $activeCondition = $this->getActiveRegistrationCondition('er');
        $sql = "SELECT er.user_id,
                       e.id AS event_id,
                       e.title,
                       e.event_year,
                       e.is_active,
                       e.start_at,
                       er.registration_status,
                       er.created_at AS registration_created_at,
                       er.id AS registration_id
                FROM event_registrations er
                INNER JOIN events e ON e.id = er.event_id
                WHERE er.user_id IN ($placeholders)
                  AND e.is_active = 1
                  AND $activeCondition
                ORDER BY er.user_id ASC, e.start_at ASC, e.id ASC";

        $stmt = $this->db->prepare($sql);
        $types = str_repeat('i', count($userIds));
        $stmt->bind_param($types, ...$userIds);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        $result = array();
        foreach ($rows as $row) {
            $userId = (int) $row['user_id'];
            if (!isset($result[$userId])) {
                $result[$userId] = array();
            }
            $result[$userId][] = $this->mapEventSummaryRow($row);
        }

        return $result;
    }

    public function findHistoricalEventSummariesByUserIds($userIds)
    {
        $userIds = array_values(array_unique(array_map('intval', is_array($userIds) ? $userIds : array())));
        if (empty($userIds)) {
            return array();
        }

        $placeholders = implode(',', array_fill(0, count($userIds), '?'));
        $sql = "SELECT er.user_id,
                       e.id AS event_id,
                       e.title,
                       e.event_year,
                       e.is_active,
                       e.start_at,
                       er.registration_status,
                       er.created_at AS registration_created_at,
                       er.id AS registration_id
                FROM event_registrations er
                INNER JOIN events e ON e.id = er.event_id
                WHERE er.user_id IN ($placeholders)
                ORDER BY er.user_id ASC,
                         COALESCE(e.start_at, STR_TO_DATE(CONCAT(e.event_year, '-01-01'), '%Y-%m-%d')) DESC,
                         e.id DESC";

        $stmt = $this->db->prepare($sql);
        $types = str_repeat('i', count($userIds));
        $stmt->bind_param($types, ...$userIds);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        $result = array();
        foreach ($rows as $row) {
            $userId = (int) $row['user_id'];
            if (!isset($result[$userId])) {
                $result[$userId] = array();
            }
            $result[$userId][] = $this->mapEventSummaryRow($row);
        }

        return $result;
    }

    private function mapEventSummaryRow($row)
    {
        return array(
            'event_id' => isset($row['event_id']) ? (int) $row['event_id'] : null,
            'title' => isset($row['title']) ? $row['title'] : null,
            'event_year' => isset($row['event_year']) ? (int) $row['event_year'] : null,
            'is_active' => isset($row['is_active']) ? (int) $row['is_active'] : 0,
            'start_at' => isset($row['start_at']) ? $row['start_at'] : null,
            'registration_status' => isset($row['registration_status']) ? $row['registration_status'] : null,
            'registration_id' => isset($row['registration_id']) ? (int) $row['registration_id'] : null,
            'registration_created_at' => isset($row['registration_created_at']) ? $row['registration_created_at'] : null,
        );
    }
}
