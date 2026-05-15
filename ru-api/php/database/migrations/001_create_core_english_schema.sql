-- 001_create_core_english_schema.sql
-- Phase 2 / Wave A (Expand)
-- Create new core tables in English without touching legacy tables.

SET NAMES utf8mb4;

-- cities must be created first: events references it via FK in 003.
CREATE TABLE IF NOT EXISTS cities (
    id INT NOT NULL AUTO_INCREMENT,
    legacy_city_id INT NULL,
    name VARCHAR(120) NOT NULL,
    slug VARCHAR(160) NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cities_legacy_city_id (legacy_city_id),
    UNIQUE KEY uq_cities_slug (slug),
    KEY idx_cities_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_user_id INT NULL,
    full_name VARCHAR(120) NOT NULL,
    display_name VARCHAR(120) NULL,
    birth_date DATE NULL,
    age INT NULL,
    gender CHAR(1) NULL,
    shirt_size VARCHAR(10) NULL,
    coming_from VARCHAR(120) NULL,
    whatsapp VARCHAR(20) NULL,
    email VARCHAR(120) NULL,
    allergies VARCHAR(255) NULL,
    reasons VARCHAR(500) NULL,
    guardian_phone VARCHAR(20) NULL,
    church VARCHAR(120) NULL,
    registered_at DATETIME NULL,
    guardian_name VARCHAR(120) NULL,
    facebook VARCHAR(120) NULL,
    instagram VARCHAR(120) NULL,
    accepted_policies TINYINT(1) NOT NULL DEFAULT 0,
    password_hash VARCHAR(255) NULL,
    medications VARCHAR(255) NULL,
    phone VARCHAR(20) NULL,
    verification_code VARCHAR(32) NULL,
    guardian_email VARCHAR(120) NULL,
    user_status VARCHAR(20) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_legacy_user_id (legacy_user_id),
    KEY idx_users_email (email),
    KEY idx_users_registered_at (registered_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS events (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_event_id INT NULL,
    organization_id BIGINT UNSIGNED NULL,
    event_year YEAR NULL,
    city_id INT NULL,
    title VARCHAR(255) NOT NULL,
    start_at DATETIME NULL,
    end_at DATETIME NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 0,
    max_registrations INT NULL,
    threshold INT NULL,
    registration_deadline DATETIME NULL,
    registration_open_at DATETIME NULL,
    price_mxn DECIMAL(10,2) NULL,
    price_usd DECIMAL(10,2) NULL,
    minimum_payment_mxn DECIMAL(10,2) NULL,
    bank_name VARCHAR(60) NULL,
    bank_account VARCHAR(60) NULL,
    bank_clabe VARCHAR(45) NULL,
    account_holder VARCHAR(150) NULL,
    contact_phone_1 VARCHAR(30) NULL,
    contact_phone_2 VARCHAR(30) NULL,
    contact_email VARCHAR(120) NULL,
    arrival_place VARCHAR(150) NULL,
    arrival_coordinates VARCHAR(2000) NULL,
    arrival_note VARCHAR(500) NULL,
    departure_place VARCHAR(150) NULL,
    departure_coordinates VARCHAR(2000) NULL,
    departure_note VARCHAR(500) NULL,
    cost_notes VARCHAR(500) NULL,
    city_label VARCHAR(80) NULL,
    crusade_place VARCHAR(80) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_events_legacy_event_id (legacy_event_id),
    KEY idx_events_active_year (is_active, event_year),
    KEY idx_events_registration_window (registration_open_at, registration_deadline)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS event_registrations (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_registration_id INT NULL,
    event_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    event_year YEAR NULL,
    registration_status VARCHAR(10) NULL,
    is_confirmed TINYINT(1) NOT NULL DEFAULT 0,
    attendance_confirmed TINYINT(1) NOT NULL DEFAULT 0,
    is_staff TINYINT(1) NOT NULL DEFAULT 0,
    is_admin TINYINT(1) NOT NULL DEFAULT 0,
    is_followup TINYINT(1) NOT NULL DEFAULT 0,
    welcome_email_sent TINYINT(1) NULL,
    email_confirmed TINYINT(1) NULL,
    requires_lodging TINYINT(1) NULL,
    room_code VARCHAR(20) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_event_registrations_legacy_id (legacy_registration_id),
    KEY idx_event_registrations_event_user (event_id, user_id),
    KEY idx_event_registrations_status (registration_status),
    KEY idx_event_registrations_lodging (requires_lodging)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS payments (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_payment_id INT NULL,
    event_registration_id BIGINT UNSIGNED NOT NULL,
    amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    description VARCHAR(120) NULL,
    currency CHAR(3) NOT NULL DEFAULT 'MXN',
    receipt_number VARCHAR(255) NULL,
    payment_method VARCHAR(30) NULL,
    paid_at DATETIME NULL,
    created_by_user_id BIGINT UNSIGNED NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_payments_legacy_payment_id (legacy_payment_id),
    KEY idx_payments_registration (event_registration_id),
    KEY idx_payments_currency (currency),
    KEY idx_payments_paid_at (paid_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS auth_tokens (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    token VARCHAR(512) NOT NULL,
    expires_at DATETIME NULL,
    created_at DATETIME NULL,
    revoked_at DATETIME NULL,
    PRIMARY KEY (id),
    KEY idx_auth_tokens_user (user_id),
    KEY idx_auth_tokens_expires (expires_at),
    KEY idx_auth_tokens_token (token(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_roles (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_user_roles_unique (user_id, role),
    KEY idx_user_roles_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
