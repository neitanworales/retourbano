<?php

require_once __DIR__ . '/../Repository/EventRepository.php';
require_once __DIR__ . '/../Repository/EventDashboardRepository.php';

class EventDashboardService
{
    private $events;
    private $dashboard;

    public function __construct()
    {
        $this->events = new EventRepository();
        $this->dashboard = new EventDashboardRepository();
    }

    public function getByEvent($eventId)
    {
        $event = $this->events->findModelById((int) $eventId);
        if (!$event) {
            return array('error' => 'event not found', 'code' => 404);
        }

        $eventData = $event->toArray();
        $capacity = isset($eventData['max_registrations']) ? (int) $eventData['max_registrations'] : 0;
        $targetAmount = isset($eventData['price_mxn']) && $eventData['price_mxn'] !== null ? (float) $eventData['price_mxn'] : null;

        $core = $this->dashboard->getCoreMetrics((int) $eventId);
        $activeRegistrations = isset($core['active_registrations']) ? (int) $core['active_registrations'] : 0;
        $available = $capacity > 0 ? max($capacity - $activeRegistrations, 0) : null;
        $occupancy = $capacity > 0 ? round(($activeRegistrations * 100) / $capacity, 2) : null;
        $participantsBirthDates = $this->dashboard->getParticipantBirthDates((int) $eventId);
        $birthdaysDuringEvent = $this->buildBirthdayCelebrants(
            $participantsBirthDates,
            isset($eventData['start_at']) ? $eventData['start_at'] : null,
            isset($eventData['end_at']) ? $eventData['end_at'] : null
        );

        $payments = $this->dashboard->getPaymentSummary((int) $eventId, $targetAmount, $activeRegistrations);
        $confirmation = $this->dashboard->getConfirmationBreakdown((int) $eventId);
        $paymentMethods = $this->dashboard->getPaymentMethodBreakdown((int) $eventId);

        return array(
            'event' => array(
                'id' => isset($eventData['id']) ? (int) $eventData['id'] : 0,
                'title' => isset($eventData['title']) ? $eventData['title'] : null,
                'event_year' => isset($eventData['event_year']) ? (int) $eventData['event_year'] : null,
                'is_active' => isset($eventData['is_active']) ? (int) $eventData['is_active'] : 0,
                'max_registrations' => $capacity,
                'price_mxn' => $targetAmount,
                'minimum_payment_mxn' => isset($eventData['minimum_payment_mxn']) && $eventData['minimum_payment_mxn'] !== null
                    ? (float) $eventData['minimum_payment_mxn']
                    : null,
            ),
            'summary' => array(
                'capacity' => $capacity,
                'registered' => $activeRegistrations,
                'inactive' => isset($core['inactive_registrations']) ? (int) $core['inactive_registrations'] : 0,
                'available' => $available,
                'occupancy_percentage' => $occupancy,
                'confirmed' => isset($core['confirmed']) ? (int) $core['confirmed'] : 0,
                'attendance_confirmed' => isset($core['attendance_confirmed']) ? (int) $core['attendance_confirmed'] : 0,
                'followup' => isset($core['followup']) ? (int) $core['followup'] : 0,
                'welcome_email_sent' => isset($core['welcome_email_sent']) ? (int) $core['welcome_email_sent'] : 0,
                'email_confirmed' => isset($core['email_confirmed']) ? (int) $core['email_confirmed'] : 0,
                'total_revenue' => isset($payments['total_revenue']) ? (float) $payments['total_revenue'] : 0.0,
                'payments_count' => isset($payments['payments_count']) ? (int) $payments['payments_count'] : 0,
                'registrations_with_payments' => isset($payments['registrations_with_payments']) ? (int) $payments['registrations_with_payments'] : 0,
                'fully_paid_count' => $payments['fully_paid_count'],
                'average_payment' => isset($payments['average_payment']) ? (float) $payments['average_payment'] : 0.0,
                'expected_revenue' => isset($payments['expected_revenue']) ? (float) $payments['expected_revenue'] : null,
                'payment_coverage_percentage' => isset($payments['payment_coverage_percentage']) ? (float) $payments['payment_coverage_percentage'] : null,
                'pending_balance' => isset($payments['pending_balance']) ? (float) $payments['pending_balance'] : null,
            ),
            'charts' => array(
                'availability' => array(
                    array('key' => 'registered', 'label' => 'Inscritos', 'count' => $activeRegistrations),
                    array('key' => 'available', 'label' => 'Disponibles', 'count' => $available !== null ? (int) $available : 0),
                ),
                'roles' => array(
                    array('key' => 'campers', 'label' => 'Guerreros', 'count' => isset($core['campers']) ? (int) $core['campers'] : 0),
                    array('key' => 'staff', 'label' => 'Staff', 'count' => isset($core['staff']) ? (int) $core['staff'] : 0),
                    array('key' => 'admins', 'label' => 'Admins', 'count' => isset($core['admins']) ? (int) $core['admins'] : 0),
                    array('key' => 'inactive', 'label' => 'Bajas', 'count' => isset($core['inactive_registrations']) ? (int) $core['inactive_registrations'] : 0),
                ),
                'gender' => $this->mapGenderBreakdown($this->dashboard->getGenderBreakdown((int) $eventId, false)),
                'staff_gender' => $this->mapGenderBreakdown($this->dashboard->getGenderBreakdown((int) $eventId, true)),
                'shirt_sizes' => $this->mapShirtSizeBreakdown($this->dashboard->getShirtSizeBreakdown((int) $eventId)),
                'lodging' => array(
                    array('key' => 'with_lodging', 'label' => 'Con hospedaje', 'count' => isset($core['with_lodging']) ? (int) $core['with_lodging'] : 0),
                    array('key' => 'without_lodging', 'label' => 'Sin hospedaje', 'count' => isset($core['without_lodging']) ? (int) $core['without_lodging'] : 0),
                ),
                'confirmation' => $this->mapLabelCountBreakdown($confirmation),
                'payment_methods' => $this->mapPaymentMethodBreakdown($paymentMethods),
            ),
            'birthdays_during_event' => $birthdaysDuringEvent,
        );
    }

