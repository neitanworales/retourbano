# Fase 2 - Migracion Backend Profesional (sin perdida de datos)

## Objetivo
Redisenar el backend PHP y la base de datos de Retourbano para pasar de un modelo legacy a una arquitectura profesional, manteniendo datos historicos y operacion continua.

Esta propuesta considera explicitamente:
- SQL real en [ywampach_retourbano.sql](ywampach_retourbano.sql)
- Endpoints/scripts legacy en [ru-api/php/retourbano](ru-api/php/retourbano)
- Renombre de dominio: `guerrero -> user`, `campamento -> event`
- Soporte formal de hospedaje y pagos
- Campos y entidades en ingles
- Nuevo dominio de organizaciones (multi-organizacion)

---

## 1) Estado actual detectado (base real)

Tablas criticas actuales:
- `guerreros`: datos personales/login
- `campamentos`: configuracion del campamento
- `campamento_guerreros`: relacion usuario-campamento, estado, asistencia, hospedaje
- `pagos`: pagos por relacion `campamento_guerreros`
- `token`: sesiones/tokens
- `guerreros_roles`: roles

Funciones legacy centrales en [ru-api/php/retourbano/RetoUrbanoDao.class.php](ru-api/php/retourbano/RetoUrbanoDao.class.php):
- Registro/reinscripcion: `inscribir`, `insertarCampamentoGuerreros`, `actualizar`
- Autenticacion: `login`, `saveToken`, `deleteToken`, `validarToken`
- Operacion/admin: `consultaGuerreros`, `changeStatus`, `changeStaff`, `changeAdmin`
- Hospedaje: `obtenerHospedajes`, `updateHospedaje`, `updateHabitacion`
- Pagos: `getPagos`, `guardarPago`, `actualizarPago`, `borrarPago`

Riesgo principal: acoplamiento fuerte a nombres legacy y SQL dinamico dentro de scripts.

---

## 2) Dominio target (ingles y profesional)

### Entidades target
- `users`
- `cities`
- `events`
- `event_registrations` (antes `campamento_guerreros`)
- `payments`
- `organizations` (nuevo)
- `organization_users` (N:M)
- `organization_events` (opcional si un evento puede tener mas de una organizacion)
- `user_roles`
- `auth_tokens`

### Regla clave de negocio
Un usuario puede registrarse en cualquier evento activo aunque no pertenezca a la organizacion dueña del evento.

Interpretacion de seguridad:
- Pertenencia a organizacion controla gestion/administracion
- Inscripcion a evento activo depende de reglas del evento (activo, cupo, ventana), no de membresia

---

## 3) Mapeo de nombres (legacy -> target)

### Tablas
- `guerreros` -> `users`
- `ciudades` -> `cities`
- `campamentos` -> `events`
- `campamento_guerreros` -> `event_registrations`
- `guerreros_roles` -> `user_roles`
- `token` -> `auth_tokens`
- `pagos` -> `payments`

### Campos principales

#### users
- `nombre` -> `full_name`
- `nick` -> `display_name`
- `fechanac` -> `birth_date`
- `edad` -> `age`
- `sexo` -> `gender`
- `vienede` -> `coming_from`
- `contacto_tutor` -> `guardian_phone`
- `tutor_nombre` -> `guardian_name`
- `email_tutor` -> `guardian_email`
- `politicas` -> `accepted_policies`
- `fechahora_registro` -> `registered_at`

#### events
- `id_campamento` -> `id`
- `id_ciudad` -> `city_id`
- `titulo` -> `title`
- `year` -> `event_year`
- `fecha_inicio` -> `start_at`
- `fecha_termino` -> `end_at`
- `activo` -> `is_active`
- `maximo_inscr` -> `max_registrations`
- `fecha_maxima` -> `registration_deadline`
- `fecha_apertura` -> `registration_open_at`
- `pago_minimoMX` -> `minimum_payment_mxn`
- `email_contacto` -> `contact_email`

