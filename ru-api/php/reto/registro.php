<?php

header('Content-Type: application/json; charset=utf-8');
require '../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();
$email = $_REQUEST['email'];
$datos = $rdatos->getGuerreroByEmail($email);
$data=(object)array();

if(empty($datos)){
    $data-> success = false;
    $data-> mensaje = "Este email($email) no se encuentra, por favor verifica.. Si tienes mas problemas comunicate a reto@ywampachuca.org o al WhatsApp 562 4242 759";
    echo json_encode($data);
}else{
    $pwd = generatePassword();
    $updatedPwd = $rdatos->updatePassword($email,$pwd);
    if($updatedPwd){
        $rdatos->enviarEmailSignUp($email, $pwd);
        $data-> success = true;
        $data-> mensaje = "Se envió tu contraseña a tu correo.. Por favor revisa el SPAM y selecciona a reto@ywampachuca.org como conocido.. A veces tarda en llegar el correo.";
        echo json_encode($data);
    }else{
        $data-> success = false;
        $data-> mensaje = "Error al crear tu usuario.. Si tienes mas problemas comunicate a reto@ywampachuca.org o al Whats 562 4242 759";
        echo json_encode($data);
    }
}

function generatePassword(){
    $palabras = array("qwer","asdf","volta","nota","retoU","segu1","zxcv","mexico","pachuca","saxofon","musik", "j3sus", "frase", "auto");
    $pwd = $palabras[array_rand($palabras)].random_int(1000, 7777).$palabras[array_rand($palabras)];
    return $pwd;
}

?>
