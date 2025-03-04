<?php
require '../db/Datos.class.php';
$datos=Datos::getInstance();

$staff = empty($_REQUEST['staff'])?0:$_REQUEST['staff'];

switch($staff){
    case '0':
        $datos->getTablaGuerreros();
        break;
    case '1':
        $datos->getTablaStaff();
        break;
    case '2':
        $datos->getTablaBajas();
        break;
}

?>