# Runbook: Fase 2 Migration - Ejecución Completa

## Descripción General
Este documento describe el flujo completo de migración de la base de datos legacy (`guerreros`, `campamentos`, etc.) al nuevo esquema profesional en inglés (`users`, `events`, `event_registrations`, etc.).

Todos los scripts son **idempotentes**: pueden ejecutarse múltiples veces sin duplicar datos ni causar errores. Esto es especialmente útil cuando hay nuevos registros en las tablas legacy y necesitas actualizar el esquema nuevo.

---

## Estructura por Fases

### Fase 0: DDL (Data Definition Language)
Crea la estructura del nuevo esquema. **Solo es necesario ejecutar una vez** (después, el DB ya existe).

1. **001_create_core_english_schema.sql**
   - Tablas: `users`, `events`, `event_registrations`, `payments`, `auth_tokens`, `user_roles`
   - Cada tabla incluye campo `legacy_*_id` para trazabilidad
   - Índices para performance

2. **002_create_organizations_schema.sql**
   - Tablas: `organizations`, `organization_users`, `organization_events`
   - Seed: `legacy-default-org` (organización por defecto)

3. **004_create_cities_schema.sql**
   - Tabla: `cities` (catálogo normalizado de ciudades)
   - Incluye `legacy_city_id` para mapeo

4. **003_create_indexes_constraints.sql**
   - Foreign keys entre todas las tablas
   - Índices adicionales para admin/reporting
   - **Ejecutar después de backfill** para evitar fricción con datos inconsistentes

---

### Fase 1: Backfill (Populating from Legacy)
Copia datos desde las tablas legacy al nuevo esquema. **Idempotente**: usa `ON DUPLICATE KEY UPDATE` y `NOT EXISTS`.

**Orden de ejecución:**

1. **101_backfill_users.sql**
   - Copia `guerreros` → `users`
   - Mapea: `nombre→full_name`, `nick→display_name`, `fechanac→birth_date`, etc.

2. **102_backfill_events.sql**
   - Copia `campamentos` → `events`
   - Join con `ciudades` para obtener nombre de ciudad
   - Mapea: `titulo→title`, `year→event_year`, `activo→is_active`, etc.

3. **108_backfill_cities.sql**
   - Copia `ciudades` → `cities`
   - Crea slugs normalizados automáticamente

4. **103_backfill_event_registrations.sql**
   - Copia `campamento_guerreros` → `event_registrations`
   - Join con `events` y `users` (usando `legacy_*_id`)
   - Normaliza status legacy (A/B/I/F/NULL) a inglés (active/cancelled/inactive/finished)

5. **104_backfill_payments.sql**
   - Copia `pagos` → `payments`
   - Join con `event_registrations` (usando `legacy_registration_id`)

6. **105_backfill_tokens_roles.sql**
   - Copia `token` → `auth_tokens`
   - Copia `guerreros_roles` → `user_roles`
   - Normaliza collation UTF-8 para evitar conflictos

7. **106_seed_default_organizations.sql**
   - Crea organizaciones desde `ciudades`
   - Asigna eventos a organizaciones por ciudad

8. **107_backfill_organization_membership.sql**
   - Copia `guerreros_asignaciones` → `organization_users`
   - Asegura que cada usuario pertenezca a la org por defecto
   - Promueve roles admin/super a membership_role='manager'

9. **109_finalize_city_relations.sql**
   - Script incremental: agrega `city_id` a `organizations` si falta (para bases ya creadas)
   - Sincroniza relaciones entre ciudades y organizaciones
   - Agrega FKs si no existen

10. **112_backfill_additional_payments.sql**
    - Copia pagos desde `pagos_copy1` y `pagos2023` (archives/duplicados)
    - Inserta solo los que no se hayan migrado aún

---

### Fase 2: Validación
Scripts de lectura solo (SELECT). **No modifican datos**. Usalos para verificar integridad post-backfill.

1. **201_reconciliation_checks.sql**
   - Compara conteos entre legacy y nuevo schema
   - Entidades: users, events, cities, event_registrations, payments, roles, tokens
   - Distingue conteos raw vs migrable (para tablas con problemas)

2. **202_fk_integrity_checks.sql**
   - Detecta registros huérfanos (foreign key violations)
   - Chequea: event_registrations sin event/user, payments sin registration, etc.
   - Si hay huérfanos, revisar [204_backfill_gap_details.sql]

3. **203_nullability_checks.sql**
   - Datos de calidad: nulls no permitidos, duplicados, cantidades negativas
   - Chequea: users sin full_name, events sin title, registrations sin status, etc.

4. **204_backfill_gap_details.sql**
   - Listado detallado de datos que no migraron o fueron deduplicados
   - Útil para diagnosticar qué legacy rows quedaron fuera
   - Categorías: missing_payment_registration_link, missing_token_user_link, duplicate_role_assignment

---

### Fase 3: Cleanup (Opcional, después de validar)
Estos scripts modifican la base. Ejecutar solo **después de validar todas las fases 0-2**.

