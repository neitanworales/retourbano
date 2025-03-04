<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');

require './RetoUrbanoDao.class.php';
$datos=RetoUrbanoDao::getInstance();

if ($_SERVER['REQUEST_METHOD'] !== 'PUT') {
    echo '{ "error": 1 , "mensaje" : "Método Incorrecto, requiere PUT" }';
    return;
}

$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

$correcto = true;

if(empty($input['id']) || empty($input['nombre']) || empty($input['email'])){
    $correcto = false;
}

if($correcto){
    $id = !empty($input['id'])?$input['id']:null;
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
    
    if(!empty($fechaNac)){
        $f = explode("-", $fechaNac);
        $f1 = explode("T", $f[2]);
        $fechanac = $f1[0]."/".$f[1]."/".$f[0];
    }else{
        $fechanac = null;
    }

    $busqueda = $datos->getGuerreroByEmail($email);
    if(!empty($busqueda)){
        if($datos->actualizarGuerrero($id,$nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienesDe,$alergias,$razones,$tutorNombre,$tutorTelefono,$iglesia,$email,$whatsapp,$facebook,$instagram,$aceptaPoliticas)){        
            //enviarEmail($nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienesDe,$alergias,$razones,$tutorNombre,$tutorTelefono,$iglesia,$email,$whatsapp,$facebook,$instagram,$aceptaPoliticas);
            //$reporte1 = recorrerArray($datos->getIndicadoresArray());        
            //$reporte2 = '';
            //enviarEmailStaff($nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienesDe,$alergias,$razones,$tutorNombre,$tutorTelefono,$iglesia,$email,$whatsapp,$facebook,$instagram,$aceptaPoliticas,$reporte1);
            echo '{ "error": 0 , "mensaje" : "Hola '.$nombre.', Tus datos se actualizaron de manera correcta." }';
        }else{
            echo '{ "error": 1 , "mensaje" : "Error al guardar" }';
        }        
    }else{
        echo '{ "error": 1 , "mensaje" : "Ese guerrero ni existe" }';
    }
}else{
    echo '{ "error": 1 , "mensaje" : "Hay datos en blanco, no se puede guardar, el id, nombre y el email son datos obligatorios" }';
}