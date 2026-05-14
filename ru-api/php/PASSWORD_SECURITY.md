# Password Security & Migration Guide

## 📋 Overview

Este proyecto implementa bcrypt (PASSWORD_BCRYPT) como estándar de hasheado de contraseñas. Todas las nuevas contraseñas deben seguir este estándar.

## 🔒 Hasheado de Contraseñas

### Estándar Actual: Bcrypt

```php
// Hasher contraseña nueva
$hash = password_hash($plainPassword, PASSWORD_BCRYPT, ['cost' => 12]);

// Verificar contraseña
if (password_verify($plainPassword, $hash)) {
    // Contraseña correcta
}
```

**Parámetros:**
- **Algorithm**: PASSWORD_BCRYPT (más seguro que PASSWORD_DEFAULT en PHP < 8.1)
- **Cost**: 12 (toma ~100ms en hardware moderno, balance seguridad/velocidad)

### ¿Por qué bcrypt?

| Característica | Bcrypt | MD5 | SHA1 |
|---|---|---|---|
| Adaptativo | ✅ Cost configurable | ❌ Fijo | ❌ Fijo |
| Salt incluido | ✅ Automático | ❌ Manual | ❌ Manual |
| Velocidad | ⚠️ Lenta (seguridad) | ❌ Muy rápida (malo) | ❌ Muy rápida (malo) |
| Ataques GPU | ⚠️ Resistente | ❌ Vulnerable | ❌ Vulnerable |
| NIST Recomendado | ✅ Sí | ❌ No | ❌ No |

## 🚀 Migración de Contraseñas Legacy

### Detección Automática

El script `scripts/migrate-passwords.php` detecta automáticamente:
- **MD5**: 32 caracteres hex
- **SHA1**: 40 caracteres hex  
- **Plaintext**: < 20 caracteres
- **Bcrypt**: Comienza con $2a$, $2b$, $2x$, $2y$

### Opción 1: Dry Run (Recomendado primero)

```bash
# Ver qué se cambiaría sin hacerlo
php scripts/migrate-passwords.php --dry-run
```

Output esperado:
```
🔐 Password Migration Tool
============================================================

⚠️  DRY RUN MODE - No changes will be made

Found 47 users to check

✓ User 1 (admin@example.com) already bcrypt
🔄 User 2 (user@example.com) detected MD5 - migrating...
   Generated temp password for account reset
...
📊 Migration Statistics:
============================================================
Total Users Scanned:    47
Already Bcrypt:         23
Legacy MD5:             18
Legacy SHA1:             4
Migrated:                0 (dry-run)
Failed:                  0
============================================================
```

### Opción 2: Ejecutar Migración

```bash
# Migrar todos los usuarios
php scripts/migrate-passwords.php
```

### Opción 3: Migrar Usuario Específico

```bash
# Migrar solo usuario ID 5
php scripts/migrate-passwords.php --user-id=5
```

## 📊 Auditar Contraseñas Actuales

### 1. Crear vista de auditoría

```bash
mysql -u root -p ywampach_retourbano < ru-api/php/database/migrations/113_audit_legacy_passwords.sql
```

### 2. Ver resumen

```sql
-- Contar por tipo
SELECT hash_type, COUNT(*) FROM v_password_audit GROUP BY hash_type;
```

### 3. Ver usuarios específicos

```sql
-- Ver todos los usuarios con MD5
SELECT id, email, hash_type FROM v_password_audit WHERE hash_type = 'MD5';

-- Ver usuarios sin contraseña
SELECT id, email, hash_type FROM v_password_audit WHERE hash_type = 'NULL';
```

## 🔑 API: Métodos de Contraseña

### AuthService

```php
// Hasher contraseña
$hash = $authService->hashPassword($plainPassword);

// Actualizar contraseña de usuario
$authService->updatePassword($userId, $newPassword);

// Validar en login (ya incluido)
$authService->login($email, $password);
```

### UserRepository

```php
// Actualizar solo el hash de contraseña
$userRepository->updatePasswordHash($userId, $newHash);
```

## 🛡️ Cambio de Contraseña: Flujo Recomendado

### 1. Endpoint: POST /api/v1/auth/change-password

```php
// En ChangePasswordController
$currentPassword = $_POST['current_password'];
$newPassword = $_POST['new_password'];

// Verificar contraseña actual
$user = $authService->validateToken($token);
if (!password_verify($currentPassword, $user->password_hash)) {
    return $response->error('Invalid current password', 401);
}

// Actualizar a nueva contraseña
$authService->updatePassword($user->id, $newPassword);
return $response->ok(['message' => 'Password updated']);
```

### 2. Endpoint: POST /api/v1/auth/reset-password

```php
// En ResetPasswordController (para usuarios sin acceso)
$email = $_POST['email'];
$user = $userRepository->findByEmail($email);

// Generar token temporal
$resetToken = bin2hex(random_bytes(32));
// Guardar en tabla temp: password_resets(token, user_id, expires_at)

// Enviar email con link: /reset?token=...
// Usuario clickea link y new password
// Validar token + actualizar contraseña
```

## ⚙️ Configuración Cost de Bcrypt

El cost actual es **12** (recomendado para 2024+).

```php
// En AuthService::hashPassword()
return password_hash($plainPassword, PASSWORD_BCRYPT, ['cost' => 12]);
```

**Ajustes según hardware:**
- **Cost 10**: ~10ms (servidores antiguos)
- **Cost 12**: ~100ms (recomendado)
- **Cost 14**: ~1000ms (servidores muy poderosos)

**Cambiar:**
```php
// Opciones en bootstrap.php
define('PASSWORD_HASH_COST', 12);
```

## 📝 Checklist: Implementación

- [x] AuthService usa bcrypt
- [x] MD5/SHA1 fallbacks removidos
- [x] Script de migración creado
- [x] Vista de auditoría creada
- [ ] Migración ejecutada en producción
- [ ] Usuarios notificados (si aplica)
- [ ] Logs creados (password-migration.log)
- [ ] Endpoint change-password implementado
- [ ] Endpoint reset-password implementado

## 🚨 Consideraciones de Seguridad

1. **Rate Limiting**: Agregar límite de intentos de login fallidos
2. **Email Verification**: Verificar email en registro
3. **2FA**: Considerar autenticación de dos factores
4. **Token Expiry**: Revisar expiración de tokens (actual: 7 días)
5. **HTTPS Only**: Asegurar que todas las contraseñas se transmiten por HTTPS
6. **Logs**: No loguear contraseñas en ningún lado

## 📋 Archivos Relacionados

```
ru-api/php/
├── src/
│   ├── Services/AuthService.php       # hashPassword(), updatePassword()
│   └── Repository/UserRepository.php   # updatePasswordHash()
├── scripts/
│   └── migrate-passwords.php           # Herramienta de migración
├── database/migrations/
│   └── 113_audit_legacy_passwords.sql  # Vista de auditoría
└── bootstrap.php                        # Carga de servicios
```

## 🔗 Referencias

- [PHP password_hash() docs](https://www.php.net/manual/en/function.password-hash.php)
- [OWASP Password Storage](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)
- [NIST Digital Identity Guidelines](https://pages.nist.gov/800-63-3/sp800-63b.html)
