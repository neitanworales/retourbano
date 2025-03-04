<?php    
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');

session_start();
$_SESSION['nombre']='';
session_destroy();
header("Location: /retourbano/reto/");
?>