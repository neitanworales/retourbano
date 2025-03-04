<?php
require '../db/HabitacionesDatos.class.php';
$habitacionesDatos=HabitacionesDatos::getInstance();

$tipo = $_REQUEST['tipo'];

switch($tipo){
    case "1":
            $habitacionesDatos->getHabitaciones();
        break;
    case "2":
            $num = $_REQUEST['num'];
            $leader = $_REQUEST['leader'];
            $descripcion = $_REQUEST['desc'];
            $sexo = $_REQUEST['sexo'];
            
            if($habitacionesDatos->addHabitacion($num,$leader,$descripcion,$sexo)){
                echo 'Guardado correctamente.';
            }else{
                echo 'Error al insertar.';
            }
        break;
    default:
        echo 'Error de selección';
        break;
}
?>