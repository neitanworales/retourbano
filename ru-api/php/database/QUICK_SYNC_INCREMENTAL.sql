-- QUICK_SYNC_INCREMENTAL.sql
-- Para sincronizar nuevos registros legacy → schema nuevo
-- Ejecutar cuando hay nuevos datos en tablas legacy
-- Más rápido que MASTER_MIGRATION.sql (salta DDL)

-- ========================================
-- FASE 1: Backfill Only (Incremental)
-- ========================================
-- Estos scripts son idempotentes: actualizar existing, insertar nuevos

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
-- FASE 2: Validation (Review output)
-- ========================================

SOURCE 201_reconciliation_checks.sql;
SOURCE 202_fk_integrity_checks.sql;
SOURCE 203_nullability_checks.sql;
SOURCE 204_backfill_gap_details.sql;

-- ========================================
-- Done! Compare results with previous run
-- ========================================
