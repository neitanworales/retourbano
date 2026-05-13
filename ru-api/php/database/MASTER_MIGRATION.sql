-- MASTER_MIGRATION.sql
-- Fase 2: Complete Migration Runner
-- Ejecuta todos los scripts de migración en orden correcto.
-- Idempotente: seguro ejecutar múltiples veces.

-- ========================================
-- FASE 0: DDL (Create Tables)
-- ========================================

SOURCE 001_create_core_english_schema.sql;
SOURCE 002_create_organizations_schema.sql;
SOURCE 004_create_cities_schema.sql;

-- ========================================
-- FASE 1: Backfill (Populate from Legacy)
-- ========================================

SOURCE 101_backfill_users.sql;
SOURCE 102_backfill_events.sql;
SOURCE 108_backfill_cities.sql;
SOURCE 103_backfill_event_registrations.sql;
SOURCE 104_backfill_payments.sql;
SOURCE 105_backfill_tokens_roles.sql;
SOURCE 106_seed_default_organizations.sql;
SOURCE 107_backfill_organization_membership.sql;
SOURCE 109_finalize_city_relations.sql;
SOURCE 112_backfill_additional_payments.sql;

-- ========================================
-- FASE 0 (part 2): Add Constraints & Indexes
-- ========================================

SOURCE 003_create_indexes_constraints.sql;

-- ========================================
-- FASE 2: Validation (Read-only)
-- ========================================

SOURCE 201_reconciliation_checks.sql;
SOURCE 202_fk_integrity_checks.sql;
SOURCE 203_nullability_checks.sql;
SOURCE 204_backfill_gap_details.sql;

-- ========================================
-- FASE 3: Cleanup (Optional)
-- Uncomment only after validating all phases above
-- ========================================

-- SOURCE 110_deprecate_legacy_tables.sql;
-- SOURCE 111_audit_unused_tables.sql;

-- ========================================
-- END OF MASTER MIGRATION
-- ========================================
-- Review validation output above before proceeding to PHP backend migration.
-- Next steps: Adapt PHP in ru-api/php/src to use new schema.
