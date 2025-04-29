<?php

/**
 * Datos short summary.
 *
 * Datos description.
 *
 * @version 1.0
 * @author Neitan
 */
class RetoUrbanoDao
{
    public $bd;
    public $funRutas;
    static $_instance;
    var $pCaja;

    /*La funci?n construct es privada para evitar que el objeto pueda ser creado mediante new*/
    private function __construct()
    {
        require 'Db.class.php';
        $this->bd = Db::getInstance(1);
    }

    /*Funci?n encargada de crear, si es necesario, el objeto. Esta es la funci?n que debemos llamar desde fuera de la clase para instanciar el objeto, y as?, poder utilizar sus m?todos*/
    public static function getInstance()
    {
        if (!(self::$_instance instanceof self)) {
            self::$_instance = new self();
        }
        return self::$_instance;
    }

    /*Evitamos el clonaje del objeto. Patr?n Singleton*/
    private function __clone()
    {
    }

    private function getGuerreroFields()
    {
        return 'g.id,
        nombre,
        nick,
        fechaNac as fechaNac,
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
        telefono,
        facebook,
        instagram,
        politicas as aceptaPoliticas,
        `status`,
        medicamentos,
        IF(staff= 0, \'false\', \'true\') as staff,
        IF(admin= 0, \'false\', \'true\') as admin,
        IF(confirmado= 0, \'false\', \'true\') as confirmado, 
        IF(asistencia= 0, \'false\', \'true\') as asistencia,
        IF(seguimiento= 0, \'false\', \'true\') as seguimiento,
        IF(email_enviado= 0, \'false\', \'true\') as emailEnviado, 
        IF(email_confirmado= 0, \'false\', \'true\') as emailConfirmado,
        IF(email_confirmado= 0, \'false\', \'true\') as emailConfirmado,
        IF(hospedaje= 0, \'false\', \'true\') as hospedaje, 
        habitacion ';
    }

    public function inscribir($nombre, $nick, $fechaNac, $edad, $sexo, $talla, $vienesDe, $alergias, $razones, $tutorNombre, $tutorTelefono, $iglesia, $email, $whatsapp, $facebook, $instagram, $aceptaPoliticas, $medicamentos, $telefono, $hospedaje)
    {
        $insert = "INSERT INTO guerreros(id, ";
        $values = "VALUES(NULL,";

        if (!empty($nombre)) {
            $insert .= "nombre, ";
            $values .= "'$nombre', ";
        }

        if (!empty($nick)) {
            $insert .= "nick, ";
            $values .= "'$nick', ";
        }


        if (!empty($fechaNac)) {
            $insert .= "fechanac, ";
            $values .= "STR_TO_DATE('$fechaNac','%d/%m/%Y'), ";
        }


        if (!empty($edad)) {
            $insert .= "edad, ";
            $values .= "'$edad', ";
        }


        if (!empty($sexo)) {
            $insert .= "sexo, ";
            $values .= "'$sexo', ";
        }


        if (!empty($talla)) {
            $insert .= "talla, ";
            $values .= "'$talla', ";
        }


        if (!empty($vienesDe)) {
            $insert .= "vienede, ";
            $values .= "'$vienesDe', ";
        }


        if (!empty($whatsapp)) {
            $insert .= "whatsapp, ";
            $values .= "'$whatsapp', ";
        }

        if (!empty($telefono)) {
            $insert .= "telefono, ";
            $values .= "'$telefono', ";
        }

        if (!empty($email)) {
            $insert .= "email, ";
            $values .= "'$email', ";
        }


        if (!empty($alergias)) {
            $insert .= "alergias, ";
            $values .= "'$alergias', ";
        }


        if (!empty($razones)) {
            $insert .= "razones, ";
            $values .= "'$razones', ";
        }

        if (!empty($tutorTelefono)) {
            $insert .= "contacto_tutor, ";
            $values .= "'$tutorTelefono', ";
        }


        if (!empty($iglesia)) {
            $insert .= "iglesia, ";
            $values .= "'$iglesia', ";
        }


        if (!empty($tutorNombre)) {
            $insert .= "tutor_nombre, ";
            $values .= "'$tutorNombre', ";
        }


        if (!empty($facebook)) {
            $insert .= "facebook, ";
            $values .= "'$facebook', ";
        }


        if (!empty($instagram)) {
            $insert .= "instagram, ";
            $values .= "'$instagram', ";
        }

        if (!empty($aceptaPoliticas)) {
            $insert .= "politicas, ";
            $values .= "'$aceptaPoliticas', ";
        }

        if (!empty($medicamentos)) {
            $insert .= "medicamentos, ";
            $values .= "'$medicamentos', ";
        }

        $insert .= "fechahora_registro)  ";
        $values .= "(NOW()))";

        $sentence = $insert . $values;

        $response = $this->bd->ejecutarPlus($sentence);

        if ($response) {
            return $this->insertarCampamentoGuerreros($response, $hospedaje);
        }
        return false;
    }

    public function insertarCampamentoGuerreros($id, $hospedaje)
    {
        $insertCampa = "INSERT INTO campamento_guerreros(";
        $valuesCampa = " VALUES (";

        $insertCampa .= "id_campamento, ";
        $valuesCampa .= "(SELECT id_campamento FROM campamentos WHERE activo = 1), ";

        $insertCampa .= "id_guerrero, ";
        $valuesCampa .= $id . ", ";

        $insertCampa .= "status, ";
        $valuesCampa .= "'A', ";

        $insertCampa .= "confirmado, ";
        $valuesCampa .= "0, ";

        $insertCampa .= "asistencia, ";
        $valuesCampa .= "0, ";

        $insertCampa .= "staff, ";
        $valuesCampa .= "0, ";

        $insertCampa .= "admin, ";
        $valuesCampa .= "0, ";

        $insertCampa .= "email_enviado, ";
        $valuesCampa .= "0, ";

        $insertCampa .= "email_confirmado, ";
        $valuesCampa .= "0, ";

        $insertCampa .= "hospedaje, ";
        $valuesCampa .= "$hospedaje, ";

        $insertCampa .= "seguimiento) ";
        $valuesCampa .= "0)";

        $sentenceCampa = $insertCampa . $valuesCampa;
        return $this->bd->ejecutar($sentenceCampa);
    }

    public function getGuerreroByEmail($email)
    {
        $que = "SELECT " . $this->getGuerreroFields() . ", cg.id as id_campamento_guerrero FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero
        WHERE email='$email' AND status='A' ORDER BY staff DESC";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getGuerreroByEmailToRecovery($email)
    {
        $que = "SELECT " . $this->getGuerreroFields() . ", cg.id as id_campamento_guerrero FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero
        WHERE email='$email' AND status='A' AND (staff=1 OR admin=1 OR seguimiento=1) ORDER BY staff DESC";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getGuerrroRegistradoByEmail($email)
    {
        $que = "SELECT 
        id,
        nombre,
        nick,
        fechaNac as fechaNac,
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
        telefono,
        facebook,
        instagram,
        politicas as aceptaPoliticas,
        medicamentos  
        FROM guerreros WHERE email='$email' ORDER BY id DESC";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getGuerrroRegistradoById($id)
    {
        $que = "SELECT 
        id,
        nombre,
        nick,
        fechaNac as fechaNac,
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
        telefono,
        facebook,
        instagram,
        politicas as aceptaPoliticas,
        medicamentos FROM guerreros WHERE id='$id'";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getGuerrroRegistradoByCode($code)
    {
        $que = "SELECT 
        id,
        nombre,
        nick,
        fechaNac as fechaNac,
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
        telefono,
        facebook,
        instagram,
        politicas as aceptaPoliticas,
        medicamentos FROM guerreros WHERE codigo='$code' ORDER BY id DESC";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getGuerreroById($id)
    {
        $que = "SELECT " . $this->getGuerreroFields() . ", cg.id as id_campamento_guerrero FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
        INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento
        WHERE g.id='$id' AND status='A' AND cm.activo=1 ORDER BY staff DESC";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getIndicadoresArray()
    {
        $que = "SELECT 'Lugares' valor ,maximo_inscr 'count', '1' paquete FROM campamentos c  WHERE c.activo=1
        UNION
        SELECT 'Disponibles' valor ,maximo_inscr-(SELECT COUNT(*) FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero  WHERE `status`= 'A') 'count', '1' paquete FROM campamentos c WHERE c.activo=1
        UNION
        SELECT 'Inscritos', COUNT(*), '1' FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero  WHERE `status`= 'A'        
        UNION
        SELECT 'Guerreros', COUNT(*), '1' FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero   WHERE `status`= 'A' AND staff=0 
        UNION
        SELECT 'Staff', COUNT(*), '1' FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero  WHERE `status`= 'A' AND staff=1
        UNION
        SELECT 'Bajas', COUNT(*), '1' FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero  WHERE `status`= 'B'
        UNION
        SELECT 'Hombres', COUNT(*), '2' FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero  WHERE `status`= 'A' AND staff=0 AND sexo='M'
        UNION
        SELECT 'Mujeres', COUNT(*), '2' FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero  WHERE `status`= 'A' AND staff=0 AND sexo='F'
        UNION
        SELECT 'Hombres_Staff', COUNT(*), '3' FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero  WHERE `status`= 'A' AND staff=1 AND sexo='M'
        UNION
        SELECT 'Mujeres_Staff', COUNT(*), '3' FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero  WHERE `status`= 'A' AND staff=1 AND sexo='F'
        UNION
        SELECT Talla, COUNT(*), '4' FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero  WHERE `status`= 'A' GROUP BY talla";
        return $this->bd->ObtenerConsulta($que);
    }

    public function obtenerConfiguracion()
    {
        $que = "SELECT c.fecha_apertura, c.fecha_maxima, c.umbral, c.maximo_inscr, 
        (SELECT COUNT(*) FROM campamento_guerreros cg WHERE status = 'A' AND cg.id_campamento=c.id_campamento ) inscritos, 
        FLOOR((100*(SELECT COUNT(*) FROM campamento_guerreros cg WHERE status = 'A'  AND cg.id_campamento=c.id_campamento))/c.maximo_inscr) porcentaje,
        c.maximo_inscr-(SELECT COUNT(*) FROM campamento_guerreros cg WHERE status = 'A'  AND cg.id_campamento=c.id_campamento) disponibles
        FROM campamentos c WHERE c.activo=1;";
        return $this->bd->ObtenerConsulta($que);
    }

    public function verificarSession($usr, $pwd)
    {
        $que = "SELECT " . $this->getGuerreroFields() . ",'' entra FROM guerreros g 
        INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero
        WHERE email='$usr' AND password='$pwd' AND status='A' 
        AND (staff=1 OR admin=1 OR seguimiento=1)";
        $array = $this->bd->ObtenerConsulta($que);
        if (!empty($array)) {
            return true;
        } else {
            return false;
        }
    }

    public function login($usuario, $password)
    {
        $que = "SELECT g.id FROM guerreros g 
                INNER JOIN guerreros_roles gr ON gr.guerrero_id=g.id
                WHERE email='$usuario' 
                AND password='$password'";
        $array = $this->bd->ObtenerConsulta($que);
        if (!empty($array)) {
            return true;
        } else {
            return false;
        }
    }

    public function saveToken($id, $token)
    {
        $delete = "DELETE FROM token WHERE id_guerrero=$id";
        $this->bd->ejecutar($delete);
        $que = "INSERT INTO token(id_guerrero,token,expires,created) 
            VALUES ('$id','$token',now(),now())";
        $this->bd->ejecutar($que);
    }

    public function deleteToken($id)
    {
        $delete = "DELETE FROM token WHERE id_guerrero=$id";
        return $this->bd->ejecutar($delete);
    }

    public function crearToken()
    {
        return bin2hex(random_bytes(16));
    }

    public function validarToken($id, $token)
    {
        $que = "SELECT * FROM token WHERE id_guerrero='$id' AND token='$token'";
        $array = $this->bd->ObtenerConsulta($que);
        if (!empty($array)) {
            return true;
        } else {
            return false;
        }
    }

    public function validarAdmin($id)
    {
        /*$que = "SELECT admin FROM campamento_guerreros WHERE id_guerrero='$id' and admin=1";
        $array = $this->bd->ObtenerConsulta($que);
        if (!empty($array)) {
            return true;
        } else {
            return false;
        }*/
        return $this->validarPermiso($id);
    }

    public function validarPermiso($id)
    {
        $que = "SELECT id FROM guerreros_roles 
        WHERE guerrero_id=2024000 
        AND rol = 'admin' OR rol = 'super'";
        $array = $this->bd->ObtenerConsulta($que);
        if (!empty($array)) {
            return true;
        } else {
            return false;
        }
    }

    public function consultaGuerreros($status, $staff, $admin, $byname, $seguimiento, $isAdmin)
    {
        $que = "SELECT "
            . $this->getGuerreroFields() .
            ",(SELECT SUM(p.cantidad) FROM pagos p WHERE p.id_campamento_guerrero=cg.id) as pagado"
            . ($isAdmin ? ",password" : "") .
            " FROM guerreros g 
            INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
            INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento AND cm.activo=true" .
            ($status == 'T' ? " WHERE " : " WHERE status = '$status' " . ($status != 'B' ? " AND " : "")) .
            ($status != 'B' ? " staff " . ($staff == 'T' ? "in(0,1)" : ("=" . $staff)) . " AND admin=$admin " : '');
        if (!empty($byname)) {
            $que .= " AND g.nombre like '%$byname%'";
        }
        $que .= ($status != 'B' ? " AND seguimiento = $seguimiento " : "");
        return $this->bd->ObtenerConsulta($que);
    }

    public function getIndicadores($opcion)
    {

        switch ($opcion) {
            case 4:
                $que = "SELECT 'Disponibles' valor ,maximo_inscr-(SELECT COUNT(*) FROM guerreros g 
                INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
                INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento
                AND cm.activo=true
                WHERE `status`= 'A' ) 'count' FROM campamentos c
                WHERE c.activo=1 
                UNION
                SELECT 'Inscritos', COUNT(*) FROM guerreros g 
                INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
                INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento
                WHERE `status`= 'A' AND cm.activo=true";
                break;
            case 5:
                $que = "SELECT 'Guerreros' valor, COUNT(*) 'count' FROM guerreros g 
                INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
                INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento
                WHERE `status`= 'A' AND staff=0 AND cm.activo=true 
                UNION
                SELECT 'Staff', COUNT(*) FROM guerreros g 
                INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
                INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento
                WHERE `status`= 'A' AND staff=1 AND cm.activo=true 
                UNION
                SELECT 'Admins', COUNT(*) FROM guerreros g 
                INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
                INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento
                WHERE `status`= 'A' AND admin=1 AND cm.activo=true 
                UNION
                SELECT 'Bajas', COUNT(*) FROM guerreros g 
                INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
                INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento
                WHERE `status`= 'B' AND cm.activo=true ";
                break;

            case 6:
                $que = "SELECT 'Hombres' valor, COUNT(*) 'count' FROM guerreros g 
                INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
                INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento
                WHERE `status`= 'A' AND staff=0 AND sexo='M' AND cm.activo=true
                UNION
                SELECT 'Mujeres', COUNT(*) FROM guerreros g 
                INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
                INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento
                WHERE `status`= 'A' AND staff=0 AND sexo='F' AND cm.activo=true";
                break;

            case 7:
                $que = "SELECT 'Hombres_Staff' valor, COUNT(*) 'count' FROM guerreros g 
                INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero
                INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento 
                WHERE `status`= 'A' AND staff=1 AND sexo='M' AND cm.activo=true
                UNION
                SELECT 'Mujeres_Staff', COUNT(*) FROM guerreros g 
                INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
                INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento
                WHERE `status`= 'A' AND staff=1 AND sexo='F' AND cm.activo=true";
                break;

            case 8:
                $que = "SELECT Talla valor, COUNT(*) 'count' FROM guerreros g 
                INNER JOIN campamento_guerreros cg ON g.id=cg.id_guerrero 
                INNER JOIN campamentos cm ON cg.id_campamento=cm.id_campamento
                WHERE `status`= 'A' AND cm.activo=true GROUP BY talla";
                break;
            case 14:
                $que = "SELECT IF(hospedaje= 0, 'Hospedaje aparte', 'Con hospedaje') as valor, COUNT(*) 'count'  
                        FROM campamento_guerreros cg
                        INNER JOIN guerreros g ON g.id = cg.id_guerrero
                        INNER JOIN campamentos c ON c.id_campamento = cg.id_campamento
                        WHERE c.activo = 1 GROUP BY hospedaje";
                break;
        }

        return $this->bd->ObtenerConsulta($que);
    }

    public function getSeguimientos()
    {
        $que = "SELECT * FROM RETO_SEGUIMIENTO AS s
                ORDER BY id_seguimiento DESC";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getSeguimientosById($id)
    {
        $que = "SELECT * FROM RETO_SEGUIMIENTO AS s
            LEFT JOIN RETO_ASISTENCIA AS a ON s.id_seguimiento=a.seguimiento_id 
            AND a.estudiante_id=$id
            LEFT JOIN campamentos AS c ON c.id_campamento = s.campamento_id 
            WHERE c.activo=1
            ORDER BY id_seguimiento DESC;";
        return $this->bd->ObtenerConsulta($que);
    }

    public function obtenerConfirmacion($dia, $id)
    {
        $que = "SELECT * FROM RETO_ASISTENCIA A 
        INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
        WHERE estudiante_id = $id AND S.activo = 1";
        $array = $this->bd->ObtenerConsulta($que);
        if (!empty($array)) {
            if ($dia != "0") {
                if ($dia != $array[0]['dia_llegada']) {
                    $que = "UPDATE RETO_ASISTENCIA A 
                    INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
                    SET dia_llegada='$dia', hora_llegada=null 
                    WHERE estudiante_id = $id AND S.activo = 1";
                    return $this->bd->ejecutar($que);
                } else {
                    return 1;
                }
            } else {
                $dia = $array[0]['dia_llegada'];
                return 1;
            }

        } else {
            if ($dia != "0") {
                $que = "INSERT INTO RETO_ASISTENCIA(seguimiento_id,estudiante_id,confirmacion,dia_llegada,registro)
                      SELECT id_seguimiento,$id,0,'$dia',now() FROM RETO_SEGUIMIENTO WHERE activo = 1";
                return $this->bd->ejecutar($que);
            }
        }
    }

    public function obtenerConfirmacionHora($hora, $id)
    {
        $que = "SELECT * FROM RETO_ASISTENCIA A 
        INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
        WHERE estudiante_id = " . $id . " AND S.activo = 1";
        $array = $this->bd->ObtenerConsulta($que);
        if (!empty($array)) {
            $que = "UPDATE RETO_ASISTENCIA A 
            INNER JOIN RETO_SEGUIMIENTO S ON A.seguimiento_id=S.id_seguimiento
            SET hora_llegada='$hora' 
            WHERE estudiante_id = " . $id . " AND S.activo = 1";
            return $this->bd->ejecutar($que);
        }
    }

    public function changeStaff($id, $value)
    {
        $que = "UPDATE campamento_guerreros SET staff=$value WHERE id_guerrero=$id";
        if ($this->bd->ejecutar($que)) {

            if ($value) {
                $this->addRolById($id, 'staff');
            } else {
                $this->deleteRolById($id, 'staff');
            }

            $response["error"] = "false";
            $response["mensaje"] = "Actualizado correctamente";
            $response["query"] = $que;
            echo json_encode($response);
        } else {
            $response["error"] = "true";
            $response["mensaje"] = "Error al cambiar staff";
            $response["query"] = $que;
            echo json_encode($response);
        }
    }

    public function changeAdmin($id, $value)
    {
        $que = "UPDATE campamento_guerreros SET admin=$value WHERE id_guerrero=$id";
        if ($this->bd->ejecutar($que)) {

            if ($value) {
                $this->addRolById($id, 'admin');
            } else {
                $this->deleteRolById($id, 'admin');
            }

            $response["error"] = "false";
            $response["mensaje"] = "Actualizado correctamente";
            $response["query"] = $que;
            echo json_encode($response);
        } else {
            $response["error"] = "true";
            $response["mensaje"] = "Error al cambiar admin";
            $response["query"] = $que;
            echo json_encode($response);
        }
    }

    public function changePassword($id, $value)
    {
        $que = "UPDATE guerreros SET password='$value' WHERE id=$id";
        if ($this->bd->ejecutar($que)) {
            $response["error"] = "false";
            $response["mensaje"] = "Actualizado correctamente";
            $response["query"] = $que;
            echo json_encode($response);
        } else {
            $response["error"] = "true";
            $response["mensaje"] = "Error al cambiar admin";
            $response["query"] = $que;
            echo json_encode($response);
        }
    }

    public function changeStatus($id, $value)
    {
        $que = "UPDATE campamento_guerreros SET status='$value' WHERE id_guerrero=$id";
        if ($this->bd->ejecutar($que)) {
            $response["error"] = "false";
            $response["mensaje"] = "Actualizado correctamente";
            $response["query"] = $que;
            echo json_encode($response);
        } else {
            $response["error"] = "true";
            $response["mensaje"] = "Error al cambiar status";
            $response["query"] = $que;
            echo json_encode($response);
        }
        ;
    }

    public function updatePassword($email, $contrasena)
    {
        $que = "UPDATE guerreros SET password='$contrasena' WHERE email='$email'";
        return $this->bd->ejecutar($que);
    }

    public function actualizar($id, $nombre, $nick, $fechaNac, $edad, $sexo, $talla, $vienesDe, $alergias, $razones, $tutorNombre, $tutorTelefono, $iglesia, $email, $whatsapp, $facebook, $instagram, $aceptaPoliticas, $medicamentos, $telefono, $codigo)
    {
        $insert = "UPDATE guerreros SET ";
        $fields = array();

        if (!empty($nombre)) {
            $fields["nombre"] = $nombre;
        }

        if (!empty($nick)) {
            $fields["nick"] = $nick;
        }

        if (!empty($fechaNac)) {
            $fields["fechanac"] = "STR_TO_DATE('$fechaNac','%d/%m/%Y')";
        }

        if (!empty($edad)) {
            $fields["edad"] = $edad;
        }

        if (!empty($sexo)) {
            $fields["sexo"] = $sexo;
        }

        if (!empty($talla)) {
            $fields["talla"] = $talla;
        }

        if (!empty($vienesDe)) {
            $fields["vienede"] = $vienesDe;
        }

        if (!empty($whatsapp)) {
            $fields["whatsapp"] = $whatsapp;
        }

        if (!empty($telefono)) {
            $fields["telefono"] = $telefono;
        }

        if (!empty($email)) {
            $fields["email"] = $email;
        }

        if (!empty($alergias)) {
            $fields["alergias"] = $alergias;
        }

        if (!empty($razones)) {
            $fields["razones"] = $razones;
        }

        if (!empty($tutorTelefono)) {
            $fields["contacto_tutor"] = $tutorTelefono;
        }

        if (!empty($iglesia)) {
            $fields["iglesia"] = $iglesia;
        }

        if (!empty($tutorNombre)) {
            $fields["tutor_nombre"] = $tutorNombre;
        }

        if (!empty($facebook)) {
            $fields["facebook"] = $facebook;
        }

        if (!empty($medicamentos)) {
            $fields["medicamentos"] = $medicamentos;
        }

        if (!empty($instagram)) {
            $fields["instagram"] = $instagram;
        }

        if (!empty($codigo)) {
            $fields["codigo"] = $codigo;
        }

        $keys = array_keys($fields);
        $i = 0;
        foreach ($keys as $key) {
            $insert .= ($i > 0 ? ", " : "") . $key . "=" . ($key != 'fechanac' ? "'" : "") . $fields[$key] . ($key != 'fechanac' ? "'" : "");
            $i++;
        }

        $sentence = $insert . " WHERE id=$id";
        return $this->bd->ejecutar($sentence);
    }

    public function getPagos($idGuerrero)
    {
        $que = "SELECT p.* FROM campamento_guerreros cg
                INNER JOIN pagos p ON cg.id = p.id_campamento_guerrero
                INNER JOIN campamentos c ON cg.id_campamento = c.id_campamento
                WHERE cg.id_guerrero=$idGuerrero AND c.activo=1";
        return $this->bd->ObtenerConsulta($que);
    }

    public function guardarPago($idcg, $cantidad, $descripcion, $divisa, $no_ticket)
    {
        $insertador = "INSERT INTO pagos(id_campamento_guerrero, cantidad, descripcion, divisa, no_ticket)
        VALUES($idcg,$cantidad,'$descripcion','$divisa','$no_ticket')";
        //echo $insertador;
        return $this->bd->ejecutar($insertador);
    }

    public function actualizarPago($idpago, $cantidad, $descripcion, $divisa, $no_ticket)
    {
        $insertador = "UPDATE pagos SET cantidad='$cantidad', descripcion = '$descripcion', divisa='$divisa', no_ticket='$no_ticket' WHERE id_pago=$idpago";
        return $this->bd->ejecutar($insertador);
    }

    public function borrarPago($idpago)
    {
        $insertador = "DELETE FROM pagos WHERE id_pago=$idpago";
        return $this->bd->ejecutar($insertador);
    }


    public function guardarAsistencia($idcg, $valor)
    {
        $updater = "UPDATE campamento_guerreros SET asistencia=$valor WHERE id=$idcg";
        return $this->bd->ejecutar($updater);
    }

    public function guardarSeguimiento($idcg, $valor)
    {
        $updater = "UPDATE campamento_guerreros SET seguimiento=$valor WHERE id=$idcg";
        return $this->bd->ejecutar($updater);
    }

    public function guardarConfirmacion($idcg, $valor)
    {
        $updater = "UPDATE campamento_guerreros SET confirmado=$valor WHERE id=$idcg";
        return $this->bd->ejecutar($updater);
    }

    public function guardarEmailEnviado($idcg, $valor)
    {
        $updater = "UPDATE campamento_guerreros SET email_enviado=$valor WHERE id=$idcg";
        return $this->bd->ejecutar($updater);
    }

    public function guardarEmailConfirmacion($idcg, $valor)
    {
        $updater = "UPDATE campamento_guerreros SET email_confirmado=$valor WHERE id=$idcg";
        return $this->bd->ejecutar($updater);
    }

    public function getAsistenciasReto()
    {
        $que = "SELECT c.id_campamento, cg.id AS cg, g.id,  g.nombre, rs.id_seguimiento, ra.* 
        FROM campamentos c 
        INNER JOIN campamento_guerreros cg ON cg.id_campamento = c.id_campamento 
        INNER JOIN guerreros g ON cg.id_guerrero=g.id 
        INNER JOIN reto_seguimiento rs ON rs.campamento_id = c.id_campamento 
        LEFT JOIN reto_asistencia ra ON ra.estudiante_id = g.id AND rs.id_seguimiento=ra.seguimiento_id
        WHERE c.activo=1
        AND cg.seguimiento=1
        AND rs.activo = 1
        ORDER BY g.nombre";
        return $this->bd->ObtenerConsulta($que);
    }

    public function consultaAgruparPorDescripcion()
    {
        $que = "SELECT descripcion 'Descripción',SUM(cantidad) FROM pagos
        GROUP BY descripcion";
        return $this->bd->ObtenerConsulta($que);
    }

    public function consultaTotales()
    {
        $que = "SELECT 'Ingresos' as 'valor',SUM(cantidad) 'count' FROM pagos p
                INNER JOIN campamento_guerreros cg ON p.id_campamento_guerrero = cg.id
                INNER JOIN campamentos c ON cg.id_campamento = c.id_campamento
                WHERE c.activo=1
                UNION
                SELECT 'Pagos completos',COUNT(*) FROM view_pagos_guerreros
                WHERE cantidad >= 2300";
        return $this->bd->ObtenerConsulta($que);
    }

    public function consultaPagos()
    {
        $que = "SELECT id_pago, id_campamento_guerrero, cantidad, descripcion, divisa, no_ticket, g.nombre FROM ywampach_retourbano.pagos as p
                INNER JOIN campamento_guerreros as cg ON cg.id = p.id_campamento_guerrero
                INNER JOIN guerreros as g ON cg.id_guerrero = g.id
                INNER JOIN campamentos c ON cg.id_campamento = c.id_campamento
                WHERE c.activo=1";
        return $this->bd->ObtenerConsulta($que);
    }

    public function consultaGuerrerosHistorial($year)
    {
        $que = "SELECT * FROM guerreros" . $year . " order by nombre";
        return $this->bd->ObtenerConsulta($que);
    }

    public function consultaPagosPorGuerrero()
    {
        $que = "SELECT nombre, staff descripcion, cantidad, pagos FROM view_pagos_guerreros ORDER BY cantidad";
        return $this->bd->ObtenerConsulta($que);
    }

    public function consultarCampamentos()
    {
        $que = "SELECT * FROM campamentos ORDER BY id_campamento DESC";
        return $this->bd->ObtenerConsulta($que);
    }

    public function consultarCampamentoActivo()
    {
        $que = "SELECT * FROM campamentos WHERE activo=1 ORDER BY id_campamento DESC";
        return $this->bd->ObtenerConsulta($que);
    }

    public function consultarCostosByCampamento($campemento)
    {
        $que = "SELECT * FROM campamento_costos WHERE campamento_id=$campemento";
        return $this->bd->ObtenerConsulta($que);
    }

    public function obtenerRolesById($id_guerrero)
    {
        $que = "SELECT rol FROM guerreros_roles WHERE guerrero_id=$id_guerrero";
        return $this->bd->ObtenerConsulta($que);
    }

    public function addRolById($id_guerrero, $rol)
    {
        $que = "INSERT INTO guerreros_roles(id, guerrero_id, rol)
                VALUES (NULL, $id_guerrero, '$rol')";
        return $this->bd->ejecutar($que);
    }

    public function deleteRolById($id_guerrero, $rol)
    {
        $que = "DELETE FROM guerreros_roles WHERE guerrero_id=$id_guerrero AND rol='$rol'";
        return $this->bd->ejecutar($que);
    }

    public function obtenerHospedajes()
    {
        /*$que="SELECT cg.id,id_guerrero, nombre, 
            confirmado, 
            asistencia,
            hospedaje,  
            sexo,
            habitacion
            FROM campamento_guerreros cg
            INNER JOIN guerreros g ON g.id = cg.id_guerrero
            INNER JOIN campamentos c ON c.id_campamento = cg.id_campamento
            WHERE hospedaje=1 AND c.activo = 1
            ORDER BY habitacion ASC, sexo ASC";*/
        $que = "SELECT * FROM view_hospedajes";
        return $this->bd->ObtenerConsulta($que);
    }

    public function updateHospedaje($id, $habitacion)
    {
        $que = "UPDATE campamento_guerreros SET habitacion = '$habitacion' WHERE id=$id";
        return $this->bd->ejecutar($que);
    }

    public function getUsuarios(){
        $que = "SELECT DISTINCT g.id, nick, email, password FROM ywampach_retourbano.guerreros g
                INNER JOIN ywampach_retourbano.guerreros_roles gr ON g.id = gr.guerrero_id
                -- WHERE (password IS NOT NULL)
                ORDER BY nick;";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getGuerrerosRepetidos(){
        $que = "SELECT email, count(*) count FROM ywampach_retourbano.guerreros g
                WHERE (g.email_tutor='' OR g.email_tutor IS NULL) 
                GROUP BY email
                ORDER BY count(*) DESC, email";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getGuerreroCampamentosByEmail($email){
        $que = "SELECT g.id as guerreroID, cg.id, cg.id_guerrero, cg.id_campamento, nick, nombre, email, email_tutor FROM ywampach_retourbano.guerreros g
                LEFT JOIN ywampach_retourbano.campamento_guerreros cg ON g.id=cg.id_guerrero
                WHERE g.email = '$email' AND (g.email_tutor='' OR g.email_tutor IS NULL) 
                ORDER BY g.id DESC, cg.id_campamento";
        return $this->bd->ObtenerConsulta($que);
    }

    public function getTotoriaByEmail($email){
        $que = "SELECT g.id as guerreroID, cg.id, cg.id_guerrero, cg.id_campamento, nick, nombre, email, email_tutor FROM ywampach_retourbano.guerreros g
                LEFT JOIN ywampach_retourbano.campamento_guerreros cg ON g.id=cg.id_guerrero
                WHERE g.email_tutor = '$email'
                ORDER BY g.id DESC, cg.id_campamento";
        return $this->bd->ObtenerConsulta($que);
    }

    public function updateTutoria($id, $email, $email_tutor)
    {
        $que = "UPDATE ywampach_retourbano.guerreros SET email='$email', email_tutor='$email_tutor' WHERE id=$id";
        return $this->bd->ejecutar($que);
    }
}