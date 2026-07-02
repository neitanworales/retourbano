<?php

require_once __DIR__ . '/BaseModel.php';

class ActivityLog extends BaseModel
{
    public $id;
    public $affected_user_id;
    public $actor_user_id;
    public $action;
    public $entity_type;
    public $entity_id;
    public $related_event_id;
    public $related_registration_id;
    public $source;
    public $old_value;
    public $new_value;
    public $metadata_json;
    public $ip_address;
    public $user_agent;
    public $created_at;
    public $updated_at;
}