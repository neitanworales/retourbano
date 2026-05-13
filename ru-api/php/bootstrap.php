<?php
/**
 * Bootstrap Application
 * 
 * Loads core dependencies and configurations
 * 
 * @version 1.0
 * @author Neitan
 */

// Environment configuration
define('APP_ENV', getenv('APP_ENV') ?: 'development');
define('APP_DEBUG', getenv('APP_DEBUG') ?: true);

// Load configuration
require_once __DIR__ . '/config/Constants.php';
require_once __DIR__ . '/config/Database.php';

// Load core classes
require_once __DIR__ . '/src/Core/Exception.php';
require_once __DIR__ . '/src/Core/Controller.php';
require_once __DIR__ . '/src/Core/Service.php';
require_once __DIR__ . '/src/Core/Router.php';

// Load database
require_once __DIR__ . '/src/Database/Connection.php';

// Load middleware
require_once __DIR__ . '/src/Middleware/Middleware.php';

// Load repository base
require_once __DIR__ . '/src/Repository/Repository.php';

// Load models
require_once __DIR__ . '/src/Models/User.php';
require_once __DIR__ . '/src/Models/Campamento.php';

// Load repositories
require_once __DIR__ . '/src/Repository/UserRepository.php';
require_once __DIR__ . '/src/Repository/CampamentoRepository.php';

// Load services
require_once __DIR__ . '/src/Services/AuthService.php';
require_once __DIR__ . '/src/Services/RegistrationService.php';

// Load controllers
require_once __DIR__ . '/src/Controllers/AuthController.php';
require_once __DIR__ . '/src/Controllers/RegistrationController.php';

// Set error handling
set_error_handler(function ($errno, $errstr, $errfile, $errline) {
    if (APP_DEBUG) {
        return false; // Let PHP handle it
    }
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'code' => 500,
        'error' => 'INTERNAL_ERROR',
        'message' => 'Internal server error'
    ]);
    exit;
});

// Set exception handler
set_exception_handler(function ($exception) {
    if ($exception instanceof AppException) {
        http_response_code($exception->getHttpCode());
        echo json_encode($exception->toArray());
    } else {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'code' => 500,
            'error' => 'INTERNAL_ERROR',
            'message' => APP_DEBUG ? $exception->getMessage() : 'Internal server error'
        ]);
    }
    exit;
});
?>
