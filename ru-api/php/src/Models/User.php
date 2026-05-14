<?php

require_once __DIR__ . '/BaseModel.php';

class User extends BaseModel
{
    public $id;
    public $legacy_user_id;
    public $full_name;
    public $display_name;
    public $birth_date;
    public $email;
    public $whatsapp;
    public $phone;
    public $password_hash;
    public $verification_code;
    public $user_status;
    public $accepted_policies;
    public $created_at;
    public $updated_at;

    public function toArray()
    {
        $data = parent::toArray();
        unset($data['password_hash'], $data['verification_code']);

        return $data;
    }
}