1. **110_deprecate_legacy_tables.sql**
   - Quita FKs entre tablas legacy
   - Renombra legacy tables con prefijo `B_` (backup):
     - `guerreros` → `B_guerreros`
     - `campamentos` → `B_campamentos`
     - `campamento_guerreros` → `B_campamento_guerreros`
     - `pagos` → `B_pagos`
     - `token` → `B_token`
     - `guerreros_roles` → `B_guerreros_roles`
     - `guerreros_asignaciones` → `B_guerreros_asignaciones`
     - `ciudades` → `B_ciudades`

2. **111_audit_unused_tables.sql**
   - Script de lectura: inspecciona qué tablas no tienen relaciones o están vacías
   - Usa `SHOW` commands en lugar de `information_schema`

---

## Instrucciones de Ejecución

### Primera vez (localhost, desde base vacía)

```sql
-- Fase 0: DDL
SOURCE 001_create_core_english_schema.sql;
SOURCE 002_create_organizations_schema.sql;
SOURCE 004_create_cities_schema.sql;

-- Fase 1: Backfill (orden exacto)
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

-- Fase 0 (parte 2): Agregar FKs/Índices
SOURCE 003_create_indexes_constraints.sql;

-- Fase 2: Validación
SOURCE 201_reconciliation_checks.sql;
SOURCE 202_fk_integrity_checks.sql;
SOURCE 203_nullability_checks.sql;
SOURCE 204_backfill_gap_details.sql;

-- Fase 3: Cleanup (OPCIONAL, ejecutar solo si todo está OK)
SOURCE 110_deprecate_legacy_tables.sql;
SOURCE 111_audit_unused_tables.sql;
```

### Futuras ejecuciones (después de nuevos registros en legacy)

Si hay nuevos registros en las tablas legacy y quieres sincronizar al esquema nuevo:

```sql
-- Fase 1: Backfill (son idempotentes)
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

-- Fase 2: Validación
SOURCE 201_reconciliation_checks.sql;
SOURCE 202_fk_integrity_checks.sql;
SOURCE 203_nullability_checks.sql;
SOURCE 204_backfill_gap_details.sql;
```

---

## Propiedades de Idempotencia

Cada script backfill (101-112) es **idempotente** usando uno o más de estos patrones:

1. **`INSERT ... ON DUPLICATE KEY UPDATE`**
   - Si el registro ya existe (por `legacy_*_id`), se actualiza en lugar de duplicar

2. **`NOT EXISTS` subconsultas**
   - Solo inserta si el registro nuevo no existe ya

3. **`CREATE TABLE IF NOT EXISTS`**
   - DDL scripts no fallan si las tablas ya existen

4. **`DROP FOREIGN KEY IF EXISTS`**
   - No falla si la FK ya no existe

5. **`LEFT JOIN ... WHERE ... IS NULL`**
   - Solo procesa registros que no fueron enlazados (ej: categorías huérfanas)

Esto significa que **puedes ejecutar todos los scripts múltiples veces sin riesgo** de:
- Duplicar registros
- Fallar por constrains
- Corromper datos

---

## Monitoreo y Debugging

### Si hay problemas en el backfill

1. **Revisar `204_backfill_gap_details.sql`**
   - Te muestra qué registros legacy no pudieron enlazarse
   - Puede haber IDs huérfanos que no existen en guerreros

2. **Verificar referencias cruzadas**
   - `event_registrations.legacy_registration_id` vs `B_campamento_guerreros.id`
   - `payments.legacy_payment_id` vs `B_pagos.id_pago`

3. **Revisar `202_fk_integrity_checks.sql` y `203_nullability_checks.sql`**
   - Te muestra si hay constraints violations o datos inválidos

### Si hay queries lentes

- Los índices en `003_create_indexes_constraints.sql` están optimizados para queries típicas
- Si hay joins lentos, revisar que las FKs estén en lugar

---

## Mapeo de Legacy → New

| Legacy Table | New Table | Primary Link |
|---|---|---|
| `B_guerreros` | `users` | `legacy_user_id` |
| `B_campamentos` | `events` | `legacy_event_id` |
| `B_ciudades` | `cities` | `legacy_city_id` |
| `B_campamento_guerreros` | `event_registrations` | `legacy_registration_id` |
| `B_pagos` | `payments` | `legacy_payment_id` |
| `B_token` | `auth_tokens` | (user_id via legacy_user_id) |
| `B_guerreros_roles` | `user_roles` | (user_id via legacy_user_id) |
| `B_guerreros_asignaciones` | `organization_users` | (partial mapping) |

---

## Notas Finales

- **Backups**: Antes de ejecutar cleanup (110), recomendado hacer backup de la DB
- **Permisos**: Necesitas permisos para ALTER TABLE, CREATE TABLE, INSERT, UPDATE
- **Collation**: Todos los scripts usan `utf8mb4_unicode_ci` para evitar conflictos legacy
- **Futuro**: Después de esto, adaptar PHP backend en [ru-api/php/src] para usar `users`, `events`, etc.
