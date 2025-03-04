<?php
header('Content-Type: application/json; charset=utf-8');
require '../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();
$hora = $_REQUEST['hora'];
$id=$_REQUEST["id"];
$rdatos->obtenerConfirmacionHora($hora,$id);
?>