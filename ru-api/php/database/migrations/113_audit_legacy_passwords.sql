-- Migration 113: Audit legacy password hashes
-- Purpose: Identify and document legacy password formats for migration
-- Date: 2026-05-13
-- Status: AUDIT ONLY - No data changes

-- Drop view if exists
DROP VIEW IF EXISTS v_password_audit;

-- Create audit view to identify password formats
CREATE VIEW v_password_audit AS
SELECT 
    id,
    email,
    password_hash,
    LENGTH(password_hash) as hash_length,
    CASE
        WHEN password_hash IS NULL THEN 'NULL'
        WHEN password_hash REGEXP '^\\$2[aby]\\$' THEN 'BCRYPT'
        WHEN LENGTH(password_hash) = 32 AND password_hash REGEXP '^[a-f0-9]{32}$' THEN 'MD5'
        WHEN LENGTH(password_hash) = 40 AND password_hash REGEXP '^[a-f0-9]{40}$' THEN 'SHA1'
        WHEN LENGTH(password_hash) < 20 THEN 'PLAINTEXT'
        ELSE 'UNKNOWN'
    END as hash_type,
    created_at,
    updated_at
FROM users
ORDER BY hash_type, id;

-- Report query: Count by type
SELECT 
    hash_type,
    COUNT(*) as count,
    GROUP_CONCAT(DISTINCT id LIMIT 5) as sample_ids
FROM v_password_audit
GROUP BY hash_type
ORDER BY count DESC;
