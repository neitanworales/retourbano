<?php

require_once __DIR__ . '/BaseRepository.php';

class AccountingRepository extends BaseRepository
{
    public function getPaymentsByEvent($eventId)
    {
        $sql = "SELECT
                    p.id AS id_pago,
                    p.event_registration_id,
                    p.amount AS cantidad,
                    p.description AS descripcion,
                    p.currency AS divisa,
                    p.receipt_number AS no_ticket,
                    COALESCE(NULLIF(TRIM(u.display_name), ''), u.full_name) AS nombre
                FROM payments p
                INNER JOIN event_registrations er ON er.id = p.event_registration_id
                INNER JOIN users u ON u.id = er.user_id
                WHERE er.event_id = ?
                ORDER BY p.id ASC";

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $eventId);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return $rows ?: array();
    }

    public function getPaymentsByUser($eventId)
    {
        $activeCondition = $this->getActiveRegistrationCondition();
        $sql = "SELECT
                    u.id AS user_id,
                    COALESCE(NULLIF(TRIM(u.display_name), ''), u.full_name) AS nombre,
                    MAX(er.is_staff) AS descripcion,
                    COALESCE(SUM(p.amount), 0) AS cantidad,
                    COUNT(p.id) AS pagos
                FROM event_registrations er
                INNER JOIN users u ON u.id = er.user_id
                LEFT JOIN payments p ON p.event_registration_id = er.id
                WHERE er.event_id = ?
                  AND $activeCondition
                GROUP BY u.id
                ORDER BY cantidad ASC, nombre ASC";

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $eventId);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return $rows ?: array();
    }

    public function getPaymentsByDescription($eventId)
    {
        $sql = "SELECT
                    p.description AS descripcion,
                    COALESCE(SUM(p.amount), 0) AS total
                FROM payments p
                INNER JOIN event_registrations er ON er.id = p.event_registration_id
                WHERE er.event_id = ?
                GROUP BY p.description
                ORDER BY total DESC";

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $eventId);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return $rows ?: array();
    }

    public function getPendingByUser($eventId)
    {
        $activeCondition = $this->getActiveRegistrationCondition();
        $sql = "SELECT
                    u.id AS user_id,
                    COALESCE(NULLIF(TRIM(u.display_name), ''), u.full_name) AS nombre,
                    MAX(er.is_staff) AS is_staff,
                    COALESCE(SUM(p.amount), 0) AS total_paid,
                    COUNT(p.id) AS payment_count,
                    MAX(COALESCE(p.paid_at, p.created_at)) AS last_payment_at
                FROM event_registrations er
                INNER JOIN users u ON u.id = er.user_id
                LEFT JOIN payments p ON p.event_registration_id = er.id
                WHERE er.event_id = ?
                  AND $activeCondition
                GROUP BY u.id
                ORDER BY total_paid ASC, nombre ASC";

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $eventId);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return $rows ?: array();
    }

    public function getCashflowByDate($eventId, $startDate = null, $endDate = null)
    {
        $sql = "SELECT
                    DATE(COALESCE(p.paid_at, p.created_at)) AS fecha,
                    COALESCE(SUM(p.amount), 0) AS total_amount,
                    COUNT(p.id) AS payments_count
                FROM payments p
                INNER JOIN event_registrations er ON er.id = p.event_registration_id
                WHERE er.event_id = ?";

        $params = array((int) $eventId);
        $types = 'i';

        if ($startDate) {
            $sql .= " AND DATE(COALESCE(p.paid_at, p.created_at)) >= ?";
            $params[] = $startDate;
            $types .= 's';
        }

        if ($endDate) {
            $sql .= " AND DATE(COALESCE(p.paid_at, p.created_at)) <= ?";
            $params[] = $endDate;
            $types .= 's';
        }

        $sql .= " GROUP BY DATE(COALESCE(p.paid_at, p.created_at)) ORDER BY fecha ASC";

        $stmt = $this->db->prepare($sql);

        $bindParams = array($types);
        foreach ($params as $index => $value) {
            $bindParams[] = &$params[$index];
        }

        call_user_func_array(array($stmt, 'bind_param'), $bindParams);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return $rows ?: array();
    }

    private function getActiveRegistrationCondition()
    {
        return "(er.registration_status IS NULL OR er.registration_status NOT IN ('B', 'inactive'))";
    }
}
