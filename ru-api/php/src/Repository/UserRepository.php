<?php

require_once __DIR__ . '/BaseRepository.php';
require_once __DIR__ . '/../Models/User.php';

class UserRepository extends BaseRepository
{
    protected $table = 'users';

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
}
