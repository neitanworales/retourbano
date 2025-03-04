<?php
require '../db/Datos.class.php';
$datos=Datos::getInstance();

echo $datos->contarInscritos();

?>