#### event_registrations
- `id_campamento` -> `event_id`
- `id_guerrero` -> `user_id`
- `status` -> `registration_status`
- `confirmado` -> `is_confirmed`
- `asistencia` -> `attendance_confirmed`
- `seguimiento` -> `is_followup`
- `email_enviado` -> `welcome_email_sent`
- `email_confirmado` -> `email_confirmed`
- `hospedaje` -> `requires_lodging`
- `habitacion` -> `room_code`

#### payments
- `id_pago` -> `id`
- `id_campamento_guerrero` -> `event_registration_id`
- `cantidad` -> `amount`
- `descripcion` -> `description`
- `divisa` -> `currency`
- `no_ticket` -> `receipt_number`

---

## 4) Nuevo modelo de organizaciones

### Nueva estructura
- `cities`
  - `id`, `legacy_city_id`, `name`, `slug`, `is_active`
- `organizations`
  - `id`, `city_id`, `name`, `slug`, `is_active`, `created_at`, `updated_at`
- `organization_users`
  - `organization_id`, `user_id`, `membership_role`, `joined_at`
  - PK compuesta (`organization_id`, `user_id`)
- `events.organization_id` (dueño principal)
  - opcionalmente `organization_events` si necesitas copropiedad

### Reglas
- Una organizacion puede crear muchos eventos
- Un usuario puede pertenecer a varias organizaciones
- Un usuario puede inscribirse a cualquier evento activo sin importar su organizacion

---

## 5) Arquitectura backend Fase 2 (PHP)

## Estructura propuesta

```text
ru-api/php/
  public/
    index.php
  routes/
    api.v1.php
  src/
    Core/
      Router.php
      Controller.php
      Service.php
      Exception.php
    Domain/
      User/
        User.php
        UserRepository.php
        UserService.php
      Event/
        Event.php
        EventRepository.php
        EventService.php
      Registration/
        EventRegistration.php
        EventRegistrationRepository.php
        RegistrationService.php
      Payment/
        Payment.php
        PaymentRepository.php
        PaymentService.php
      Organization/
        Organization.php
        OrganizationRepository.php
        OrganizationService.php
      Auth/
        AuthService.php
        TokenRepository.php
    Infrastructure/
      Database/
        Connection.php
        TransactionManager.php
      Http/
        Request.php
        Response.php
    Application/
      Controllers/
        AuthController.php
        UsersController.php
        EventsController.php
        RegistrationsController.php
        PaymentsController.php
        OrganizationsController.php
```

### Criterios de diseño
- Controladores delgados
- Servicios con reglas de negocio
- Repositories solo acceso a datos
- Transacciones para casos criticos (registro + relacion + pago inicial)
- DTOs de entrada/salida en ingles

---

## 6) Estrategia de migracion de base de datos (sin perdida)

Se recomienda migracion en 4 oleadas, no un rename directo destructivo.

### Oleada A - Expand (no disruptiva)
1. Crear tablas nuevas en ingles (`users`, `events`, `event_registrations`, `payments`, `auth_tokens`, `organizations`, `organization_users`)
2. Agregar campos nuevos requeridos (timestamps, audit, llaves de organizacion)
3. Crear indices y llaves foraneas en esquema nuevo

### Oleada B - Backfill historico
1. Copiar todos los datos legacy a nuevo esquema
2. Generar reporte de reconciliacion por tabla:
   - conteo total
   - checksum por PK
   - nulos no esperados
3. Congelar definiciones de mapeo en scripts versionados

### Oleada C - Dual write + compatibilidad
1. Temporalmente, escritura dual:
   - el codigo nuevo escribe en esquema nuevo
   - triggers o jobs sincronizan hacia legacy (si aun hay consumidores legacy)
2. Mantener endpoints legacy funcionando mientras se corta frontend

