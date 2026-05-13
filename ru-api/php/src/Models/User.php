<?php
/**
 * User Model
 * 
 * @version 1.0
 * @author Neitan
 */

class User
{
    public $id;
    public $nombre;
    public $nick;
    public $fechaNac;
    public $edad;
    public $sexo;
    public $talla;
    public $vienesDe;
    public $alergias;
    public $razones;
    public $tutorNombre;
    public $tutorTelefono;
    public $iglesia;
    public $email;
    public $whatsapp;
    public $telefono;
    public $facebook;
    public $instagram;
    public $aceptaPoliticas;
    public $medicamentos;
    public $status;
    public $staff;
    public $admin;
    public $confirmado;
    public $asistencia;
    public $seguimiento;
    public $emailEnviado;
    public $emailConfirmado;
    public $hospedaje;
    public $habitacion;
    public $password;
    public $fechahoraRegistro;

    /**
     * Create User from array
     * 
     * @param array $data
     * @return User
     */
    public static function fromArray($data)
    {
        $user = new self();
        foreach ($data as $key => $value) {
            if (property_exists($user, $key)) {
                $user->$key = $value;
            }
        }
        return $user;
    }

    /**
     * Convert User to array
     * 
     * @return array
     */
    public function toArray()
    {
        $reflection = new ReflectionClass($this);
        $properties = $reflection->getProperties();
        $array = [];

        foreach ($properties as $property) {
            $key = $property->getName();
            $array[$key] = $this->$key ?? null;
        }

        return $array;
    }

    /**
     * Get public user info (without sensitive data)
     * 
     * @return array
     */
    public function toPublicArray()
    {
        $data = $this->toArray();
        unset($data['password']);
        return $data;
    }
}
?>
