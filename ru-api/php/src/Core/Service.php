<?php
/**
 * Base Service Class
 * 
 * Provides common business logic patterns
 * 
 * @version 1.0
 * @author Neitan
 */

abstract class Service
{
    protected $repository;

    /**
     * Initialize service with repository
     * 
     * @param Repository $repository
     */
    public function __construct(Repository $repository)
    {
        $this->repository = $repository;
    }

    /**
     * Get repository instance
     * 
     * @return Repository
     */
    public function getRepository()
    {
        return $this->repository;
    }

    /**
     * Validate required fields
     * 
     * @param array $data
     * @param array $required
     * @return array Errors array (empty if valid)
     */
    protected function validateRequired($data, $required)
    {
        $errors = [];

        foreach ($required as $field) {
            if (empty($data[$field])) {
                $errors[$field] = "The {$field} field is required";
            }
        }

        return $errors;
    }

    /**
     * Validate email format
     * 
     * @param string $email
     * @return bool
     */
    protected function validateEmail($email)
    {
        return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
    }

    /**
     * Validate field length
     * 
     * @param string $field
     * @param int $minLength
     * @param int $maxLength
     * @return bool
     */
    protected function validateLength($field, $minLength = 0, $maxLength = 255)
    {
        $length = strlen($field);
        return $length >= $minLength && $length <= $maxLength;
    }
}
?>
