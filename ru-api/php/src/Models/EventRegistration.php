<?php

require_once __DIR__ . '/BaseModel.php';

class EventRegistration extends BaseModel
{
    public $id;
    public $legacy_registration_id;
    public $event_id;
    public $user_id;
    public $event_year;
    public $registration_status;
    public $is_confirmed;
    public $attendance_confirmed;
    public $is_staff;
    public $is_admin;
    public $is_followup;
    public $requires_lodging;
    public $room_code;
    public $created_at;
    public $updated_at;
}
