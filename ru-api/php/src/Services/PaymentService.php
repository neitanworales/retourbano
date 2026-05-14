<?php

require_once __DIR__ . '/../Models/Payment.php';
require_once __DIR__ . '/../Repository/PaymentRepository.php';

class PaymentService
{
    private $payments;

    public function __construct()
    {
        $this->payments = new PaymentRepository();
    }

    public function create($eventRegistrationId, $amount, $description, $currency = 'MXN', $receiptNumber = null, $paymentMethod = null, $paidAt = null, $createdByUserId = null)
    {
        $payment = new Payment(array(
            'legacy_payment_id' => null,
            'event_registration_id' => (int) $eventRegistrationId,
            'amount' => (float) $amount,
            'description' => $description,
            'currency' => $currency,
            'receipt_number' => $receiptNumber,
            'payment_method' => $paymentMethod,
            'paid_at' => $paidAt,
            'created_by_user_id' => $createdByUserId,
        ));

        $id = $this->payments->create($payment);
        return array(
            'id' => (int) $id,
            'event_registration_id' => (int) $eventRegistrationId,
            'amount' => (float) $amount,
        );
    }

    public function update($paymentId, $fields)
    {
        return $this->payments->updateFields((int) $paymentId, is_array($fields) ? $fields : array());
    }

    public function delete($paymentId)
    {
        return $this->payments->deleteById((int) $paymentId);
    }

    public function getById($paymentId)
    {
        return $this->payments->findModelById((int) $paymentId);
    }

    public function getByRegistrationId($registrationId)
    {
        return $this->payments->findByRegistrationId((int) $registrationId);
    }
}
