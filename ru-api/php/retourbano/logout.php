<?php    
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');

require './RetoUrbanoDao.class.php';
$datos=RetoUrbanoDao::getInstance();

$id = $_REQUEST['id'];

$respuesta = $datos->deleteToken($id);

if($respuesta){
    $array["success"]=true;
    echo json_encode($array);
}else{
    $array["success"]=false;
    echo json_encode($array);
}


?>