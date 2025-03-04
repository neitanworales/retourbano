<?php
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');

require './RetoUrbanoDao.class.php';
$datos=RetoUrbanoDao::getInstance();


if(empty($_REQUEST["idguerrero"])){
    echo '{ "error": 1 , "mensaje" : "Falta idguerrero param" }';
    return;
}

$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

$id_guerrero = $_REQUEST["idguerrero"];

$busqueda = $datos->getGuerreroById($id_guerrero);

if(empty($busqueda)){
    echo '{ "error": 1 , "mensaje" : "guerrero no encontrado" }';
    return;
}

$idpago = !empty($_REQUEST['idpago'])?$_REQUEST['idpago']:null;
$divisa = !empty($input['divisa'])?$input['divisa']:null;
$descripcion = !empty($input['descripcion'])?$input['descripcion']:null;
$cantidad = !empty($input['cantidad'])?$input['cantidad']:null;
$no_ticket = !empty($input['no_ticket'])?$input['no_ticket']:null;
$idcg = $busqueda[0]["id_campamento_guerrero"];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
    if($datos->guardarPago($idcg,$cantidad,$descripcion,$divisa,$no_ticket)){
        echo '{ "error": 0 , "mensaje" : "Guardado correctamente" }';
    }else{
        echo '{ "error": 1 , "mensaje" : "Error al guardar", "idgc":"'.$idcg.'", "cantidad":"'.$cantidad.'", "idgc":"'.$idcg.'" }';
    }

}else if ($_SERVER['REQUEST_METHOD'] == 'PUT') {

    if(empty($idpago)){
        echo '{ "error": 1 , "mensaje" : "id_pago es necesario" }';
    }

    if($datos->actualizarPago($idpago,$cantidad,$descripcion,$divisa,$no_ticket)){
        echo '{ "error": 0 , "mensaje" : "Guardado correctamente" }';
    }else{
        echo '{ "error": 1 , "mensaje" : "Error al guardar" }';
    }

}else if ($_SERVER['REQUEST_METHOD'] == 'DELETE') {

    if(empty($idpago)){
        echo '{ "error": 1 , "mensaje" : "id_pago es necesario" }';
    }

    if($datos->borrarPago($idpago)){
        echo '{ "error": 0 , "mensaje" : "Guardado correctamente" }';
    }else{
        echo '{ "error": 1 , "mensaje" : "Error al guardar" }';
    }

}
else{
    echo '{ "error": 1 , "mensaje" : "Método Incorrecto, requiere POST, PUT O DELETE" }';
    return;
}

?>