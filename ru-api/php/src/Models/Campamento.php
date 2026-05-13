<?php
/**
 * Campamento Model
 * 
 * @version 1.0
 * @author Neitan
 */

class Campamento
{
    public $id;
    public $nombre;
    public $descripcion;
    public $fecha_inicio;
    public $fecha_fin;
    public $ubicacion;
    public $capacidad;
    public $costo;
    public $estado;
    public $año;
    public $fecha_creacion;
    public $fecha_actualizacion;

    /**
     * Create Campamento from array
     * 
     * @param array $data
     * @return Campamento
     */
    public static function fromArray($data)
    {
        $campamento = new self();
        foreach ($data as $key => $value) {
            if (property_exists($campamento, $key)) {
                $campamento->$key = $value;
            }
        }
        return $campamento;
    }

    /**
     * Convert Campamento to array
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
}
?>
