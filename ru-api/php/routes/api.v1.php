<?php

$authController = new AuthController();
$registrationController = new RegistrationController();
$eventController = new EventController();
$cityController = new CityController();
$organizationController = new OrganizationController();
$eventDashboardController = new EventDashboardController();
$userController = new UserController();
$paymentController = new PaymentController();
$lodgingController = new LodgingController();
$accountingController = new AccountingController();
$authGuard = new AuthGuard();

$router->add('POST', '/api/v1/auth/login', function ($request) use ($authController) {
    return $authController->login($request);
});

$router->add('POST', '/api/v1/auth/validate', function ($request) use ($authController) {
    return $authController->validate($request);
});

$router->add('POST', '/api/v1/auth/logout', function ($request) use ($authController) {
    return $authController->logout($request);
});

$router->add('POST', '/api/v1/auth/forgot-password', function ($request) use ($authController) {
    return $authController->forgotPassword($request);
});

$router->add('POST', '/api/v1/auth/validate-reset-token', function ($request) use ($authController) {
    return $authController->validateResetToken($request);
});

$router->add('POST', '/api/v1/auth/reset-password', function ($request) use ($authController) {
    return $authController->resetPassword($request);
});

$router->add('POST', '/api/v1/registrations', function ($request) use ($registrationController) {
    return $registrationController->register($request);
});

$router->add('PUT', '/api/v1/registrations', function ($request) use ($registrationController) {
    return $registrationController->update($request);
});

$router->add('POST', '/api/v1/re-enrollment/request-code', function ($request) use ($registrationController) {
    return $registrationController->requestReenrollmentCode($request);
});

$router->add('GET', '/api/v1/re-enrollment/validate-code', function ($request) use ($registrationController) {
    return $registrationController->validateReenrollmentCode($request);
});

$router->add('PATCH', '/api/v1/registrations/status', function ($request) use ($registrationController, $authGuard) {
    return $authGuard->protect($request, function ($securedRequest) use ($registrationController) {
        return $registrationController->updateStatus($securedRequest);
    });
});

$router->add('POST', '/api/v1/registrations/welcome-email', function ($request) use ($registrationController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($registrationController) {
        return $registrationController->resendWelcomeEmail($securedRequest);
    });
});

$router->add('POST', '/api/v1/registrations/confirmation-email', function ($request) use ($registrationController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($registrationController) {
        return $registrationController->sendConfirmationInfoEmail($securedRequest);
    });
});

$router->add('DELETE', '/api/v1/registrations', function ($request) use ($registrationController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($registrationController) {
        return $registrationController->delete($securedRequest);
    });
});

$router->add('GET', '/api/v1/events', function ($request) use ($eventController) {
    return $eventController->list($request);
});

$router->add('GET', '/api/v1/events/detail', function ($request) use ($eventController) {
    return $eventController->detail($request);
});

$router->add('POST', '/api/v1/events', function ($request) use ($eventController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('admin', 'super'), function ($securedRequest) use ($eventController) {
        return $eventController->create($securedRequest);
    });
});

$router->add('PUT', '/api/v1/events', function ($request) use ($eventController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('admin', 'super'), function ($securedRequest) use ($eventController) {
        return $eventController->update($securedRequest);
    });
});

$router->add('DELETE', '/api/v1/events', function ($request) use ($eventController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('admin', 'super'), function ($securedRequest) use ($eventController) {
        return $eventController->delete($securedRequest);
    });
});

$router->add('GET', '/api/v1/cities', function ($request) use ($cityController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin', 'super'), function ($securedRequest) use ($cityController) {
        return $cityController->list($securedRequest);
    });
});

$router->add('POST', '/api/v1/cities', function ($request) use ($cityController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('admin', 'super'), function ($securedRequest) use ($cityController) {
        return $cityController->create($securedRequest);
    });
});

$router->add('PUT', '/api/v1/cities', function ($request) use ($cityController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('admin', 'super'), function ($securedRequest) use ($cityController) {
        return $cityController->update($securedRequest);
    });
});

$router->add('DELETE', '/api/v1/cities', function ($request) use ($cityController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('admin', 'super'), function ($securedRequest) use ($cityController) {
        return $cityController->delete($securedRequest);
    });
});

$router->add('GET', '/api/v1/organizations', function ($request) use ($organizationController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin', 'super'), function ($securedRequest) use ($organizationController) {
        return $organizationController->list($securedRequest);
    });
});

$router->add('POST', '/api/v1/organizations', function ($request) use ($organizationController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('admin', 'super'), function ($securedRequest) use ($organizationController) {
        return $organizationController->create($securedRequest);
    });
});

$router->add('PUT', '/api/v1/organizations', function ($request) use ($organizationController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('admin', 'super'), function ($securedRequest) use ($organizationController) {
        return $organizationController->update($securedRequest);
    });
});

$router->add('DELETE', '/api/v1/organizations', function ($request) use ($organizationController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('admin', 'super'), function ($securedRequest) use ($organizationController) {
        return $organizationController->delete($securedRequest);
    });
});

