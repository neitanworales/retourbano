<?php

require_once __DIR__ . '/BaseModel.php';

class Event extends BaseModel
{
    public $id;
    public $legacy_event_id;
    public $organization_id;
    public $city_id;
    public $event_year;
    public $title;
    public $start_at;
    public $end_at;
    public $is_active;
    public $max_registrations;
    public $registration_deadline;
    public $registration_open_at;
    public $price_mxn;
    public $price_usd;
    public $created_at;
    public $updated_at;
}
