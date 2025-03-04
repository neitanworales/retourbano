<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json; charset=utf-8');

require './RetoUrbanoDao.class.php';
$datos=RetoUrbanoDao::getInstance();

$role_requiered = ['admin'];

if(empty($_REQUEST['user']) or empty($_REQUEST['token'])) {
    http_response_code(400); 
    $response["error"]="true";
    $response["mensaje"]="Bad request";
    echo json_encode($response);
    exit;
}

$user = $_REQUEST['user'];
$token = $_REQUEST['token'];

if(!$datos->validarToken($user, $token) or !$datos->validarAdmin($user)){
    http_response_code(401); 
    $response["error"]="true";
    $response["mensaje"]="No authorizado";
    echo json_encode($response);
    exit;
} else {
    http_response_code(200);
    $arrayResponse['resultado']=$datos->consultarCampamentos();
    $arrayResponse["error"]="false";
    $arrayResponse["mensaje"]="Ok";
    echo json_encode($arrayResponse);
}

?>