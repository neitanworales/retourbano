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

    public function updateFields($id, $fields)
    {
        $allowed = array(
            'amount' => 'd',
            'description' => 's',
            'currency' => 's',
            'receipt_number' => 's',
            'payment_method' => 's',
            'paid_at' => 's',
        );

        $setParts = array();
        $types = '';
        $params = array();

        foreach ($fields as $column => $value) {
            if (!array_key_exists($column, $allowed)) {
                continue;
            }
            $setParts[] = "$column = ?";
            $type = $allowed[$column];
            $types .= $type;
            $params[] = $type === 'd' ? (float) $value : (string) $value;
        }

        if (empty($setParts)) {
            return false;
        }

        $sql = 'UPDATE payments SET ' . implode(', ', $setParts) . ', updated_at = NOW() WHERE id = ?';
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

    public function deleteById($id)
    {
        $sql = 'DELETE FROM payments WHERE id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $id);
        $ok = $stmt->execute();
        $stmt->close();

        return $ok;
    }
}
