<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');

require './RetoUrbanoDao.class.php';
$datos=RetoUrbanoDao::getInstance();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo '{ "error": 1 , "mensaje" : "Método Incorrecto, requiere POST" }';
    return;
}

if(empty($_REQUEST["idguerrero"])){
    echo '{ "error": 1 , "mensaje" : "Falta idguerrero param" }';
    return;
}

if(empty($_REQUEST["enviado"])){
    echo '{ "error": 1 , "mensaje" : "Falta enviado param" }';
    return;
}

if(empty($_REQUEST["confirmado"])){
    echo '{ "error": 1 , "mensaje" : "Falta confirmado param" }';
    return;
}

$id_guerrero = $_REQUEST["idguerrero"];
$busqueda = $datos->getGuerreroById($id_guerrero);

if(empty($busqueda)){
    echo '{ "error": 1 , "mensaje" : "guerrero no encontrado" }';
    return;
}

$valor = !empty($_REQUEST['valor'])?$_REQUEST['valor']:null;
$idcg = $busqueda[0]["id_campamento_guerrero"];

$enviado = $_REQUEST["enviado"];
$confirmado = $_REQUEST["confirmado"];
$emailEnviado = $busqueda[0]["emailEnviado"]=="true";

if(!$emailEnviado){
    $emailEnviado = enviarEmailInformacion($busqueda[0]["email"]);
}

if($datos->guardarEmailEnviado($idcg,$enviado) && $datos->guardarEmailConfirmacion($idcg,$confirmado)){
    echo '{ "error": 0 , "mensaje" : "Guardado correctamente", "emailEnviado": '.($emailEnviado?'true':'false').', "enviadoAntes":'.($emailEnviado?'true':'false').'}';
}else{
    echo '{ "error": 1 , "mensaje" : "Error al guardar" }';
}


function enviarEmailInformacion($email){
    $headers = "From: reto@ywampachuca.org\r\n";
    $headers .= "MIME-Version: 1.0\r\n";
    $headers .= "Content-Type: text/html; charset=UTF-8\r\n";
    
    mail($email , 'Jucum Pachuca, INFORMACION - RETO URBANO', getMensajeEmailInformacion($email),$headers);    
}

function getMensajeEmailInformacion($email){
    return '<div dir="ltr">
        <div>
            <font face="arial, helvetica, sans-serif" size="4">
                <br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><b>INFORMACIÓN - RETO URBANO - OBEDIENCIA RADICAL VOLUMEN II</b></font>
        </div>
        <div>
            <p>Hola!<p>
            <p>Recibe un saludo de parte del equipo de logística de Reto Urbano.</p>
            
            <p>
                Cada vez falta menos para el día de inicio de nuestro campamento 2022 y queremos darte a conocer información muy importante.
            </p>
            <p>
                Recuerda que si no has hecho tu pago, requerimos que por lo menos puedas hacer un depósito de $800 para apartar tu lugar a mas tardar el 1ro de julio, y el resto puedes pagarlo a tu llegada. 
            </p>

            <p>
                <strong>Llegada</strong> 
                </p>

            <p>
                lunes 24 Julio 2023
                </p>

            <p>
                Centro de Estudios Teológicos y Ministeriales ( CETyM  Pachuca ). 
                </p>

            <p>
            Hora de registro: Lunes 24  de Junio de 9:00 -10:00 am (Procura ser puntual, pues el registro solamente estará abierto por una hora)
                </p>

            <p>
            </p>

            <p>
                <strong>Salida</strong> 
                </p>

            <p> 
                sábado 29 Julio 2023
                </p>
            <p>
             12:00 pm
            </p>
            <p>
                Toda esta información mas a detalle con mapas, direcciones y horarios se encuentra en: 
                <a href="https://ywampachuca.org/retourbano/info">https://ywampachuca.org/retourbano/info</a> 
            </p>
            <p>
                También añadimos una lista de las cosas que debes considerar traer para que tu estancia sea increíble. Si tienes alguna pregunta, no dudes en ponerte en contacto con nosotros por nuestras redes sociales. 
            </p>
            <p>
            <strong>¡¡IMPORTANTE!!: RESPONDE ESTE EMAIL NOTIFICÁNDONOS QUE ESTÁS ENTERADO</strong>
            </p>
            <p>
                IG: @retourbano 
                </p>

            <p>
                FB: Reto Urbano
            </p>
        </div>
    </div>';
}