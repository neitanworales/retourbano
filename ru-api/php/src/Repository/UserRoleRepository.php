<?php

require_once __DIR__ . '/BaseRepository.php';

class UserRoleRepository extends BaseRepository
{
    protected $table = 'user_roles';

    public function getRolesByUserId($userId)
    {
        $sql = 'SELECT role FROM user_roles WHERE user_id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $userId);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return strtolower(trim((string) $row['role']));
        }, $rows);
    }
}
