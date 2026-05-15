-- 102_backfill_events.sql
-- Phase 2 / Backfill
-- Populate events from legacy campamentos.

SET NAMES utf8mb4;

-- cities is populated in 108, which runs after this script.
-- Disable FK checks to allow city_id insertion before that backfill.
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO events (
    legacy_event_id,
    event_year,
    city_id,
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
    cost_notes,
    city_label,
    crusade_place
)
SELECT
    c.id_campamento AS legacy_event_id,
    c.year AS event_year,
    c.id_ciudad AS city_id,
    COALESCE(NULLIF(TRIM(c.titulo), ''), CONCAT('legacy-event-', c.id_campamento)) AS title,
    NULLIF(c.fecha_inicio, '0000-00-00 00:00:00') AS start_at,
    NULLIF(c.fecha_termino, '0000-00-00 00:00:00') AS end_at,
    IFNULL(c.activo, 0) AS is_active,
    c.maximo_inscr AS max_registrations,
    c.umbral AS threshold,
    NULLIF(c.fecha_maxima, '0000-00-00 00:00:00') AS registration_deadline,
    NULLIF(c.fecha_apertura, '0000-00-00 00:00:00') AS registration_open_at,
    c.costoMX AS price_mxn,
    c.costoUSD AS price_usd,
    c.pago_minimoMX AS minimum_payment_mxn,
    NULLIF(TRIM(c.banco), '') AS bank_name,
    NULLIF(TRIM(c.cuenta), '') AS bank_account,
    NULLIF(TRIM(c.clabe), '') AS bank_clabe,
    NULLIF(TRIM(c.titularCuenta), '') AS account_holder,
    NULLIF(TRIM(c.contacto1), '') AS contact_phone_1,
    NULLIF(TRIM(c.contacto2), '') AS contact_phone_2,
    NULLIF(TRIM(c.email_contacto), '') AS contact_email,
    NULLIF(TRIM(c.llegada_lugar), '') AS arrival_place,
    NULLIF(TRIM(c.llegada_coordenadas), '') AS arrival_coordinates,
    NULLIF(TRIM(c.llegada_nota), '') AS arrival_note,
    NULLIF(TRIM(c.salida_lugar), '') AS departure_place,
    NULLIF(TRIM(c.salida_coordenadas), '') AS departure_coordinates,
    NULLIF(TRIM(c.salida_nota), '') AS departure_note,
    NULLIF(TRIM(c.notas_costos), '') AS cost_notes,
    NULLIF(TRIM(ci.nombre), '') AS city_label,
    NULLIF(TRIM(c.cruzada_lugar), '') AS crusade_place
FROM campamentos c
LEFT JOIN ciudades ci ON ci.id = c.id_ciudad
ON DUPLICATE KEY UPDATE
    event_year = VALUES(event_year),
    city_id = VALUES(city_id),
    title = VALUES(title),
    start_at = VALUES(start_at),
    end_at = VALUES(end_at),
    is_active = VALUES(is_active),
    max_registrations = VALUES(max_registrations),
    threshold = VALUES(threshold),
    registration_deadline = VALUES(registration_deadline),
    registration_open_at = VALUES(registration_open_at),
    price_mxn = VALUES(price_mxn),
    price_usd = VALUES(price_usd),
    minimum_payment_mxn = VALUES(minimum_payment_mxn),
    bank_name = VALUES(bank_name),
    bank_account = VALUES(bank_account),
    bank_clabe = VALUES(bank_clabe),
    account_holder = VALUES(account_holder),
    contact_phone_1 = VALUES(contact_phone_1),
    contact_phone_2 = VALUES(contact_phone_2),
    contact_email = VALUES(contact_email),
    arrival_place = VALUES(arrival_place),
    arrival_coordinates = VALUES(arrival_coordinates),
    arrival_note = VALUES(arrival_note),
    departure_place = VALUES(departure_place),
    departure_coordinates = VALUES(departure_coordinates),
    departure_note = VALUES(departure_note),
    cost_notes = VALUES(cost_notes),
    city_label = VALUES(city_label),
    crusade_place = VALUES(crusade_place);

SET FOREIGN_KEY_CHECKS = 1;