$router->add('GET', '/api/v1/events/upcoming-availability', function ($request) use ($eventController, $authGuard) {
    return $authGuard->protect($request, function ($securedRequest) use ($eventController) {
        return $eventController->upcomingAvailability($securedRequest);
    });
});

$router->add('GET', '/api/v1/events/dashboard', function ($request) use ($eventDashboardController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($eventDashboardController) {
        return $eventDashboardController->getByEvent($securedRequest);
    });
});

$router->add('GET', '/api/v1/users/detail', function ($request) use ($userController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($userController) {
        return $userController->detail($securedRequest);
    });
});

$router->add('GET', '/api/v1/users/profile', function ($request) use ($userController, $authGuard) {
    return $authGuard->protect($request, function ($securedRequest) use ($userController) {
        return $userController->profile($securedRequest);
    });
});

$router->add('PATCH', '/api/v1/users/roles', function ($request) use ($userController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('admin'), function ($securedRequest) use ($userController) {
        return $userController->updateRoles($securedRequest);
    });
});

$router->add('PATCH', '/api/v1/users/event-roles', function ($request) use ($userController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('admin'), function ($securedRequest) use ($userController) {
        return $userController->updateEventRoles($securedRequest);
    });
});

$router->add('PATCH', '/api/v1/users/password', function ($request) use ($userController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($userController) {
        return $userController->updatePassword($securedRequest);
    });
});

$router->add('GET', '/api/v1/registrations/detail', function ($request) use ($registrationController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($registrationController) {
        return $registrationController->getById($securedRequest);
    });
});

$router->add('GET', '/api/v1/registrations/by-event', function ($request) use ($registrationController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($registrationController) {
        return $registrationController->getByEvent($securedRequest);
    });
});

$router->add('GET', '/api/v1/registrations/by-user', function ($request) use ($registrationController, $authGuard) {
    return $authGuard->protect($request, function ($securedRequest) use ($registrationController) {
        return $registrationController->getByUser($securedRequest);
    });
});

$router->add('POST', '/api/v1/payments', function ($request) use ($paymentController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($paymentController) {
        return $paymentController->create($securedRequest);
    });
});

$router->add('PATCH', '/api/v1/payments', function ($request) use ($paymentController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($paymentController) {
        return $paymentController->update($securedRequest);
    });
});

$router->add('DELETE', '/api/v1/payments', function ($request) use ($paymentController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($paymentController) {
        return $paymentController->delete($securedRequest);
    });
});

$router->add('GET', '/api/v1/payments/detail', function ($request) use ($paymentController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($paymentController) {
        return $paymentController->getById($securedRequest);
    });
});

$router->add('GET', '/api/v1/payments/by-registration', function ($request) use ($paymentController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($paymentController) {
        return $paymentController->getByRegistration($securedRequest);
    });
});

// Accounting endpoints
$router->add('GET', '/api/v1/accounting/summary', function ($request) use ($accountingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($accountingController) {
        return $accountingController->summary($securedRequest);
    });
});

$router->add('GET', '/api/v1/accounting/payments', function ($request) use ($accountingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($accountingController) {
        return $accountingController->payments($securedRequest);
    });
});

$router->add('GET', '/api/v1/accounting/payments-by-user', function ($request) use ($accountingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($accountingController) {
        return $accountingController->paymentsByUser($securedRequest);
    });
});

$router->add('GET', '/api/v1/accounting/payments-by-description', function ($request) use ($accountingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($accountingController) {
        return $accountingController->paymentsByDescription($securedRequest);
    });
});

$router->add('GET', '/api/v1/accounting/payment-methods', function ($request) use ($accountingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($accountingController) {
        return $accountingController->paymentMethods($securedRequest);
    });
});

$router->add('GET', '/api/v1/accounting/pending-by-user', function ($request) use ($accountingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($accountingController) {
        return $accountingController->pendingByUser($securedRequest);
    });
});

$router->add('GET', '/api/v1/accounting/cashflow', function ($request) use ($accountingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($accountingController) {
        return $accountingController->cashflow($securedRequest);
    });
});

// Lodging endpoints
$router->add('GET', '/api/v1/lodging/registrations', function ($request) use ($lodgingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($lodgingController) {
        return $lodgingController->getRegistrationsByLodging($securedRequest);
    });
});

$router->add('GET', '/api/v1/lodging/rooms', function ($request) use ($lodgingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($lodgingController) {
        return $lodgingController->getRoomsList($securedRequest);
    });
});

$router->add('GET', '/api/v1/lodging/unassigned', function ($request) use ($lodgingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($lodgingController) {
        return $lodgingController->getUnassignedRegistrations($securedRequest);
    });
});

$router->add('PATCH', '/api/v1/lodging/room-assignment', function ($request) use ($lodgingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($lodgingController) {
        return $lodgingController->updateRoomAssignment($securedRequest);
    });
});

$router->add('PATCH', '/api/v1/lodging/lodging-requirement', function ($request) use ($lodgingController, $authGuard) {
    return $authGuard->protectWithRoles($request, array('staff', 'admin'), function ($securedRequest) use ($lodgingController) {
        return $lodgingController->updateLodgingRequirement($securedRequest);
    });
});
