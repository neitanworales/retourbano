<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');
 
require './RetoUrbanoDao.class.php';
$datos=RetoUrbanoDao::getInstance();

$arrayResponse['resultado']=$datos->getAsistenciasReto();

$number=1;
foreach ($arrayResponse['resultado'] as &$valor)
{
    $valor["numero"]=$number++;
    $valor["confirmacion"]= $valor["confirmacion"]=="1";
}

echo json_encode($arrayResponse);

?>