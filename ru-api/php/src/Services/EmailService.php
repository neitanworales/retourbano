<?php

class EmailService
{
    private $templatesPath;
    private $fromAddress = 'Reto Urbano <reto@ywampachuca.org>';

    public function __construct()
    {
        $this->templatesPath = realpath(__DIR__ . '/../../retourbano/emails') . DIRECTORY_SEPARATOR;
    }

    private function renderTemplate($templateName, array $variables)
    {
        $path = $this->templatesPath . $templateName;
        if (!file_exists($path)) {
            error_log('EmailService: template not found: ' . $path);
            return false;
        }

        $html = file_get_contents($path);
        foreach ($variables as $key => $value) {
            $html = str_replace('{{' . $key . '}}', htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8'), $html);
        }
        return $html;
    }

    private function send($to, $subject, $html)
    {
        if (!$to || $html === false) {
            return false;
        }

        $headers = "From: {$this->fromAddress}\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=UTF-8\r\n";

        $sent = @mail($to, $subject, $html, $headers);
        if (!$sent) {
            error_log('EmailService: failed to send to ' . $to . ' | subject: ' . $subject);
        }
        return $sent;
    }

    /**
     * Sends the registration confirmation email to the user
     * and a staff notification to the event contact email.
     */
    public function sendRegistrationEmail($user, $event, $requiresLodging = 0, $reasons = null)
    {
        $to = isset($user->email) ? trim((string) $user->email) : '';
        if ($to === '') {
            return false;
        }

        $hospedaje = (int) $requiresLodging === 1 ? 'Con Hospedaje' : 'Sin Hospedaje';

        $variables = array(
            'year'          => isset($event->event_year) ? $event->event_year : '',
            'ciudad'        => isset($event->city_label) ? $event->city_label : '',
            'titulo'        => isset($event->title) ? $event->title : '',
            'nick'          => isset($user->display_name) ? $user->display_name : '',
            'nombre'        => isset($user->full_name) ? $user->full_name : '',
            'fechanac'      => isset($user->birth_date) ? $user->birth_date : '',
            'edad'          => isset($user->age) ? $user->age : '',
            'sexo'          => isset($user->gender) ? $user->gender : '',
            'talla'         => isset($user->shirt_size) ? $user->shirt_size : '',
            'hospedaje'     => $hospedaje,
            'vienesDe'      => isset($user->coming_from) ? $user->coming_from : '',
            'alergias'      => isset($user->allergies) ? $user->allergies : '',
            'razones'       => $reasons !== null ? $reasons : '',
            'iglesia'       => isset($user->church) ? $user->church : '',
            'email'         => $to,
            'whatsapp'      => isset($user->whatsapp) ? $user->whatsapp : '',
            'telefono'      => isset($user->phone) ? $user->phone : '',
            'facebook'      => isset($user->facebook) ? $user->facebook : '',
            'instagram'     => isset($user->instagram) ? $user->instagram : '',
            'medicamentos'  => isset($user->medications) ? $user->medications : '',
            'tutorNombre'   => isset($user->guardian_name) ? $user->guardian_name : '',
            'tutorTelefono' => isset($user->guardian_phone) ? $user->guardian_phone : '',
        );

        $subject = 'Bienvenido a Reto Urbano ' . $variables['year'] . ' - ' . $variables['ciudad'];
        $html = $this->renderTemplate('inscripcion.html', $variables);
        $sent = $this->send($to, $subject, $html);

        $staffEmail = isset($event->contact_email) ? trim((string) $event->contact_email) : '';
        if ($staffEmail !== '') {
            $staffHtml = $this->renderTemplate('inscripcion-staff.html', $variables);
            $this->send($staffEmail, '[NUEVO GUERRERO] ' . $subject, $staffHtml);
        }

        return $sent;
    }

    /**
     * Sends the re-enrollment verification code email.
     */
    public function sendReenrollmentEmail($user, $event, $code)
    {
        $to = isset($user->email) ? trim((string) $user->email) : '';
        if ($to === '') {
            return false;
        }

        $baseUrl = getenv('REENROLLMENT_URL_BASE');
        if (!$baseUrl) {
            $baseUrl = 'https://ywampachuca.org/retourbano/reinscripcion';
        }

        $eventId = ($event && isset($event->id)) ? (int) $event->id : 0;

        $variables = array(
            'nick'          => isset($user->display_name) && trim((string) $user->display_name) !== ''
                                ? $user->display_name
                                : (isset($user->full_name) ? $user->full_name : 'participante'),
            'year'          => ($event && isset($event->event_year)) ? $event->event_year : '',
            'titulo'        => ($event && isset($event->title)) ? $event->title : '',
            'ciudad'        => ($event && isset($event->city_label)) ? $event->city_label : '',
            'codigo'        => $code,
            'basesite'      => $baseUrl,
            'id_campamento' => $eventId,
        );

        $html = $this->renderTemplate('reinscripcion.html', $variables);
        $subject = 'Reinscripcion Reto Urbano - Codigo de verificacion';
        return $this->send($to, $subject, $html);
    }

    /**
     * Sends a secure token-based password reset email.
     */
    public function sendPasswordResetEmail($user, $resetUrl, $expiresAt)
    {
        $to = isset($user->email) ? trim((string) $user->email) : '';
        if ($to === '') {
            return false;
        }

        $safeName = isset($user->display_name) && trim((string) $user->display_name) !== ''
            ? trim((string) $user->display_name)
            : (isset($user->full_name) ? trim((string) $user->full_name) : 'participante');

        $subject = 'Recuperacion de contrasena - Reto Urbano';
        $html = '<html><body style="font-family: Arial, sans-serif; color: #222;">'
            . '<h2>Recuperacion de contrasena</h2>'
            . '<p>Hola ' . htmlspecialchars($safeName, ENT_QUOTES, 'UTF-8') . ',</p>'
            . '<p>Recibimos una solicitud para restablecer tu contrasena.</p>'
            . '<p><a href="' . htmlspecialchars($resetUrl, ENT_QUOTES, 'UTF-8') . '">Haz clic aqui para cambiar tu contrasena</a></p>'
            . '<p>Este enlace expira el: <strong>' . htmlspecialchars($expiresAt, ENT_QUOTES, 'UTF-8') . '</strong></p>'
            . '<p>Si no solicitaste este cambio, puedes ignorar este correo.</p>'
            . '<p>Equipo Reto Urbano</p>'
            . '</body></html>';

        return $this->send($to, $subject, $html);
    }
}
