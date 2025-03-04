<?php
require '../db/Datos.class.php';
$datos=Datos::getInstance();

$id=$_REQUEST['id'];
$value=$_REQUEST['value'];

if($datos->CambiarStaff($id, $value))
{
    echo 'Cambio hecho correctamente';
}
else
{
    echo 'Error en cambio';
}


?>