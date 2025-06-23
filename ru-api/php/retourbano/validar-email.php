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
require 'emails/EnviarEmail.class.php';

$datos = RetoUrbanoDao::getInstance();
$emailDao = EnviarEmail::getInstance();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $email = $_REQUEST['email'];
    if (!empty($email)) {
        $busqueda = $datos->getGuerrroRegistradoByEmail($email);
        if (!empty($busqueda)) {
            $campamento = $datos->consultarCampamentoActivo();

            $codigo_generated = bin2hex(random_bytes(4));

            $datos->actualizar($busqueda[0]["id"],NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, $codigo_generated);

            $variables = array();
            $variables["nick"] = $busqueda[0]['nick'];
            $variables["year"] = $campamento[0]["id_campamento"];
            $variables["codigo"] = $codigo_generated;
            $variables["basesite"] = "http://ywampachuca.org/retourbano";
            
            $templateName = "reinscripcion.html";
            $template = $emailDao->getTemplate($variables, $templateName);
            $emailEnviado = $emailDao->enviarEmail($email, 'Reinscripción Reto Urbano', $template, true);
            $response["mensaje"] = $emailEnviado ? "Se envió correo de verificacion a $email, ¡¡Recuerda revisar tu bandeja de SPAM o Correo no deseado!!": "Error al enviar correo de verificacion a $email";
            $response["code"] = 200;
            http_response_code(200);
            echo json_encode($response);
        } else {
            $response["mensaje"] = "No se encontró este correo: $email - favor de validar.";
            $response["code"] = 404;
            http_response_code(200);
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