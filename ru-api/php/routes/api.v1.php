<?php

$authController = new AuthController();
$registrationController = new RegistrationController();

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

$router->add('PATCH', '/api/v1/registrations/status', function ($request) use ($registrationController) {
    return $registrationController->updateStatus($request);
});
