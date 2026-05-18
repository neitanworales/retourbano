<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Services/AccountingService.php';

class AccountingController extends BaseController
{
    private $accountingService;

    public function __construct()
    {
        $this->accountingService = new AccountingService();
    }

    public function summary($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $legacyEventId = isset($request['id_campamento']) ? (int) $request['id_campamento'] : null;
        $fullPaymentAmount = isset($request['full_payment_amount']) ? $request['full_payment_amount'] : null;

        $result = $this->accountingService->getSummary($eventId, $legacyEventId, $fullPaymentAmount);
        if (isset($result['error'])) {
            return $this->fail($result['error'], isset($result['code']) ? (int) $result['code'] : 400);
        }

        return $this->ok($result, 'accounting summary');
    }

    public function payments($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $legacyEventId = isset($request['id_campamento']) ? (int) $request['id_campamento'] : null;

        $result = $this->accountingService->getPayments($eventId, $legacyEventId);
        if (isset($result['error'])) {
            return $this->fail($result['error'], isset($result['code']) ? (int) $result['code'] : 400);
        }

        return $this->ok($result, 'accounting payments');
    }

    public function paymentsByUser($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $legacyEventId = isset($request['id_campamento']) ? (int) $request['id_campamento'] : null;

        $result = $this->accountingService->getPaymentsByUser($eventId, $legacyEventId);
        if (isset($result['error'])) {
            return $this->fail($result['error'], isset($result['code']) ? (int) $result['code'] : 400);
        }

        return $this->ok($result, 'accounting payments by user');
    }

    public function paymentsByDescription($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $legacyEventId = isset($request['id_campamento']) ? (int) $request['id_campamento'] : null;

        $result = $this->accountingService->getPaymentsByDescription($eventId, $legacyEventId);
        if (isset($result['error'])) {
            return $this->fail($result['error'], isset($result['code']) ? (int) $result['code'] : 400);
        }

        return $this->ok($result, 'accounting payments by description');
    }

    public function paymentMethods($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $legacyEventId = isset($request['id_campamento']) ? (int) $request['id_campamento'] : null;

        $result = $this->accountingService->getPaymentMethods($eventId, $legacyEventId);
        if (isset($result['error'])) {
            return $this->fail($result['error'], isset($result['code']) ? (int) $result['code'] : 400);
        }

        return $this->ok($result, 'accounting payment methods');
    }

    public function pendingByUser($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $legacyEventId = isset($request['id_campamento']) ? (int) $request['id_campamento'] : null;
        $fullPaymentAmount = isset($request['full_payment_amount']) ? $request['full_payment_amount'] : null;

        $result = $this->accountingService->getPendingByUser($eventId, $legacyEventId, $fullPaymentAmount);
        if (isset($result['error'])) {
            return $this->fail($result['error'], isset($result['code']) ? (int) $result['code'] : 400);
        }

        return $this->ok($result, 'accounting pending by user');
    }

    public function cashflow($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $legacyEventId = isset($request['id_campamento']) ? (int) $request['id_campamento'] : null;
        $startDate = isset($request['start_date']) ? trim((string) $request['start_date']) : null;
        $endDate = isset($request['end_date']) ? trim((string) $request['end_date']) : null;

        $result = $this->accountingService->getCashflow($eventId, $legacyEventId, $startDate, $endDate);
        if (isset($result['error'])) {
            return $this->fail($result['error'], isset($result['code']) ? (int) $result['code'] : 400);
        }

        return $this->ok($result, 'accounting cashflow');
    }
}
