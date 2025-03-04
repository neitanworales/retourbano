<?php

/**
 * Db short summary.
 *
 * Db description.
 *
 * @version 1.0
 * @author Neitan
 */
class Db
{
    private $servidor;
    private $usuario;
    private $password;
    private $base_datos;
    private $link;
    private $stmt;
    private $array;

    static $_instance;

    /*La funci n construct es privada para evitar que el objeto pueda ser creado mediante new*/
    private function __construct($proyecto){
        $this->setConexion($proyecto);
        $this->conectar();
    }

    /*M todo para establecer los par metros de la conexi n*/
    private function setConexion($proyecto){
        require 'Conf.class.php';
        $conf = Conf::getInstance($proyecto);
        $this->servidor=$conf->getHostDB();
        $this->base_datos=$conf->getDB();
        $this->usuario=$conf->getUserDB();
        $this->password=$conf->getPassDB();
    }

    /*Evitamos el clonaje del objeto. Patr n Singleton*/
    private function __clone(){ }

    /*Funci n encargada de crear, si es necesario, el objeto. Esta es la funci n que debemos llamar desde fuera de la clase para instanciar el objeto, y as , poder utilizar sus m todos*/
    public static function getInstance($proyecto){
        if (!(self::$_instance instanceof self)){
            self::$_instance=new self($proyecto);
        }
        return self::$_instance;
    }

    /*Realiza la conexi n a la base de datos.*/
    private function conectar(){
        $this->link= new mysqli($this->servidor, $this->usuario, $this->password, $this->base_datos);
        $this->link->set_charset("utf8");
    }

    /*M todo para ejecutar una sentencia sql*/
    public function ejecutar($sql){
        $this->stmt=mysqli_query($this->link,$sql);
        return $this->stmt;
    }

    public function ejecutarPlus($sql){
        mysqli_query($this->link,$sql);
        return mysqli_insert_id($this->link);
    }

    /*M todo para obtener una fila de resultados de la sentencia sql*/
    public function obtener_fila($stmt,$fila){
        if ($fila==0){
            $this->array=mysql_fetch_array($stmt);
        }else{
            mysql_data_seek($stmt,$fila);
            $this->array=mysql_fetch_array($stmt);
        }
        return $this->array;
    }

    //Devuelve el  ltimo id del insert introducido
    public function lastID(){
        return mysql_insert_id($this->link);
    }

    public function ObtenerConsulta($query)
    {
        $arreglo = array();
        $i = 0;		
        $res=mysqli_query($this->link,$query);
        if($res) {
            while ($fila =  mysqli_fetch_assoc($res)) 
            {
                $keys = array_keys($fila);
                foreach($keys as $key)
                    $arreglo[$i][$key]=$fila[$key];
                $i++;			
            }
        }
        return $arreglo;
    }

    public function ObtenerConsultaResource($query)
    {
        $res = mysql_query($query) or die(mysql_error());       
        return $res;
    }
}