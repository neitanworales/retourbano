<?php
header('Content-Type: application/json; charset=utf-8');
require '../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();
$id=$_REQUEST["id"];
$datos = $rdatos->getSeguimientosById($id);
echo json_encode($datos);
?>