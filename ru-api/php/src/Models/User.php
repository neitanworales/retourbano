<?php

require_once __DIR__ . '/BaseModel.php';

class User extends BaseModel
{
    public $id;
    public $legacy_user_id;
    public $full_name;
    public $display_name;
    public $birth_date;
    public $age;
    public $gender;
    public $shirt_size;
    public $coming_from;
    public $whatsapp;
    public $email;
    public $allergies;
    public $guardian_phone;
    public $church;
    public $registered_at;
    public $guardian_name;
    public $facebook;
    public $instagram;
    public $accepted_policies;
    public $password_hash;
    public $medications;
    public $phone;
    public $verification_code;
    public $guardian_email;
    public $user_status;
    public $created_at;
    public $updated_at;

    public function toArray()
    {
        $data = parent::toArray();
        unset($data['password_hash'], $data['verification_code']);

        // Backward-compatible aliases consumed by the frontend user model.
        $data['nombre'] = isset($data['full_name']) ? $data['full_name'] : null;
        $data['nick'] = isset($data['display_name']) ? $data['display_name'] : null;
        $data['fechaNac'] = isset($data['birth_date']) ? $data['birth_date'] : null;
        $data['edad'] = isset($data['age']) ? $data['age'] : null;
        $data['sexo'] = isset($data['gender']) ? $data['gender'] : null;
        $data['talla'] = isset($data['shirt_size']) ? $data['shirt_size'] : null;
        $data['vienesDe'] = isset($data['coming_from']) ? $data['coming_from'] : null;
        $data['alergias'] = isset($data['allergies']) ? $data['allergies'] : null;
        $data['tutorTelefono'] = isset($data['guardian_phone']) ? $data['guardian_phone'] : null;
        $data['iglesia'] = isset($data['church']) ? $data['church'] : null;
        $data['tutorNombre'] = isset($data['guardian_name']) ? $data['guardian_name'] : null;
        $data['emailTutor'] = isset($data['guardian_email']) ? $data['guardian_email'] : null;
        $data['medicamentos'] = isset($data['medications']) ? $data['medications'] : null;
        $data['telefono'] = isset($data['phone']) ? $data['phone'] : null;
        $data['aceptaPoliticas'] = isset($data['accepted_policies']) ? ((int) $data['accepted_policies'] === 1) : null;

        return $data;
    }
}
