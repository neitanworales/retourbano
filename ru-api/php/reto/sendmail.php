<?php

enviarEmail('2018','San Benito','del Toribio','','neitan.morales@gmail.com','contrasena','2342524234','username','29/10/1987','4234253453');



function enviarEmail($ano,$nombre,$apellido,$alias,$email,$contrasena,$tel,$username,$fecha_nac,$tel_tutor){
        $headers = "From: reto@ywampachuca.org\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=UTF-8\r\n";

        $message=getMessage($nombre);
        if(mail ($email , 'Jucum Pachuca, RETO SEGUIMIENTO', $this->getMensajePersona() ,$headers))
        {
            
        }
        if(mail ('reto@ywampachuca.org' , 'Nuevo Inscrito', $this->getMensajeStaff() ,$headers))
        {
            
        }
        header("Location:../../retourbano/registro.php?pasa=1&nombre=$nombre");
        exit();
    }

    function getMensajePersona($ano,$nombre,$apellido,$alias,$email,$contrasena,$tel,$username,$fecha_nac,$tel_tutor){
        return '<div dir="ltr">
        <font face="arial, helvetica, sans-serif" size="4">Hola, '.$nombre.'!</font>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">
                <br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">Te has inscrito correctamente a<b> RETO SEGUIMIENTO 2018-2019</b></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">Estos son tus datos de registro:</font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><b>Nombre completo: </b>'.$nombre.' '.$apellido.'o</font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><b>Fecha de Nacimiento: </b>'.$fecha_nac.'</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Email:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$email.'</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Teléfono:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$tel.'</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Contacto tutor:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$tel_tutor.'</font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">Los datos a continuación son importantes para tu ingreso a nuestra plataforma, no los pierdas:</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Usuario:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$username.'</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Contraseña:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$contrasena.'</font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">Nos vemos en el primer seguimiento!&nbsp;<br>Un abrazo y estaremos orando por ti!<br><br>Atentamente<br>Liderazgo
                de RETO</font>
        </div>
    </div>';
    }

    function getMensajeStaff($ano,$nombre,$apellido,$alias,$email,$contrasena,$tel,$username,$fecha_nac,$tel_tutor){
        return '<div dir="ltr">
        <font face="arial, helvetica, sans-serif" size="4">Hola!</font>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">
                <br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">Hay un nuevo inscrito a<b> RETO SEGUIMIENTO 2018-2019</b></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">Estos son sus datos de registro:</font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><b>Nombre completo: </b>'.$nombre.' '.$apellido.'o</font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><b>Fecha de Nacimiento: </b>'.$fecha_nac.'</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Email:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$email.'</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Teléfono:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$tel.'</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Contacto tutor:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$tel_tutor.'</font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">Los datos a continuación son importantes para tu ingreso a nuestra plataforma, no los pierdas:</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Usuario:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$username.'</font>
        </div>
        <div><b><font face="arial, helvetica, sans-serif" size="4">Contraseña:&nbsp;</font></b><font face="arial, helvetica, sans-serif"
                size="4">'.$contrasena.'</font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4"><br></font>
        </div>
        <div>
            <font face="arial, helvetica, sans-serif" size="4">Le dije que: Nos vemos en el primer seguimiento!&nbsp;<br>Un abrazo y estaremos orando por ti!<br><br>Atentamente<br>Liderazgo
                de RETO</font>
                <p><font face="arial, helvetica, sans-serif" size="4">Atentamente... Neitan Morales... Correo Generado automáticamente.</font></p>
        </div>
    </div>';
    }

    ?>