<?php
/**
 * Application Constants
 * 
 * @version 1.0
 * @author Neitan
 */

// Environment
define('APP_ENV', getenv('APP_ENV') ?: 'development');
define('APP_DEBUG', getenv('APP_DEBUG') ?: true);
define('APP_VERSION', '1.0.0');

// API
define('API_VERSION', 'v1');
define('API_URL', 'http://localhost:8000');

// Response codes
define('HTTP_OK', 200);
define('HTTP_CREATED', 201);
define('HTTP_BAD_REQUEST', 400);
define('HTTP_UNAUTHORIZED', 401);
define('HTTP_FORBIDDEN', 403);
define('HTTP_NOT_FOUND', 404);
define('HTTP_CONFLICT', 409);
define('HTTP_UNPROCESSABLE_ENTITY', 422);
define('HTTP_INTERNAL_SERVER_ERROR', 500);

// User roles
define('ROLE_GUERRERO', 'guerrero');
define('ROLE_STAFF', 'staff');
define('ROLE_ADMIN', 'admin');

// Status
define('STATUS_ACTIVE', 'active');
define('STATUS_INACTIVE', 'inactive');
define('STATUS_PENDING', 'pending');

// Token expiry (in seconds, default 24 hours)
define('TOKEN_EXPIRY', 86400);
?>
