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
    $email = $_REQUEST['email'];
    if (!empty($email)) {
        $busqueda = $datos->getGuerrroRegistradoByEmail($email);
        if (!empty($busqueda)) {
            $variables = array();
            $variables["nick"] = "Nonoalco";
            $variables["year"] = "2025";
            $variables["codigo"] = "43fds-243f4-4e244";
            $variables["basesite"] = "http://ywampachuca.org/retourbano";
            $templateName = "verificacion-reinscripcion.html";
            $template = $emailDao->getTemplate($variables, $templateName);
            $emailEnviado = $emailDao->enviarEmail($email, 'Reinscripción Reto Urbano', $template);
            $response["mensaje"] = $emailEnviado ? "Se envió correo de verificacion a $email": "Error al enviar correo de verificacion a $email";
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