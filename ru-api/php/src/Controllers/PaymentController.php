<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Services/PaymentService.php';

class PaymentController extends BaseController
{
    private $paymentService;

    public function __construct()
    {
        $this->paymentService = new PaymentService();
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

        return $this->ok($result, 'payment created');
    }

    public function update($request)
    {
        $paymentId = isset($request['payment_id']) ? (int) $request['payment_id'] : 0;
        if ($paymentId <= 0) {
            return $this->fail('payment_id is required', 422);
        }

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

        return $this->ok(array('payment_id' => $paymentId, 'updated' => $updates), 'payment updated');
    }

    public function delete($request)
    {
        $paymentId = isset($request['payment_id']) ? (int) $request['payment_id'] : 0;
        if ($paymentId <= 0) {
            return $this->fail('payment_id is required', 422);
        }

        $ok = $this->paymentService->delete($paymentId);
        if (!$ok) {
            return $this->fail('could not delete payment', 500);
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
