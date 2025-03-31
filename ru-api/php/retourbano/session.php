<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');
header("Expires: Tue, 03 Jul 2001 06:00:00 GMT");
header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

require './RetoUrbanoDao.class.php';
$datos=RetoUrbanoDao::getInstance();

$id = $_REQUEST['id'];
$token = $_REQUEST['token'];

if($datos->validarToken($id, $token)){

    $response = $datos->getGuerrroRegistradoById($id);

    $rolesQuery = $datos->obtenerRolesById($response[0]['id']);
    $roles = array();
    foreach ($rolesQuery as &$rol)
    {
        array_push($roles, $rol['rol']);
    }
    $response[0]['roles']=$roles;
    $array["guerrero"]= $response[0];
    $array["guerrero"]["staff"]= $array["guerrero"]["staff"]=="true";
    $array["guerrero"]["admin"]= $array["guerrero"]["admin"]=="true";
    $array["guerrero"]["confirmado"]= $array["guerrero"]["confirmado"]=="true";
    $array["guerrero"]["asistencia"]= $array["guerrero"]["asistencia"]=="true";
    $array["guerrero"]["seguimiento"]= $array["guerrero"]["seguimiento"]=="true";
    $array["error"]=false;
    $array["mensaje"]="Session correcta";
    echo json_encode($array);
}else{
    $array["error"]=true;
    $array["mensaje"]="No hay sesion";
    echo json_encode($array);
}

?>