<?php
/**
 * Custom Application Exception
 * 
 * @version 1.0
 * @author Neitan
 */

class AppException extends Exception
{
    protected $httpCode;
    protected $errorCode;

    public function __construct(
        $message = "An error occurred",
        $httpCode = 500,
        $errorCode = 'INTERNAL_ERROR',
        Exception $previous = null
    ) {
        parent::__construct($message, 0, $previous);
        $this->httpCode = $httpCode;
        $this->errorCode = $errorCode;
    }

    public function getHttpCode()
    {
        return $this->httpCode;
    }

    public function getErrorCode()
    {
        return $this->errorCode;
    }

    public function toArray()
    {
        return [
            'success' => false,
            'error' => $this->errorCode,
            'message' => $this->message,
            'code' => $this->httpCode
        ];
    }
}

/**
 * Validation Exception
 */
class ValidationException extends AppException
{
    public function __construct($message = "Validation failed", $errors = [])
    {
        parent::__construct($message, 422, 'VALIDATION_ERROR');
        $this->errors = $errors;
    }

    public function toArray()
    {
        return array_merge(parent::toArray(), [
            'errors' => $this->errors ?? []
        ]);
    }
}

/**
 * Authentication Exception
 */
class AuthenticationException extends AppException
{
    public function __construct($message = "Authentication failed")
    {
        parent::__construct($message, 401, 'AUTHENTICATION_ERROR');
    }
}

/**
 * Authorization Exception
 */
class AuthorizationException extends AppException
{
    public function __construct($message = "Access denied")
    {
        parent::__construct($message, 403, 'AUTHORIZATION_ERROR');
    }
}

/**
 * Not Found Exception
 */
class NotFoundException extends AppException
{
    public function __construct($message = "Resource not found")
    {
        parent::__construct($message, 404, 'NOT_FOUND');
    }
}

/**
 * Resource Already Exists Exception
 */
class ResourceExistsException extends AppException
{
    public function __construct($message = "Resource already exists")
    {
        parent::__construct($message, 409, 'CONFLICT');
    }
}
?>
