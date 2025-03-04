<?php
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json; charset=utf-8');

require './RetoUrbanoDao.class.php';
$datos=RetoUrbanoDao::getInstance();

$role_requiered = ['admin'];

if(empty($_REQUEST['user']) or empty($_REQUEST['token']) or empty($_REQUEST['opcion'])) {
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
}
$isAdmin = true;
$opcion = $_REQUEST['opcion'];

switch($opcion){
    case 1:
        //totales
        $arrayResponse['resultado']=$datos->consultaTotales();
        $arrayResponse["error"]="false";
        $arrayResponse["mensaje"]="Ok";
        echo json_encode($arrayResponse);
        break;
    case 2:
        //pagos
        $arrayResponse['resultado']=$datos->consultaPagos();
        $arrayResponse["error"]="false";
        $arrayResponse["mensaje"]="Ok";
        echo json_encode($arrayResponse);
        break;
    case 3:
        //agrupacion
        $arrayResponse['resultado']=$datos->consultaAgruparPorDescripcion();
        $arrayResponse["error"]="false";
        $arrayResponse["mensaje"]="Ok";
        echo json_encode($arrayResponse);
        break;
    case 4:
        //por campero
        $arrayResponse['resultado']=$datos->consultaPagosPorGuerrero();
        $arrayResponse["error"]="false";
        $arrayResponse["mensaje"]="Ok";
        echo json_encode($arrayResponse);
        break;
    default:
        http_response_code(400); 
        $response["error"]="true";
        $response["mensaje"]="Ninguna opcion seleccionada";
        echo json_encode($response);    
        break;
}

?>