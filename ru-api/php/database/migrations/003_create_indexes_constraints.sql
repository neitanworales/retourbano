-- 003_create_indexes_constraints.sql
-- Phase 2 / Wave A (Expand)
-- Add relational constraints and final indexes to new English schema.
-- Run this after 001, 002, 004 and the backfill scripts.

SET NAMES utf8mb4;

ALTER TABLE event_registrations
    ADD CONSTRAINT fk_event_registrations_event
        FOREIGN KEY (event_id) REFERENCES events(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_event_registrations_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE payments
    ADD CONSTRAINT fk_payments_registration
        FOREIGN KEY (event_registration_id) REFERENCES event_registrations(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_payments_created_by_user
        FOREIGN KEY (created_by_user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE auth_tokens
    ADD CONSTRAINT fk_auth_tokens_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE user_roles
    ADD CONSTRAINT fk_user_roles_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE events
    ADD CONSTRAINT fk_events_city
        FOREIGN KEY (city_id) REFERENCES cities(id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    ADD CONSTRAINT fk_events_organization
        FOREIGN KEY (organization_id) REFERENCES organizations(id)
        ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE organizations
    ADD CONSTRAINT fk_organizations_city
        FOREIGN KEY (city_id) REFERENCES cities(id)
        ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE organization_users
    ADD CONSTRAINT fk_organization_users_organization
        FOREIGN KEY (organization_id) REFERENCES organizations(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_organization_users_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE organization_events
    ADD CONSTRAINT fk_organization_events_organization
        FOREIGN KEY (organization_id) REFERENCES organizations(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_organization_events_event
        FOREIGN KEY (event_id) REFERENCES events(id)
        ON UPDATE CASCADE ON DELETE CASCADE;

-- Extra performance indexes for admin/reporting filters.
ALTER TABLE event_registrations
    ADD KEY idx_event_registrations_staff_admin (is_staff, is_admin),
    ADD KEY idx_event_registrations_event_status (event_id, registration_status),
    ADD KEY idx_event_registrations_event_year (event_year);

ALTER TABLE payments
    ADD KEY idx_payments_registration_currency (event_registration_id, currency),
    ADD KEY idx_payments_receipt (receipt_number(191));

ALTER TABLE events
    ADD KEY idx_events_org_active (organization_id, is_active),
    ADD KEY idx_events_city (city_id);
