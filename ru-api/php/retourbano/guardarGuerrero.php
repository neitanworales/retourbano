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

$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

$correcto = true;

if(empty($input['nombre']) || empty($input['email'])){
    $correcto = false;
}

if($correcto){

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
    $telefono = !empty($input['telefono'])?$input['telefono']:null;
    $facebook = !empty($input['facebook'])?$input['facebook']:null;
    $medicamentos = !empty($input['medicamentos'])?$input['medicamentos']:null;
    $instagram = !empty($input['instagram'])?$input['instagram']:null;
    $aceptaPoliticas = !empty($input['aceptaPoliticas'])?$input['aceptaPoliticas']:null;
    $isTutor = !empty($_REQUEST['tutor'])?$_REQUEST['tutor']:false;
    if(!empty($fechaNac)){
        $f = explode("-", $fechaNac);
        $f1 = explode("T", $f[2]);
        $fechanac = $f1[0]."/".$f[1]."/".$f[0];
    }else{
        $fechanac = null;
    }

    $busqueda = $isTutor ? array() : $datos->getGuerreroByEmail($email);
    if(!empty($busqueda)){
        echo '{ "error": 1 , "mensaje" : "Ya existe un registro con ese correo electrónico" }';
    }else{
        if($datos->guardarGuerrero($nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienesDe,$alergias,$razones,$tutorNombre,$tutorTelefono,$iglesia,$email,$whatsapp,$facebook,$instagram,$aceptaPoliticas,$medicamentos,$telefono)){        
            enviarEmail($nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienesDe,$alergias,$razones,$tutorNombre,$tutorTelefono,$iglesia,$email,$whatsapp,$facebook,$instagram,$aceptaPoliticas,$medicamentos,$telefono);
            $reporte1 = recorrerArray($datos->getIndicadoresArray());        
            $reporte2 = '';
            enviarEmailStaff($nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienesDe,$alergias,$razones,$tutorNombre,$tutorTelefono,$iglesia,$email,$whatsapp,$facebook,$instagram,$aceptaPoliticas,$reporte1,$medicamentos,$telefono);
            echo '{ "error": 0 , "mensaje" : "Hola '.$nombre.', Tu registro fue realizado de manera correcta." }';
        }else{
            echo '{ "error": 1 , "mensaje" : "Error al guardar" }';
        }
    }
}else{
    echo '{ "error": 1 , "mensaje" : "Hay datos en blanco, no se puede guardar, el nombre y el email son datos obligatorios" }';
}

function enviarEmailStaff($nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienesDe,$alergias,$razones,$tutorNombre,$tutorTelefono,$iglesia,$email,$whatsapp,$facebook,$instagram,$aceptaPoliticas,$reporte1,$medicamentos,$telefono){

    // the message
    $msg = '<html><head>
    <style>.correoreto {padding: 20px;background-color: whitesmoke;font-family: Arial, Helvetica, sans-serif;}
        .correoreto img {}
        h3 {padding: 10px;background-color: lavender;}
        p {color: brown;}

        #deals {
            display: flex;        /* Flex layout so items have equal height  */
            flex-flow: row wrap;  /* Allow items to wrap into multiple lines */
            margin: 5px;
          }
        .sale-item {
            display: flex;        /* Lay out each item using flex layout */
            flex-flow: column;    /* Lay out item’s contents vertically  */
            background: beige;
            margin-right: 5px;
            display: block;
            text-align: center;
            padding: 5px;
          }
          .header{
            font-size: large;
          }
          .body{
            font-size: medium;
          }
    </style>
    </head>
    <body><div class="correoreto">
        <h3>Hola, Se ha registrado un nuevo GUERRERO > '.$nick.' </h3>
        <p>Con los siguientes datos:</p>
        <table class="tabla">        
            <tr><td>Nombre</td><td> '.$nombre.'</td></tr>
            <tr><td>Gafete</td><td> '.$nick.'</td></tr>
            <tr><td>Fecha de Nac</td><td>'.$fechanac.'</td></tr>
            <tr><td>Edad</td><td>'.$edad.'</td></tr>
            <tr><td>Sexo</td><td>'.$sexo.'</td></tr>
            <tr><td>Talla</td><td>'.$talla.'</td></tr>
            <tr><td>Vienes de</td><td>'.$vienesDe.'</td></tr>
            <tr><td>Alergias</td><td>'.$alergias.'</td></tr>
            <tr><td>Razón de asistir a RU</td><td>'.$razones.'</td></tr>
            <tr><td>Iglesia</td><td>'.$iglesia.'</td></tr>
            <tr><td>email</td><td>'.$email.'</td></tr>
            <tr><td>Whatsapp</td><td>'.$whatsapp.'</td></tr>
            <tr><td>Telefono</td><td>'.$telefono.'</td></tr>
            <tr><td>Facebook</td><td>'.$facebook.'</td></tr>
            <tr><td>Instagram</td><td>'.$instagram.'</td></tr>
            <tr><td>Medicamentos</td><td>'.$medicamentos.'</td></tr>
            <tr><td>Tutor</td><td>'.$tutorNombre.'</td></tr>
            <tr><td>Contacto Tutor</td><td>'.$tutorTelefono.'</td></tr>
        </table>
        <p>Recuerda estar orando por este nuevo guerrero que ha aceptado el reto</p>
        
        <h2>Informaci&oacute;n de INSCRIPCIONES</h2>        
            '.$reporte1.'
        <p>Atentamente: Neitan >D </p></div></body></html>';

    $headers = "From: reto@ywampachuca.org\r\n";    
    $headers .= "MIME-Version: 1.0\r\n";
    $headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
  
    mail("reto@ywampachuca.org","Nuevo Registro",$msg,$headers);
}

