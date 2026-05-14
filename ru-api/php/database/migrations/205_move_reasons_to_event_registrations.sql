-- Migration 205: Move `reasons` column from `users` to `event_registrations`
--
-- Reasons are contextual to a specific event registration, not a permanent user property.
-- This migration moves the column and backfills data via the user_id FK.
--
-- Run this migration BEFORE deploying the updated PHP models.

-- Step 1: Add the column to event_registrations
ALTER TABLE event_registrations
    ADD COLUMN reasons VARCHAR(500) NULL DEFAULT NULL AFTER email_confirmed;

-- Step 2: Backfill from users (one registration per user is sufficient for historic data)
UPDATE event_registrations er
    JOIN users u ON u.id = er.user_id
    SET er.reasons = u.reasons
    WHERE u.reasons IS NOT NULL AND u.reasons != '';

-- Step 3: Remove the column from users
ALTER TABLE users DROP COLUMN reasons;
