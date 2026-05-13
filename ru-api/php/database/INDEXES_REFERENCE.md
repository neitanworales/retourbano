# Índice de Scripts de Migración Fase 2

## Tabla de Referencia Rápida

| Script | Fase | Tipo | Descripción | Idempotente |
|--------|------|------|-------------|------------|
| 001_create_core_english_schema.sql | 0 | DDL | Tablas: users, events, event_registrations, payments, auth_tokens, user_roles | Sí (IF NOT EXISTS) |
| 002_create_organizations_schema.sql | 0 | DDL | Tablas: organizations, organization_users, organization_events + seed | Sí (IF NOT EXISTS) |
| 003_create_indexes_constraints.sql | 0 | DDL | Foreign keys e índices de performance | Sí (ADD IF NOT EXISTS) |
| 004_create_cities_schema.sql | 0 | DDL | Tabla: cities (catálogo normalizado) | Sí (IF NOT EXISTS) |
| 101_backfill_users.sql | 1 | INSERT | `B_guerreros` → `users` | Sí (ON DUPLICATE KEY) |
| 102_backfill_events.sql | 1 | INSERT | `B_campamentos` → `events` | Sí (ON DUPLICATE KEY) |
| 103_backfill_event_registrations.sql | 1 | INSERT | `B_campamento_guerreros` → `event_registrations` | Sí (ON DUPLICATE KEY) |
| 104_backfill_payments.sql | 1 | INSERT | `B_pagos` → `payments` | Sí (ON DUPLICATE KEY) |
| 105_backfill_tokens_roles.sql | 1 | INSERT | `B_token` → `auth_tokens`, `B_guerreros_roles` → `user_roles` | Sí (ON DUPLICATE KEY) |
| 106_seed_default_organizations.sql | 1 | INSERT | Crea orgs desde `B_ciudades`, asigna eventos | Sí (NOT EXISTS) |
| 107_backfill_organization_membership.sql | 1 | INSERT | `B_guerreros_asignaciones` → `organization_users` | Sí (NOT EXISTS) |
| 108_backfill_cities.sql | 1 | INSERT | `B_ciudades` → `cities` | Sí (ON DUPLICATE KEY) |
| 109_finalize_city_relations.sql | 1 | ALTER/UPDATE | Agrega `city_id` a organizations, sincroniza FKs | Sí (IF NOT EXISTS) |
| 110_deprecate_legacy_tables.sql | 3 | ALTER | Quita FKs legacy, renombra a `B_*` prefix | Sí (DROP IF EXISTS) |
| 111_audit_unused_tables.sql | 3 | SELECT | Inspecciona tablas sin relaciones/vacías | Sí (read-only) |
| 112_backfill_additional_payments.sql | 1 | INSERT | `pagos_copy1`, `pagos2023` → `payments` | Sí (ON DUPLICATE KEY) |
| 201_reconciliation_checks.sql | 2 | SELECT | Compara conteos legacy vs nuevo | Sí (read-only) |
| 202_fk_integrity_checks.sql | 2 | SELECT | Detecta registros huérfanos | Sí (read-only) |
| 203_nullability_checks.sql | 2 | SELECT | Validación de datos (nulls, duplicados, etc) | Sí (read-only) |
| 204_backfill_gap_details.sql | 2 | SELECT | Listado detallado de datos no migrados | Sí (read-only) |

---

## Archivos de Documentación

| Archivo | Propósito |
|---------|----------|
| MIGRATION_RUNBOOK.md | Guía completa con instrucciones de ejecución por fases |
| MASTER_MIGRATION.sql | Script maestro que ejecuta todo en orden correcto |
| QUICK_SYNC_INCREMENTAL.sql | Script rápido para sincronizar nuevos registros (sin DDL) |
| MIGRATION_CHECKLIST.md | Checklist pre/post migración con verificaciones |
| INDEXES_REFERENCE.md | (Este archivo) - Referencia rápida de todos los scripts |

---

## Mapeo Legacy → New Schema

```
B_guerreros              → users              (legacy_user_id)
B_campamentos            → events             (legacy_event_id)
B_ciudades               → cities             (legacy_city_id)
B_campamento_guerreros   → event_registrations (legacy_registration_id)
B_pagos                  → payments           (legacy_payment_id)
B_token                  → auth_tokens        (via user_id)
B_guerreros_roles        → user_roles         (via user_id)
B_guerreros_asignaciones → organization_users (partial)
```

---

## Orden de Ejecución (Por Fases)

### Fase 0: DDL (1 vez solamente)
```
001 → 002 → 004 → (backfill 1xx) → 003
```

