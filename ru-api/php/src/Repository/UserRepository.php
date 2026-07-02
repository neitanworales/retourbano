<?php

require_once __DIR__ . '/BaseRepository.php';
require_once __DIR__ . '/../Models/User.php';

class UserRepository extends BaseRepository
{
    protected $table = 'users';

    public function findManyModels($limit = 100, $offset = 0)
    {
        $rows = $this->findAll($limit, $offset);

        return array_map(function ($row) {
            return new User($row);
        }, $rows);
    }

    public function findManageableUsers($limit = 100, $offset = 0, $search = '')
    {
        $search = trim((string) $search);
        $hasSearch = $search !== '';
        $searchLike = '%' . $search . '%';

        $sql = "SELECT u.*
                FROM users u
                WHERE (
                    u.password_hash IS NOT NULL AND TRIM(u.password_hash) <> ''
                )
                OR EXISTS (
                    SELECT 1
                    FROM user_roles ur
                    WHERE ur.user_id = u.id
                      AND ur.role IN ('staff', 'admin')
                )";

        if ($hasSearch) {
            $sql .= " AND (
                    u.full_name LIKE ?
                    OR u.display_name LIKE ?
                    OR u.email LIKE ?
                )";
        }

        $sql .= "
                ORDER BY u.full_name ASC, u.id ASC
                LIMIT ? OFFSET ?";

        $stmt = $this->db->prepare($sql);

