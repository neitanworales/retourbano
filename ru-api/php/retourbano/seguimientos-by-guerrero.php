<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json; charset=utf-8');

require './RetoUrbanoDao.class.php';
$datos = RetoUrbanoDao::getInstance();
$id = $_REQUEST["id"];
$seguimientos["resultado"] = $datos->getSeguimientosById($id);
echo json_encode($seguimientos);
?>