### Oleada D - Cutover y retiro
1. Cambiar rutas de API a leer solo esquema nuevo
2. Monitoreo y validacion 1-2 ciclos de evento
3. Retirar tablas legacy (o dejar archivadas de solo lectura)

---

## 7) Script SQL recomendado (fase 2)

### 7.1 DDL inicial (nuevo esquema)
- `001_create_core_english_schema.sql`
- `002_create_organizations_schema.sql`
- `003_create_indexes_constraints.sql`

### 7.2 Migracion de datos
- `101_backfill_users.sql`
- `102_backfill_events.sql`
- `103_backfill_event_registrations.sql`
- `104_backfill_payments.sql`
- `105_backfill_tokens_roles.sql`
- `106_seed_default_organizations.sql`
- `107_backfill_organization_membership.sql`

### 7.3 Validacion
- `201_reconciliation_checks.sql`
- `202_fk_integrity_checks.sql`
- `203_nullability_checks.sql`

### 7.4 Cutover
- `301_enable_new_api_mode.sql` (si usas flags en DB)
- `302_archive_legacy_tables.sql`

---

## 8) Plan de migracion de codigo (endpoints legacy -> v1)

Fuente legacy en [ru-api/php/retourbano](ru-api/php/retourbano):

- `inscribir.php`, `reinscribir.php` -> `POST /api/v1/registrations`
- `login.php`, `logout.php`, `recovery-password.php` -> `POST /api/v1/auth/*`
- `mantenimiento.php` -> dividir en:
  - `GET /api/v1/events/{id}/registrations`
  - `PATCH /api/v1/registrations/{id}`
  - `GET /api/v1/reports/*`
- `guardar-pago.php`, `pagos-mantenimiento.php` -> `POST/PUT/DELETE /api/v1/payments`
- `campamento-activo.php`, `campamentos.php` -> `GET /api/v1/events/active`, `GET /api/v1/events`
- `send-email.php`, `validar-email.php` -> `POST /api/v1/notifications/*`

Regla de nomenclatura en PHP:
- Nunca usar `Guerrero` o `Campamento` en nuevos namespaces/clases
- Solo `User`, `Event`, `EventRegistration`, `Payment`, `Organization`

---

## 9) Hospedaje y pagos (obligatorio en fase 2)

### Hospedaje
Moverlo formalmente a `event_registrations`:
- `requires_lodging` (bool)
- `room_code` (nullable)
- (opcional) `lodging_notes`

### Pagos
Formalizar `payments` con:
- FK a `event_registrations`
- `amount`, `currency`, `description`, `receipt_number`
- (recomendado) `payment_method`, `paid_at`, `created_by_user_id`

Consultas operativas clave:
- saldo por registro (`event_cost - SUM(payments.amount)`)
- estado de pago (`pending`, `partial`, `paid`)

---

## 10) Riesgos y controles

Riesgos:
- IDs historicos no uniformes
- Nulos legacy en columnas criticas
- dependencia de SQL embebido en scripts

Controles:
- Migracion idempotente por lotes
- Transacciones por bloque
- Tablas de auditoria de migracion
- Feature flag para cambiar lectura legacy/new
- Rollback plan: mantener legado en read-only hasta cierre

---

## 11) Entregables concretos Fase 2

1. Nuevo esquema SQL en ingles con organizaciones
2. Scripts de backfill + reconciliacion
3. API v1 con arquitectura por capas
4. Adaptador temporal para endpoints legacy
5. Manual de cutover y rollback
6. Checklist de validacion sin perdida de datos

---

## 12) Resultado esperado

Al finalizar Fase 2:
- El codigo PHP usa exclusivamente dominio en ingles (`User`, `Event`)
- El nuevo modelo soporta organizaciones multi-tenant sin bloquear inscripcion a eventos activos
- Hospedaje y pagos quedan integrados de forma consistente
- La migracion conserva historico completo y permite retiro gradual del legado

