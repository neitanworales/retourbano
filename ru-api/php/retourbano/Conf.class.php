<?php

/**
 * Coneccion short summary.
 *
 * Clase que funciona para conectarnos a la base de datos.
 *
 * @version 1.0
 * @author Neitan
 */
class Conf
{
    private $_domain;
    private $_userdb;
    private $_passdb;
    private $_hostdb;
    private $_db;

    static $_instance;

    private function __construct($proyecto){
        require 'config.php';

        switch($proyecto)
        {            
            case '1':
                $this->_userdb=$user_1;
                $this->_passdb=$password_1;
                $this->_hostdb=$host_1;
                $this->_db=$db_1;
                break;                        
        }
    }

    private function __clone(){ }

    public static function getInstance($proyecto){
        if (!(self::$_instance instanceof self)){
            self::$_instance=new self($proyecto);
        }
        return self::$_instance;
    }

    public function getUserDB(){
        $var=$this->_userdb;
        return $var;
    }

    public function getHostDB(){
        $var=$this->_hostdb;
        return $var;
    }

    public function getPassDB(){
        $var=$this->_passdb;
        return $var;
    }

    public function getDB(){
        $var=$this->_db;
        return $var;
    }
}