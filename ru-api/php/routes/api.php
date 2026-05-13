<?php
/**
 * API Routes Definition
 * 
 * Define all API endpoints
 * 
 * @version 1.0
 * @author Neitan
 */

// CORS Middleware
$router->middleware(['CorsMiddleware']);

// =================================
// V1 API Routes
// =================================

// Authentication Routes
$router->post('/api/v1/auth/login', 'AuthController@login');
$router->post('/api/v1/auth/register', 'AuthController@register');
$router->post('/api/v1/auth/logout', 'AuthController@logout');
$router->post('/api/v1/auth/forgot-password', 'AuthController@forgotPassword');
$router->post('/api/v1/auth/reset-password', 'AuthController@resetPassword');
$router->put('/api/v1/auth/change-password', 'AuthController@changePassword');

// Registration Routes
$router->post('/api/v1/registration/register', 'RegistrationController@register');
$router->get('/api/v1/registration/profile/{id}', 'RegistrationController@getProfile');
$router->put('/api/v1/registration/profile/{id}', 'RegistrationController@updateProfile');
$router->post('/api/v1/registration/reregister', 'RegistrationController@reregister');
$router->post('/api/v1/registration/confirm-email', 'RegistrationController@confirmEmail');
$router->get('/api/v1/registration/my-registrations/{id}', 'RegistrationController@getRegistrations');

// TODO: Add more routes for other features
// $router->get('/api/v1/campamentos', 'CampamentoController@list');
// $router->get('/api/v1/campamentos/{id}', 'CampamentoController@show');
// $router->post('/api/v1/attendance/register', 'AttendanceController@register');
// etc...

// Health check endpoint
$router->get('/api/v1/health', function () {
    echo json_encode([
        'success' => true,
        'message' => 'API is running',
        'version' => API_VERSION,
        'timestamp' => date('Y-m-d H:i:s')
    ]);
});
?>
