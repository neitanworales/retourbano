<?php

/**
 * Datos short summary.
 *
 * Datos description.
 *
 * @version 1.0
 * @author Neitan
 */
class Datos
{
    public $bd;
    public $funRutas;
    static $_instance;
    var $pCaja;

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

    public function GuardarGuerrero($nombre,$edad,$talla,$vienede,$whats,$email,$razones,$sexo,$nick,$alergias,$fechanac)
    {
        $que="INSERT INTO guerreros(nombre,edad,talla,vienede,whatsapp,email,razones,staff,confima_pago,nomero_ticket,status,sexo,nick,alergias,fechanac) 
                VALUES('$nombre', TIMESTAMPDIFF(YEAR,STR_TO_DATE('$fechanac', '%d/%m/%Y'),CURDATE()),'$talla','$vienede','$whats','$email','$razones',0,0,'','A','$sexo','$nick','$alergias',STR_TO_DATE('$fechanac', '%d/%m/%Y'))";        
        return $this->bd->ejecutar($que);
    }

    public function RegistrarLlegada($id,$hab,$tall,$entr)
    {
        $que="INSERT INTO relaciones(guerrero_id,habitacion_id,entrenamiento_id,taller_id,playera,gafete) 
                VALUES('$id','$hab','$entr','$tall',0,0)";        
        if($this->bd->ejecutar($que)){
            $que="UPDATE guerreros SET status='I' WHERE id=$id";
            return $this->bd->ejecutar($que);
        }
    }

    public function ActualizarLlegada($id,$hab,$tall,$entr)
    {
        $que="UPDATE relaciones SET habitacion_id=$hab,entrenamiento_id=$entr,taller_id=$tall,playera=0,gafete=0 WHERE guerrero_id = $id";        
        if($this->bd->ejecutar($que)){
            $que="UPDATE guerreros SET status='I' WHERE id=$id";
            return $this->bd->ejecutar($que);
        }
    }

    public function ActualizarFinalizar($id,$gafete,$playera)
    {
        $que="UPDATE relaciones SET playera=$gafete,gafete=$playera WHERE guerrero_id = $id";        
        if($this->bd->ejecutar($que)){
            $que="UPDATE guerreros SET status='F' WHERE id=$id";
            return $this->bd->ejecutar($que);
        }
    }

    public function DarDeBaja($id){
        $que="UPDATE guerreros SET status='B' WHERE id=$id";
        return $this->bd->ejecutar($que);
    }

    public function CambiarStaff($id, $staff){
        $que="UPDATE guerreros SET staff=$staff WHERE id=$id";
        return $this->bd->ejecutar($que);
    }

    public function CambiarPago($id, $pago,$ticket,$cantidad){
        $que="UPDATE guerreros SET confima_pago=$pago,nomero_ticket='$ticket',cantidad=$cantidad WHERE id=$id";        
        return $this->bd->ejecutar($que);
    }

    public function getContadorTotal(){
        $que ="SELECT * FROM guerreros";
        $recurso = $this->bd->ObtenerConsulta($que);
        echo count($recurso);
    }

    public function getContadorGuerreros(){
        $que ="SELECT * FROM guerreros WHERE staff=0 and status='A'";
        $recurso = $this->bd->ObtenerConsulta($que);
        echo count($recurso);
    }

    public function getContadorStaff(){
        $que ="SELECT * FROM guerreros WHERE staff=1 and status='A'";
        $recurso = $this->bd->ObtenerConsulta($que);
        echo count($recurso);
    }

    public function getContadorBajas(){
        $que ="SELECT * FROM guerreros WHERE status='B'";
        $recurso = $this->bd->ObtenerConsulta($que);
        echo count($recurso);
    }

    public function getTablaGuerreros(){
        $que ="SELECT guerreros.*,ORD(staff) AS staff2, ORD(confima_pago) AS confima_pago2, R.habitacion_id habitacion FROM guerreros 
        LEFT JOIN relaciones R ON guerreros.id = R.guerrero_id
        WHERE staff=0 and status='A'";

        $this->ArrayToJson($this->manipularArray($this->bd->ObtenerConsulta($que)));
    }

    public function getTablaStaff(){
        $que ="SELECT guerreros.*,ORD(staff) AS staff2, ORD(confima_pago) AS confima_pago2, R.habitacion_id habitacion  FROM guerreros 
        LEFT JOIN relaciones R ON guerreros.id = R.guerrero_id
        WHERE staff=1 and status='A';";
        $this->ArrayToJson($this->manipularArray($this->bd->ObtenerConsulta($que)));
    }

