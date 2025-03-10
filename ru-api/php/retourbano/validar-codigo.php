<?php
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json; charset=utf-8');

require './RetoUrbanoDao.class.php';
require 'emails/EnviarEmail.class.php';

$datos = RetoUrbanoDao::getInstance();
$emailDao = EnviarEmail::getInstance();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $email = $_REQUEST['codigo'];
    if (!empty($email)) {
        $busqueda = $datos->getGuerrroRegistradoByCode($codigo);
        if (!empty($busqueda)) {
            $response["mensaje"] = "Ok";
            $response["resultado"] = $busqueda[0];
            $response["code"] = 200;
            http_response_code(200);
            echo json_encode($response);
        } else {
            $response["mensaje"] = "Not found $email";
            $response["code"] = 404;
            http_response_code(404);
            echo json_encode($response);
        }
    } else {
        $response["mensaje"] = "Bad request - faltan elementos: email";
        $response["code"] = 400;
        http_response_code(400);
        echo json_encode($response);
    }
} else {
    $response["mensaje"] = "Bad request";
    $response["code"] = 400;
    http_response_code(400);
    echo json_encode($response);
}