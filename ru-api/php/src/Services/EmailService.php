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
        $allowRaw = array('reporteResumen', 'reporte');
        foreach ($variables as $key => $value) {
            $replacement = in_array($key, $allowRaw, true)
                ? (string) $value
                : htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
            $html = str_replace('{{' . $key . '}}', $replacement, $html);
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
    public function sendRegistrationEmail($user, $event, $requiresLodging = 0, $reasons = null, $reinscription = false, $dashboard = null)
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
            'banco'         => isset($event->bank_name) ? $event->bank_name : '',
            'cuenta'        => isset($event->bank_account) ? $event->bank_account : '',
            'titularCuenta'  => isset($event->account_holder) ? $event->account_holder : '',
            'pago_minimoMX' => isset($event->minimum_payment_mxn) ? $event->minimum_payment_mxn : '',
            'contacto1'      => isset($event->contact_phone_1) ? $event->contact_phone_1 : '',
            'contacto2'      => isset($event->contact_phone_2) ? $event->contact_phone_2 : '',
        );

        if (is_array($dashboard)) {
            $variables['reporteResumen'] = $this->buildStaffReportSummaryHtml($dashboard);
            $variables['reporte'] = $this->buildStaffReportDetailsHtml($dashboard);
        } else {
            $variables['reporteResumen'] = '';
            $variables['reporte'] = '';
        }

        $subject = 'Bienvenido a Reto Urbano ' . $variables['year'] . ' - ' . $variables['ciudad'];
        $html = $this->renderTemplate('inscripcion.html', $variables);
        $sent = $this->send($to, $subject, $html);

        $staffEmail = isset($event->contact_email) ? trim((string) $event->contact_email) : '';
        if ($staffEmail !== '') {
            $staffHtml = $this->renderTemplate('inscripcion-staff.html', $variables);
            $this->send($staffEmail, '[REPORTE A STAFF][' . $variables['ciudad'] . '] '. ($reinscription ? 'Reinscripcion' : 'Nuevo') . ' a Reto Urbano ' . $variables['year'] . ' - ' . $variables['ciudad'], $staffHtml);
        }

        return $sent;
    }

    private function buildStaffReportSummaryHtml(array $dashboard)
    {
        $summary = isset($dashboard['summary']) && is_array($dashboard['summary']) ? $dashboard['summary'] : array();
        $charts = isset($dashboard['charts']) && is_array($dashboard['charts']) ? $dashboard['charts'] : array();

        $cards = array(
            array('label' => 'Inscritos', 'value' => isset($summary['registered']) ? (int) $summary['registered'] : 0, 'color' => '#2B6CB0', 'bg' => '#EBF8FF'),
            array('label' => 'Disponibles', 'value' => isset($summary['available']) && $summary['available'] !== null ? (int) $summary['available'] : 0, 'color' => '#2F855A', 'bg' => '#F0FFF4'),
            array('label' => 'Capacidad', 'value' => isset($summary['capacity']) ? (int) $summary['capacity'] : 0, 'color' => '#4A5568', 'bg' => '#F7FAFC'),
            array('label' => 'Ocupacion', 'value' => isset($summary['occupancy_percentage']) && $summary['occupancy_percentage'] !== null ? round((float) $summary['occupancy_percentage'], 0) . '%' : '0%', 'color' => '#C05621', 'bg' => '#FFFAF0'),
            array('label' => 'Guerreros', 'value' => $this->countChartItems($charts, 'roles', array('campers', 'Guerreros')), 'color' => '#2D3748', 'bg' => '#EDF2F7'),
            array('label' => 'Staff', 'value' => $this->countChartItems($charts, 'roles', array('staff', 'Staff')), 'color' => '#6B46C1', 'bg' => '#FAF5FF'),
            array('label' => 'Admins', 'value' => $this->countChartItems($charts, 'roles', array('admins', 'Admins')), 'color' => '#553C9A', 'bg' => '#FAF5FF'),
            array('label' => 'Bajas', 'value' => $this->countChartItems($charts, 'roles', array('inactive', 'Bajas')), 'color' => '#C53030', 'bg' => '#FFF5F5'),
            array('label' => 'Hombres', 'value' => $this->countChartItems($charts, 'gender', array('m', 'M', 'Hombres')), 'color' => '#1A365D', 'bg' => '#EBF4FF'),
            array('label' => 'Mujeres', 'value' => $this->countChartItems($charts, 'gender', array('f', 'F', 'Mujeres')), 'color' => '#97266D', 'bg' => '#FFF5F7'),
            array('label' => 'Con hospedaje', 'value' => $this->countChartItems($charts, 'lodging', array('with_lodging', 'Con hospedaje')), 'color' => '#2F855A', 'bg' => '#F0FFF4'),
            array('label' => 'Hospedaje aparte', 'value' => $this->countChartItems($charts, 'lodging', array('without_lodging', 'Hospedaje aparte', 'Sin hospedaje')), 'color' => '#B7791F', 'bg' => '#FFFAF0')
        );

        $html = '<table width="100%" cellpadding="0" cellspacing="0" style="border-collapse:separate;border-spacing:10px 10px;margin:0 -10px;">';
        $totalCards = count($cards);
        for ($index = 0; $index < $totalCards; $index += 4) {
            $html .= '<tr>';
            for ($column = 0; $column < 4; $column++) {
                $cardIndex = $index + $column;
                if ($cardIndex < $totalCards) {
                    $card = $cards[$cardIndex];
                    $html .= '<td width="25%" valign="top"><table width="100%" cellpadding="0" cellspacing="0" style="border-collapse:collapse;background-color:' . $card['bg'] . ';border:1px solid #E2E8F0;border-radius:10px;"><tr><td style="padding:14px 12px;text-align:center;"><div style="font-size:12px;line-height:1.4;color:#718096;text-transform:uppercase;letter-spacing:1px;">' . $card['label'] . '</div><div style="margin-top:6px;font-size:24px;line-height:1.2;color:' . $card['color'] . ';font-weight:700;">' . $card['value'] . '</div></td></tr></table></td>';
                } else {
                    $html .= '<td width="25%"></td>';
                }
            }
            $html .= '</tr>';
        }
        $html .= '</table>';

        return $html;
    }

    private function buildStaffReportDetailsHtml(array $dashboard)
    {
        $summary = isset($dashboard['summary']) && is_array($dashboard['summary']) ? $dashboard['summary'] : array();
        $charts = isset($dashboard['charts']) && is_array($dashboard['charts']) ? $dashboard['charts'] : array();

        $rows = array(
            array('label' => 'Inscritos', 'value' => isset($summary['registered']) ? (int) $summary['registered'] : 0),
            array('label' => 'Disponibles', 'value' => isset($summary['available']) && $summary['available'] !== null ? (int) $summary['available'] : 0),
            array('label' => 'Confirmados', 'value' => isset($summary['confirmed']) ? (int) $summary['confirmed'] : 0),
            array('label' => 'Asistencia confirmada', 'value' => isset($summary['attendance_confirmed']) ? (int) $summary['attendance_confirmed'] : 0),
            array('label' => 'Seguimiento', 'value' => isset($summary['followup']) ? (int) $summary['followup'] : 0),
            array('label' => 'Correo enviado', 'value' => isset($summary['welcome_email_sent']) ? (int) $summary['welcome_email_sent'] : 0),
            array('label' => 'Correo confirmado', 'value' => isset($summary['email_confirmed']) ? (int) $summary['email_confirmed'] : 0),
            array('label' => 'Hospedaje', 'value' => $this->countChartItems($charts, 'lodging', array('with_lodging', 'Con hospedaje')) . ' / ' . $this->countChartItems($charts, 'lodging', array('without_lodging', 'Hospedaje aparte', 'Sin hospedaje'))),
        );

        $html = '<table width="100%" cellpadding="0" cellspacing="0" style="border-collapse:collapse;font-size:14px;">';
        $count = count($rows);
        for ($i = 0; $i < $count; $i++) {
            $row = $rows[$i];
            $background = ($i % 2 === 0) ? '#F7FAFC' : '#FFFFFF';
            $html .= '<tr style="background-color:' . $background . ';"><td style="padding:10px 14px;color:#2D3748;font-weight:700;border-bottom:1px solid #E2E8F0;width:38%;">' . $row['label'] . '</td><td style="padding:10px 14px;color:#4A5568;border-bottom:1px solid #E2E8F0;">' . $row['value'] . '</td></tr>';
        }
        $html .= '</table>';

        return $html;
    }

    private function countChartItems(array $charts, $section, array $keys)
    {
        if (!isset($charts[$section]) || !is_array($charts[$section])) {
            return 0;
        }

        $total = 0;
        foreach ($charts[$section] as $item) {
            $key = isset($item['key']) ? (string) $item['key'] : '';
            if (in_array($key, $keys, true)) {
                $total += isset($item['count']) ? (int) $item['count'] : 0;
            }
        }

        return $total;
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
            $baseUrl = 'https://ywampachuca.org/retourbano';
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
        $variables = array(
            'nick'      => $safeName,
            'resetUrl'  => $resetUrl,
            'expiresAt' => $expiresAt,
        );
        $html = $this->renderTemplate('recovery-password.html', $variables);

        return $this->send($to, $subject, $html);
    }
}
