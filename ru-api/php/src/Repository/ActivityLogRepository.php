<?php

require_once __DIR__ . '/BaseRepository.php';
require_once __DIR__ . '/../Models/ActivityLog.php';

class ActivityLogRepository extends BaseRepository
{
    protected $table = 'bitacora_cambios';

    public function findModelById($id)
    {
        $row = $this->findById($id);
        return $row ? new ActivityLog($row) : null;
    }

    public function createEntry($userId, $action, $oldValue = null, $newValue = null, $options = array())
    {
        if (!is_array($options)) {
            $options = array('created_at' => $options);
        }

        $sql = 'INSERT INTO bitacora_cambios (
            affected_user_id,
            actor_user_id,
            action,
            entity_type,
            entity_id,
            related_event_id,
            related_registration_id,
            source,
            old_value,
            new_value,
            metadata_json,
            ip_address,
            user_agent,
            created_at,
            updated_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
        $stmt = $this->db->prepare($sql);

        $normalizedUserId = $userId !== null ? (int) $userId : null;
        $normalizedActorId = isset($options['actor_user_id']) && $options['actor_user_id'] !== null ? (int) $options['actor_user_id'] : null;
        $normalizedAction = $this->truncateText($action, 255);
        $normalizedEntityType = $this->truncateText(isset($options['entity_type']) ? $options['entity_type'] : null, 100);
        $normalizedEntityId = isset($options['entity_id']) && $options['entity_id'] !== null ? (int) $options['entity_id'] : null;
        $normalizedRelatedEventId = isset($options['related_event_id']) && $options['related_event_id'] !== null ? (int) $options['related_event_id'] : null;
        $normalizedRelatedRegistrationId = isset($options['related_registration_id']) && $options['related_registration_id'] !== null ? (int) $options['related_registration_id'] : null;
        $normalizedSource = $this->truncateText(isset($options['source']) ? $options['source'] : 'api.v1', 100);
        $normalizedOldValue = $this->normalizeValue($oldValue, 8000);
        $normalizedNewValue = $this->normalizeValue($newValue, 8000);
        $normalizedMetadata = $this->normalizeJson(isset($options['metadata']) ? $options['metadata'] : null, 8000);
        $normalizedIpAddress = $this->truncateText(isset($options['ip_address']) ? $options['ip_address'] : null, 64);
        $normalizedUserAgent = $this->truncateText(isset($options['user_agent']) ? $options['user_agent'] : null, 500);
        $normalizedCreatedAt = isset($options['created_at']) && $options['created_at'] ? $options['created_at'] : date('Y-m-d H:i:s');
        $normalizedUpdatedAt = isset($options['updated_at']) && $options['updated_at'] ? $options['updated_at'] : $normalizedCreatedAt;

        $stmt->bind_param(
            'iisssiiisssssss',
            $normalizedUserId,
            $normalizedActorId,
            $normalizedAction,
            $normalizedEntityType,
            $normalizedEntityId,
            $normalizedRelatedEventId,
            $normalizedRelatedRegistrationId,
            $normalizedSource,
            $normalizedOldValue,
            $normalizedNewValue,
            $normalizedMetadata,
            $normalizedIpAddress,
            $normalizedUserAgent,
            $normalizedCreatedAt,
            $normalizedUpdatedAt
        );
        $ok = $stmt->execute();
        $id = $this->db->insert_id;
        $stmt->close();

        return $ok ? (int) $id : 0;
    }

    public function findLatestByUserId($userId, $limit = 10)
    {
        $normalizedLimit = max(1, min(50, (int) $limit));
        $sql = 'SELECT * FROM bitacora_cambios WHERE affected_user_id = ? ORDER BY created_at DESC, id DESC LIMIT ?';
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('ii', $userId, $normalizedLimit);
        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return array_map(function ($row) {
            return new ActivityLog($row);
        }, $rows);
    }

