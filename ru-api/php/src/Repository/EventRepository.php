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
}
