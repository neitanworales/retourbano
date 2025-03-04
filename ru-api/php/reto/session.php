<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');
require '../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();

$id = $_REQUEST['id'];
$token = $_REQUEST['token'];

$response = $rdatos->getGuerreroById($id);


if( !empty($response[0]) && $rdatos->validarToken($id, $token)){
    $array["guerrero"]= $response[0];
    $array["guerrero"]["staff"]= $array["guerrero"]["staff"]==1;
    $array["guerrero"]["admin"]= $array["guerrero"]["admin"]==1;
    $array["error"]=false;
    $array["mensaje"]="Session correcta";
    echo json_encode($array);
}else{
    $array["error"]=true;
    $array["mensaje"]="No hay sesion";
    echo json_encode($array);
}

?>