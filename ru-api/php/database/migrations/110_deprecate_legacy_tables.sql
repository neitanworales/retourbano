-- 110_deprecate_legacy_tables.sql
-- Phase 2 / Cleanup
-- Rename legacy tables with B_ prefix and remove dangling foreign keys.
-- This marks the tables as deprecated backups, no longer actively used.

SET NAMES utf8mb4;

-- Drop foreign keys that reference legacy tables
-- (These are constraints from legacy tables pointing to each other or other legacy tables)

SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE guerreros_asignaciones DROP FOREIGN KEY IF EXISTS FK_guerreros_asignaciones_guerreros;
ALTER TABLE guerreros_asignaciones DROP FOREIGN KEY IF EXISTS FK_guerreros_asignaciones_ciudades;
ALTER TABLE campamento_guerreros DROP FOREIGN KEY IF EXISTS FK_campamento_guerreros_guerreros;
ALTER TABLE campamento_guerreros DROP FOREIGN KEY IF EXISTS FK_campamento_guerreros_campamentos;
ALTER TABLE token DROP FOREIGN KEY IF EXISTS FK_token_guerreros;
ALTER TABLE pagos DROP FOREIGN KEY IF EXISTS FK_pagos_campamento_guerreros;
ALTER TABLE guerreros_roles DROP FOREIGN KEY IF EXISTS FK_guerreros_roles_guerreros;
ALTER TABLE campamentos DROP FOREIGN KEY IF EXISTS FK_campamentos_ciudades;

-- Rename legacy tables with B_ prefix (deprecated/backup)
RENAME TABLE
    guerreros TO B_guerreros,
    campamentos TO B_campamentos,
    campamento_guerreros TO B_campamento_guerreros,
    pagos TO B_pagos,
    token TO B_token,
    guerreros_roles TO B_guerreros_roles,
    guerreros_asignaciones TO B_guerreros_asignaciones,
    ciudades TO B_ciudades;

SET FOREIGN_KEY_CHECKS = 1;

-- Documentation: legacy table mapping
-- B_guerreros              → users
-- B_campamentos            → events
-- B_campamento_guerreros   → event_registrations
-- B_pagos                  → payments
-- B_token                  → auth_tokens
-- B_guerreros_roles        → user_roles
-- B_guerreros_asignaciones → organization_users (partial)
-- B_ciudades               → cities
