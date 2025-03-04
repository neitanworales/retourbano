<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');

require './RetoUrbanoDao.class.php';
$datos=RetoUrbanoDao::getInstance();

$hora = $_REQUEST['hora'];
$id=$_REQUEST["id"];
if($datos->obtenerConfirmacionHora($hora,$id)){
    $response["error"]=false;
    $response["mensaje"]="Confirmado correctamente";
    echo json_encode($response);
}else{
    $response["error"]=true;
    $response["mensaje"]="Error al confirmar";
    echo json_encode($response);
}

?>