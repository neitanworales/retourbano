<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    return 0;
}

require './RetoUrbanoDao.class.php';
$datos = RetoUrbanoDao::getInstance();

require 'emails/EnviarEmail.class.php';
$emailDao = EnviarEmail::getInstance();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $inputJSON = file_get_contents('php://input');
    $input = json_decode($inputJSON, TRUE);

    $correcto = true;

    if (empty($input['nombre']) || empty($input['email'])) {
        $correcto = false;
    }

    if ($correcto) {

        $nombre = !empty($input['nombre']) ? $input['nombre'] : null;
        $nick = !empty($input['nick']) ? $input['nick'] : null;
        $fechaNac = !empty($input['fechaNac']) ? $input['fechaNac'] : null;
        $edad = !empty($input['edad']) ? $input['edad'] : null;
        $sexo = !empty($input['sexo']) ? $input['sexo'] : null;
        $talla = !empty($input['talla']) ? $input['talla'] : null;
        $vienesDe = !empty($input['vienesDe']) ? $input['vienesDe'] : null;
        $alergias = !empty($input['alergias']) ? $input['alergias'] : null;
        $razones = !empty($input['razones']) ? $input['razones'] : null;
        $tutorNombre = !empty($input['tutorNombre']) ? $input['tutorNombre'] : null;
        $tutorTelefono = !empty($input['tutorTelefono']) ? $input['tutorTelefono'] : null;
        $iglesia = !empty($input['iglesia']) ? $input['iglesia'] : null;
        $email = !empty($input['email']) ? $input['email'] : null;
        $whatsapp = !empty($input['whatsapp']) ? $input['whatsapp'] : null;
        $telefono = !empty($input['telefono']) ? $input['telefono'] : null;
        $facebook = !empty($input['facebook']) ? $input['facebook'] : null;
        $medicamentos = !empty($input['medicamentos']) ? $input['medicamentos'] : null;
        $instagram = !empty($input['instagram']) ? $input['instagram'] : null;
        $aceptaPoliticas = !empty($input['aceptaPoliticas']) ? $input['aceptaPoliticas'] : null;
        $isTutor = !empty($_REQUEST['tutor']) ? $_REQUEST['tutor'] : false;
        $hospedaje = !empty($input['hospedaje']) ? $input['hospedaje'] : null;
        if (!empty($fechaNac)) {
            $f = explode("-", $fechaNac);
            $f1 = explode("T", $f[2]);
            $fechanac = $f1[0] . "/" . $f[1] . "/" . $f[0];
        } else {
            $fechanac = null;
        }

        $busqueda = $isTutor ? array() : $datos->getGuerreroByEmail($email);
        if (!empty($busqueda)) {
            $response["mensaje"] = "Ya existe un registro con ese correo electrónico, por favor intenta reinscribirte";
            $response["error"] = true;
            $response["code"] = 400;
            http_response_code(200);
            echo json_encode($response);
        } else {
            if ($datos->inscribir($nombre, $nick, $fechanac, $edad, $sexo, $talla, $vienesDe, $alergias, $razones, $tutorNombre, $tutorTelefono, $iglesia, $email, $whatsapp, $facebook, $instagram, $aceptaPoliticas, $medicamentos, $telefono, $hospedaje)) {

                $variables = array();
                $variables["nombre"] = $nombre;
                $variables["nick"] = $nick;
                $variables["fechanac"] = $fechanac;
                $variables["edad"] = $edad;
                $variables["sexo"] = $sexo;
                $variables["talla"] = $talla;
                $variables["vienesDe"] = $vienesDe;
                $variables["alergias"] = $alergias;
                $variables["razones"] = $razones;
                $variables["tutorNombre"] = $tutorNombre;
                $variables["tutorTelefono"] = $tutorTelefono;
                $variables["iglesia"] = $iglesia;
                $variables["email"] = $email;
                $variables["whatsapp"] = $whatsapp;
                $variables["facebook"] = $facebook;
                $variables["instagram"] = $instagram;
                $variables["aceptaPoliticas"] = $aceptaPoliticas;
                $variables["medicamentos"] = $medicamentos;
                $variables["telefono"] = $telefono;
                $variables["hospedaje"] = $hospedaje;
                $variables["reporte"] = $datos->recorrerArray($datos->getIndicadoresArray());

                $campamento = $datos->consultarCampamentoActivo();

                $variables["year"] = $campamento[0]["id_campamento"];
                $variables["titulo"] = $campamento[0]["titulo"];
                $variables["costoMX"] = $campamento[0]["costoMX"];
                $variables["costoUSD"] = $campamento[0]["costoUSD"];
                $variables["banco"] = $campamento[0]["banco"];
                $variables["cuenta"] = $campamento[0]["cuenta"];
                $variables["titularCuenta"] = $campamento[0]["titularCuenta"];
                $variables["contacto1"] = $campamento[0]["contacto1"];
                $variables["contacto2"] = $campamento[0]["contacto2"];
                $variables["pago_minimoMX"] = $campamento[0]["pago_minimoMX"];

                $templateName = "inscripcion.html";
                $template = $emailDao->getTemplate($variables, $templateName);
                $emailEnviado = $emailDao->enviarEmail($email, 'Te inscribiste a Reto Urbano', $template, false);

                if ($emailEnviado) {
                    $templateName = "inscripcion-staff.html";
                    $message = $emailDao->getTemplate($variables, $templateName);
                    $emailDao->reportarStaff('Nuevo inscrito Reto Urbano', $message);
                }
                $response["mensaje"] = "Hola ' . $nombre . ', Tu registro fue realizado de manera correcta. Se envió un correo al email ($email) que nos proporcionaste con información de pago y demás cosas que deberías saber.";
                $response["error"] = false;
                $response["code"] = 200;
                http_response_code(200);
                echo json_encode($response);
            } else {
                $response["mensaje"] = "Error al guardar";
                $response["error"] = true;
                $response["code"] = 500;
                http_response_code(500);
                echo json_encode($response);
            }
        }
    } else {
        $response["mensaje"] = "Bad request - faltan elementos: nombre, email";
        $response["error"] = true;
        $response["code"] = 400;
        http_response_code(400);
        echo json_encode($response);
    }
} else {
    $response["mensaje"] = "Bad request";
    $response["error"] = true;
    $response["code"] = 400;
    http_response_code(400);
    echo json_encode($response);
}

?>