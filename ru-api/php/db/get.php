<?php
require '../../db/RetoDatos.class.php';
$rdatos=RetoDatos::getInstance();

$rdatos->getGuerreros();
?>