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
        $sql = 'INSERT INTO events (
                    legacy_event_id,
                    organization_id,
                    city_id,
                    event_year,
                    title,
                    start_at,
                    end_at,
                    is_active,
                    max_registrations,
                    threshold,
                    registration_deadline,
                    registration_open_at,
                    price_mxn,
                    price_usd,
                    minimum_payment_mxn,
                    bank_name,
                    bank_account,
                    bank_clabe,
                    account_holder,
                    contact_phone_1,
                    contact_phone_2,
                    contact_email,
                    arrival_place,
                    arrival_coordinates,
                    arrival_note,
                    departure_place,
                    departure_coordinates,
                    departure_note,
                    cost_notes
                ) VALUES (
                    ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
                )';

        $stmt = $this->db->prepare($sql);
        $legacyEventId = isset($event->legacy_event_id) ? (int) $event->legacy_event_id : null;
        $organizationId = isset($event->organization_id) ? (int) $event->organization_id : null;
        $cityId = isset($event->city_id) ? (int) $event->city_id : null;
        $eventYear = isset($event->event_year) ? (int) $event->event_year : null;
        $title = isset($event->title) ? (string) $event->title : null;
        $startAt = isset($event->start_at) ? (string) $event->start_at : null;
        $endAt = isset($event->end_at) ? (string) $event->end_at : null;
        $isActive = isset($event->is_active) ? (int) $event->is_active : 0;
        $maxRegistrations = isset($event->max_registrations) ? (int) $event->max_registrations : null;
        $threshold = isset($event->threshold) ? (int) $event->threshold : null;
        $registrationDeadline = isset($event->registration_deadline) ? (string) $event->registration_deadline : null;
        $registrationOpenAt = isset($event->registration_open_at) ? (string) $event->registration_open_at : null;
        $priceMxn = isset($event->price_mxn) ? (float) $event->price_mxn : null;
        $priceUsd = isset($event->price_usd) ? (float) $event->price_usd : null;
        $minimumPaymentMxn = isset($event->minimum_payment_mxn) ? (float) $event->minimum_payment_mxn : null;
        $bankName = isset($event->bank_name) ? (string) $event->bank_name : null;
        $bankAccount = isset($event->bank_account) ? (string) $event->bank_account : null;
        $bankClabe = isset($event->bank_clabe) ? (string) $event->bank_clabe : null;
        $accountHolder = isset($event->account_holder) ? (string) $event->account_holder : null;
        $contactPhone1 = isset($event->contact_phone_1) ? (string) $event->contact_phone_1 : null;
        $contactPhone2 = isset($event->contact_phone_2) ? (string) $event->contact_phone_2 : null;
        $contactEmail = isset($event->contact_email) ? (string) $event->contact_email : null;
        $arrivalPlace = isset($event->arrival_place) ? (string) $event->arrival_place : null;
        $arrivalCoordinates = isset($event->arrival_coordinates) ? (string) $event->arrival_coordinates : null;
        $arrivalNote = isset($event->arrival_note) ? (string) $event->arrival_note : null;
        $departurePlace = isset($event->departure_place) ? (string) $event->departure_place : null;
        $departureCoordinates = isset($event->departure_coordinates) ? (string) $event->departure_coordinates : null;
        $departureNote = isset($event->departure_note) ? (string) $event->departure_note : null;
        $costNotes = isset($event->cost_notes) ? (string) $event->cost_notes : null;

        $stmt->bind_param(
            'iiiisssiiisssdddsssssssssssss',
            $legacyEventId,
            $organizationId,
            $cityId,
            $eventYear,
            $title,
            $startAt,
            $endAt,
            $isActive,
            $maxRegistrations,
            $threshold,
            $registrationDeadline,
            $registrationOpenAt,
            $priceMxn,
            $priceUsd,
            $minimumPaymentMxn,
            $bankName,
            $bankAccount,
            $bankClabe,
            $accountHolder,
            $contactPhone1,
            $contactPhone2,
            $contactEmail,
            $arrivalPlace,
            $arrivalCoordinates,
            $arrivalNote,
            $departurePlace,
            $departureCoordinates,
            $departureNote,
            $costNotes
        );

        $stmt->execute();
        $id = $this->db->insert_id;
        $stmt->close();

        if ($legacyEventId === null || $legacyEventId <= 0) {
            $this->assignLegacyEventId($id, $id);
        }

        return $id;
    }

    public function update(Event $event)
    {
        $sql = 'UPDATE events
                SET legacy_event_id = ?, organization_id = ?, city_id = ?, event_year = ?, title = ?, start_at = ?, end_at = ?,
                    is_active = ?, max_registrations = ?, threshold = ?, registration_deadline = ?, registration_open_at = ?,
                    price_mxn = ?, price_usd = ?, minimum_payment_mxn = ?, bank_name = ?, bank_account = ?, bank_clabe = ?,
                    account_holder = ?, contact_phone_1 = ?, contact_phone_2 = ?, contact_email = ?, arrival_place = ?,
                    arrival_coordinates = ?, arrival_note = ?, departure_place = ?, departure_coordinates = ?, departure_note = ?,
                    cost_notes = ?
                WHERE id = ?';

        $stmt = $this->db->prepare($sql);
        $legacyEventId = isset($event->legacy_event_id) ? (int) $event->legacy_event_id : null;
        $organizationId = isset($event->organization_id) ? (int) $event->organization_id : null;
        $cityId = isset($event->city_id) ? (int) $event->city_id : null;
        $eventYear = isset($event->event_year) ? (int) $event->event_year : null;
        $title = isset($event->title) ? (string) $event->title : null;
        $startAt = isset($event->start_at) ? (string) $event->start_at : null;
        $endAt = isset($event->end_at) ? (string) $event->end_at : null;
        $isActive = isset($event->is_active) ? (int) $event->is_active : 0;
        $maxRegistrations = isset($event->max_registrations) ? (int) $event->max_registrations : null;
        $threshold = isset($event->threshold) ? (int) $event->threshold : null;
        $registrationDeadline = isset($event->registration_deadline) ? (string) $event->registration_deadline : null;
        $registrationOpenAt = isset($event->registration_open_at) ? (string) $event->registration_open_at : null;
        $priceMxn = isset($event->price_mxn) ? (float) $event->price_mxn : null;
        $priceUsd = isset($event->price_usd) ? (float) $event->price_usd : null;
        $minimumPaymentMxn = isset($event->minimum_payment_mxn) ? (float) $event->minimum_payment_mxn : null;
        $bankName = isset($event->bank_name) ? (string) $event->bank_name : null;
        $bankAccount = isset($event->bank_account) ? (string) $event->bank_account : null;
        $bankClabe = isset($event->bank_clabe) ? (string) $event->bank_clabe : null;
        $accountHolder = isset($event->account_holder) ? (string) $event->account_holder : null;
        $contactPhone1 = isset($event->contact_phone_1) ? (string) $event->contact_phone_1 : null;
        $contactPhone2 = isset($event->contact_phone_2) ? (string) $event->contact_phone_2 : null;
        $contactEmail = isset($event->contact_email) ? (string) $event->contact_email : null;
        $arrivalPlace = isset($event->arrival_place) ? (string) $event->arrival_place : null;
        $arrivalCoordinates = isset($event->arrival_coordinates) ? (string) $event->arrival_coordinates : null;
        $arrivalNote = isset($event->arrival_note) ? (string) $event->arrival_note : null;
        $departurePlace = isset($event->departure_place) ? (string) $event->departure_place : null;
        $departureCoordinates = isset($event->departure_coordinates) ? (string) $event->departure_coordinates : null;
        $departureNote = isset($event->departure_note) ? (string) $event->departure_note : null;
        $costNotes = isset($event->cost_notes) ? (string) $event->cost_notes : null;
        $eventId = (int) $event->id;

        $stmt->bind_param(
            'iiiisssiiisssdddssssssssssssssi',
            $legacyEventId,
            $organizationId,
            $cityId,
            $eventYear,
            $title,
            $startAt,
            $endAt,
            $isActive,
            $maxRegistrations,
            $threshold,
            $registrationDeadline,
            $registrationOpenAt,
            $priceMxn,
            $priceUsd,
            $minimumPaymentMxn,
            $bankName,
            $bankAccount,
            $bankClabe,
            $accountHolder,
            $contactPhone1,
            $contactPhone2,
            $contactEmail,
            $arrivalPlace,
            $arrivalCoordinates,
            $arrivalNote,
            $departurePlace,
            $departureCoordinates,
            $departureNote,
            $costNotes,
            $eventId
        );

        $ok = $stmt->execute();
        $stmt->close();

        if ($ok && ($legacyEventId === null || $legacyEventId <= 0)) {
            $this->assignLegacyEventId($eventId, $eventId);
        }

        return $ok;
    }

    public function delete($id)
    {
        return $this->deleteById($id);
    }

    public function getLegacyIdByEventId($eventId)
    {
        $sql = 'SELECT legacy_event_id FROM events WHERE id = ? LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $eventId);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        if (!$row) {
            return null;
        }

        $legacyId = isset($row['legacy_event_id']) ? (int) $row['legacy_event_id'] : 0;
        if ($legacyId > 0) {
            return $legacyId;
        }

        return (int) $eventId;
    }

    public function replaceCostos($legacyEventId, $costos)
    {
        $legacyEventId = (int) $legacyEventId;
        if ($legacyEventId <= 0) {
            return false;
        }

        $this->deleteCostosByLegacyEventId($legacyEventId);

        if (!is_array($costos) || empty($costos)) {
            return true;
        }

        $sql = 'INSERT INTO campamento_costos (campamento_id, divisa, cantidad, descripcion, incluye)
                VALUES (?, ?, ?, ?, ?)';

        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            return false;
        }

        foreach ($costos as $costo) {
            $divisa = isset($costo['divisa']) ? trim((string) $costo['divisa']) : '';
            $cantidad = isset($costo['cantidad']) ? (float) $costo['cantidad'] : 0.0;
            $descripcion = isset($costo['descripcion']) ? trim((string) $costo['descripcion']) : '';
            $incluyeRaw = isset($costo['incluye']) ? $costo['incluye'] : array();
            if (!is_array($incluyeRaw)) {
                $incluyeRaw = array_map('trim', explode(',', (string) $incluyeRaw));
            }
            $incluye = implode(',', array_values(array_filter(array_map(function ($item) {
                return trim((string) $item);
            }, $incluyeRaw), function ($item) {
                return $item !== '';
            })));

            $stmt->bind_param('isdss', $legacyEventId, $divisa, $cantidad, $descripcion, $incluye);
            if (!$stmt->execute()) {
                $stmt->close();
                return false;
            }
        }

        $stmt->close();
        return true;
    }

    public function deleteCostosByLegacyEventId($legacyEventId)
    {
        $legacyEventId = (int) $legacyEventId;
        if ($legacyEventId <= 0) {
            return true;
        }

        $sql = 'DELETE FROM campamento_costos WHERE campamento_id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $legacyEventId);
        $ok = $stmt->execute();
        $stmt->close();

        return $ok;
    }

    private function assignLegacyEventId($eventId, $legacyEventId)
    {
        $sql = 'UPDATE events SET legacy_event_id = ? WHERE id = ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('ii', $legacyEventId, $eventId);
        $stmt->execute();
        $stmt->close();
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
