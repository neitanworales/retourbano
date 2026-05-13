-- 002_create_organizations_schema.sql
-- Phase 2 / Wave A (Expand)
-- Create organization model to support many-to-many user membership
-- and event ownership.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS organizations (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_city_id INT NULL,
    city_id INT NULL,
    name VARCHAR(150) NOT NULL,
    slug VARCHAR(180) NOT NULL,
    legal_name VARCHAR(200) NULL,
    email VARCHAR(120) NULL,
    phone VARCHAR(30) NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_organizations_slug (slug),
    KEY idx_organizations_active (is_active),
    KEY idx_organizations_city (city_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS organization_users (
    organization_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    membership_role VARCHAR(40) NOT NULL DEFAULT 'member',
    joined_at DATETIME NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (organization_id, user_id),
    KEY idx_organization_users_user (user_id),
    KEY idx_organization_users_role (membership_role),
    KEY idx_organization_users_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS organization_events (
    organization_id BIGINT UNSIGNED NOT NULL,
    event_id BIGINT UNSIGNED NOT NULL,
    ownership_type VARCHAR(30) NOT NULL DEFAULT 'owner',
    assigned_at DATETIME NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (organization_id, event_id),
    KEY idx_organization_events_event (event_id),
    KEY idx_organization_events_ownership_type (ownership_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed a neutral default organization to simplify initial backfill.
INSERT INTO organizations (name, slug, legal_name, is_active)
SELECT 'Legacy Default Organization', 'legacy-default-org', 'Legacy Default Organization', 1
WHERE NOT EXISTS (
    SELECT 1 FROM organizations WHERE slug = 'legacy-default-org'
);
