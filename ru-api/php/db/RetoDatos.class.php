<?php

/**
 * Datos short summary.
 *
 * Datos description.
 *
 * @version 1.0
 * @author Neitan
 */
class RetoDatos
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

    private function ArrayToJson ($array){                
        echo json_encode(array('resultado' => $array));
    }

    private function ArrayToJsonGuerrero ($array){                
        echo json_encode(array('usuarios' => $array));
    }   

    public function verificarSession($usr,$pwd){
        $que ="SELECT *,'' entra FROM guerreros WHERE email='$usr' AND password='$pwd'";        
        $array = $this->bd->ObtenerConsulta($que);        
        if(!empty($array)){
            $array[0]['entra'] = true;
            session_start();            
            $_SESSION['nombre'] = $array[0]['nombre'];
            $_SESSION['id'] = $array[0]['id'];
            $_SESSION['staff'] = $array[0]['staff'];
            $_SESSION['email'] = $array[0]['email'];
            $_SESSION['token'] = $this->crearToken();
            $this->saveToken($array[0]['id'],$_SESSION['token']);
            return true;           
        }else{
            return false;
        }
    }

    public function getGuerreros(){
        $que = "SELECT * FROM RETO_GUERREROS ORDER BY staff";
        $this->ArrayToJsonGuerrero($this->bd->ObtenerConsulta($que));        
    }

    public function getAsistencia(){        
        $que = "SELECT CONCAT(nombre,' ',apellidos) nombre, VA.dia_llegada FROM VISTA_ASISTENCIA_ACTIVA VA
		RIGHT JOIN RETO_GUERREROS G ON G.id_estudiante=VA.estudiante_id
		ORDER BY staff";
        $this->ArrayToJson($this->bd->ObtenerConsulta($que));        
    }

    public function obtenerConfirmacion($dia,$id){
        session_start();

        $que ="SELECT * FROM RETO_ASISTENCIA A 
        INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
        WHERE estudiante_id = ".$id." AND S.activo = 1";
        $array = $this->bd->ObtenerConsulta($que);
        if(!empty($array)){
            if($dia!="0"){
                if($dia!=$array[0]['dia_llegada']){
                    $que = "UPDATE RETO_ASISTENCIA A 
                    INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
                    SET dia_llegada='$dia', hora_llegada=null 
                    WHERE estudiante_id = ".$id." AND S.activo = 1";
                    $this->bd->ejecutar($que); 
                }
            }
            else{            
                $dia=$array[0]['dia_llegada'];
            }
            
        }else{
            if($dia!="0"){
                $que="INSERT INTO RETO_ASISTENCIA(seguimiento_id,estudiante_id,confirmacion,dia_llegada,registro)
                      SELECT id_seguimiento,".$id.",0,'$dia',now() FROM RETO_SEGUIMIENTO WHERE activo = 1";
                $this->bd->ejecutar($que);                
            }
        }
    }

    public function obtenerConfirmacionHora($hora,$id){
        session_start();

        $que ="SELECT * FROM RETO_ASISTENCIA A 
        INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
        WHERE estudiante_id = ".$id." AND S.activo = 1";
        $array = $this->bd->ObtenerConsulta($que);
        if(!empty($array)){
            $que = "UPDATE RETO_ASISTENCIA A 
            INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
            SET hora_llegada='$hora' 
            WHERE estudiante_id = ".$id." AND S.activo = 1";
            $this->bd->ejecutar($que); 
        }
    }

    public function getSeguimientoActivo(){
        $que = 'SELECT * ,
        CONCAT(DATE_FORMAT(fecha_inicio,"%d"), ", ",
        DATE_FORMAT(DATE_ADD(fecha_inicio,INTERVAL 1 DAY),"%d")," y ",
        DATE_FORMAT(DATE_ADD(fecha_inicio,INTERVAL 2 DAY),"%d")," ", texto_fecha) texto
        FROM 
        RETO_SEGUIMIENTO 
        WHERE 
        ACTIVO=1';
        $this->ArrayToJson($this->bd->ObtenerConsulta($que));
    }

    public function getCumpleanos(){
        $que = 'SELECT nombre NOMBRE, DATE_FORMAT(fecha_nac,"%m %d") FECHA, TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE()) EDAD
        FROM RETO_GUERREROS
        WHERE activo = 1
        ORDER BY DATE_FORMAT(fecha_nac,"%m"),DATE_FORMAT(fecha_nac,"%d")';
        $this->ArrayToJson($this->bd->ObtenerConsulta($que));
    }  
    
    public function getConteoAsistencia(){
        $que = 'SELECT G.sexo SEXO, COUNT(*) CUANTOS FROM RETO_ASISTENCIA A
        INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
        INNER JOIN guerreros G ON A.estudiante_id=G.id
        WHERE S.activo=1 AND A.dia_llegada<>"n" AND G.staff=0
        GROUP BY G.sexo
        UNION
        SELECT "TOTAL", COUNT(*) CUANTOS FROM RETO_ASISTENCIA A
        INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
        INNER JOIN guerreros G ON A.estudiante_id=G.id
        WHERE S.activo=1 AND A.dia_llegada<>"n" AND G.staff=0';
        $this->ArrayToJson($this->bd->ObtenerConsulta($que));
    }  

    public function getGuerreroByEmail($email){
        $que = "SELECT * FROM guerreros WHERE email='$email' AND status='A' ORDER BY staff DESC";
        return $this->bd->ObtenerConsulta($que);
    }  

    public function getGuerreroById($id){
        $que = "SELECT * FROM guerreros WHERE id='$id' AND status='A' ORDER BY staff DESC";
        return $this->bd->ObtenerConsulta($que);
    } 

    public function updatePassword($email,$contrasena){
        $que = "UPDATE guerreros SET password='$contrasena' WHERE email='$email'" ;
        return $this->bd->ejecutar($que);
    }   
    
    public function enviarEmailSignUp($email, $pwd){
        $headers = "From: reto@ywampachuca.org\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=UTF-8\r\n";
        
        mail($email , 'Jucum Pachuca, RETO SEGUIMIENTO', $this->getMensajeEmailSignUP($email,$pwd),$headers);
        mail('reto@ywampachuca.org' , 'Nuevo registro', $this->getMensajeEmailSignUP($email,$pwd),$headers);     
    }

    private function getMensajeEmailSignUP($email,$pwd){
        return '<div dir="ltr">
        <font face="arial, helvetica, sans-serif" size="4">Hola!</font>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">
                <br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">Te has inscrito correctamente a <b> RETO SEGUIMIENTO 2021-2022</b></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">Estos son sus datos de registro:</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Email:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$email.'</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Password:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$pwd.'</font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">Usa esa cuenta para entrar al portal en www.ywapachuca.org/retourbano/reto<br>Un abrazo y estaremos orando por ti!<br><br>Atentamente<br>Liderazgo
                de RETO</font>
                <p><font face="arial, helvetica, sans-serif" size="4">Correo Generado automáticamente.</font></p>
        </div>
    </div>';
    }

    public function getSeguimientosById($id){
        $que = "SELECT * FROM RETO_SEGUIMIENTO AS s
            LEFT JOIN RETO_ASISTENCIA AS a ON s.id_seguimiento=a.seguimiento_id 
            AND a.estudiante_id=$id
            ORDER BY id_seguimiento;";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getListaAsistencia(){
        $que = "SELECT G.id,(SELECT id_seguimiento FROM RETO_SEGUIMIENTO WHERE activo=1) as id_seguimiento, nombre, staff, nick, A.dia_llegada,A.hora_llegada, A.confirmacion FROM RETO_ASISTENCIA A
        RIGHT JOIN guerreros G ON G.id=A.estudiante_id 
        LEFT JOIN RETO_SEGUIMIENTO S ON S.id_seguimiento=A.seguimiento_id
        WHERE `password` IS NOT NULL
        AND (id_seguimiento IS NULL OR id_seguimiento IN (SELECT id_seguimiento FROM RETO_SEGUIMIENTO WHERE activo=1)) 
        ORDER BY nombre;";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getListaAsistenciaBySeguimiento($id){
        $que = "SELECT seguimiento_id, estudiante_id, confirmacion, dia_llegada, hora_llegada, registro 
                FROM RETO_ASISTENCIA WHERE seguimiento_id=$id";
        return $this->bd->ObtenerConsulta($que);
    }

    public function updateAsistencia($asiste, $id_seguimiento, $id_guerrero){

        $que ="SELECT * FROM RETO_ASISTENCIA A 
        WHERE estudiante_id = $id_guerrero AND A.seguimiento_id=$id_seguimiento";
        $array = $this->bd->ObtenerConsulta($que);
        if(!empty($array)){
            $que1 = "UPDATE RETO_ASISTENCIA set confirmacion= IF (confirmacion, 0, 1)
                    WHERE seguimiento_id=$id_seguimiento AND estudiante_id=$id_guerrero";
            $this->bd->ejecutar($que1); 
        }else{
            $que2="INSERT INTO RETO_ASISTENCIA(seguimiento_id,estudiante_id,confirmacion,registro)
                  VALUES ($id_seguimiento,$id_guerrero,$asiste,now());";
                $this->bd->ejecutar($que2);
        }
    }

    public function getListaAltasReto(){
        $que = "SELECT id,nombre,nick,email,staff FROM guerreros WHERE `password` IS NOT NULL";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getSeguimientos(){
        $que = "SELECT * FROM RETO_SEGUIMIENTO AS s
                ORDER BY id_seguimiento DESC";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getSeguimientoById($id_seguimiento){
        $que = "SELECT * FROM RETO_SEGUIMIENTO WHERE id_seguimiento=$id_seguimiento";
        return $this->bd->ObtenerConsulta($que);
    }

    public function addSeguimiento($fecha_inicio, $activo, $titulo, $texto_fecha){
        $que2="INSERT INTO RETO_SEGUIMIENTO(id_seguimiento, fecha_inicio, activo, titulo, texto_fecha)
                VALUES(null,'$fecha_inicio',$activo,'$titulo','$texto_fecha')";
        return $this->bd->ejecutar($que2);
    }

    public function updateSeguimiento($id,$fecha_inicio, $activo, $titulo, $texto_fecha){
        $que2="UPDATE RETO_SEGUIMIENTO SET
                fecha_inicio='$fecha_inicio',
                activo=$activo,
                titulo='$titulo',
                texto_fecha='$texto_fecha'
                WHERE id_seguimiento=$id";
        return $this->bd->ejecutar($que2);
    }

    public function getGuerrerosSecure(){
        $que="SELECT id,nombre,email, `password`, staff FROM guerreros WHERE `password` IS NOT NULL";
        return $this->bd->ObtenerConsulta($que);
    }

    public function saveToken($id, $token){
        $delete = "DELETE FROM token WHERE id_guerrero=$id";
        $this->bd->ejecutar($delete);
        $que="INSERT INTO token(id_guerrero,token,expires,created) 
            VALUES ('$id','$token',now(),now())";
        $this->bd->ejecutar($que);
    }

    public function crearToken(){
        return bin2hex(random_bytes(16));
    }

    public function validarToken($id, $token){
        $que ="SELECT * FROM token WHERE id_guerrero='$id' AND token='$token'";        
        $array = $this->bd->ObtenerConsulta($que);        
        if(!empty($array)){
            return true;           
        }else{
            return false;
        }
    }
}