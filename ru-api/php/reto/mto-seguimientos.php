<?php
header('Content-Type: application/json; charset=utf-8');
require '../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();
$id=$_REQUEST["id"];
$fecha_inicio=$_REQUEST["fecha"];
$activo=$_REQUEST["activo"];
$titulo=$_REQUEST["titulo"];
$texto_fecha=$_REQUEST["texto"];

if(empty($id)){
    $rdatos->addSeguimiento($fecha_inicio, $activo, $titulo, $texto_fecha);
}else{
    $rdatos->updateSeguimiento($id,$fecha_inicio, $activo, $titulo, $texto_fecha);
}

?>