<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');
require '../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();

$usr = $_REQUEST['username'];
$pwd = $_REQUEST['password'];

if($rdatos->verificarSession($usr,$pwd)){
    $array["session"]=$_SESSION;
    //$array["resultado"] = $rdatos->getGuerreroByEmail($usr);
    $array["code"]=200;
    $array["success"]=true;
    echo json_encode($array);
}else{
    $array["code"]=401;
    $array["success"]=false;
    echo json_encode($array);
}

?>