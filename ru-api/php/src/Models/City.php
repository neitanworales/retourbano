<?php

require_once __DIR__ . '/BaseModel.php';

class City extends BaseModel
{
    public $id;
    public $legacy_city_id;
    public $name;
    public $slug;
    public $is_active;
    public $created_at;
    public $updated_at;
}
