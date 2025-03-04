<?php
header('Content-Type: application/json; charset=utf-8');
require '../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();
session_start();

if(empty($_SESSION['staff'])){
    $data=(object)array();
    $data-> success = false;
    $data-> mensaje = "No tienes permiso";
    echo json_encode($data);
}else{
    if($_SESSION['staff']==1){
        echo json_encode($rdatos->getGuerrerosSecure());
    }else{
        $data=(object)array();
        $data-> success = false;
        $data-> mensaje = "No tienes permiso";
        echo json_encode($data);
    }
}
?>