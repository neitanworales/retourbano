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

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $campamento = $datos->consultarCampamentoActivo();

    $costos = $datos->consultarCostosByCampamento($campamento[0]['id_campamento']);
    
    foreach ($costos as &$costo)
    {
        $incluyeArray = explode(',', $costo['incluye']);
        $incluyes = array();
        foreach ($incluyeArray as &$includes)
        {
            array_push($incluyes, $includes);
        }
        $costo['incluye'] = $incluyes;
    }

    $campamento[0]['costos'] = $costos;
    $response["resultado"] = $campamento;
    $response["mensaje"] = "Ok";
    $response["code"] = 200;
    http_response_code(200);
    echo json_encode($response);
} else {
    $response["mensaje"] = "Bad request";
    $response["code"] = 400;
    http_response_code(400);
    echo json_encode($response);
}