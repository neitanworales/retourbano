<?php
header('Content-Type: application/json; charset=utf-8');
require '../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();
session_start();
$email = $_SESSION['email'];
echo json_encode($rdatos->getGuerreroByEmail($email));
?>