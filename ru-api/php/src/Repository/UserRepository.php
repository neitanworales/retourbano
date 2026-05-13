<?php
/**
 * User Repository
 * 
 * Data access layer for User model
 * 
 * @version 1.0
 * @author Neitan
 */

class UserRepository extends Repository
{
    protected $table = 'guerreros';
    protected $primaryKey = 'id';

    /**
     * Find user by email
     * 
     * @param string $email
     * @return array|null
     */
    public function findByEmail($email)
    {
        return $this->findBy('email', '=', $email);
    }

    /**
     * Find user by nick
     * 
     * @param string $nick
     * @return array|null
     */
    public function findByNick($nick)
    {
        return $this->findBy('nick', '=', $nick);
    }

    /**
     * Check if email exists
     * 
     * @param string $email
     * @param int|null $excludeId
     * @return bool
     */
    public function emailExists($email, $excludeId = null)
    {
        $sql = "SELECT COUNT(*) as total FROM {$this->table} WHERE email = ?";
        $params = [$email];

        if ($excludeId !== null) {
            $sql .= " AND id != ?";
            $params[] = $excludeId;
        }

        $result = $this->connection->fetchOne($sql, $params);
        return ($result['total'] ?? 0) > 0;
    }

    /**
     * Get user with roles
     * 
     * @param int $id
     * @return array|null
     */
    public function getUserWithRoles($id)
    {
        $user = $this->find($id);

        if (!$user) {
            return null;
        }

        // Get roles (if you have a roles table)
        // For now, determine roles from user fields
        $roles = [];
        if ($user['admin'] === 'true' || $user['admin'] === 1) {
            $roles[] = 'admin';
        }
        if ($user['staff'] === 'true' || $user['staff'] === 1) {
            $roles[] = 'staff';
        }
        if (empty($roles)) {
            $roles[] = 'guerrero';
        }

        $user['roles'] = $roles;
        return $user;
    }

    /**
     * Search users by criteria
     * 
     * @param string $searchTerm
     * @param int $limit
     * @return array
     */
    public function search($searchTerm, $limit = 50)
    {
        $searchTerm = "%{$searchTerm}%";
        $sql = "SELECT * FROM {$this->table} WHERE nombre LIKE ? OR email LIKE ? OR nick LIKE ? LIMIT ?";
        return $this->connection->fetchAll($sql, [$searchTerm, $searchTerm, $searchTerm, $limit]);
    }

    /**
     * Get users by status
     * 
     * @param string $status
     * @return array
     */
    public function getUsersByStatus($status)
    {
        return $this->findAllBy('status', '=', $status);
    }

    /**
     * Update user password
     * 
     * @param int $id
     * @param string $hashedPassword
     * @return int
     */
    public function updatePassword($id, $hashedPassword)
    {
        return $this->update($id, ['password' => $hashedPassword]);
    }

    /**
     * Get user fields with formatted boolean values
     * 
     * @param int $id
     * @return array|null
     */
    public function getFormatted($id)
    {
        $user = $this->find($id);

        if (!$user) {
            return null;
        }

        // Convert boolean fields
        $booleanFields = ['staff', 'admin', 'confirmado', 'asistencia', 'seguimiento', 'emailEnviado', 'emailConfirmado', 'hospedaje'];
        foreach ($booleanFields as $field) {
            if (isset($user[$field])) {
                $user[$field] = $user[$field] === 'true' || $user[$field] === 1 ? true : false;
            }
        }

        return $user;
    }
}
?>
