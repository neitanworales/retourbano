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
        $id_campamento = null;
        if (isset($input['id_campamento'])) {
            $tmp = filter_var($input['id_campamento'], FILTER_VALIDATE_INT);
            $id_campamento = $tmp !== false ? $tmp : null;
        } elseif (isset($_GET['id_campamento'])) {
            $tmp = filter_var($_GET['id_campamento'], FILTER_VALIDATE_INT);
            $id_campamento = $tmp !== false ? $tmp : null;
        }    
        $email = $_REQUEST['email'];

    if (!empty($email)) {
        $busqueda = $datos->getGuerrroRegistradoByEmail($email);
        if (!empty($busqueda)) {
            $campamento = $datos->consultarCampamentoActivoById($id_campamento);

            $codigo_generated = bin2hex(random_bytes(4));

            $datos->actualizar($busqueda[0]["id"],NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, $codigo_generated);

            $variables = array();
            $variables["nick"] = $busqueda[0]['nick'];
            $variables["codigo"] = $codigo_generated;
            $variables["basesite"] = "http://ywampachuca.org/retourbano";

            $variables["id_campamento"] = $id_campamento;
            $variables["year"] = $campamento[0]["year"];
            $variables["titulo"] = $campamento[0]["titulo"];
            $variables["costoMX"] = $campamento[0]["costoMX"];
            $variables["costoUSD"] = $campamento[0]["costoUSD"];
            $variables["banco"] = $campamento[0]["banco"];
            $variables["cuenta"] = $campamento[0]["cuenta"];
            $variables["titularCuenta"] = $campamento[0]["titularCuenta"];
            $variables["contacto1"] = $campamento[0]["contacto1"];
            $variables["contacto2"] = $campamento[0]["contacto2"];
            $variables["pago_minimoMX"] = $campamento[0]["pago_minimoMX"];
            $variables["contacto_email"] = $campamento[0]["contacto_email"];
            $variables["ciudad"] = $datos->consultarCiudadById($campamento[0]["id_ciudad"])[0]["nombre"];
            
            $templateName = "reinscripcion.html";
            $template = $emailDao->getTemplate($variables, $templateName);
            $emailEnviado = $emailDao->enviarEmail($email, "Reinscripción Reto Urbano " . $variables['titulo'] . " - " . $variables['ciudad'], $template, true, $variables["contacto_email"]);
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