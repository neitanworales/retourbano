<?php
header('Content-Type: application/json; charset=utf-8');
require '../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();
echo json_encode($rdatos->getListaAsistencia());
?>