    public function getTablaBajas(){
        $que ="SELECT guerreros.*,ORD(staff) AS staff2, ORD(confima_pago) AS confima_pago2, R.habitacion_id habitacion  FROM guerreros 
        LEFT JOIN relaciones R ON guerreros.id = R.guerrero_id
        WHERE status='B';";
        $this->ArrayToJson($this->manipularArray($this->bd->ObtenerConsulta($que)));
    }

    private function ArrayToJson ($array){                
        echo json_encode(array('resultado' => $array));
    }        

    public function getContadorSexo(){
        $que ="SELECT sexo,COUNT(*) count FROM guerreros WHERE status<>'B' GROUP BY sexo;";
        $this->ArrayToJson($this->bd->ObtenerConsulta($que));        
    }    
    
    public function getContadorStaffJ(){
        $que ="SELECT CASE WHEN staff=1 THEN 'STAFF' ELSE 'GUERREROS' END ,COUNT(*) count FROM guerreros WHERE status<>'B' GROUP BY staff;";
        $this->ArrayToJson($this->bd->ObtenerConsulta($que));
    }    

    public function getTallas(){
        $qury = "SELECT talla,COUNT(*) count FROM guerreros WHERE status<>'B' GROUP BY talla";
        $this->ArrayToJson($this->bd->ObtenerConsulta($qury));
    }

    public function getInscritosPorSexoStaff(){
        $qury = "SELECT sexo,CASE WHEN staff=1 THEN 'STAFF' ELSE 'GUERREROS' END,COUNT(*) count FROM guerreros WHERE status<>'B' GROUP BY sexo,staff;";
        $this->ArrayToJson($this->bd->ObtenerConsulta($qury));
    }

    public function getFinanzas(){
        $qury = "SELECT 'Recaudado' as concepto,SUM(cantidad) as cantidad FROM guerreros WHERE status IN ('A','I') and confima_pago = 1";
        $array = $this->bd->ObtenerConsulta($qury);
        foreach($array as $ele){
            
            echo '<div class="col-lg-2 col-md-6">
                        <div class="panel panel-success">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-xs-12">
                                        <i class="glyphicon glyphicon-usd"></i>
                                    </div>
                                    <div class="col-xs-9 text-right">
                                        <div class="huge">'.$ele['cantidad'].'</div>
                                        <div><h3>'.$ele['concepto'].'</h3></div>
                                    </div>
                                </div>
                            </div>                            
                        </div>
                    </div>';

        }
    }

    public function manipularArray($array)
    {
        $output = array();
        $c=1;
        foreach($array as $ele){
            $ele['id_c']=$c++;
            $ele['staff']=$this->obtenerBottonStaff($ele['id'],$ele['staff2']);
            $ele['confima_pago']=$this->obtenerBottonConfirmaPago($ele['id'],$ele['confima_pago2'],$ele['cantidad'],$ele['nomero_ticket']);
            $ele['nomero_ticket']='<input type="text" id="txtTicket_'.$ele['id'].'" value="'.$ele['nomero_ticket'].'">';
            $ele['confirma_ins']=$this->obtenerBottonConfirmaLlegada($ele['id'],$ele['habitacion']);
            $ele['btn_baja']=$this->obtenerBottonBaja($ele['id'],$ele['status']);
            array_push($output,$ele);
        }
        return $output;
    }    

    public function manipularArrayCats($array)
    {
        $output = array();
        $c=1;
        foreach($array as $ele){ 
            $ele['id_c']=$c++;           
            array_push($output,$ele);
        }
        return $output;
    }  

    public function manipularArrayIns($array)
    {
        $output = array();
        $c=1;
        foreach($array as $ele){ 
            $ele['id_c']=$c++;  
            $ele['btn_final']=$this->obtenerBottonFinalizar($ele['id']);         
            array_push($output,$ele);
        }
        return $output;
    }

    public function manipularArrayFinal($array)
    {
        $output = array();
        $c=1;
        foreach($array as $ele){ 
            $ele['id_c']=$c++;            
            array_push($output,$ele);
        }
        return $output;
    }

    public function obtenerBottonFinalizar($id)
    {                     
        $texto = 'Finalizar';
        $color = 'btn-danger';        
                
        return '<button type="button" class="btn '.$color.'" data-toggle="modal" data-target="#modalFinal"  onclick="cargarFinalizar(\''.$id.'\');" >'.$texto.'</button>';        
    }

