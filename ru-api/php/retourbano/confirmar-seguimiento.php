<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');

require './RetoUrbanoDao.class.php';
$datos=RetoUrbanoDao::getInstance();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo '{ "error": 1 , "mensaje" : "Método Incorrecto, requiere POST" }';
    return;
}

if(empty($_REQUEST["idguerrero"])){
    echo '{ "error": 1 , "mensaje" : "Falta idguerrero param" }';
    return;
}

if(empty($_REQUEST["seguimiento"])){
    echo '{ "error": 1 , "mensaje" : "Se desconoce el proceso a seguir: seguimiento" }';
    return;
}

$id_guerrero = $_REQUEST["idguerrero"];
$busqueda = $datos->getGuerreroById($id_guerrero);

if(empty($busqueda)){
    echo '{ "error": 1 , "mensaje" : "guerrero no encontrado" }';
    return;
}

$seguimiento = $_REQUEST["seguimiento"];
$idcg = $busqueda[0]["id_campamento_guerrero"];

if($datos->guardarSeguimiento($idcg,$seguimiento)){
    echo '{ "error": 0 , "mensaje" : "Guardado correctamente" }';
}else{
    echo '{ "error": 1 , "mensaje" : "Error al guardar" }';
}

?>