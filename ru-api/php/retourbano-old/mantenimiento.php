<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json');
 
require '../db/RUDatos.class.php';
$datos=RUDatos::getInstance();

$opcion = $_REQUEST['opcion'];

switch($opcion){
    case 1:
        $status = $_REQUEST['status'];
        $staff = $_REQUEST['staff']==2?"T":$_REQUEST['staff'];        
        $datos->consultaGuerreros($status,$staff);
        break;
    case 2:
        $status = empty($_REQUEST['status'])?"Z":$_REQUEST['status'];
        $id = empty($_REQUEST['id'])?"0":$_REQUEST['id'];
        if($id==0){
            echo 'error de id';            
        }
        if($status=='Z'){
            echo 'error de valor de status';            
        }
        $datos->changeStatus($id,$status);
        break;
    case 3:
        $staff = $_REQUEST['staff'];
        $id = empty($_REQUEST['id'])?"0":$_REQUEST['id'];
        if($id==0){
            echo '{"error":1,"mensaje":"error de id", "query":""}';            
        }else if($staff<>'1' && $staff<>'0'){
            echo '{"error":1,"mensaje":"error de valor de staff : '.$staff.'", "query":""}';            
        }else{
            $datos->changeStaff($id,$staff);
        }
        break;
    case 4:        
        $datos->getIndicadores();
        break;
    case 5:        
        $cantidad = empty($_REQUEST['cantidad'])?"0":$_REQUEST['cantidad'];
        $descripcion = empty($_REQUEST['descripcion'])?"":$_REQUEST['descripcion'];
        $id_guerrero = empty($_REQUEST['id_guerrero'])?"0":$_REQUEST['id_guerrero'];
        $divisa = empty($_REQUEST['divisa'])?"":$_REQUEST['divisa'];
        if($cantidad==0){
            echo '{"error":1,"mensaje":"error de cantidad '.$cantidad.'", "query":""}';            
        }if($descripcion==""){
            echo '{"error":1,"mensaje":"error de descripcion '.$descripcion.'", "query":""}';            
        }if($id_guerrero==0){
            echo '{"error":1,"mensaje":"error de id_guerrero '.$id_guerrero.'", "query":""}';            
        }if($divisa==""){
            echo '{"error":1,"mensaje":"error de divisa '.$divisa.'", "query":""}';          
        }else{
            $datos->guardarPago($cantidad,$descripcion,$id_guerrero,$divisa);
        }
        break;
    case 6:
            $datos->obtenerPagos();
        break;
    default:
        echo "ninguna opcion seleccionada";
        break;
}

?>