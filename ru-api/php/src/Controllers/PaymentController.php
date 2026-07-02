<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Services/PaymentService.php';
require_once __DIR__ . '/../Repository/EventRegistrationRepository.php';
require_once __DIR__ . '/../Repository/ActivityLogRepository.php';

class PaymentController extends BaseController
{
    private $paymentService;
    private $eventRegistrations;
    private $activityLog;

    public function __construct()
    {
        $this->paymentService = new PaymentService();
        $this->eventRegistrations = new EventRegistrationRepository();
        $this->activityLog = new ActivityLogRepository();
    }

    public function create($request)
    {
        $registrationId = isset($request['event_registration_id']) ? (int) $request['event_registration_id'] : 0;
        $amount = isset($request['amount']) ? (float) $request['amount'] : 0;
        $description = isset($request['description']) ? trim($request['description']) : '';
        $currency = isset($request['currency']) ? trim($request['currency']) : 'MXN';
        $receiptNumber = isset($request['receipt_number']) ? trim($request['receipt_number']) : null;
        $paymentMethod = isset($request['payment_method']) ? trim($request['payment_method']) : null;
        $paidAt = isset($request['paid_at']) ? trim($request['paid_at']) : null;
        $createdByUserId = isset($request['created_by_user_id']) ? (int) $request['created_by_user_id'] : null;

        if ($registrationId <= 0 || $amount <= 0 || $description === '') {
            return $this->fail('event_registration_id, amount, and description are required', 422);
        }

        $result = $this->paymentService->create(
            $registrationId,
            $amount,
            $description,
            $currency,
            $receiptNumber,
            $paymentMethod,
            $paidAt,
            $createdByUserId
        );

        $registration = $this->eventRegistrations->findModelById($registrationId);
        if ($registration && isset($registration->user_id)) {
            $detail = array(
                'amount' => (float) $amount,
                'currency' => $currency,
                'description' => $description,
                'payment_method' => $paymentMethod,
                'receipt_number' => $receiptNumber,
                'recorded_by_user_id' => isset($request['auth_user']) && isset($request['auth_user']->id) ? (int) $request['auth_user']->id : $createdByUserId,
            );

            $this->activityLog->createEntry(
                (int) $registration->user_id,
                'payments.create',
                null,
                json_encode($detail, JSON_UNESCAPED_UNICODE)
                ,
                array(
                    'actor_user_id' => isset($request['auth_user']) && isset($request['auth_user']->id) ? (int) $request['auth_user']->id : $createdByUserId,
                    'entity_type' => 'payment',
                    'entity_id' => isset($result['id']) ? (int) $result['id'] : null,
                    'related_event_id' => isset($registration->event_id) ? (int) $registration->event_id : null,
                    'related_registration_id' => $registrationId,
                    'source' => 'api.v1.payments',
                    'metadata' => $detail,
                )
            );
        }

        return $this->ok($result, 'payment created');
    }

    public function update($request)
    {
        $paymentId = isset($request['payment_id']) ? (int) $request['payment_id'] : 0;
        if ($paymentId <= 0) {
            return $this->fail('payment_id is required', 422);
        }

        $payment = $this->paymentService->getById($paymentId);
        if (!$payment) {
            return $this->fail('payment not found', 404);
        }

        $registration = $this->eventRegistrations->findModelById((int) $payment->event_registration_id);

        $updates = array();

        if (isset($request['amount'])) {
            $amount = (float) $request['amount'];
            if ($amount > 0) {
                $updates['amount'] = $amount;
            }
        }

        if (isset($request['description'])) {
            $desc = trim((string) $request['description']);
            if ($desc !== '') {
                $updates['description'] = $desc;
            }
        }

        if (isset($request['currency'])) {
            $currency = trim((string) $request['currency']);
            if ($currency !== '') {
                $updates['currency'] = $currency;
            }
        }

        if (isset($request['receipt_number'])) {
            $updates['receipt_number'] = trim((string) $request['receipt_number']);
        }

        if (isset($request['payment_method'])) {
            $updates['payment_method'] = trim((string) $request['payment_method']);
        }

        if (isset($request['paid_at'])) {
            $updates['paid_at'] = trim((string) $request['paid_at']);
        }

        if (empty($updates)) {
            return $this->fail('At least one field is required', 422);
        }

        $ok = $this->paymentService->update($paymentId, $updates);
        if (!$ok) {
            return $this->fail('could not update payment', 500);
        }

        if ($registration && isset($registration->user_id)) {
            $this->activityLog->createEntry((int) $registration->user_id, 'payments.update', $payment->toArray(), array_merge($payment->toArray(), $updates), array(
                'actor_user_id' => isset($request['auth_user']) && isset($request['auth_user']->id) ? (int) $request['auth_user']->id : null,
                'entity_type' => 'payment',
                'entity_id' => $paymentId,
                'related_event_id' => isset($registration->event_id) ? (int) $registration->event_id : null,
                'related_registration_id' => (int) $payment->event_registration_id,
                'source' => 'api.v1.payments',
                'metadata' => array('updated_fields' => array_keys($updates)),
            ));
        }

        return $this->ok(array('payment_id' => $paymentId, 'updated' => $updates), 'payment updated');
    }

    public function delete($request)
    {
        $paymentId = isset($request['payment_id']) ? (int) $request['payment_id'] : 0;
        if ($paymentId <= 0) {
            return $this->fail('payment_id is required', 422);
        }

        $payment = $this->paymentService->getById($paymentId);
        if (!$payment) {
            return $this->fail('payment not found', 404);
        }

        $registration = $this->eventRegistrations->findModelById((int) $payment->event_registration_id);

        $ok = $this->paymentService->delete($paymentId);
        if (!$ok) {
            return $this->fail('could not delete payment', 500);
        }

        if ($registration && isset($registration->user_id)) {
            $this->activityLog->createEntry((int) $registration->user_id, 'payments.delete', $payment->toArray(), array('deleted' => true), array(
                'actor_user_id' => isset($request['auth_user']) && isset($request['auth_user']->id) ? (int) $request['auth_user']->id : null,
                'entity_type' => 'payment',
                'entity_id' => $paymentId,
                'related_event_id' => isset($registration->event_id) ? (int) $registration->event_id : null,
                'related_registration_id' => (int) $payment->event_registration_id,
                'source' => 'api.v1.payments',
            ));
        }

        return $this->ok(array('payment_id' => $paymentId), 'payment deleted');
    }

    public function getById($request)
    {
        $paymentId = isset($request['payment_id']) ? (int) $request['payment_id'] : 0;
        if ($paymentId <= 0) {
            return $this->fail('payment_id is required', 422);
        }

        $payment = $this->paymentService->getById($paymentId);
        if (!$payment) {
            return $this->fail('payment not found', 404);
        }

        return $this->ok(array('payment' => $payment->toArray()), 'payment found');
    }

    public function getByRegistration($request)
    {
        $registrationId = isset($request['event_registration_id']) ? (int) $request['event_registration_id'] : 0;
        if ($registrationId <= 0) {
            return $this->fail('event_registration_id is required', 422);
        }

        $payments = $this->paymentService->getByRegistrationId($registrationId);
        $items = array_map(function ($payment) {
            return $payment->toArray();
        }, $payments);

        return $this->ok(array('payments' => $items), 'payments found');
    }
}
