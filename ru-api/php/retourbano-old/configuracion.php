<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');

require '../db/RUDatos.class.php';
$datos=RUDatos::getInstance();
echo json_decode($datos->obtenerConfiguracion());
?>