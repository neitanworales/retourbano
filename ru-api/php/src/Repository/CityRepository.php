<?php

require_once __DIR__ . '/BaseRepository.php';
require_once __DIR__ . '/../Models/City.php';

class CityRepository extends BaseRepository
{
    protected $table = 'cities';

    public function findMany($active = null, $limit = 100, $offset = 0)
    {
        $conditions = array();
        $params = array();
        $types = '';

        if ($active !== null) {
            $conditions[] = 'is_active = ?';
            $params[] = (int) $active;
            $types .= 'i';
        }

        $sql = 'SELECT * FROM cities';
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
            return new City($row);
        }, $rows);
    }

    public function findModelById($id)
    {
        $row = $this->findById($id);
        return $row ? new City($row) : null;
    }

    public function findByLegacyId($legacyId)
    {
        $sql = 'SELECT * FROM cities WHERE legacy_city_id = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $legacyId);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? new City($row) : null;
    }

    public function findBySlug($slug)
    {
        $sql = 'SELECT * FROM cities WHERE slug = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('s', $slug);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? new City($row) : null;
    }

    public function create(City $city)
    {
        $sql = 'INSERT INTO cities (legacy_city_id, name, slug, is_active) VALUES (?, ?, ?, ?)';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('issi', $city->legacy_city_id, $city->name, $city->slug, $city->is_active);

        $stmt->execute();
        $id = $this->db->insert_id;
        $stmt->close();

        return $id;
    }

    public function update(City $city)
    {
        $sql = 'UPDATE cities SET legacy_city_id = ?, name = ?, slug = ?, is_active = ? WHERE id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('issii', $city->legacy_city_id, $city->name, $city->slug, $city->is_active, $city->id);
        $ok = $stmt->execute();
        $stmt->close();

        return $ok;
    }

    public function delete($id)
    {
        return $this->deleteById($id);
    }
}
