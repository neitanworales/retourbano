<?php
require '../db/RUDatos.class.php';
$datos=RUDatos::getInstance();

$correcto = true;

$correcto = !empty($_REQUEST['nombre']);
$correcto = !empty($_REQUEST['nick']);
$correcto = !empty($_REQUEST['fechanac']);
$correcto = !empty($_REQUEST['edad']);
$correcto = !empty($_REQUEST['sexo']);
$correcto = !empty($_REQUEST['talla']);
$correcto = !empty($_REQUEST['vienede']);
$correcto = !empty($_REQUEST['whatsapp']);
$correcto = !empty($_REQUEST['email']);
$correcto = !empty($_REQUEST['alergias']);
$correcto = !empty($_REQUEST['razone']);
$correcto = !empty($_REQUEST['tutor']);
$correcto = !empty($_REQUEST['iglesia']);

if($correcto){

    $nombre=$_REQUEST['nombre'];
    $nick=$_REQUEST['nick'];
    $fechanac=$_REQUEST['fechanac'];
    $edad=$_REQUEST['edad'];
    $sexo=$_REQUEST['sexo'];
    $talla=$_REQUEST['talla'];
    $vienede=$_REQUEST['vienede'];
    $whatsapp=$_REQUEST['whatsapp'];
    $email=$_REQUEST['email'];
    $alergias=$_REQUEST['alergias'];
    $razone=$_REQUEST['razone'];
    $tutor = $_REQUEST['tutor'];
    $iglesia = $_REQUEST['iglesia'];

    if($datos->guardarGuerrero($nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienede,$whatsapp,$email,$alergias,$razone,$tutor,$iglesia)){
        echo '{ "error": 0 , "mensaje" : "Hola '.$nombre.', Tu registro fue realizado de manera correcta." }#';
        enviarEmail($nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienede,$whatsapp,$email,$alergias,$razone,$tutor,$iglesia);        
    }else{
        echo '{ "error": 1 , "mensaje" : "Error al guardar" }#';
    }
}else{
    echo '{ "error": 1 , "mensaje" : "Hay datos en blanco, no se puede guardar" }#';
}


function enviarEmail($nombre,$nick,$fechanac,$edad,$sexo,$talla,$vienede,$whatsapp,$email,$alergias,$razone,$tutor,$iglesia){
    // the message
    $msg = '<style>.correoreto {padding: 20px;background-color: whitesmoke;font-family: Arial, Helvetica, sans-serif;}
        .correoreto img {width: 100%;height: 100%;display: block;margin-left: auto;margin-right: auto;}
        h3 {padding: 10px;background-color: lavender;}
        p {color: brown;}
    </style>
    <div class="correoreto">
        <img src="http://ywampachuca.org/retourbano/images/retox/titulo.png">
        <h3>Hola '.$nick.', te has registrado correctamente a Reto Urbano X</h3>
        <p>con los siguientes datos:</p>
        <table class="tabla">        
            <tr><td>Nombre</td><td>'.$nombre.'</td></tr>
            <tr><td>Nick</td><td>'.$nick.'</td></tr>
            <tr><td>Fecha de Nacimiento</td><td>'.$fechanac.'</td></tr>
            <tr><td>Edad</td><td>'.$edad.'</td></tr>
            <tr><td>Sexo</td><td>'.$sexo.'</td></tr>
            <tr><td>Talla</td><td>'.$talla.'</td></tr>
            <tr><td>Vienes de</td><td>'.$vienede.'</td></tr>
            <tr><td>Iglesia</td><td>'.$iglesia.'</td></tr>
            <tr><td>Whatsapp</td><td>'.$whatsapp.'</td></tr>
            <tr><td>Tutor</td><td>'.$tutor.'</td></tr>
            <tr><td>Correo electr&oacute;nico</td><td>'.$email.'</td></tr>
            <tr><td>Alergias</td><td>'.$alergias.'</td></tr>
            <tr><td>Razones</td><td>'.$razone.'</td></tr>
        </table>
        <p>Tus datos quedan resguardados para su uso en la log&iacute;stica del campamento.<br>
            tambi&eacute;n estaremos orando por ti.</p>

        <p>Es importante que hagas tu dep&oacute;sito:</p>
        <h2>Informaci&oacute;n de pago</h2>
        <ul>
            <li>
                <p><b>BANAMEX</b>
                    <br><b>5204 1655 0400 9196</b>
                    <br><b>LINETTE YAZMIN ROLD&Aacute;N MART&Iacute;NEZ</b></p>
            </li>
            <li>
                Puedes hacer un dep&oacute;sito mínimo de $400 (no reembolsable) para apartar tu lugar...<br>
                y pagar el resto por medio de mas dep&oacute;sitos o hasta el día del campamento.
            </li>
            <li>
                Puedes hacer el pago total del campamento.
            </li>
            <li>
                El costo del campamento incluye: Hospedaje, alimentaci&oacute;n, transporte, playera, materiales para
                ministerio y más.
            </li>
            <li>
                El dep&oacute;sito lo puedes hacer en el Banco (Banamex) o en OXXO (Cobra comisi&oacute;n de 10 pesos
                extra).
            </li>
            <li>
                Es importante que nos notifiques tus dep&oacute;sitos en reto@ywampachuca.org
            </li>
            <li>
                Puedes notificar igualemente por el chat de la p&aacute;gina de <a
                    href="https://www.facebook.com/Retourbanojucumpachuca/">Reto Urbano</a>
            </li>
        </ul><p>Atentamente: Staff de #RUX</p></div>';

    // send email
    mail($email,"RETO URBANO",$msg);

    $datos2=RUDatos::getInstance();
    $texto = $datos2->obtenerConfiguracionText();
    
    $msg.="\n\n\n".$texto;

    mail("reto@ywampachuca.org","Nuevo Registro",$msg);    
}
?>