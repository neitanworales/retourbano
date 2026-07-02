CREATE TABLE IF NOT EXISTS `bitacora_cambios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `affected_user_id` int(11) DEFAULT NULL COMMENT 'Usuario afectado por el cambio',
  `actor_user_id` int(11) DEFAULT NULL COMMENT 'Usuario que ejecuta la accion',
  `action` varchar(255) DEFAULT NULL COMMENT 'Accion registrada, por ejemplo users.profile.update',
  `entity_type` varchar(100) DEFAULT NULL COMMENT 'Tipo de entidad afectada: user, registration, payment, role',
  `entity_id` int(11) DEFAULT NULL COMMENT 'Id de la entidad afectada',
  `related_event_id` int(11) DEFAULT NULL COMMENT 'Evento relacionado si aplica',
  `related_registration_id` int(11) DEFAULT NULL COMMENT 'Inscripcion relacionada si aplica',
  `source` varchar(100) DEFAULT NULL COMMENT 'Origen del evento: api.v1, cron, admin-ui',
  `old_value` mediumtext DEFAULT NULL COMMENT 'Resumen previo compacto',
  `new_value` mediumtext DEFAULT NULL COMMENT 'Resumen nuevo compacto',
  `metadata_json` mediumtext DEFAULT NULL COMMENT 'Detalle estructurado en JSON',
  `ip_address` varchar(64) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_bitacora_affected_user_created_at` (`affected_user_id`, `created_at`),
  KEY `idx_bitacora_actor_fecha` (`actor_user_id`, `created_at`),
  KEY `idx_bitacora_action_fecha` (`action`, `created_at`),
  KEY `idx_bitacora_entity` (`entity_type`, `entity_id`),
  KEY `idx_bitacora_event_registration` (`related_event_id`, `related_registration_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `bitacora_cambios`
  MODIFY COLUMN `old_value` mediumtext DEFAULT NULL COMMENT 'Resumen previo compacto',
  MODIFY COLUMN `new_value` mediumtext DEFAULT NULL COMMENT 'Resumen nuevo compacto',
  MODIFY COLUMN `metadata_json` mediumtext DEFAULT NULL COMMENT 'Detalle estructurado en JSON',
  MODIFY COLUMN `user_agent` text DEFAULT NULL;

UPDATE bitacora_cambios
SET created_at = COALESCE(created_at, NOW()),
  updated_at = COALESCE(updated_at, created_at, NOW()),
  source = COALESCE(source, 'app'),
  entity_type = COALESCE(entity_type,
    CASE
      WHEN action LIKE 'payments%' THEN 'payment'
      WHEN action LIKE 'registrations%' THEN 'registration'
      WHEN action LIKE 'users.%role%' THEN 'role'
      ELSE 'user'
    END
  )
WHERE created_at IS NULL
   OR updated_at IS NULL
   OR source IS NULL
   OR entity_type IS NULL;

SET @sql := IF(
  EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'bitacora_cambios' AND INDEX_NAME = 'idx_bitacora_affected_user_created_at'
  ),
  'SELECT 1',
  'ALTER TABLE bitacora_cambios
    ADD KEY idx_bitacora_affected_user_created_at (affected_user_id, created_at),
    ADD KEY idx_bitacora_actor_fecha (actor_user_id, created_at),
    ADD KEY idx_bitacora_action_fecha (action, created_at),
    ADD KEY idx_bitacora_entity (entity_type, entity_id),
    ADD KEY idx_bitacora_event_registration (related_event_id, related_registration_id)'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;