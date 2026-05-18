<?php

require_once __DIR__ . '/../Repository/AccountingRepository.php';
require_once __DIR__ . '/../Repository/EventDashboardRepository.php';
require_once __DIR__ . '/../Repository/EventRepository.php';

class AccountingService
{
    private $accounting;
    private $dashboard;
    private $events;

    public function __construct()
    {
        $this->accounting = new AccountingRepository();
        $this->dashboard = new EventDashboardRepository();
        $this->events = new EventRepository();
    }

    public function getSummary($eventId, $legacyEventId = null, $fullPaymentAmount = null)
    {
        $event = $this->resolveEvent($eventId, $legacyEventId);
        if (is_array($event) && isset($event['error'])) {
            return $event;
        }

        $eventId = (int) $event->id;
        $core = $this->dashboard->getCoreMetrics($eventId);
        $activeRegistrations = isset($core['active_registrations']) ? (int) $core['active_registrations'] : 0;

        $targetAmount = $this->normalizeAmount($fullPaymentAmount);
        if ($targetAmount === null) {
            $targetAmount = isset($event->price_mxn) && $event->price_mxn !== null
                ? (float) $event->price_mxn
                : null;
        }

        $payments = $this->dashboard->getPaymentSummary($eventId, $targetAmount, $activeRegistrations);

        $indicators = array(
            array('valor' => 'Ingresos', 'count' => isset($payments['total_revenue']) ? (float) $payments['total_revenue'] : 0.0, 'paquete' => 1),
            array('valor' => 'Pagos registrados', 'count' => isset($payments['payments_count']) ? (int) $payments['payments_count'] : 0, 'paquete' => 1),
            array('valor' => 'Registros con pago', 'count' => isset($payments['registrations_with_payments']) ? (int) $payments['registrations_with_payments'] : 0, 'paquete' => 1),
        );

        if (isset($payments['fully_paid_count']) && $payments['fully_paid_count'] !== null) {
            $indicators[] = array('valor' => 'Pagos completos', 'count' => (int) $payments['fully_paid_count'], 'paquete' => 1);
        }

        if (isset($payments['average_payment']) && $payments['average_payment'] !== null) {
            $indicators[] = array('valor' => 'Promedio por pago', 'count' => (float) $payments['average_payment'], 'paquete' => 1);
        }

        if (isset($payments['expected_revenue']) && $payments['expected_revenue'] !== null) {
            $indicators[] = array('valor' => 'Ingresos esperados', 'count' => (float) $payments['expected_revenue'], 'paquete' => 1);
        }

        if (isset($payments['pending_balance']) && $payments['pending_balance'] !== null) {
            $indicators[] = array('valor' => 'Saldo pendiente', 'count' => (float) $payments['pending_balance'], 'paquete' => 1);
        }

        return array(
            'event' => array(
                'id' => isset($event->id) ? (int) $event->id : 0,
                'legacy_event_id' => isset($event->legacy_event_id) ? (int) $event->legacy_event_id : null,
                'title' => isset($event->title) ? $event->title : null,
                'event_year' => isset($event->event_year) ? (int) $event->event_year : null,
            ),
            'summary' => $payments,
            'indicators' => $indicators,
        );
    }

    public function getPayments($eventId, $legacyEventId = null)
    {
        $event = $this->resolveEvent($eventId, $legacyEventId);
        if (is_array($event) && isset($event['error'])) {
            return $event;
        }

        $items = $this->accounting->getPaymentsByEvent((int) $event->id);

        return array(
            'event' => array(
                'id' => isset($event->id) ? (int) $event->id : 0,
                'legacy_event_id' => isset($event->legacy_event_id) ? (int) $event->legacy_event_id : null,
                'title' => isset($event->title) ? $event->title : null,
                'event_year' => isset($event->event_year) ? (int) $event->event_year : null,
            ),
            'payments' => $items,
        );
    }

    public function getPaymentsByUser($eventId, $legacyEventId = null)
    {
        $event = $this->resolveEvent($eventId, $legacyEventId);
        if (is_array($event) && isset($event['error'])) {
            return $event;
        }

        $items = $this->accounting->getPaymentsByUser((int) $event->id);

        return array(
            'event' => array(
                'id' => isset($event->id) ? (int) $event->id : 0,
                'legacy_event_id' => isset($event->legacy_event_id) ? (int) $event->legacy_event_id : null,
                'title' => isset($event->title) ? $event->title : null,
                'event_year' => isset($event->event_year) ? (int) $event->event_year : null,
            ),
            'payments' => $items,
        );
    }

    public function getPaymentsByDescription($eventId, $legacyEventId = null)
    {
        $event = $this->resolveEvent($eventId, $legacyEventId);
        if (is_array($event) && isset($event['error'])) {
            return $event;
        }

        $items = $this->accounting->getPaymentsByDescription((int) $event->id);

        return array(
            'event' => array(
                'id' => isset($event->id) ? (int) $event->id : 0,
                'legacy_event_id' => isset($event->legacy_event_id) ? (int) $event->legacy_event_id : null,
                'title' => isset($event->title) ? $event->title : null,
                'event_year' => isset($event->event_year) ? (int) $event->event_year : null,
            ),
            'payments' => $items,
        );
    }