    public function obtenerBottonStaff($id,$staff)
    {             
        $metodo='HacerCampero';
        $texto = 'Camp';
        
        if($staff=='0')
        {
            $metodo='HacerStaff';
            $texto = 'Staff';       
        }

        return '<button type="button" class="btn btn-info" onclick="'.$metodo.'('.$id.');">'.$texto.'</button>';        
    }

    public function obtenerBottonConfirmaPago($id,$staff, $cantidad, $ticket)
    {                     
        $texto = 'Cambios al pago';
        $color = 'btn-info';

        if($staff==0){
            $texto = 'Confirmar Pago';            
        }
        else{
            $color='btn-success';
        }

                
        return '<button type="button" class="btn '.$color.'" data-toggle="modal" data-target="#modalPago" onclick="cargarDatosConfirmacion(\''.$cantidad.'\',\''.$ticket.'\',\''.$id.'\');" >'.$texto.'</button>';        
    }

    public function obtenerBottonBaja($id,$status){
        $texto = 'Dar de baja';
        $color = 'btn-danger';
        $metodo = 'DeleteGuerrero(\''.$id.'\');';
        
        if($status=='B'){
            $texto = 'Dar de alta';
            $color = 'btn-success';
            $metodo = 'ActivarGuerrero(\''.$id.'\');';
        }

        return '<button type="button" class="btn '.$color.'" onclick="'.$metodo.'" >'.$texto.'</button>';        
    }

    public function obtenerBottonConfirmaLlegada($id,$abita)
    {                     
        $texto = 'Confirmar Llegada';
        $color = 'btn-warning';        
                
        return '<button type="button" class="btn '.$color.'" data-toggle="modal" data-target="#modalLlegada" onclick="cargarDatosLlegada(\''.$id.'\',\''.$abita.'\');" >'.$texto.'</button>';        
    }

    public function obtenerHabitacion(){
        $qury = "SELECT id_habitacion VALUE,CONCAT(num_habitacion,' (',(SELECT COUNT(*) FROM relaciones R WHERE R.habitacion_id=H.id_habitacion),')',' - ',G.nombre,' - ',descripcion) TEXT FROM habitaciones H
                INNER JOIN guerreros G ON H.leader=G.id";
        $array = $this->bd->ObtenerConsulta($qury);
        echo '<option value="0">Selecciona Habitación</option>';
        foreach($array as $ele){
            echo '<option value="'.$ele['VALUE'].'">'.$ele['TEXT'].'</option>';
        }
    }

    public function obtenerEntrenamiento(){
        $qury = "SELECT id_entrenamiento VALUE,CONCAT(`descripcion`,' - ',H.leader,' - (',(SELECT COUNT(*) FROM relaciones R WHERE R.entrenamiento_id=H.id_entrenamiento),')') TEXT FROM entrenamientos H";
        $array = $this->bd->ObtenerConsulta($qury);
        echo '<option value="0">Selecciona Entrenamiento</option>';
        foreach($array as $ele){
            echo '<option value="'.$ele['VALUE'].'">'.$ele['TEXT'].'</option>';
        }
    }

    public function obtenerTaller(){
        $qury = "SELECT id_taller VALUE,CONCAT(`descripcion`,' - ',H.leader,' - (',(SELECT COUNT(*) FROM relaciones R WHERE R.taller_id=H.id_taller),')') TEXT FROM talleres H";
        $array = $this->bd->ObtenerConsulta($qury);
        echo '<option value="0">Selecciona Taller</option>';
        foreach($array as $ele){
            echo '<option value="'.$ele['VALUE'].'">'.$ele['TEXT'].'</option>';
        }
    }

    public function obtenerTablaHabitaciones(){
        $que ="SELECT *,(SELECT COUNT(*) FROM relaciones R WHERE R.habitacion_id=h.id_habitacion) registrados FROM habitaciones h";
        $this->ArrayToJson($this->manipularArrayCats($this->bd->ObtenerConsulta($que)));
    }
    
    public function obtenerTablaTalleres(){
        $que ="SELECT *,(SELECT COUNT(*) FROM relaciones R WHERE R.taller_id=t.id_taller) registrados FROM talleres t";
        $this->ArrayToJson($this->manipularArrayCats($this->bd->ObtenerConsulta($que)));
    }

    public function obtenerTablaEntrenamientos(){
        $que ="SELECT *, (SELECT COUNT(*) FROM relaciones R WHERE R.entrenamiento_id=e.id_entrenamiento) registrados FROM entrenamientos e";
        $this->ArrayToJson($this->manipularArrayCats($this->bd->ObtenerConsulta($que)));
    }

