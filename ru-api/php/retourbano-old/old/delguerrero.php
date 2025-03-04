<?php
require '../db/Datos.class.php';
$datos=Datos::getInstance();

$tipo=$_REQUEST['tipo'];
$id=$_REQUEST['id'];

if($datos->cambiarStatusGuerrero($id,$tipo)){
    echo "Hecho correctamente.";
}else{
    echo "Hubo un error.";
}

?>