    public function getPaymentMethods($eventId, $legacyEventId = null)
    {
        $event = $this->resolveEvent($eventId, $legacyEventId);
        if (is_array($event) && isset($event['error'])) {
            return $event;
        }

        $items = $this->dashboard->getPaymentMethodBreakdown((int) $event->id);

        return array(
            'event' => array(
                'id' => isset($event->id) ? (int) $event->id : 0,
                'legacy_event_id' => isset($event->legacy_event_id) ? (int) $event->legacy_event_id : null,
                'title' => isset($event->title) ? $event->title : null,
                'event_year' => isset($event->event_year) ? (int) $event->event_year : null,
            ),
            'methods' => $items,
        );
    }

    public function getPendingByUser($eventId, $legacyEventId = null, $fullPaymentAmount = null)
    {
        $event = $this->resolveEvent($eventId, $legacyEventId);
        if (is_array($event) && isset($event['error'])) {
            return $event;
        }

        $targetAmount = $this->normalizeAmount($fullPaymentAmount);
        if ($targetAmount === null) {
            $targetAmount = isset($event->price_mxn) && $event->price_mxn !== null
                ? (float) $event->price_mxn
                : null;
        }

        $rows = $this->accounting->getPendingByUser((int) $event->id);
        $items = array_map(function ($row) use ($targetAmount) {
            $totalPaid = isset($row['total_paid']) ? (float) $row['total_paid'] : 0.0;
            $expected = $targetAmount !== null ? (float) $targetAmount : null;
            $pending = $expected !== null ? max($expected - $totalPaid, 0) : null;

            return array(
                'user_id' => isset($row['user_id']) ? (int) $row['user_id'] : 0,
                'nombre' => isset($row['nombre']) ? $row['nombre'] : null,
                'is_staff' => isset($row['is_staff']) ? (int) $row['is_staff'] : 0,
                'total_paid' => $totalPaid,
                'expected_amount' => $expected,
                'pending_amount' => $pending,
                'payment_count' => isset($row['payment_count']) ? (int) $row['payment_count'] : 0,
                'last_payment_at' => isset($row['last_payment_at']) ? $row['last_payment_at'] : null,
            );
        }, $rows);

        return array(
            'event' => array(
                'id' => isset($event->id) ? (int) $event->id : 0,
                'legacy_event_id' => isset($event->legacy_event_id) ? (int) $event->legacy_event_id : null,
                'title' => isset($event->title) ? $event->title : null,
                'event_year' => isset($event->event_year) ? (int) $event->event_year : null,
                'price_mxn' => $targetAmount,
            ),
            'pending' => $items,
        );
    }

    public function getCashflow($eventId, $legacyEventId = null, $startDate = null, $endDate = null)
    {
        $event = $this->resolveEvent($eventId, $legacyEventId);
        if (is_array($event) && isset($event['error'])) {
            return $event;
        }

        $startDate = $this->normalizeDate($startDate);
        $endDate = $this->normalizeDate($endDate);

        $items = $this->accounting->getCashflowByDate((int) $event->id, $startDate, $endDate);

        return array(
            'event' => array(
                'id' => isset($event->id) ? (int) $event->id : 0,
                'legacy_event_id' => isset($event->legacy_event_id) ? (int) $event->legacy_event_id : null,
                'title' => isset($event->title) ? $event->title : null,
                'event_year' => isset($event->event_year) ? (int) $event->event_year : null,
            ),
            'cashflow' => $items,
        );
    }

    private function resolveEvent($eventId, $legacyEventId = null)
    {
        $eventId = (int) $eventId;
        $legacyEventId = $legacyEventId !== null ? (int) $legacyEventId : null;

        if ($eventId > 0) {
            $event = $this->events->findModelById($eventId);
            if ($event) {
                return $event;
            }
        }

        if ($legacyEventId !== null && $legacyEventId > 0) {
            $event = $this->events->findByLegacyId($legacyEventId);
            if ($event) {
                return $event;
            }
        }

        $activeEvents = $this->events->findUpcomingActive(1);
        if (!empty($activeEvents)) {
            return $activeEvents[0];
        }

        return array('error' => 'active event not found', 'code' => 404);
    }

    private function normalizeAmount($value)
    {
        if ($value === null) {
            return null;
        }

        $normalized = is_numeric($value) ? (float) $value : null;
        return $normalized !== null && $normalized > 0 ? $normalized : null;
    }

    private function normalizeDate($value)
    {
        $value = is_string($value) ? trim($value) : '';
        if ($value === '') {
            return null;
        }

        $timestamp = strtotime($value);
        if ($timestamp === false) {
            return null;
        }

        return date('Y-m-d', $timestamp);
    }
}