    public function obtenerTablaInscritos(){
        $que ="SELECT G.id, G.nombre, G.talla, G.status, R.gafete, R.playera, G2.nombre lider FROM guerreros G
                INNER JOIN relaciones R ON G.id = R.guerrero_id
                INNER JOIN habitaciones H ON H.id_habitacion = R.habitacion_id 
                INNER JOIN guerreros G2 ON G2.id = H.leader
                WHERE G.status = 'I'";
        $this->ArrayToJson($this->manipularArrayIns($this->bd->ObtenerConsulta($que)));
    }

    public function obtenerTablaBajas(){
        $que ="SELECT * FROM guerreros G                
                WHERE G.status = 'B'";
        $this->ArrayToJson($this->manipularArrayIns($this->bd->ObtenerConsulta($que)));
    }

    public function obtenerFinalizados(){
        $que = "SELECT G.id, G.nombre, G.talla, G.status, R.gafete, R.playera, G2.nombre lider, H.num_habitacion habitacion,T.descripcion taller, E.descripcion entrenamiento FROM guerreros G
                INNER JOIN relaciones R ON G.id = R.guerrero_id
                INNER JOIN habitaciones H ON H.id_habitacion = R.habitacion_id 
                INNER JOIN guerreros G2 ON G2.id = H.leader
                INNER JOIN entrenamientos E ON E.id_entrenamiento = R.entrenamiento_id
                INNER JOIN talleres T ON T.id_taller = R.taller_id
                WHERE G.status = 'F'";
        $this->ArrayToJson($this->manipularArrayFinal($this->bd->ObtenerConsulta($que)));
    }

    public function verificarRelacion($id){
        $que ="SELECT * FROM relaciones WHERE guerrero_id=$id";
        $array = $this->bd->ObtenerConsulta($que);
        if(count($array)>=1){
            return true;
        }else{
            return false;
        }
        

    }

    public function verificarSession($usr,$pwd){
        $que ="SELECT * FROM RETO_GUERREROS WHERE email='$usr' AND password='$pwd'";
        $array = $this->bd->ObtenerConsulta($que);
        if(count($array)>=1){
            session_start();
            $_SESSION['nombre'] = $array[0]['nombre'];
            $_SESSION['apellidos'] = $array[0]['apellidos'];
            $_SESSION['id'] = $array[0]['id_estudiante'];
            $_SESSION['staff'] = $array[0]['staff'];
            return true;
        }else{
            return false;
        }
    }

