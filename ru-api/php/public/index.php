<?php
/**
 * Main API Entry Point (Versioned)
 * 
 * Handles all API requests
 * Routes: /api/v1/*
 * 
 * @version 1.0
 * @author Neitan
 */

// Load bootstrap
require_once __DIR__ . '/bootstrap.php';

// Initialize router
$router = new Router();

// Load routes
require_once __DIR__ . '/routes/api.php';

// Dispatch request
$router->dispatch();
?>
