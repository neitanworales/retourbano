<?php

/**
 * Datos short summary.
 *
 * Datos description.
 *
 * @version 1.0
 * @author Neitan
 */
class EnviarEmail
{
    static $_instance;

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

    public function getTemplate($variables, $templateName)
    {
        $templateName="https://ywampachuca.org/php/retourbano/emails/".$templateName;
        $arrContextOptions = array(
            "ssl" => array(
                "verify_peer" => false,
                "verify_peer_name" => false,
            ),
        );
        $template = file_get_contents($templateName, false, stream_context_create($arrContextOptions));
        foreach ($variables as $key => $value) {
            $template = str_replace('{{' . $key . '}}', $value, $template);
        }
        return $template;
    }

    public function enviarEmail($to, $subject, $message, $reenviarStaff)
    {
        $headers = "From: Reto Urbano <reto@ywampachuca.org>\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
        $enviado = mail($to, $subject, $message, $headers);
        if($reenviarStaff){
            $reenviarStaff->reportarStaff($subject, $message);
        }
        return $enviado;
    }

    public function reportarStaff($subject, $message){
        $headers = "From: Avisos Staff RU <reto@ywampachuca.org>\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
        $subject = '[REPORTE A STAFF] '.$subject;
        $enviado = mail('reto@ywampachuca.org', $subject, $message, $headers);
        return $enviado;
    }

}