        if ($hasSearch) {
            $stmt->bind_param('sssii', $searchLike, $searchLike, $searchLike, $limit, $offset);
        } else {
            $stmt->bind_param('ii', $limit, $offset);
        }

        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new User($row);
        }, $rows);
    }

    public function findUsersWithEventHistory($limit = 100, $offset = 0, $search = '')
    {
        $search = trim((string) $search);
        $hasSearch = $search !== '';
        $searchLike = '%' . $search . '%';

        $sql = "SELECT u.*, stats.attendance_count, stats.last_registration_at
                FROM users u
                INNER JOIN (
                    SELECT er.user_id,
                           COUNT(DISTINCT er.event_id) AS attendance_count,
                           MAX(COALESCE(er.created_at, '1970-01-01 00:00:00')) AS last_registration_at
                    FROM event_registrations er
                    GROUP BY er.user_id
                ) stats ON stats.user_id = u.id";

        if ($hasSearch) {
            $sql .= "
                WHERE (
                    u.full_name LIKE ?
                    OR u.display_name LIKE ?
                    OR u.email LIKE ?
                )";
        }

        $sql .= "
                ORDER BY stats.attendance_count DESC, stats.last_registration_at DESC, u.full_name ASC, u.id ASC
                LIMIT ? OFFSET ?";

        $stmt = $this->db->prepare($sql);

        if ($hasSearch) {
            $stmt->bind_param('sssii', $searchLike, $searchLike, $searchLike, $limit, $offset);
        } else {
            $stmt->bind_param('ii', $limit, $offset);
        }

        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new User($row);
        }, $rows);
    }

    public function findModelById($id)
    {
        $row = $this->findById($id);
        return $row ? new User($row) : null;
    }

    public function findByLegacyId($legacyId)
    {
        $sql = 'SELECT * FROM users WHERE legacy_user_id = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $legacyId);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? new User($row) : null;
    }

    public function findByEmail($email)
    {
        $sql = 'SELECT * FROM users WHERE email = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? new User($row) : null;
    }

    public function findByVerificationCode($code)
    {
        $sql = 'SELECT * FROM users WHERE verification_code = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('s', $code);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? new User($row) : null;
    }

    public function updateVerificationCode($userId, $verificationCode)
    {
        $sql = 'UPDATE users SET verification_code = ? WHERE id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('si', $verificationCode, $userId);
        $ok = $stmt->execute();
        $stmt->close();

        return $ok;
    }

    public function create(User $user)
    {
        $sql = 'INSERT INTO users (legacy_user_id, full_name, display_name, birth_date, age, gender, shirt_size, coming_from, email, whatsapp, phone, allergies, guardian_phone, guardian_name, guardian_email, facebook, instagram, church, medications, password_hash, verification_code, user_status, accepted_policies, registered_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())';
        $stmt = $this->db->prepare($sql);

        $stmt->bind_param(
            'isssisssssssssssssssssi',
            $user->legacy_user_id,
            $user->full_name,
            $user->display_name,
            $user->birth_date,
            $user->age,
            $user->gender,
            $user->shirt_size,
            $user->coming_from,
            $user->email,
            $user->whatsapp,
            $user->phone,
            $user->allergies,
            $user->guardian_phone,
            $user->guardian_name,
            $user->guardian_email,
            $user->facebook,
            $user->instagram,
            $user->church,
            $user->medications,
            $user->password_hash,
            $user->verification_code,
            $user->user_status,
            $user->accepted_policies
        );

        $stmt->execute();
        $id = $this->db->insert_id;
        $stmt->close();

        return $id;
    }

    public function update(User $user)
    {
        $sql = 'UPDATE users
                SET full_name = ?, display_name = ?, birth_date = ?, age = ?, gender = ?, shirt_size = ?,
                    coming_from = ?, email = ?, whatsapp = ?, phone = ?, allergies = ?, guardian_phone = ?,
                    guardian_name = ?, guardian_email = ?, facebook = ?, instagram = ?, church = ?,
                    medications = ?, password_hash = ?, verification_code = ?, user_status = ?, accepted_policies = ?
                WHERE id = ?';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param(
            'sssisssssssssssssssssii',
            $user->full_name,
            $user->display_name,
            $user->birth_date,
            $user->age,
            $user->gender,
            $user->shirt_size,
            $user->coming_from,
            $user->email,
            $user->whatsapp,
            $user->phone,
            $user->allergies,
            $user->guardian_phone,
            $user->guardian_name,
            $user->guardian_email,
            $user->facebook,
            $user->instagram,
            $user->church,
            $user->medications,
            $user->password_hash,
            $user->verification_code,
            $user->user_status,
            $user->accepted_policies,
            $user->id
        );

        $ok = $stmt->execute();
        $stmt->close();

        return $ok;
    }

    public function updatePasswordHash($userId, $newHash)
    {
        $sql = 'UPDATE users SET password_hash = ? WHERE id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('si', $newHash, $userId);
        $ok = $stmt->execute();
        $stmt->close();

        return $ok;
    }

    public function clearPasswordHash($userId)
    {
        return $this->updatePasswordHash((int) $userId, '');
    }

    public function findLegacyDuplicateEmails()
    {
        $sql = "SELECT email, count(*) count FROM ywampach_retourbano.guerreros g
                WHERE (g.email_tutor='' OR g.email_tutor IS NULL)
                GROUP BY email
                ORDER BY count(*) DESC, email";
        $result = $this->db->query($sql);
        return $result ? $result->fetch_all(MYSQLI_ASSOC) : array();
    }

    public function findLegacyRegistrationsByEmail($email)
    {
        $sql = "SELECT g.id as guerreroID, cg.id, cg.id_guerrero, cg.id_campamento, nick, nombre, email, email_tutor
                FROM ywampach_retourbano.guerreros g
                LEFT JOIN ywampach_retourbano.campamento_guerreros cg ON g.id=cg.id_guerrero
                WHERE g.email = ? AND (g.email_tutor='' OR g.email_tutor IS NULL)
                ORDER BY g.id DESC, cg.id_campamento";
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return $rows;
    }

    public function findLegacyTutorshipsByEmail($email)
    {
        $sql = "SELECT g.id as guerreroID, cg.id, cg.id_guerrero, cg.id_campamento, nick, nombre, email, email_tutor
                FROM ywampach_retourbano.guerreros g
                LEFT JOIN ywampach_retourbano.campamento_guerreros cg ON g.id=cg.id_guerrero
                WHERE g.email_tutor = ?
                ORDER BY g.id DESC, cg.id_campamento";
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return $rows;
    }

    public function updateLegacyTutorLink($legacyUserId, $email, $emailTutor)
    {
        $sql = 'UPDATE ywampach_retourbano.guerreros SET email = ?, email_tutor = ? WHERE id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('ssi', $email, $emailTutor, $legacyUserId);
        $ok = $stmt->execute();
        $affected = (int) $stmt->affected_rows;
        $stmt->close();

        return array(
            'ok' => $ok,
            'affected' => $affected,
        );
    }
}
