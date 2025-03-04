<?php
header('Content-Type: application/json; charset=utf-8');
require '../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();
$dia = $_REQUEST['dia'];
$id=$_REQUEST["id"];
$rdatos->obtenerConfirmacion($dia,$id);
?>