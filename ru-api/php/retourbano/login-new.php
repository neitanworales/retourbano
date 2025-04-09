<?php
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    return 0;
}

require './RetoUrbanoDao.class.php';
$datos = RetoUrbanoDao::getInstance();

$usuario = $_REQUEST['username'];
$password = $_REQUEST['password'];

if ($datos->login($usuario, $password)) {

    $registro = $datos->getGuerrroRegistradoByEmail($usuario);

    $rolesQuery = $datos->obtenerRolesById($registro[0]['id']);
    $roles = array();
    foreach ($rolesQuery as &$rol) {
        array_push($roles, $rol['rol']);
    }
    $sesion['roles'] = $roles;
    $sesion["guerrero"] = $registro[0];
    $sesion["guerrero"]["staff"] = $sesion["guerrero"]["staff"] == "true";
    $sesion["guerrero"]["admin"] = $sesion["guerrero"]["admin"] == "true";
    $sesion["guerrero"]["confirmado"] = $sesion["guerrero"]["confirmado"] == "true";
    $sesion["guerrero"]["asistencia"] = $sesion["guerrero"]["asistencia"] == "true";
    $sesion["guerrero"]["seguimiento"] = $sesion["guerrero"]["seguimiento"] == "true";
    $sesion['token'] = $datos->crearToken();
    $datos->saveToken($registro[0]['id'], $sesion['token']);
    $sesion["id"] = $registro[0]['id'];
    $response["session"] = $sesion;
    $response["code"] = 200;
    $response["mensaje"] = "Session correcta";
    $response["success"] = true;
    http_response_code(200);
    echo json_encode($response);
} else {
    $response["code"] = 401;
    $response["message"] = 'Not authorized';
    $response["success"] = false;
    http_response_code(401);
    echo json_encode($response);
}

?>