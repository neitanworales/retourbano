-- 103_backfill_event_registrations.sql
-- Phase 2 / Backfill
-- Populate event_registrations from legacy campamento_guerreros.

SET NAMES utf8mb4;

INSERT INTO event_registrations (
    legacy_registration_id,
    event_id,
    user_id,
    event_year,
    registration_status,
    is_confirmed,
    attendance_confirmed,
    is_staff,
    is_admin,
    is_followup,
    welcome_email_sent,
    email_confirmed,
    requires_lodging,
    room_code
)
SELECT
    cg.id AS legacy_registration_id,
    e.id AS event_id,
    u.id AS user_id,
    cg.year AS event_year,
    CASE
        WHEN cg.status IS NULL OR TRIM(cg.status) = '' THEN 'active'
        WHEN UPPER(TRIM(cg.status)) = 'A' THEN 'active'
        WHEN UPPER(TRIM(cg.status)) = 'B' THEN 'cancelled'
        WHEN UPPER(TRIM(cg.status)) = 'I' THEN 'inactive'
        WHEN UPPER(TRIM(cg.status)) = 'F' THEN 'finished'
        ELSE LOWER(TRIM(cg.status))
    END AS registration_status,
    IFNULL(cg.confirmado, 0) AS is_confirmed,
    IFNULL(cg.asistencia, 0) AS attendance_confirmed,
    IFNULL(cg.staff, 0) AS is_staff,
    IFNULL(cg.admin, 0) AS is_admin,
    IFNULL(cg.seguimiento, 0) AS is_followup,
    IFNULL(cg.email_enviado, 0) AS welcome_email_sent,
    IFNULL(cg.email_confirmado, 0) AS email_confirmed,
    IFNULL(cg.hospedaje, 0) AS requires_lodging,
    NULLIF(TRIM(cg.habitacion), '') AS room_code
FROM campamento_guerreros cg
INNER JOIN events e ON e.legacy_event_id = cg.id_campamento
INNER JOIN users u ON u.legacy_user_id = cg.id_guerrero
ON DUPLICATE KEY UPDATE
    event_id = VALUES(event_id),
    user_id = VALUES(user_id),
    event_year = VALUES(event_year),
    registration_status = VALUES(registration_status),
    is_confirmed = VALUES(is_confirmed),
    attendance_confirmed = VALUES(attendance_confirmed),
    is_staff = VALUES(is_staff),
    is_admin = VALUES(is_admin),
    is_followup = VALUES(is_followup),
    welcome_email_sent = VALUES(welcome_email_sent),
    email_confirmed = VALUES(email_confirmed),
    requires_lodging = VALUES(requires_lodging),
    room_code = VALUES(room_code);
