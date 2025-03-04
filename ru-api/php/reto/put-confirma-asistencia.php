<?php
header('Content-Type: application/json; charset=utf-8');
require '../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();
$asiste=$_REQUEST["asistencia"];
$id_seguimiento=$_REQUEST["seguimiento"];
$id_guerrero=$_REQUEST["guerrero"];
$datos = $rdatos->updateAsistencia($asiste, $id_seguimiento, $id_guerrero);
$data=(object)array();
$data-> success = $datos;
echo json_encode($data);
?>