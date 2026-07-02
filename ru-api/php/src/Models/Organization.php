<?php

require_once __DIR__ . '/BaseModel.php';

class Organization extends BaseModel
{
    public $id;
    public $legacy_city_id;
    public $city_id;
    public $name;
    public $slug;
    public $legal_name;
    public $email;
    public $phone;
    public $is_active;
    public $created_at;
    public $updated_at;
}
