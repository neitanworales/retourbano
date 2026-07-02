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
    public $lobby_end_at;
    public $end_at;
    public $is_active;
    public $max_registrations;
    public $threshold;
    public $registration_deadline;
    public $registration_open_at;
    public $price_mxn;
    public $price_usd;
    public $minimum_payment_mxn;
    public $bank_name;
    public $bank_account;
    public $bank_clabe;
    public $account_holder;
    public $contact_phone_1;
    public $contact_phone_2;
    public $contact_email;
    public $arrival_place;
    public $arrival_coordinates;
    public $arrival_note;
    public $departure_place;
    public $departure_coordinates;
    public $departure_note;
    public $cost_notes;
    public $city_label;
    public $created_at;
    public $updated_at;
    public $is_registered;
    public $registration_id;
    public $registration_status;
    public $user_id;
    public $event_id;
}
