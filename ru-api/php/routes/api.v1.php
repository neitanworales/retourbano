<?php

$authController = new AuthController();
$registrationController = new RegistrationController();
$eventController = new EventController();
$userController = new UserController();
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

$router->add('POST', '/api/v1/auth/reset-password', function ($request) use ($authController) {
    return $authController->resetPassword($request);
});

$router->add('POST', '/api/v1/registrations', function ($request) use ($registrationController) {
    return $registrationController->register($request);
});

$router->add('PATCH', '/api/v1/registrations/status', function ($request) use ($registrationController, $authGuard) {
    return $authGuard->protect($request, function ($securedRequest) use ($registrationController) {
        return $registrationController->updateStatus($securedRequest);
    });
});

$router->add('GET', '/api/v1/events', function ($request) use ($eventController) {
    return $eventController->list($request);
});

$router->add('GET', '/api/v1/events/detail', function ($request) use ($eventController) {
    return $eventController->detail($request);
});

$router->add('GET', '/api/v1/events/upcoming-availability', function ($request) use ($eventController, $authGuard) {
    return $authGuard->protect($request, function ($securedRequest) use ($eventController) {
        return $eventController->upcomingAvailability($securedRequest);
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
