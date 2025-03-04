<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');

require '../db/RUDatos.class.php';
$datos=RUDatos::getInstance();

$correcto = true;


if ($_SERVER['REQUEST_METHOD'] !== 'PUT') {
    echo '{ "error": 1 , "mensaje" : "Método Incorrecto, requiere PUT" }';
    return;
}

$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

if($correcto){

    $id = !empty($input['id'])?$input['id']:null;

    if(empty($id)){
        echo '{ "error": 1 , "mensaje" : "No se encuentra id" }';
        return;
    }

    $nombre = !empty($input['nombre'])?$input['nombre']:null;
    $nick = !empty($input['nick'])?$input['nick']:null;
    $fechaNac = !empty($input['fechaNac'])?$input['fechaNac']:null;
    $edad = !empty($input['edad'])?$input['edad']:null;
    $sexo = !empty($input['sexo'])?$input['sexo']:null;
    $talla = !empty($input['talla'])?$input['talla']:null;
    $vienesDe = !empty($input['vienesDe'])?$input['vienesDe']:null;
    $alergias = !empty($input['alergias'])?$input['alergias']:null;
    $razones = !empty($input['razones'])?$input['razones']:null;
    $tutorNombre = !empty($input['tutorNombre'])?$input['tutorNombre']:null;
    $tutorTelefono = !empty($input['tutorTelefono'])?$input['tutorTelefono']:null;
    $iglesia = !empty($input['iglesia'])?$input['iglesia']:null;
    $email = !empty($input['email'])?$input['email']:null;
    $whatsapp = !empty($input['whatsapp'])?$input['whatsapp']:null;
    $facebook = !empty($input['facebook'])?$input['facebook']:null;
    $instagram = !empty($input['instagram'])?$input['instagram']:null;
    $aceptaPoliticas = !empty($input['aceptaPoliticas'])?$input['aceptaPoliticas']:null;
    $password = !empty($input['password'])?$input['password']:null;
    
    if(!empty($fechaNac)){
        //$f = explode("/", $fechaNac);
        //$fechanac = $f[2]."/".$f[1]."/".$f[0];
        $fechanac = $fechaNac;
    }else{
        $fechanac = null;
    }

    if(empty($nombre) ||
    !empty($nick) ||
    !empty($fechaNac) ||
    !empty($edad) ||
    !empty($sexo) ||
    !empty($talla) ||
    !empty($vienesDe) ||
    !empty($alergias) ||
    !empty($razones) ||
    !empty($tutorNombre) ||
    !empty($tutorTelefono) ||
    !empty($iglesia) ||
    !empty($email) ||
    !empty($whatsapp) ||
    !empty($facebook) ||
    !empty($instagram) ||
    !empty($password) ||
    !empty($aceptaPoliticas)){
        
        if($datos->updateGuerrero($id,$nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienesDe,$alergias,$razones,$tutorNombre,$tutorTelefono,$iglesia,$email,$whatsapp,$facebook,$instagram,$aceptaPoliticas,$password)){        
            
            
            
            echo '{ "error": 0 , "mensaje" : "Hola '.$nombre.', Tus cambios se guardaron correctamente." }';
        }else{
            echo '{ "error": 1 , "mensaje" : "Error al guardar" }';
            return;
        }

    }else{
        echo '{ "error": 1 , "mensaje" : "No hay datos para guardar" }';
        return;
    }
}else{
    echo '{ "error": 1 , "mensaje" : "Hay datos en blanco, no se puede guardar" }';
    return;
}


?>