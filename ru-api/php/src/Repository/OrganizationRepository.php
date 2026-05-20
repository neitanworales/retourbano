<?php

require_once __DIR__ . '/BaseRepository.php';
require_once __DIR__ . '/../Models/Organization.php';

class OrganizationRepository extends BaseRepository
{
    protected $table = 'organizations';

    public function findMany($active = null, $cityId = null, $limit = 100, $offset = 0)
    {
        $conditions = array();
        $params = array();
        $types = '';

        if ($active !== null) {
            $conditions[] = 'is_active = ?';
            $params[] = (int) $active;
            $types .= 'i';
        }

        if ($cityId !== null) {
            $conditions[] = 'city_id = ?';
            $params[] = (int) $cityId;
            $types .= 'i';
        }

        $sql = 'SELECT * FROM organizations';
        if (!empty($conditions)) {
            $sql .= ' WHERE ' . implode(' AND ', $conditions);
        }
        $sql .= ' ORDER BY name ASC LIMIT ? OFFSET ?';

        $params[] = (int) $limit;
        $params[] = (int) $offset;
        $types .= 'ii';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param($types, ...$params);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new Organization($row);
        }, $rows);
    }

    public function findModelById($id)
    {
        $row = $this->findById($id);
        return $row ? new Organization($row) : null;
    }

    public function findBySlug($slug)
    {
        $sql = 'SELECT * FROM organizations WHERE slug = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('s', $slug);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? new Organization($row) : null;
    }

    public function findByLegacyCityId($legacyCityId)
    {
        $sql = 'SELECT * FROM organizations WHERE legacy_city_id = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $legacyCityId);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? new Organization($row) : null;
    }

    public function create(Organization $organization)
    {
        $sql = 'INSERT INTO organizations (legacy_city_id, city_id, name, slug, legal_name, email, phone, is_active)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param(
            'iisssssi',
            $organization->legacy_city_id,
            $organization->city_id,
            $organization->name,
            $organization->slug,
            $organization->legal_name,
            $organization->email,
            $organization->phone,
            $organization->is_active
        );

        $stmt->execute();
        $id = $this->db->insert_id;
        $stmt->close();

        return $id;
    }

    public function update(Organization $organization)
    {
        $sql = 'UPDATE organizations
                SET legacy_city_id = ?, city_id = ?, name = ?, slug = ?, legal_name = ?, email = ?, phone = ?, is_active = ?
                WHERE id = ?';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param(
            'iisssssii',
            $organization->legacy_city_id,
            $organization->city_id,
            $organization->name,
            $organization->slug,
            $organization->legal_name,
            $organization->email,
            $organization->phone,
            $organization->is_active,
            $organization->id
        );

        $ok = $stmt->execute();
        $stmt->close();

        return $ok;
    }

    public function delete($id)
    {
        return $this->deleteById($id);
    }
}