    public function obtenerConfirmacion($dia){
        session_start();
        $s = "";
        $v = "";
        $n = "";

        $que ="SELECT * FROM RETO_ASISTENCIA A 
        INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
        WHERE estudiante_id = ".$_SESSION['id']." AND S.activo = 1";
        $array = $this->bd->ObtenerConsulta($que);
        if(count($array)>=1){
            if($dia!="0"){
                if($dia!=$array[0]['dia_llegada']){
                    $que = "UPDATE RETO_ASISTENCIA A 
                    INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
                    SET dia_llegada='$dia' 
                    WHERE estudiante_id = ".$_SESSION['id']." AND S.activo = 1";
                    $this->bd->ejecutar($que); 
                }
            }
            else{            
                $dia=$array[0]['dia_llegada'];
            }
            
        }else{
            if($dia!="0"){
                $que="INSERT INTO RETO_ASISTENCIA(seguimiento_id,estudiante_id,confirmacion,dia_llegada,registro)
                      SELECT id_seguimiento,".$_SESSION['id'].",0,'$dia',now() FROM RETO_SEGUIMIENTO WHERE activo = 1";
                $this->bd->ejecutar($que);                
            }
        }
                
        if($dia=='v'){
            $v = "btn-success";
            $s = "";
            $n = "";
        }else if($dia=='s'){
            $s = "btn-success";
            $v = "";
            $n = "";
        }else if($dia=='n'){
            $n = "btn-danger";
            $v = "";
            $s = "";
        }

        echo '<button type="button" class="btn '.$v.'" onclick="confirmarViernes();">Viernes</button>
        <button type="button" class="btn '.$s.'" onclick="confirmarSabado();">Sábado</button>
        <button type="button" class="btn '.$n.'" onclick="confirmarFalta();">:( No asistiré</button>';
    }

    public function obtenerAsignado(){
        session_start();
        $que ="SELECT * FROM RETO_INTERCAMBIO I
        INNER JOIN RETO_GUERREROS G ON I.a=G.id_estudiante
        WHERE de = ".$_SESSION['id'].";";
        $array = $this->bd->ObtenerConsulta($que);
        if(count($array)>=1){
            echo '<h2>'.$array[0]['nombre']." ".$array[0]['apellidos'].'</h2>';
        }else{
            echo '<button type="button" class="btn btn-info" onclick="sortear();">Naiden aún (click para sortear)</button>';
        }
    }

    public function sortearIntercambio(){
        session_start();
        $que ="SELECT * FROM RETO_GUERREROS G
        LEFT JOIN RETO_INTERCAMBIO I ON G.id_estudiante=I.a
        WHERE G.id_estudiante <> ".$_SESSION['id']." AND a IS NULL AND G.activo=1;";
        $array2 = $this->bd->ObtenerConsulta($que);
        
        $tamano = count($array2);
        $select = rand ( 0 , $tamano-1 );

        $que="INSERT INTO RETO_INTERCAMBIO(de,a) VALUES  (".$_SESSION['id'].",".$array2[$select]['id_estudiante'].")";
        $this->bd->ejecutar($que);
        echo '<h2>'.$array2[$select]['nombre']." ".$array2[$select]['apellidos'].'</h2>';
    }

    public function getAsistencia(){        
        $que = "SELECT CONCAT(nombre,' ',apellidos) nombre, VA.dia_llegada, G.telefono, G.telefono_tutor FROM VISTA_ASISTENCIA_ACTIVA VA
        RIGHT JOIN RETO_GUERREROS G ON G.id_estudiante=VA.estudiante_id
        ORDER BY staff";
        $this->ArrayToJson($this->manipularArrayReto($this->bd->ObtenerConsulta($que)));        
    }

    public function getIntercambio(){
        $que = "SELECT CONCAT(G.nombre,' ',G.apellidos) de, CONCAT(G2.nombre,' ',G2.apellidos) a FROM RETO_GUERREROS G
                LEFT JOIN RETO_INTERCAMBIO I ON I.de=G.id_estudiante
                LEFT JOIN RETO_GUERREROS G2 ON G2.id_estudiante=I.a WHERE G.activo=1
                ORDER BY G.nombre";
        $this->ArrayToJson($this->manipularArrayIntercambio($this->bd->ObtenerConsulta($que)));
    }

    public function manipularArrayIntercambio($array)
    {
        $output = array();
        $c=1;
        foreach($array as $ele){
            $ele['id_c']=$c++;
            //$ele['a'] = $ele['a']!=''?'YA':'FALTA';
            array_push($output,$ele);
        }
        return $output;
    }

    public function manipularArrayReto($array)
    {
        $output = array();
        $c=1;
        foreach($array as $ele){
            $ele['id_c']=$c++;
            $ele['dia_llegada']=$this->obtenerBtnsDias($ele['dia_llegada']);        
            array_push($output,$ele);
        }
        return $output;
    }

    private function obtenerBtnsDias($dia){
        $color = 'default';
        $string = "";
        if($dia=='v'){
            $color = 'success';
            $string = "VIERNES";
        }else if($dia=='s'){
            $color = 'warning';
            $string = "SÁBADO";
        }else if($dia=='n'){
            $color = 'danger';
            $string = "NO VIENE";
        }            
        return "<button type=\"button\" class=\"btn btn-$color\">$string</button>";
    }

    public function cambiarPasword($pwd){
        session_start();
        $que="UPDATE RETO_GUERREROS SET password='$pwd' WHERE id_estudiante=".$_SESSION['id'];
        return $this->bd->ejecutar($que);
    }

    public function cambiarEmail($email){
        session_start();
        $que="UPDATE RETO_GUERREROS SET email='$email' WHERE id_estudiante=".$_SESSION['id'];
        return $this->bd->ejecutar($que);
    }

    public function cambiarAlias($alias){
        session_start();
        $que="UPDATE RETO_GUERREROS SET alias='$alias' WHERE id_estudiante=".$_SESSION['id'];
        return $this->bd->ejecutar($que);
    }

    public function cambiarStatusGuerrero($id,$tipo){
        $que="UPDATE guerreros SET status='$tipo' WHERE id=$id;";
        return $this->bd->ejecutar($que);
    }

    public function contarInscritos(){
        $que="SELECT COUNT(*) C, maximo_inscr M, maximo_inscr-COUNT(*) R, umbral U FROM guerreros, configuracion WHERE staff=0 AND status='A'";
        $this->ArrayToJson($this->bd->ObtenerConsulta($que));
    }
}