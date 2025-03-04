<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST');
header("Expires: Tue, 03 Jul 2001 06:00:00 GMT");
header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

require './RetoUrbanoDao.class.php';
$datos=RetoUrbanoDao::getInstance();

$usr = $_REQUEST['username'];
$pwd = $_REQUEST['password'];

if($datos->verificarSession($usr,$pwd)){
    $array["session"]=$_SESSION;
    $array["code"]=200;
    $array["success"]=true;
    echo json_encode($array);
}else{
    http_response_code(401); 
    $array["code"]=401;
    $array["message"]='Not authorized';
    $array["success"]=false;
    echo json_encode($array);
}

?>