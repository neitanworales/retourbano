<?php

require_once __DIR__ . '/BaseRepository.php';
require_once __DIR__ . '/../Models/Event.php';

class EventRepository extends BaseRepository
{
    protected $table = 'events';

    public function findModelById($id)
    {
        $row = $this->findById($id);
        return $row ? new Event($row) : null;
    }

    public function findByLegacyId($legacyId)
    {
        $sql = 'SELECT * FROM events WHERE legacy_event_id = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $legacyId);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return $row ? new Event($row) : null;
    }

    public function findActiveByYear($year)
    {
        $sql = 'SELECT * FROM events WHERE is_active = 1 AND event_year = ? ORDER BY start_at ASC';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $year);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new Event($row);
        }, $rows);
    }

    public function findMany($year = null, $active = null, $limit = 100, $offset = 0)
    {
        $conditions = array();
        $params = array();
        $types = '';

        if ($year !== null) {
            $conditions[] = 'event_year = ?';
            $params[] = (int) $year;
            $types .= 'i';
        }

        if ($active !== null) {
            $conditions[] = 'is_active = ?';
            $params[] = (int) $active;
            $types .= 'i';
        }

        $sql = 'SELECT * FROM events';
        if (!empty($conditions)) {
            $sql .= ' WHERE ' . implode(' AND ', $conditions);
        }
        $sql .= ' ORDER BY event_year DESC, start_at ASC LIMIT ? OFFSET ?';

        $params[] = (int) $limit;
        $params[] = (int) $offset;
        $types .= 'ii';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param($types, ...$params);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new Event($row);
        }, $rows);
    }

    public function findUpcomingActive($limit = null)
    {
        $sql = 'SELECT * FROM events
                WHERE is_active = 1
                ORDER BY start_at ASC, id ASC';

        if ($limit !== null && (int) $limit > 0) {
            $sql .= ' LIMIT ?';
            $stmt = $this->db->prepare($sql);
            $limit = (int) $limit;
            $stmt->bind_param('i', $limit);
        } else {
            $stmt = $this->db->prepare($sql);
        }

        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new Event($row);
        }, $rows);
    }

    public function create(Event $event)
    {
        $sql = 'INSERT INTO events (legacy_event_id, organization_id, city_id, event_year, title, start_at, end_at, is_active, max_registrations, registration_deadline, registration_open_at, price_mxn, price_usd)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param(
            'iiiisssiissdd',
            $event->legacy_event_id,
            $event->organization_id,
            $event->city_id,
            $event->event_year,
            $event->title,
            $event->start_at,
            $event->end_at,
            $event->is_active,
            $event->max_registrations,
            $event->registration_deadline,
            $event->registration_open_at,
            $event->price_mxn,
            $event->price_usd
        );

        $stmt->execute();
        $id = $this->db->insert_id;
        $stmt->close();

        return $id;
    }

    public function update(Event $event)
    {
        $sql = 'UPDATE events
                SET organization_id = ?, city_id = ?, event_year = ?, title = ?, start_at = ?, end_at = ?,
                    is_active = ?, max_registrations = ?, registration_deadline = ?, registration_open_at = ?,
                    price_mxn = ?, price_usd = ?
                WHERE id = ?';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param(
            'iiisssiissddi',
            $event->organization_id,
            $event->city_id,
            $event->event_year,
            $event->title,
            $event->start_at,
            $event->end_at,
            $event->is_active,
            $event->max_registrations,
            $event->registration_deadline,
            $event->registration_open_at,
            $event->price_mxn,
            $event->price_usd,
            $event->id
        );

        $ok = $stmt->execute();
        $stmt->close();

        return $ok;
    }

    public function getConfiguracion($eventId)
    {
        $sql = 'SELECT 
                    e.registration_open_at AS fecha_apertura,
                    e.registration_deadline AS fecha_maxima,
                    e.threshold AS umbral,
                    e.max_registrations AS maximo_inscr,
                    COALESCE((SELECT COUNT(*) FROM event_registrations WHERE event_id = ? AND registration_status = "A"), 0) AS inscritos,
                    COALESCE(FLOOR((100 * COALESCE((SELECT COUNT(*) FROM event_registrations WHERE event_id = ? AND registration_status = "A"), 0)) / NULLIF(e.max_registrations, 0)), 0) AS porcentaje,
                    COALESCE(e.max_registrations - (SELECT COUNT(*) FROM event_registrations WHERE event_id = ? AND registration_status = "A"), 0) AS disponibles
                FROM events e
                WHERE e.id = ?
                LIMIT 1';
        
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('iiii', $eventId, $eventId, $eventId, $eventId);
        $stmt->execute();
        $result = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        if (!$result) {
            return null;
        }

        $config = new \stdClass();
        $config->fecha_apertura = $result['fecha_apertura'];
        $config->fecha_maxima = $result['fecha_maxima'];
        $config->umbral = (int) $result['umbral'];
        $config->maximo_inscr = (int) $result['maximo_inscr'];
        $config->inscritos = (int) $result['inscritos'];
        $config->porcentaje = (int) $result['porcentaje'];
        $config->disponibles = (int) $result['disponibles'];

        return $config;
    }

    public function getCostos($legacyEventId)
    {
        $legacyEventId = (int) $legacyEventId;
        if ($legacyEventId <= 0) {
            return array();
        }

        $sql = 'SELECT id, campamento_id, divisa, cantidad, descripcion, incluye
                FROM campamento_costos
                WHERE campamento_id = ?
                ORDER BY id ASC';

        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $legacyEventId);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            $includes = array();
            if (isset($row['incluye']) && $row['incluye'] !== null && trim((string) $row['incluye']) !== '') {
                $includes = array_values(array_filter(array_map('trim', explode(',', (string) $row['incluye'])), function ($item) {
                    return $item !== '';
                }));
            }

            return array(
                'id' => isset($row['id']) ? (int) $row['id'] : null,
                'campamento_id' => isset($row['campamento_id']) ? (int) $row['campamento_id'] : null,
                'divisa' => isset($row['divisa']) ? (string) $row['divisa'] : null,
                'cantidad' => isset($row['cantidad']) ? (float) $row['cantidad'] : null,
                'descripcion' => isset($row['descripcion']) ? (string) $row['descripcion'] : null,
                'incluye' => $includes,
            );
        }, $rows);
    }
}
