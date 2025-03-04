<?php

/**
 * Datos short summary.
 *
 * Datos description.
 *
 * @version 1.0
 * @author Neitan
 */
class RUDatos
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

    private function ArrayToJson($array){                
        echo json_encode(array('resultado' => $array));
    }

    private function ArrayToText($array){
        return json_encode(array('resultado' => $array));
    }

    public function obtenerConfiguracion(){        
        $que = "SELECT c.fecha_apertura, c.fecha_maxima, c.umbral, c.maximo_inscr, 
        (SELECT COUNT(*) FROM guerreros WHERE status = 'A') inscritos, 
        FLOOR((100*(SELECT COUNT(*) FROM guerreros WHERE status = 'A'))/c.maximo_inscr) porcentaje,
        c.maximo_inscr-(SELECT COUNT(*) FROM guerreros WHERE status = 'A') disponibles
        FROM configuracion c;";
        return $this->ArrayToJson($this->bd->ObtenerConsulta($que));
    }

    public function obtenerConfiguracionText(){        
        $que = "SELECT c.fecha_apertura, c.fecha_maxima, c.umbral, c.maximo_inscr,  
        (SELECT COUNT(*) FROM guerreros WHERE status = 'A') inscritos, 
        FLOOR((100*(SELECT COUNT(*) FROM guerreros WHERE status = 'A'))/c.maximo_inscr) porcentaje,
        c.maximo_inscr-(SELECT COUNT(*) FROM guerreros WHERE status = 'A') disponibles
        FROM configuracion c;";
        return $this->ArrayToText($this->bd->ObtenerConsulta($que));
    }

    public function GuardarGuerrero($nombre,$nick,$fechaNac,$edad,$sexo,$talla,$vienesDe,$alergias,$razones,$tutorNombre,$tutorTelefono,$iglesia,$email,$whatsapp,$facebook,$instagram,$aceptaPoliticas)
    {
        $insert="INSERT INTO guerreros(id, ";
        $values="VALUES(NULL,";
        
        if(!empty($nombre)){
            $insert.="nombre, ";
            $values.="'$nombre', ";
        }
        
        if(!empty($nick)){
            $insert.="nick, ";
            $values.="'$nick', ";
        }


        if(!empty($fechaNac)){
            $insert.="fechanac, ";
            $values.="STR_TO_DATE('$fechaNac','%d/%m/%Y'), ";
        }
                

        if(!empty($edad)){
            $insert.="edad, ";
            $values.="'$edad', ";
        }
                

        if(!empty($sexo)){
            $insert.="sexo, ";
            $values.="'$sexo', ";
        }
                

        if(!empty($talla)){
            $insert.="talla, ";
            $values.="'$talla', ";
        }
                

        if(!empty($vienesDe)){
            $insert.="vienede, ";
            $values.="'$vienesDe', ";
        }
                

        if(!empty($whatsapp)){
            $insert.="whatsapp, ";
            $values.="'$whatsapp', ";
        }
                

        if(!empty($email)){
            $insert.="email, ";
            $values.="'$email', ";
        }
                

        if(!empty($alergias)){
            $insert.="alergias, ";
            $values.="'$alergias', ";
        }
                

        if(!empty($razones)){
            $insert.="razones, ";
            $values.="'$razones', ";
        }

        if(!empty($tutorTelefono)){
            $insert.="contacto_tutor, ";
            $values.="'$tutorTelefono', ";
        }
                

        if(!empty($iglesia)){
            $insert.="iglesia, ";
            $values.="'$iglesia', ";
        }


        if(!empty($tutorNombre)){
            $insert.="tutor_nombre, ";
            $values.="'$tutorNombre', ";
        }
                

        if(!empty($facebook)){
            $insert.="facebook, ";
            $values.="'$facebook', ";
        }
                

        if(!empty($instagram)){
            $insert.="instagram, ";
            $values.="'$instagram', ";
        }    

        if(!empty($aceptaPoliticas)){
            $insert.="politicas, ";
            $values.="'$aceptaPoliticas', ";
        }
                

        $insert.="staff, ";
        $values.="0, ";

        $insert.="status, ";
        $values.="'A', ";

        $insert.="fechahora_registro)  ";
        $values.="(NOW()))";      

        $sentence = $insert.$values;

        return $this->bd->ejecutar($sentence);
    }  

    public function updateGuerrero($id,$nombre,$nick,$fechaNac,$edad,$sexo,$talla,$vienesDe,$alergias,$razones,$tutorNombre,$tutorTelefono,$iglesia,$email,$whatsapp,$facebook,$instagram,$aceptaPoliticas,$password)
    {
        $que="UPDATE guerreros SET ";

        if(!empty($nombre)){
            $que.="nombre='$nombre', ";
        }
        if(!empty($nick)){
            $que.="nick='$nick', ";
        }
        if(!empty($fechaNac)){
            $que.="fechanac='$fechaNac', ";
        }
        if(!empty($edad)){
            $que.="edad='$edad', ";
        }
        if(!empty($sexo)){
            $que.="sexo='$sexo', ";
        }
        if(!empty($talla)){
            $que.="talla='$talla', ";
        }
        if(!empty($vienesDe)){
            $que.="vienesDe='$vienesDe', ";
        }
        if(!empty($alergias)){
            $que.="alergias='$alergias', ";
        }
        if(!empty($razones)){
            $que.="razones='$razones', ";
        }
        if(!empty($tutorNombre)){
            $que.="tutor_nombre='$tutorNombre', ";
        }
        if(!empty($tutorTelefono)){
            $que.="contacto_tutor='$tutorTelefono', ";
        }
        if(!empty($iglesia)){
            $que.="iglesia='$iglesia', ";
        }
        if(!empty($email)){
            $que.="email='$email', ";
        }
        if(!empty($whatsapp)){
            $que.="whatsapp='$whatsapp', ";
        }
        if(!empty($facebook)){
            $que.="facebook='$facebook', ";
        }
        if(!empty($instagram)){
            $que.="instagram='$instagram', ";
        }
        if(!empty($aceptaPoliticas)){
            $que.="aceptaPoliticas='$aceptaPoliticas', ";
        }
        if(!empty($password)){
            $que.="password='$password', ";
        }

        $que = substr($que,0,-2);
        $que.=" WHERE id=$id";
        return $this->bd->ejecutar($que);
    } 

    public function consultaGuerreros($status, $staff){
        $que = "SELECT 
        id,
        nombre,
        nick,
        fechaNac,
        edad,
        sexo,
        talla,
        vienede as vienesDe,
        alergias,
        razones,
        tutor_nombre as tutorNombre,
        contacto_tutor as tutorTelefono,
        iglesia,
        email,
        whatsapp,
        facebook,
        instagram,
        politicas as aceptaPoliticas,
        IF(staff = 0, 'false', 'true') as staff ,
        admin
        FROM guerreros ".($status=='T'?" WHERE ":" WHERE status = '$status' AND ")." staff ".($staff=='T'?"in(0,1)":("=".$staff));        
        $array = $this->bd->ObtenerConsulta($que);
        return $this->ArrayToJson($array);
    }

    public function changeStaff($id,$value){
        $que = "UPDATE guerreros SET staff=$value WHERE id=$id";
        if($this->bd->ejecutar($que)){
            echo '{"error":0,"mensaje":"Actualizado correctamente", "query":"'.$que.'"}';
        }else{
            echo '{"error":1,"mensaje":"Error al cambiar estatus", "query":"'.$que.'"}';
        };
    }

    public function changeStatus($id,$value){
        $que = "UPDATE guerreros SET status='$value' WHERE id=$id";
        if($this->bd->ejecutar($que)){
            echo '{"error":0,"mensaje":"Actualizado correctamente", "query":"'.$que.'"}';
        }else{
            echo '{"error":1,"mensaje":"Error al cambiar estatus", "query":"'.$que.'"}';
        };
    }

    public function getIndicadores(){
        $que = "SELECT 'Lugares' valor ,maximo_inscr 'count', '1' paquete FROM configuracion
        UNION
        SELECT 'Disponibles' valor ,maximo_inscr-(SELECT COUNT(*) FROM guerreros WHERE `status`= 'A') 'count', '1' paquete FROM configuracion
        UNION
        SELECT 'Inscritos', COUNT(*), '1' FROM guerreros WHERE `status`= 'A'        
        UNION
        SELECT 'Guerreros', COUNT(*), '1' FROM guerreros WHERE `status`= 'A' AND staff=0 
        UNION
        SELECT 'Staff', COUNT(*), '1' FROM guerreros WHERE `status`= 'A' AND staff=1
        UNION
        SELECT 'Bajas', COUNT(*), '1' FROM guerreros WHERE `status`= 'B'
        UNION
        SELECT 'Hombres', COUNT(*), '2' FROM guerreros WHERE `status`= 'A' AND staff=0 AND sexo='M'
        UNION
        SELECT 'Mujeres', COUNT(*), '2' FROM guerreros WHERE `status`= 'A' AND staff=0 AND sexo='F'
        UNION
        SELECT 'Hombres_Staff', COUNT(*), '3' FROM guerreros WHERE `status`= 'A' AND staff=1 AND sexo='M'
        UNION
        SELECT 'Mujeres_Staff', COUNT(*), '3' FROM guerreros WHERE `status`= 'A' AND staff=1 AND sexo='F'
        UNION
        SELECT Talla, COUNT(*), '4' FROM guerreros WHERE `status`= 'A' GROUP BY talla
        UNION 
        SELECT 'Total Pagado', CONCAT('$ ',FORMAT(FLOOR(SUM(cantidad)),0)), '5' FROM pagos";
        return $this->ArrayToJson($this->bd->ObtenerConsulta($que));
    }

    public function getIndicadoresArray(){
        $que = "SELECT 'Lugares' valor ,maximo_inscr 'count', '1' paquete FROM configuracion
        UNION
        SELECT 'Disponibles' valor ,maximo_inscr-(SELECT COUNT(*) FROM guerreros WHERE `status`= 'A') 'count', '1' paquete FROM configuracion
        UNION
        SELECT 'Inscritos', COUNT(*), '1' FROM guerreros WHERE `status`= 'A'        
        UNION
        SELECT 'Guerreros', COUNT(*), '1' FROM guerreros WHERE `status`= 'A' AND staff=0 
        UNION
        SELECT 'Staff', COUNT(*), '1' FROM guerreros WHERE `status`= 'A' AND staff=1
        UNION
        SELECT 'Bajas', COUNT(*), '1' FROM guerreros WHERE `status`= 'B'
        UNION
        SELECT 'Hombres', COUNT(*), '2' FROM guerreros WHERE `status`= 'A' AND staff=0 AND sexo='M'
        UNION
        SELECT 'Mujeres', COUNT(*), '2' FROM guerreros WHERE `status`= 'A' AND staff=0 AND sexo='F'
        UNION
        SELECT 'Hombres_Staff', COUNT(*), '3' FROM guerreros WHERE `status`= 'A' AND staff=1 AND sexo='M'
        UNION
        SELECT 'Mujeres_Staff', COUNT(*), '3' FROM guerreros WHERE `status`= 'A' AND staff=1 AND sexo='F'
        UNION
        SELECT Talla, COUNT(*), '4' FROM guerreros WHERE `status`= 'A' GROUP BY talla";        
        return $this->bd->ObtenerConsulta($que);
    }

    public function guardarPago($cantidad,$descripcion,$id_guerrero,$divisa){
        $que = "INSERT INTO 
        pagos(id_pago,cantidad,descripcion,id_guerrero,divisa) 
        values(null,'$cantidad','$descripcion','$id_guerrero','$divisa');";        
        if($this->bd->ejecutar($que)){
            echo '{error:0,mensaje:"Pago guardado correctamente", query:"'.$que.'"}';
        }else{
            echo '{error:1,mensaje:"Error al cambiar estatus", query:"'.$que.'"}';
        };
    }

    public function obtenerPagos(){
        $que="SELECT nombre, SUM(P.cantidad) pagado FROM guerreros G
        INNER JOIN pagos P ON G.id=P.id_guerrero
        GROUP BY id_guerrero
        ORDER BY nombre;";
        return $this->ArrayToJson($this->bd->ObtenerConsulta($que));
    }
    
    //////////////////////////// reconexion ////////////////////////////////

    public function guardarReconexion($nombre,$edad,$telefono,$vienede,$comentarios,$campamentos,$entrenamientos,$email){
        $que = "INSERT INTO reconexion(id,nombre,edad,telefono,vienede,comentarios,campamentos,entrenamientos,fechahoraregistro,status,email) 
                VALUES (NULL,'$nombre',$edad,'$telefono','$vienede','$comentarios','$campamentos','$entrenamientos',NOW(),1,'$email')";        
        return $this->bd->ejecutar($que);
    }
    
    public function getReconectados(){
        $que="SELECT * FROM reconexion";
        return $this->ArrayToJson($this->bd->ObtenerConsulta($que));
    }

    public function insertBitacoraCambios($guerrero_id, $tabla, $old_value, $new_value){
        $que = "INSERT INTO BITACORA_CAMBIOS(id,guerrero_id,tabla,old_value,new_value,fecha) 
        VALUES (NULL,'$guerrero_id', '$tabla', '$old_value', '$new_value' ,NOW())";        
        return $this->bd->ejecutar($que);
    }
}