<?php
require '../db/RUDatos.class.php';
$datos=RUDatos::getInstance();

header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('content-type: application/json; charset=utf-8');

if(!empty($_REQUEST['accion'])){
   return $datos->getReconectados();
}

$correcto1 = !empty($_REQUEST['trainings']);
$correcto2 = !empty($_REQUEST['camps']);
$correcto3 = !empty($_REQUEST['coments']);
$correcto4 = !empty($_REQUEST['dedonde']);
$correcto5 = !empty($_REQUEST['whats']);
$correcto6 = !empty($_REQUEST['edad']);
$correcto7 = !empty($_REQUEST['name']);
$correcto8 = !empty($_REQUEST['email']);

if($correcto1 && $correcto2 && $correcto3 && $correcto4 && $correcto5 && $correcto6 && $correcto7&$correcto8){

    $name=$_REQUEST['name'];
    $edad=$_REQUEST['edad'];
    $whats=$_REQUEST['whats'];
    $dedonde=$_REQUEST['dedonde'];
    $coments=$_REQUEST['coments'];
    $email=$_REQUEST['email'];
    
    $camps="";
    $trainings="";

    foreach($_REQUEST['trainings'] as $check) {
        $trainings.=(','.$check);
    }
    
    foreach($_REQUEST['camps'] as $check) {
        $camps.=(','.$check);
    }

    $camps=ltrim($camps, ",");
    $trainings=ltrim($trainings, ",");    

    if($datos->guardarReconexion(strtoupper($name),$edad,$whats,strtoupper($dedonde),strtoupper($coments),$camps,$trainings,$email)){

        enviarEmail(strtoupper($name),$edad,$whats,strtoupper($dedonde),strtoupper($coments),$camps,$trainings,$email);

        echo '{ "error": "0" , "mensaje" : "Hola '.strtoupper($name).', Tu registro fue realizado de manera correcta." }';
    }else{
        echo '{ "error": "1" , "mensaje" : "Error al guardar" }';
    }

}else{    
    echo '{ "error": "1" , "mensaje" : "Hay datos en blanco, no se puede guardar:", "mensaje2" : "'.(!$correcto1?'\nSelecciona alguna casilla de entrenamiento':'').'", "mensaje3" : "' .(!$correcto2?'\nSelecciona alguna casilla de campamentos':'').'"}';
}

function enviarEmail($nombre,$edad,$whatsapp,$dedonde,$coments,$camps,$trainings,$email){
    // the message
    $msg = '<html><head>
    <style>.correoreto {padding: 20px;background-color: whitesmoke;font-family: Arial, Helvetica, sans-serif;}
        .correoreto img {}
        h3 {padding: 10px;background-color: lavender;}
        p {color: brown;}
    </style>
</head>
<body><div class="correoreto">
        <img src="http://ywampachuca.org/retourbano/img/logo2.png">
        <h3>Hola '.$nombre.', te has registrado correctamente a RECONEXIÓN</h3>
        <p>con los siguientes datos:</p>
        <table class="tabla">        
            <tr><td>Nombre</td><td>'.$nombre.'</td></tr>
            <tr><td>Edad</td><td>'.$edad.'</td></tr>
            <tr><td>Whatsapp</td><td>'.$whatsapp.'</td></tr>
            <tr><td>Vienes de </td><td>'.$dedonde.'</td></tr>
            <tr><td>Comentarios</td><td>'.$coments.'</td></tr>
            <tr><td>Campamentos</td><td>'.$camps.'</td></tr>
            <tr><td>Entrenamientos</td><td>'.getSovieticos($trainings).'</td></tr>            
        </table>
        <p>Tus datos quedan resguardados para su uso en la log&iacute;stica del congreso.<br>
            tambi&eacute;n estaremos orando por ti.</p>
        
        <p>Atentamente: Staff de Reto</p></div></body></html>';    


        $headers = "From: reto@ywampachuca.org\r\n";    
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";

    // send email
    mail($email,"Registro",$msg,$headers);
    mail("reto@ywampachuca.org","Nuevo Registro",$msg,$headers);    
}

function getSovieticos($str){
    $arr1 = explode(",", $str);
    $out = "";    
    foreach ($arr1 as $valor){
        $out.=", ".getEntrenamientosDesc($valor);
    }    
    return substr($out, 1);
}

function getEntrenamientosDesc($id){
    switch($id){
        case 0:
            return "Ninguno";
        break;
        case 1:
            return "Drama";
        break;
        case 2:
            return "Música";
        break;
        case 3:
            return "Niños";
        break;
        case 4:
            return "Coreografía";
        break;
        case 5:
            return "Evangelismo Urbano";
        break;
    }
}

?>