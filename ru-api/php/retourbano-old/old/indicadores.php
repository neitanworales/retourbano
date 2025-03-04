<?php
require '../db/Datos.class.php';
$datos=Datos::getInstance();

$tipo = empty($_REQUEST['tipo'])?"0":$_REQUEST['tipo'];

switch($tipo){
    default:
        echo 'Error de selección';
        break;
    case "1":
        $datos->getContadorSexo();
        break;
    case "2":
        $datos->getContadorStaffJ();
        break;
    case "3":
        $datos->getTallas();
        break;
    case "4":
        $datos->getInscritosPorSexoStaff();
        break;        
}

?>