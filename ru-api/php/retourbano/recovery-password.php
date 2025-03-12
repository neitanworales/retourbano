<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');

require './RetoUrbanoDao.class.php';
$rdatos = RetoUrbanoDao::getInstance();

require 'emails/EnviarEmail.class.php';
$emailDao = EnviarEmail::getInstance();

$data = (object) array();

if (empty($_REQUEST['email'])) {
    $data->error = true;
    $data->mensaje = "El email es necesario";
    echo json_encode($data);
    return;
}

$email = $_REQUEST['email'];
$datos = $rdatos->getGuerreroByEmailToRecovery($email);

if (empty($datos)) {
    $data->error = true;
    $data->mensaje = "Este email($email) no se encuentra habilitado para un login.";
    echo json_encode($data);
} else {
    $pwd = generatePassword();
    $updatedPwd = $rdatos->updatePassword($email, $pwd);
    if ($updatedPwd) {

        $variables = array();
        $variables["email"] = $email;
        $variables["pwd"] = $pwd; 

        $message = $emailDao->getTemplate($variables, 'recovery-password.html');
        $emailDao->enviarEmail($email,'Recuperación de contraseña', $message, true);

        $data->error = false;
        $data->mensaje = "Se envió tu contraseña a tu correo.. Por favor revisa el SPAM y selecciona a reto@ywampachuca.org como conocido.. A veces tarda en llegar el correo.";
        echo json_encode($data);
    } else {
        $data->error = true;
        $data->mensaje = "Error al obtener tu contraseña. Si tienes mas problemas comunicate a reto@ywampachuca.org o al Whats 562 4242 759";
        echo json_encode($data);
    }
}

function generatePassword()
{
    $palabras = array("qwer", "asdf", "volta", "nota", "retoU", "segu1", "zxcv", "mexico", "pachuca", "saxofon", "musik", "j3sus", "frase", "auto");
    $pwd = $palabras[array_rand($palabras)] . random_int(1000, 7777) . $palabras[array_rand($palabras)];
    return $pwd;
}

?>