<?php

require_once __DIR__ . '/BaseRepository.php';

class EventDashboardRepository extends BaseRepository
{
    private function getActiveRegistrationCondition()
    {
        return "(er.registration_status IS NULL OR er.registration_status NOT IN ('B', 'inactive'))";
    }

    public function getCoreMetrics($eventId)
    {
        $activeCondition = $this->getActiveRegistrationCondition();
        $sql = "SELECT
                    SUM(CASE WHEN $activeCondition THEN 1 ELSE 0 END) AS active_registrations,
                    SUM(CASE WHEN NOT $activeCondition THEN 1 ELSE 0 END) AS inactive_registrations,
                    SUM(CASE WHEN $activeCondition AND er.is_staff = 0 THEN 1 ELSE 0 END) AS campers,
                    SUM(CASE WHEN $activeCondition AND er.is_staff = 1 THEN 1 ELSE 0 END) AS staff,
                    SUM(CASE WHEN $activeCondition AND er.is_admin = 1 THEN 1 ELSE 0 END) AS admins,
                    SUM(CASE WHEN $activeCondition AND er.requires_lodging = 1 THEN 1 ELSE 0 END) AS with_lodging,
                    SUM(CASE WHEN $activeCondition AND (er.requires_lodging = 0 OR er.requires_lodging IS NULL) THEN 1 ELSE 0 END) AS without_lodging,
                    SUM(CASE WHEN $activeCondition AND er.is_followup = 1 THEN 1 ELSE 0 END) AS followup,
                    SUM(CASE WHEN $activeCondition AND er.welcome_email_sent = 1 THEN 1 ELSE 0 END) AS welcome_email_sent,
                    SUM(CASE WHEN $activeCondition AND er.email_confirmed = 1 THEN 1 ELSE 0 END) AS email_confirmed,
                    SUM(CASE WHEN $activeCondition AND er.is_confirmed = 1 THEN 1 ELSE 0 END) AS confirmed,
                    SUM(CASE WHEN $activeCondition AND er.attendance_confirmed = 1 THEN 1 ELSE 0 END) AS attendance_confirmed
                FROM event_registrations er
                WHERE er.event_id = ?";

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $eventId);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ?: array();
    }

    public function getGenderBreakdown($eventId, $staffOnly)
    {
        $activeCondition = $this->getActiveRegistrationCondition();
        $sql = "SELECT
                    COALESCE(NULLIF(TRIM(u.gender), ''), 'U') AS gender,
                    COUNT(*) AS count
                FROM event_registrations er
                INNER JOIN users u ON u.id = er.user_id
                WHERE er.event_id = ?
                  AND $activeCondition
                  AND er.is_staff = ?
                GROUP BY COALESCE(NULLIF(TRIM(u.gender), ''), 'U')
                ORDER BY count DESC, gender ASC";

        $staffValue = $staffOnly ? 1 : 0;
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('ii', $eventId, $staffValue);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return $rows;
    }

    public function getShirtSizeBreakdown($eventId)
    {
        $activeCondition = $this->getActiveRegistrationCondition();
        $sql = "SELECT
                    COALESCE(NULLIF(TRIM(u.shirt_size), ''), 'SIN_TALLA') AS shirt_size,
                    COUNT(*) AS count
                FROM event_registrations er
                INNER JOIN users u ON u.id = er.user_id
                WHERE er.event_id = ?
                  AND $activeCondition
                GROUP BY COALESCE(NULLIF(TRIM(u.shirt_size), ''), 'SIN_TALLA')
                ORDER BY count DESC, shirt_size ASC";

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $eventId);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return $rows;
    }

    public function getParticipantBirthDates($eventId)
    {
        $activeCondition = $this->getActiveRegistrationCondition();
        $sql = "SELECT
                    u.id AS user_id,
                    u.full_name,
                    u.display_name,
                    u.birth_date
                FROM event_registrations er
                INNER JOIN users u ON u.id = er.user_id
                WHERE er.event_id = ?
                  AND $activeCondition
                  AND u.birth_date IS NOT NULL
                ORDER BY u.birth_date ASC";

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $eventId);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return $rows;
    }

    public function getPaymentSummary($eventId, $fullPaymentAmount = null, $activeRegistrations = null)
    {
        $activeCondition = $this->getActiveRegistrationCondition();
        $sql = "SELECT
                    COALESCE(SUM(p.amount), 0) AS total_revenue,
                    COUNT(p.id) AS payments_count,
                    COUNT(DISTINCT CASE WHEN p.id IS NOT NULL THEN er.id END) AS registrations_with_payments
                FROM event_registrations er
                LEFT JOIN payments p ON p.event_registration_id = er.id
                WHERE er.event_id = ?
                  AND $activeCondition";

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $eventId);
        $stmt->execute();
        $summary = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        $summary = $summary ?: array();
        $summary['fully_paid_count'] = null;
        $summary['average_payment'] = isset($summary['payments_count']) && (int) $summary['payments_count'] > 0
            ? round(((float) $summary['total_revenue']) / (int) $summary['payments_count'], 2)
            : 0.0;
        $summary['expected_revenue'] = null;
        $summary['payment_coverage_percentage'] = null;
        $summary['pending_balance'] = null;

        if ($fullPaymentAmount !== null && $activeRegistrations !== null) {
            $expectedRevenue = (float) $fullPaymentAmount * (int) $activeRegistrations;
            $summary['expected_revenue'] = round($expectedRevenue, 2);
            $summary['payment_coverage_percentage'] = $expectedRevenue > 0
                ? round(((float) $summary['total_revenue'] * 100) / $expectedRevenue, 2)
                : 0.0;
            $summary['pending_balance'] = max($expectedRevenue - (float) $summary['total_revenue'], 0);
        }

        if ($fullPaymentAmount !== null && (float) $fullPaymentAmount > 0) {
            $fullyPaidSql = "SELECT COUNT(*) AS fully_paid_count
                             FROM (
                                SELECT er.id, COALESCE(SUM(p.amount), 0) AS total_paid
                                FROM event_registrations er
                                LEFT JOIN payments p ON p.event_registration_id = er.id
                                WHERE er.event_id = ?
                                  AND $activeCondition
                                GROUP BY er.id
                             ) payment_totals
                             WHERE total_paid >= ?";

            $amount = (float) $fullPaymentAmount;
            $stmt = $this->db->prepare($fullyPaidSql);
            $stmt->bind_param('id', $eventId, $amount);
            $stmt->execute();
            $row = $stmt->get_result()->fetch_assoc();
            $stmt->close();

            $summary['fully_paid_count'] = isset($row['fully_paid_count']) ? (int) $row['fully_paid_count'] : 0;
        }

        return $summary;
    }

        public function getConfirmationBreakdown($eventId)
        {
                $activeCondition = $this->getActiveRegistrationCondition();
                $sql = "SELECT label, count FROM (
                                        SELECT 'Confirmados' AS label,
                                                     SUM(CASE WHEN er.is_confirmed = 1 THEN 1 ELSE 0 END) AS count,
                                                     1 AS sort_order
                                        FROM event_registrations er
                                        WHERE er.event_id = ?
                                            AND $activeCondition
                                        UNION ALL
                                        SELECT 'Sin confirmar' AS label,
                                                     SUM(CASE WHEN er.is_confirmed = 0 OR er.is_confirmed IS NULL THEN 1 ELSE 0 END) AS count,
                                                     2 AS sort_order
                                        FROM event_registrations er
                                        WHERE er.event_id = ?
                                            AND $activeCondition
                                        UNION ALL
                                        SELECT 'Asistencia confirmada' AS label,
                                                     SUM(CASE WHEN er.attendance_confirmed = 1 THEN 1 ELSE 0 END) AS count,
                                                     3 AS sort_order
                                        FROM event_registrations er
                                        WHERE er.event_id = ?
                                            AND $activeCondition
                                        UNION ALL
                                        SELECT 'Asistencia pendiente' AS label,
                                                     SUM(CASE WHEN er.attendance_confirmed = 0 OR er.attendance_confirmed IS NULL THEN 1 ELSE 0 END) AS count,
                                                     4 AS sort_order
                                        FROM event_registrations er
                                        WHERE er.event_id = ?
                                            AND $activeCondition
                                ) confirmation_totals
                                ORDER BY sort_order ASC";

                $stmt = $this->db->prepare($sql);
                $stmt->bind_param('iiii', $eventId, $eventId, $eventId, $eventId);
                $stmt->execute();
                $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
                $stmt->close();

                return $rows;
        }

        public function getPaymentMethodBreakdown($eventId)
        {
                $activeCondition = $this->getActiveRegistrationCondition();
                $sql = "SELECT
                                        COALESCE(NULLIF(TRIM(p.payment_method), ''), 'SIN_METODO') AS payment_method,
                                        COUNT(*) AS count,
                                        COALESCE(SUM(p.amount), 0) AS total_amount
                                FROM event_registrations er
                                INNER JOIN payments p ON p.event_registration_id = er.id
                                WHERE er.event_id = ?
                                    AND $activeCondition
                                GROUP BY COALESCE(NULLIF(TRIM(p.payment_method), ''), 'SIN_METODO')
                                ORDER BY total_amount DESC, count DESC, payment_method ASC";

                $stmt = $this->db->prepare($sql);
                $stmt->bind_param('i', $eventId);
                $stmt->execute();
                $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
                $stmt->close();

                return $rows;
        }
}
