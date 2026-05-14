<?php

require_once __DIR__ . '/BaseRepository.php';
require_once __DIR__ . '/../Models/Organization.php';

class OrganizationRepository extends BaseRepository
{
    protected $table = 'organizations';

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
}
