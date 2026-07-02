<?php

require_once __DIR__ . '/../Models/EventRegistration.php';
require_once __DIR__ . '/../Repository/EventRepository.php';
require_once __DIR__ . '/../Repository/EventRegistrationRepository.php';
require_once __DIR__ . '/../Repository/PaymentRepository.php';
require_once __DIR__ . '/../Repository/UserRepository.php';
require_once __DIR__ . '/../Repository/UserRoleRepository.php';
require_once __DIR__ . '/EventDashboardService.php';
require_once __DIR__ . '/EmailService.php';

class RegistrationService
{
    private $events;
    private $registrations;
    private $payments;
    private $users;
    private $userRoles;
    private $dashboard;
    private $email;

    public function __construct()
    {
        $this->events = new EventRepository();
        $this->registrations = new EventRegistrationRepository();
        $this->payments = new PaymentRepository();
        $this->users = new UserRepository();
        $this->userRoles = new UserRoleRepository();
        $this->dashboard = new EventDashboardService();
        $this->email = new EmailService();
    }

    public function register($userId, $eventId, $requiresLodging = 0, $roomCode = null, $reasons = null, $reinscription = false)
    {
        $event = $this->events->findModelById((int) $eventId);
        if (!$event) {
            return array('error' => 'Event not found');
        }

        if ((int) $event->is_active !== 1) {
            return array('error' => 'Event is not active');
        }

        $existing = $this->registrations->findByEventAndUser((int) $eventId, (int) $userId);
        if ($existing) {
            return array('error' => 'User is already registered for this event', 'registration_id' => (int) $existing->id);
        }

        $registration = new EventRegistration(array(
            'reinscription' => (int) $reinscription,
            'event_id' => (int) $eventId,
            'user_id' => (int) $userId,
            'event_year' => $event->event_year,
            'registration_status' => 'A',
            'is_confirmed' => 0,
            'attendance_confirmed' => 0,
            'is_staff' => 0,
            'is_admin' => 0,
            'is_followup' => 0,
            'welcome_email_sent' => 0,
            'email_confirmed' => 0,
            'requires_lodging' => (int) $requiresLodging,
            'room_code' => $roomCode,
            'reasons' => $reasons,
        ));

        $id = $this->registrations->create($registration);

        $user = $this->users->findModelById((int) $userId);
        if ($user) {
            $dashboardData = $this->dashboard->getByEvent((int) $eventId);
            if (!is_array($dashboardData) || (isset($dashboardData['error']) && $dashboardData['error'])) {
                $dashboardData = null;
            }

            $emailSent = $this->email->sendRegistrationEmail($user, $event, $requiresLodging, $reasons, $reinscription, $dashboardData) ? 1 : 0;
            if ($emailSent) {
                $this->registrations->incrementWelcomeEmailSent((int) $id);
            }
        }

        return array(
            'id' => (int) $id,
            'event_id' => (int) $eventId,
            'user_id' => (int) $userId,
            'registration_status' => 'A',
        );
    }

    public function updateStatus($registrationId, $status)
    {
        return $this->registrations->updateStatus((int) $registrationId, $status);
    }

    public function updateFields($registrationId, $fields)
    {
        return $this->registrations->updateFields((int) $registrationId, is_array($fields) ? $fields : array());
    }

    public function sendWelcomeEmail($registrationId)
    {
        $registration = $this->registrations->findModelById((int) $registrationId);
        if (!$registration) {
            return array('error' => 'registration not found');
        }

        $event = $this->events->findModelById((int) $registration->event_id);
        if (!$event) {
            return array('error' => 'event not found');
        }

        $user = $this->users->findModelById((int) $registration->user_id);
        if (!$user) {
            return array('error' => 'user not found');
        }

        $dashboardData = $this->dashboard->getByEvent((int) $registration->event_id);
        if (!is_array($dashboardData) || (isset($dashboardData['error']) && $dashboardData['error'])) {
            $dashboardData = null;
        }

        $sent = $this->email->sendRegistrationEmail(
            $user,
            $event,
            isset($registration->requires_lodging) ? (int) $registration->requires_lodging : 0,
            isset($registration->reasons) ? $registration->reasons : null,
            isset($registration->reinscription) ? (int) $registration->reinscription === 1 : false,
            $dashboardData
        );

        if (!$sent) {
            return array('error' => 'could not send welcome email');
        }

        $welcomeEmailSentCount = $this->registrations->incrementWelcomeEmailSent((int) $registrationId);
        if ($welcomeEmailSentCount === false) {
            return array('error' => 'could not update welcome email counter');
        }

        return array(
            'registration_id' => (int) $registrationId,
            'welcome_email_sent' => (int) $welcomeEmailSentCount,
        );
    }

    public function sendConfirmationInfoEmail($registrationId)
    {
        $registration = $this->registrations->findModelById((int) $registrationId);
        if (!$registration) {
            return array('error' => 'registration not found');
        }

        $event = $this->events->findModelById((int) $registration->event_id);
        if (!$event) {
            return array('error' => 'event not found');
        }

        $user = $this->users->findModelById((int) $registration->user_id);
        if (!$user) {
            return array('error' => 'user not found');
        }

        $sent = $this->email->sendEventInfoConfirmationEmail($user, $event);
        if (!$sent) {
            return array('error' => 'could not send confirmation email');
        }

        $confirmationEmailSentCount = $this->registrations->incrementConfirmationEmailSent((int) $registrationId);
        if ($confirmationEmailSentCount === false) {
            return array('error' => 'could not update email counter');
        }

        return array(
            'registration_id' => (int) $registrationId,
            'email_sent' => true,
            'email_confirmed' => (int) $confirmationEmailSentCount,
            'confirmation_email_sent' => (int) $confirmationEmailSentCount,
        );
    }

    public function delete($registrationId)
    {
        $registration = $this->registrations->findModelById((int) $registrationId);
        if (!$registration) {
            return array('error' => 'registration not found');
        }

        $userId = isset($registration->user_id) ? (int) $registration->user_id : 0;

        $this->payments->deleteByRegistrationId((int) $registrationId);
        $deleted = $this->registrations->deleteById((int) $registrationId);
        if (!$deleted) {
            return array('error' => 'could not delete registration');
        }

        if ($userId > 0) {
            $shouldHaveStaffRole = $this->registrations->userHasAnyStaffRegistration($userId);
            $shouldHaveAdminRole = $this->registrations->userHasAnyAdminRegistration($userId);

            if ($shouldHaveStaffRole) {
                $this->userRoles->addRoles($userId, array('staff'));
            } else {
                $this->userRoles->removeRoles($userId, array('staff'));
            }

            if ($shouldHaveAdminRole) {
                $this->userRoles->addRoles($userId, array('admin'));
            } else {
                $this->userRoles->removeRoles($userId, array('admin'));
            }
        }

        return array(
            'registration_id' => (int) $registrationId,
            'deleted' => true,
        );
    }

    public function getById($registrationId)
    {
        return $this->registrations->findModelById((int) $registrationId);
    }

    public function getByEvent($eventId, $limit = 100, $offset = 0, $filters = array())
    {
        return $this->registrations->findByEvent((int) $eventId, (int) $limit, (int) $offset, $filters);
    }

    public function getByUser($userId, $limit = 100, $offset = 0, $includeActive = false)
    {
        return $this->registrations->findByUser((int) $userId, (int) $limit, (int) $offset, (bool) $includeActive);
    }
}