    private function buildBirthdayCelebrants($rows, $startAt, $endAt)
    {
        if (!$startAt || !$endAt) {
            return array();
        }

        try {
            $start = new DateTimeImmutable((string) $startAt);
            $end = new DateTimeImmutable((string) $endAt);
        } catch (Exception $e) {
            return array();
        }

        if ($end < $start) {
            $tmp = $start;
            $start = $end;
            $end = $tmp;
        }

        $items = array();
        foreach (is_array($rows) ? $rows : array() as $row) {
            if (!isset($row['birth_date']) || !$row['birth_date']) {
                continue;
            }

            try {
                $birthDate = new DateTimeImmutable((string) $row['birth_date']);
            } catch (Exception $e) {
                continue;
            }

            $birthdayDate = $this->buildBirthdayDateForYear($birthDate, (int) $start->format('Y'));
            if ($birthdayDate < $start) {
                $birthdayDate = $this->buildBirthdayDateForYear($birthDate, (int) $start->format('Y') + 1);
            }

            if ($birthdayDate < $start || $birthdayDate > $end) {
                continue;
            }

            $displayName = isset($row['display_name']) ? trim((string) $row['display_name']) : '';
            $fullName = isset($row['full_name']) ? trim((string) $row['full_name']) : '';
            $name = $displayName !== '' ? $displayName : $fullName;
            $ageTurning = (int) $birthdayDate->format('Y') - (int) $birthDate->format('Y');

            $items[] = array(
                'user_id' => isset($row['user_id']) ? (int) $row['user_id'] : 0,
                'name' => $name,
                'full_name' => $fullName,
                'display_name' => $displayName,
                'birth_date' => $birthDate->format('Y-m-d'),
                'birthday_on' => $birthdayDate->format('Y-m-d'),
                'birthday_label' => $birthdayDate->format('d/m'),
                'age_turning' => $ageTurning,
            );
        }

        usort($items, function ($a, $b) {
            $dateCompare = strcmp((string) $a['birthday_on'], (string) $b['birthday_on']);
            if ($dateCompare !== 0) {
                return $dateCompare;
            }

            return strcmp((string) $a['name'], (string) $b['name']);
        });

        return $items;
    }

    private function buildBirthdayDateForYear($birthDate, $year)
    {
        $month = (int) $birthDate->format('m');
        $day = (int) $birthDate->format('d');

        if (!checkdate($month, $day, $year)) {
            $day = cal_days_in_month(CAL_GREGORIAN, $month, $year);
        }

        return new DateTimeImmutable(sprintf('%04d-%02d-%02d', (int) $year, $month, $day));
    }

    private function mapGenderBreakdown($rows)
    {
        $labelMap = array(
            'M' => 'Hombres',
            'F' => 'Mujeres',
            'U' => 'Sin definir',
        );

        return array_map(function ($row) use ($labelMap) {
            $key = isset($row['gender']) ? strtoupper((string) $row['gender']) : 'U';
            if (!array_key_exists($key, $labelMap)) {
                $key = 'U';
            }

            return array(
                'key' => strtolower($key),
                'label' => $labelMap[$key],
                'count' => isset($row['count']) ? (int) $row['count'] : 0,
            );
        }, is_array($rows) ? $rows : array());
    }

    private function mapShirtSizeBreakdown($rows)
    {
        return array_map(function ($row) {
            $size = isset($row['shirt_size']) ? (string) $row['shirt_size'] : 'SIN_TALLA';

            return array(
                'key' => strtolower($size),
                'label' => $size === 'SIN_TALLA' ? 'Sin talla' : $size,
                'count' => isset($row['count']) ? (int) $row['count'] : 0,
            );
        }, is_array($rows) ? $rows : array());
    }

    private function mapLabelCountBreakdown($rows)
    {
        return array_map(function ($row) {
            $label = isset($row['label']) ? (string) $row['label'] : 'Sin etiqueta';

            return array(
                'key' => strtolower(str_replace(' ', '_', $label)),
                'label' => $label,
                'count' => isset($row['count']) ? (int) $row['count'] : 0,
            );
        }, is_array($rows) ? $rows : array());
    }

    private function mapPaymentMethodBreakdown($rows)
    {
        return array_map(function ($row) {
            $method = isset($row['payment_method']) ? (string) $row['payment_method'] : 'SIN_METODO';

            return array(
                'key' => strtolower($method),
                'label' => $method === 'SIN_METODO' ? 'Sin metodo' : $method,
                'count' => isset($row['count']) ? (int) $row['count'] : 0,
                'total_amount' => isset($row['total_amount']) ? (float) $row['total_amount'] : 0.0,
            );
        }, is_array($rows) ? $rows : array());
    }
}