### Fase 1: Backfill (idempotente, repetible)
```
101 → 102 → 108 → 103 → 104 → 105 → 106 → 107 → 109 → 112
```

### Fase 2: Validación (lectura)
```
201 → 202 → 203 → 204
```

### Fase 3: Cleanup (opcional)
```
110 → 111
```

---

## Decisiones de Diseño

### 1. Idempotencia
Todos los scripts usan patrones que permiten ejecución múltiple sin riesgo:
- `INSERT ... ON DUPLICATE KEY UPDATE` (scripts 10x-112)
- `NOT EXISTS` subconsultas (scripts 106, 107)
- `CREATE TABLE IF NOT EXISTS` (DDL)
- `DROP ... IF EXISTS` (cleanup)

### 2. Trazabilidad
Cada tabla nueva tiene columna `legacy_*_id`:
- `users.legacy_user_id`
- `events.legacy_event_id`
- `cities.legacy_city_id`
- `event_registrations.legacy_registration_id`
- `payments.legacy_payment_id`

Esto permite siempre saber cuál era el registro original legacy.

### 3. Normalización de Datos
- **Status**: Legacy A/B/I/F → Nuevo active/cancelled/inactive/finished
- **Collation**: UTF-8 explicit para evitar conflictos
- **Names**: COALESCE + NULLIF para limpiar espacios/vacíos
- **Currency**: Default MXN si vacío

### 4. Organización Flexible
- Default org: `legacy-default-org` (comodín para eventos sin org clara)
- Orgs por ciudad: Cada `ciudad` → su org automática
- Membership: Cada usuario → default org + sus orgs asignadas

### 5. Campos en Inglés
Todo el esquema nuevo usa nombres en inglés:
- `nombre` → `full_name`
- `titulo` → `title`
- `activo` → `is_active`
- `ciudad` → `cities` (tabla)
- etc.

---

## Columnas Importantes del Nuevo Schema

### users
- `id` (PK)
- `legacy_user_id` (trazabilidad)
- `full_name`, `display_name`, `email`
- `password_hash`, `verification_code`
- `birth_date`, `gender`, `shirt_size`
- `accepted_policies`, `user_status`
- Timestamps: `registered_at`, `created_at`, `updated_at`

### events
- `id` (PK)
- `legacy_event_id` (trazabilidad)
- `organization_id` (FK a organizations)
- `city_id` (FK a cities)
- `title`, `event_year`
- `is_active`, `max_registrations`
- Fechas: `start_at`, `end_at`, `registration_deadline`, `registration_open_at`
- Precios: `price_mxn`, `price_usd`, `minimum_payment_mxn`
- Detalles: `arrival_place`, `arrival_coordinates`, `departure_place`, etc.

### event_registrations
- `id` (PK)
- `legacy_registration_id` (trazabilidad)
- `event_id` (FK)
- `user_id` (FK)
- `registration_status` (active/cancelled/inactive/finished)
- Booleans: `is_confirmed`, `attendance_confirmed`, `is_staff`, `is_admin`, `is_followup`
- `requires_lodging`, `room_code`

### payments
- `id` (PK)
- `legacy_payment_id` (trazabilidad)
- `event_registration_id` (FK)
- `amount`, `currency` (MXN/USD)
- `receipt_number`, `payment_method`
- `paid_at`, `created_by_user_id`

### organizations
- `id` (PK)
- `legacy_city_id` (trazabilidad, si aplica)
- `city_id` (FK a cities)
- `name`, `slug`, `legal_name`
- `is_active`

### cities
- `id` (PK, matches legacy ciudad.id)
- `legacy_city_id` (redundante pero explícito)
- `name`, `slug`
- `is_active`

---

## Performance Considerations

- **Índices**: Todos los FKs automáticamente indexados
- **Unique constraints**: `legacy_*_id` para evitar duplicados
- **Composite keys**: `(organization_id, user_id)` para organization_users
- **Queries lentas**: Revisar 202_fk_integrity_checks si hay problemas

---

## Próximos Pasos (Backend PHP)

1. Crear Models en `ru-api/php/src/Domain/`:
   - `User`, `Event`, `EventRegistration`, `Payment`, `Organization`, `City`

2. Crear Repositories:
   - `UserRepository`, `EventRepository`, `RegistrationRepository`, `PaymentRepository`

3. Crear Services:
   - `AuthService`, `RegistrationService`, `PaymentService`

4. Crear Controllers:
   - `AuthController`, `RegistrationController`, `PaymentController`

5. Adaptar endpoints legacy en `ru-api/php/retourbano/` para usar nuevas clases
