<?php
/**
 * Base Controller Class
 * 
 * Provides common HTTP response methods
 * 
 * @version 1.0
 * @author Neitan
 */

abstract class Controller
{
    protected $statusCode = 200;

    /**
     * Send JSON response
     * 
     * @param mixed $data
     * @param int $statusCode
     * @param string $message
     * @return void
     */
    public function success($data = null, $statusCode = 200, $message = 'Success')
    {
        http_response_code($statusCode);
        echo json_encode([
            'success' => true,
            'code' => $statusCode,
            'message' => $message,
            'data' => $data
        ]);
    }

    /**
     * Send error response
     * 
     * @param string $message
     * @param int $statusCode
     * @param string $errorCode
     * @param array $errors
     * @return void
     */
    public function error($message = 'Error', $statusCode = 500, $errorCode = 'ERROR', $errors = [])
    {
        http_response_code($statusCode);
        echo json_encode([
            'success' => false,
            'code' => $statusCode,
            'error' => $errorCode,
            'message' => $message,
            'errors' => !empty($errors) ? $errors : null
        ]);
    }

    /**
     * Send created response
     * 
     * @param mixed $data
     * @param string $message
     * @return void
     */
    public function created($data = null, $message = 'Resource created successfully')
    {
        $this->success($data, 201, $message);
    }

    /**
     * Send validation error response
     * 
     * @param array $errors
     * @param string $message
     * @return void
     */
    public function validationError($errors = [], $message = 'Validation failed')
    {
        $this->error($message, 422, 'VALIDATION_ERROR', $errors);
    }

    /**
     * Send not found response
     * 
     * @param string $message
     * @return void
     */
    public function notFound($message = 'Resource not found')
    {
        $this->error($message, 404, 'NOT_FOUND');
    }

    /**
     * Send unauthorized response
     * 
     * @param string $message
     * @return void
     */
    public function unauthorized($message = 'Unauthorized')
    {
        $this->error($message, 401, 'UNAUTHORIZED');
    }

    /**
     * Send forbidden response
     * 
     * @param string $message
     * @return void
     */
    public function forbidden($message = 'Access denied')
    {
        $this->error($message, 403, 'FORBIDDEN');
    }

    /**
     * Get JSON request body
     * 
     * @return array
     */
    public function getInput()
    {
        $input = file_get_contents('php://input');
        return json_decode($input, true) ?? [];
    }

    /**
     * Get URL parameter
     * 
     * @param string $key
     * @param mixed $default
     * @return mixed
     */
    public function getParam($key, $default = null)
    {
        return $_GET[$key] ?? $default;
    }

    /**
     * Get POST parameter
     * 
     * @param string $key
     * @param mixed $default
     * @return mixed
     */
    public function postParam($key, $default = null)
    {
        return $_POST[$key] ?? $default;
    }
}
?>
