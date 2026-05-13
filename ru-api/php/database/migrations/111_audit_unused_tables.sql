-- 111_audit_unused_tables.sql
-- Phase 2 / Audit
-- Identify tables with no foreign key relationships and row counts.
-- Helps determine which tables can be safely deprecated or consolidated.
-- Uses SHOW commands instead of information_schema for compatibility.

SET NAMES utf8mb4;

-- Create temporary table to hold all table names and row counts
CREATE TEMPORARY TABLE temp_table_stats (
    table_name VARCHAR(255),
    row_count BIGINT
);

-- Query all table row counts using SELECT COUNT(*)
-- (Must be done manually per table in this approach)
SELECT '=== TABLE ROW COUNTS ===' AS category;

-- Show row counts for all tables (manual inspection of structure)
SELECT 
    CONCAT('SELECT "', TABLE_NAME, '" AS table_name, COUNT(*) AS row_count FROM `', TABLE_NAME, '`;') AS query_to_run
FROM (
    SELECT 'users' AS TABLE_NAME UNION
    SELECT 'events' UNION
    SELECT 'cities' UNION
    SELECT 'event_registrations' UNION
    SELECT 'payments' UNION
    SELECT 'auth_tokens' UNION
    SELECT 'user_roles' UNION
    SELECT 'organizations' UNION
    SELECT 'organization_users' UNION
    SELECT 'organization_events'
) available_tables;

SELECT '=== EMPTY TABLES ===' AS analysis;
-- After inspecting row counts above, manually identify which have 0 rows

SELECT '=== TABLES TO CHECK FOR RELATIONSHIPS ===' AS next_step;
-- Review table structures with: SHOW CREATE TABLE <table_name>
-- Look for:
-- - FOREIGN KEY constraints (FKs this table creates)
-- - REFERENCES sections (tables that reference this one)

SELECT CONCAT(
    'Run: SHOW CREATE TABLE ', t, ';'
) AS inspection_command
FROM (
    SELECT 'users' AS t UNION
    SELECT 'events' UNION
    SELECT 'cities' UNION
    SELECT 'event_registrations' UNION
    SELECT 'payments' UNION
    SELECT 'auth_tokens' UNION
    SELECT 'user_roles' UNION
    SELECT 'organizations' UNION
    SELECT 'organization_users' UNION
    SELECT 'organization_events'
) tables;
