<?php
/**
 * Datos short summary.
 *
 * Datos description.
 *
 * @version 1.0
 * @author Neitan
 */
class HabitacionesDatos
{
    public $bd;    
    static $_instance;    

    /*La funci?n construct es privada para evitar que el objeto pueda ser creado mediante new*/
    private function __construct(){
        require 'Db.class.php';
        $this->bd=Db::getInstance(1);
    }

    /*Funci?n encargada de crear, si es necesario, el objeto. Esta es la funci?n que debemos llamar desde fuera de la clase para instanciar el objeto, y as?, poder utilizar sus m?todos*/
    public static function getInstance(){
        if (!(self::$_instance instanceof self)){
            self::$_instance=new self();
        }
        return self::$_instance;
    }

    /*Evitamos el clonaje del objeto. Patr?n Singleton*/
    private function __clone(){ }

    public function getHabitaciones(){
        $que="SELECT H.id_habitacion,H.num_habitacion,H.leader,H.descripcion,H.sexo,G.nombre FROM habitaciones H
                INNER JOIN guerreros G ON G.id=H.leader";
        $this->ArrayToJson($this->manipularArray($this->bd->ObtenerConsulta($que)));
    }

    public function addHabitacion($num,$leader,$descripcion,$sexo){
        $que="INSERT INTO habitaciones(num_habitacion,leader,descripcion,sexo)
                VALUES ('$num','$leader','$descripcion','$sexo');";
        return $this->bd->ejecutar($que);
    }

    public function manipularArray($array)
    {
        $output = array();
        $c=1;
        foreach($array as $ele){
            $ele['id_c']=$c++;
            //$ele['staff']=$this->obtenerBottonStaff($ele['id'],$ele['staff2']);
            //$ele['confima_pago']=$this->obtenerBottonConfirmaPago($ele['id'],$ele['confima_pago2'],$ele['cantidad'],$ele['nomero_ticket']);
            //$ele['nomero_ticket']='<input type="text" id="txtTicket_'.$ele['id'].'" value="'.$ele['nomero_ticket'].'">';
            //$ele['confirma_ins']=$this->obtenerBottonConfirmaLlegada($ele['id'],$ele['habitacion']);
            //$ele['btn_baja']=$this->obtenerBottonBaja($ele['id']);
            array_push($output,$ele);
        }
        return $output;
    }

    private function ArrayToJson($array){                
        echo json_encode(array('resultado' => $array));
    } 
}
?>