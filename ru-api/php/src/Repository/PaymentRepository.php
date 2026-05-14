<?php

require_once __DIR__ . '/BaseRepository.php';
require_once __DIR__ . '/../Models/Payment.php';

class PaymentRepository extends BaseRepository
{
    protected $table = 'payments';

    public function findModelById($id)
    {
        $row = $this->findById($id);
        return $row ? new Payment($row) : null;
    }

    public function findByLegacyId($legacyId)
    {
        $sql = 'SELECT * FROM payments WHERE legacy_payment_id = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $legacyId);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? new Payment($row) : null;
    }

    public function findByRegistrationId($registrationId)
    {
        $sql = 'SELECT * FROM payments WHERE event_registration_id = ? ORDER BY id ASC';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $registrationId);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new Payment($row);
        }, $rows);
    }

    public function create(Payment $payment)
    {
        $sql = 'INSERT INTO payments (legacy_payment_id, event_registration_id, amount, description, currency, receipt_number, payment_method, paid_at, created_by_user_id)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param(
            'iidsssssi',
            $payment->legacy_payment_id,
            $payment->event_registration_id,
            $payment->amount,
            $payment->description,
            $payment->currency,
            $payment->receipt_number,
            $payment->payment_method,
            $payment->paid_at,
            $payment->created_by_user_id
        );

        $stmt->execute();
        $id = $this->db->insert_id;
        $stmt->close();

        return $id;
    }
}