    public function findDetailed($limit = 100, $offset = 0, $search = '', $action = '')
    {
        $normalizedLimit = max(1, min(500, (int) $limit));
        $normalizedOffset = max(0, (int) $offset);
        $normalizedSearch = trim((string) $search);
        $normalizedAction = trim((string) $action);
        $hasSearch = $normalizedSearch !== '';
        $hasAction = $normalizedAction !== '';
        $searchLike = '%' . $normalizedSearch . '%';

        $sql = "SELECT al.*,\n"
            . "       actor.full_name AS actor_full_name,\n"
            . "       actor.display_name AS actor_display_name,\n"
            . "       actor.email AS actor_email,\n"
            . "       affected.full_name AS affected_full_name,\n"
            . "       affected.display_name AS affected_display_name,\n"
            . "       affected.email AS affected_email,\n"
            . "       event.title AS related_event_title,\n"
            . "       event.event_year AS related_event_year\n"
            . "FROM bitacora_cambios al\n"
            . "LEFT JOIN users actor ON actor.id = al.actor_user_id\n"
            . "LEFT JOIN users affected ON affected.id = al.affected_user_id\n"
            . "LEFT JOIN events event ON event.id = al.related_event_id\n"
            . "WHERE 1 = 1";

        if ($hasSearch) {
            $sql .= " AND (\n"
                . "    al.action LIKE ?\n"
                . "    OR al.entity_type LIKE ?\n"
                . "    OR al.source LIKE ?\n"
                . "    OR al.old_value LIKE ?\n"
                . "    OR al.new_value LIKE ?\n"
                . "    OR al.metadata_json LIKE ?\n"
                . "    OR actor.full_name LIKE ?\n"
                . "    OR actor.display_name LIKE ?\n"
                . "    OR actor.email LIKE ?\n"
                . "    OR affected.full_name LIKE ?\n"
                . "    OR affected.display_name LIKE ?\n"
                . "    OR affected.email LIKE ?\n"
                . "    OR event.title LIKE ?\n"
                . ")";
        }

        if ($hasAction) {
            $sql .= ' AND al.action = ?';
        }

        $sql .= ' ORDER BY al.created_at DESC, al.id DESC LIMIT ? OFFSET ?';

        $stmt = $this->db->prepare($sql);

        if ($hasSearch && $hasAction) {
            $stmt->bind_param(
                'ssssssssssssssii',
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $normalizedAction,
                $normalizedLimit,
                $normalizedOffset
            );
        } elseif ($hasSearch) {
            $stmt->bind_param(
                'sssssssssssssii',
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $normalizedLimit,
                $normalizedOffset
            );
        } elseif ($hasAction) {
            $stmt->bind_param('sii', $normalizedAction, $normalizedLimit, $normalizedOffset);
        } else {
            $stmt->bind_param('ii', $normalizedLimit, $normalizedOffset);
        }

        $stmt->execute();
        $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        return $rows;
    }

    public function countDetailed($search = '', $action = '')
    {
        $normalizedSearch = trim((string) $search);
        $normalizedAction = trim((string) $action);
        $hasSearch = $normalizedSearch !== '';
        $hasAction = $normalizedAction !== '';
        $searchLike = '%' . $normalizedSearch . '%';

        $sql = "SELECT COUNT(*) AS total\n"
            . "FROM bitacora_cambios al\n"
            . "LEFT JOIN users actor ON actor.id = al.actor_user_id\n"
            . "LEFT JOIN users affected ON affected.id = al.affected_user_id\n"
            . "LEFT JOIN events event ON event.id = al.related_event_id\n"
            . "WHERE 1 = 1";

        if ($hasSearch) {
            $sql .= " AND (\n"
                . "    al.action LIKE ?\n"
                . "    OR al.entity_type LIKE ?\n"
                . "    OR al.source LIKE ?\n"
                . "    OR al.old_value LIKE ?\n"
                . "    OR al.new_value LIKE ?\n"
                . "    OR al.metadata_json LIKE ?\n"
                . "    OR actor.full_name LIKE ?\n"
                . "    OR actor.display_name LIKE ?\n"
                . "    OR actor.email LIKE ?\n"
                . "    OR affected.full_name LIKE ?\n"
                . "    OR affected.display_name LIKE ?\n"
                . "    OR affected.email LIKE ?\n"
                . "    OR event.title LIKE ?\n"
                . ")";
        }

        if ($hasAction) {
            $sql .= ' AND al.action = ?';
        }

        $stmt = $this->db->prepare($sql);

        if ($hasSearch && $hasAction) {
            $stmt->bind_param(
                'ssssssssssssss',
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $normalizedAction
            );
        } elseif ($hasSearch) {
            $stmt->bind_param(
                'sssssssssssss',
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike,
                $searchLike
            );
        } elseif ($hasAction) {
            $stmt->bind_param('s', $normalizedAction);
        }

        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        return isset($row['total']) ? (int) $row['total'] : 0;
    }

    public function listDistinctActions()
    {
        $sql = 'SELECT DISTINCT action FROM bitacora_cambios WHERE action IS NOT NULL AND TRIM(action) <> "" ORDER BY action ASC';
        $result = $this->db->query($sql);
        if (!$result) {
            return array();
        }

        $rows = $result->fetch_all(MYSQLI_ASSOC);
        $result->close();

        return array_map(function ($row) {
            return isset($row['action']) ? (string) $row['action'] : '';
        }, $rows);
    }

    private function truncateText($value, $limit)
    {
        if ($value === null) {
            return null;
        }

        $stringValue = trim((string) $value);
        if ($stringValue === '') {
            return null;
        }

        if (function_exists('mb_substr')) {
            return mb_substr($stringValue, 0, $limit);
        }

        return substr($stringValue, 0, $limit);
    }

    private function normalizeValue($value, $limit)
    {
        if (is_array($value) || is_object($value)) {
            return $this->truncateText(json_encode($value, JSON_UNESCAPED_UNICODE), $limit);
        }

        return $this->truncateText($value, $limit);
    }

    private function normalizeJson($value, $limit)
    {
        if ($value === null) {
            return null;
        }

        if (is_string($value)) {
            return $this->truncateText($value, $limit);
        }

        return $this->truncateText(json_encode($value, JSON_UNESCAPED_UNICODE), $limit);
    }
}