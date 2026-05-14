<?php

require_once __DIR__ . '/BaseModel.php';

class Payment extends BaseModel
{
    public $id;
    public $legacy_payment_id;
    public $event_registration_id;
    public $amount;
    public $description;
    public $currency;
    public $receipt_number;
    public $payment_method;
    public $paid_at;
    public $created_by_user_id;
    public $created_at;
    public $updated_at;
}