function enviarEmail($nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienesDe,$alergias,$razones,$tutorNombre,$tutorTelefono,$iglesia,$email,$whatsapp,$facebook,$instagram,$aceptaPoliticas,$medicamentos,$telefono){
    // the message
    $msg = '<html><head>
    <style>.correoreto {padding: 20px;background-color: whitesmoke;font-family: Arial, Helvetica, sans-serif;}
        .correoreto img {}
        h3 {padding: 10px;background-color: lavender;}
        p {color: brown;}
    </style>
    </head>
    <body><div class="correoreto">
        <h1>RETO URBANO 2024</h1>
        <h2>El mismo de ayer, hoy y siempre<h2>
        <h3>Hola '.$nick.', te has registrado correctamente a Reto Urbano 2024</h3>
        <p>Con los siguientes datos:</p>
        <table class="tabla">        
            <tr><td>Nombre</td><td> '.$nombre.'</td></tr>
            <tr><td>Gafete</td><td> '.$nick.'</td></tr>
            <tr><td>Fecha de Nac</td><td>'.$fechanac.'</td></tr>
            <tr><td>Edad</td><td>'.$edad.'</td></tr>
            <tr><td>Sexo</td><td>'.$sexo.'</td></tr>
            <tr><td>Talla</td><td>'.$talla.'</td></tr>
            <tr><td>Vienes de</td><td>'.$vienesDe.'</td></tr>
            <tr><td>Alergias</td><td>'.$alergias.'</td></tr>
            <tr><td>Razón de asistir a RU</td><td>'.$razones.'</td></tr>
            <tr><td>Iglesia</td><td>'.$iglesia.'</td></tr>
            <tr><td>email</td><td>'.$email.'</td></tr>
            <tr><td>Whatsapp</td><td>'.$whatsapp.'</td></tr>
            <tr><td>Teléfono</td><td>'.$telefono.'</td></tr>
            <tr><td>Facebook</td><td>'.$facebook.'</td></tr>
            <tr><td>Instagram</td><td>'.$instagram.'</td></tr>
            <tr><td>Medicamentos</td><td>'.$medicamentos.'</td></tr>
            <tr><td>Tutor</td><td>'.$tutorNombre.'</td></tr>
            <tr><td>Contacto Tutor</td><td>'.$tutorTelefono.'</td></tr>
        </table>
        <p>Tus datos quedan resguardados para su uso en la log&iacute;stica del campamento.<br>
            tambi&eacute;n estaremos orando por ti.</p>

        <p>Es importante que hagas tu dep&oacute;sito:</p>
        <h2>Informaci&oacute;n de pago</h2>
        <ul>
            <li>
                <p><b>Banco Azteca</b>
                <br><b>4027 6658 5482 3326</b>
                <br><b>Rebeca Castro Zamudio</b></p>
            </li>
            <li>
                El costo del campamento es de $2,300 MXN o $180 USD para extranjeros
            </li>
            <li>
                Puedes hacer un dep&oacute;sito mínimo de $1000 (no reembolsable) para apartar tu lugar...<br>
                y pagar el resto por medio de mas dep&oacute;sitos o hasta el día del campamento.
            </li>
            <li>
                Puedes hacer el pago total del campamento.
            </li>
            <li>
                El costo del campamento incluye: Hospedaje, alimentaci&oacute;n, playera, materiales para
                ministerio y más.
            </li>
            <li>
                El dep&oacute;sito lo puedes hacer en alguna sucursal de Banco Azteca o por transferencia bancaria.
            </li>
            Una vez realizado tu pago, Es importante que nos notifiques tus dep&oacute;sitos en
                <b>reto&#64;ywampachuca.org</b> o al los whatsapps <b>5615220124</b> y/o <b>2212139818</b> enviando tus fichas de depósito y el nombre de la persona inscrita.
                Puedes notificar igualemente por el chat de la p&aacute;gina de <a
                    href="https://www.facebook.com/Retourbanojucumpachuca/">Reto Urbano</a>
            </li>
        </ul><p>Atentamente: Staff de #RUX</p></div></body></html>';    


        $headers = "From: reto@ywampachuca.org\r\n";    
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";


    mail($email,"Registro",$msg,$headers);
  
}

function recorrerArray($array){
    $cadena = "";
    $ant=1;
    $cadena = '<div id="deals">';
    foreach ($array as $value){ 
        $cadena .= ($value['paquete']!=$ant?'</div><div id="deals">':'').'<div class="sale-item">
                        <div class="header">'.$value['valor'].'</div>
                        <div class="body">'.$value['count'].'</div>
                    </div>';
        $ant = $value['paquete'];
    }
    $cadena .= '</div>';
    return $cadena; 
}

?>