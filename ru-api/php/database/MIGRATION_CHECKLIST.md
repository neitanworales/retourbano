# Checklist: Pre & Post Migration

## Pre-Migration Checks

- [ ] **Backup de base actual**
  ```bash
  mysqldump -u root -p ywampach_retourbano > backup_$(date +%Y%m%d_%H%M%S).sql
  ```

- [ ] **Verificar acceso a base**
  ```sql
  USE ywampach_retourbano;
  SELECT COUNT(*) FROM guerreros;
  SELECT COUNT(*) FROM campamentos;
  SELECT COUNT(*) FROM campamento_guerreros;
  SELECT COUNT(*) FROM pagos;
  ```

- [ ] **Revisar tablas legacy que quieres migrar**
  ```sql
  SHOW TABLES LIKE '%pagos%';
  SHOW TABLES LIKE '%guerrero%';
  ```

- [ ] **Listar archivos migrations en carpeta**
  ```bash
  ls -la ru-api/php/database/migrations/*.sql | wc -l
  # Deberían ser 20+ scripts
  ```

---

## Ejecución de Migración

### Opción 1: Usar MASTER_MIGRATION.sql (completo)
```bash
cd ru-api/php/database
mysql -u root -p ywampach_retourbano < MASTER_MIGRATION.sql 2>&1 | tee migration_$(date +%Y%m%d_%H%M%S).log
```

### Opción 2: Ejecutar scripts manualmente (más control)
```bash
mysql -u root -p ywampach_retourbano

-- Dentro de MySQL:
SOURCE MIGRATION_RUNBOOK.md;  -- (leer las instrucciones)
SOURCE 001_create_core_english_schema.sql;
SOURCE 002_create_organizations_schema.sql;
... (seguir orden del RUNBOOK)
```

### Opción 3: Sincronizar nuevos registros (incremental)
```bash
mysql -u root -p ywampach_retourbano < QUICK_SYNC_INCREMENTAL.sql
```

---

## Post-Migration Verification

### Fase 0: Estructura
- [ ] Verificar que todas las tablas nuevas existan
  ```sql
  SHOW TABLES LIKE 'users';
  SHOW TABLES LIKE 'events';
  SHOW TABLES LIKE 'event_registrations';
  SHOW TABLES LIKE 'payments';
  SHOW TABLES LIKE 'organizations';
  SHOW TABLES LIKE 'cities';
  ```

### Fase 1: Datos migrados
- [ ] Contar registros por tabla nueva
  ```sql
  SELECT COUNT(*) FROM users;
  SELECT COUNT(*) FROM events;
  SELECT COUNT(*) FROM event_registrations;
  SELECT COUNT(*) FROM payments;
  SELECT COUNT(*) FROM auth_tokens;
  SELECT COUNT(*) FROM user_roles;
  SELECT COUNT(*) FROM organizations;
  SELECT COUNT(*) FROM cities;
  ```

- [ ] Comparar con legacy (deben ser iguales o muy cercanos)
  ```sql
  SELECT 'guerreros' AS table_name, COUNT(*) AS legacy_count FROM B_guerreros
  UNION
  SELECT 'campamentos', COUNT(*) FROM B_campamentos
  UNION
  SELECT 'event_registrations', COUNT(*) FROM B_campamento_guerreros
  UNION
  SELECT 'pagos', COUNT(*) FROM B_pagos;
  ```

### Fase 2: Integridad relacional
- [ ] Revisar output de 202_fk_integrity_checks.sql
  - Debe mostrar todas las categorías con `orphan_count = 0`
  - Si no, revisar [204_backfill_gap_details.sql]

- [ ] Revisar output de 203_nullability_checks.sql
  - Todos los checks deben mostrar `issue_count = 0`
  - O muy bajos (<5% del total)

### Fase 3: Muestras de datos
- [ ] Verificar que los datos se copiaron correctamente
  ```sql
  -- Sample user
  SELECT * FROM users LIMIT 1\G
  
  -- Sample event
  SELECT * FROM events LIMIT 1\G
  
  -- Sample registration
  SELECT * FROM event_registrations LIMIT 1\G
  
  -- Sample payment
  SELECT * FROM payments LIMIT 1\G
  ```

- [ ] Verificar mapeo de campos (legacy → new)
  ```sql
  -- Confirmar que nombre → full_name
  SELECT legacy_user_id, full_name 
  FROM users 
  WHERE legacy_user_id IS NOT NULL 
  LIMIT 5;
  
  -- Confirmar que titulo → title
  SELECT legacy_event_id, title 
  FROM events 
  WHERE legacy_event_id IS NOT NULL 
  LIMIT 5;
  ```

---

## Post-Migration Actions

### Si todo pasó ✅
1. **Commit a Git**
   ```bash
   git add ru-api/php/database/migrations/
   git add ru-api/php/database/MIGRATION_RUNBOOK.md
   git add ru-api/php/database/MASTER_MIGRATION.sql
   git commit -m "feat: Fase 2 SQL migration complete (schema, backfill, validation)"
   ```

2. **Próximo paso: Backend PHP**
   - Adaptar [ru-api/php/src] para usar nuevo schema
   - Crear Models: User, Event, EventRegistration, Payment
   - Crear Repositories y Services

### Si hay problemas ❌
1. **Inspeccionar 204_backfill_gap_details.sql**
   - Ver qué registros legacy no se migraron
   - Determinar si son datos válidos o corruptos

2. **Revisar 203_nullability_checks.sql**
   - Si hay many issues, posible problema de lógica en backfill
   - Revisar los scripts 10X-112 para entender mapeos

3. **Revert DB from backup**
   ```bash
   mysql -u root -p ywampach_retourbano < backup_YYYYMMDD_HHMMSS.sql
   ```

---

## Notas de Performance

- **Primera ejecución**: ~2-5 minutos (depende de tamaño DB)
- **Incrementales**: ~30 segundos a 1 minuto
- **Validación**: ~10-30 segundos
- **Cleanup (110)**: ~5 segundos

Todos los scripts usan índices, así que no deberían ser lentos.

---

## Soporte / Debugging

### Script que falla
- Anotar el nombre del script (ej: 105_backfill_tokens_roles.sql)
- Copiar el error exacto
- Revisar que:
  - Las tablas legacy que referencia existen (`SHOW TABLES LIKE 'token'`)
  - No haya errores de permisos (`SHOW GRANTS FOR 'root'@'localhost'`)
  - No haya conflictos de collation (revisa los CONVERT UTF-8)

### Datos que no migran
- Ejecutar 204_backfill_gap_details.sql
- Ver cuáles registros legacy quedan sin enlazar
- Determinar si es normal (ej: IDs huérfanos) o un bug

### Duplicados después de re-ejecutar
- **No debería pasar** (scripts son idempotentes)
- Si pasa, revisar que el script use `ON DUPLICATE KEY UPDATE`
- Posible issue: unique key está mal definida

---

## Conclusión

Una vez completada esta checklist, el DB está listo para que el backend PHP (ru-api/php/src) lo utilice.

La siguiente fase es adaptar los endpoints y servicios PHP para consultar el nuevo schema en inglés.
