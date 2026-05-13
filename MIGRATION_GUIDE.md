# Guía de Migración - De Código Antiguo a Arquitectura Nueva

## Resumen Ejecutivo

La nueva arquitectura cambia de un patrón DAO monolítico a una arquitectura limpia con separación de responsabilidades:
- **Antes**: Lógica directa en archivos PHP + un DAO gigante
- **Después**: Controllers → Services → Repositories → Connection

## Comparación: Antiguo vs Nuevo

### 1. Registro de Usuario

#### ❌ ANTIGUO (inscribir.php)
```php
<?php
require './RetoUrbanoDao.class.php';
$datos = RetoUrbanoDao::getInstance();

$nombre = $_POST['nombre'];
$email = $_POST['email'];
// ... más parámetros ...

// Lógica mezclada con HTTP
if ($datos->inscribir($nombre, $nick, ..., $hospedaje, $id_campamento, $year)) {
    // Éxito
} else {
    // Error
}
?>
```

**Problemas:**
- Validación no centralizada
- SQL injection potential (sin prepared statements)
- Lógica duplicada en RetoUrbanoDao
- No hay separación de responsabilidades
- Difícil de testear

#### ✅ NUEVO

```php
// routes/api.php
$router->post('/api/v1/registration/register', 'RegistrationController@register');

// Controllers/RegistrationController.php
class RegistrationController extends Controller {
    public function register() {
        try {
            $input = $this->getInput(); // JSON input
            $campamentoId = $input['campamentoId'];
            
            $result = $this->registrationService->registerWithCampamento($input, $campamentoId);
            $this->created($result); // Respuesta JSON 201
        } catch (ValidationException $e) {
            $this->validationError($e->errors);
        }
    }
}

// Services/RegistrationService.php
class RegistrationService extends Service {
    public function registerWithCampamento($data, $campamentoId) {
        // Validar
        $errors = $this->validateRequired($data, ['nombre', 'email']);
        if (!empty($errors)) {
            throw new ValidationException('Validation failed', $errors);
        }
        
        // Crear usuario
        $userId = $this->repository->create($data);
        
        // Asignar a campamento
        $this->assignCampamento($userId, $campamentoId);
        
        return ['id' => $userId, 'message' => 'Registered successfully'];
    }
}

// Repository/UserRepository.php
class UserRepository extends Repository {
    protected $table = 'guerreros';
    
    public function create($data) {
        // Prepared statement automáticamente
        return $this->connection->insert(
            "INSERT INTO guerreros (nombre, email, ...) VALUES (?, ?, ...)",
            [$data['nombre'], $data['email'], ...]
        );
    }
}

// Database/Connection.php
class Connection {
    public function insert($sql, $params = []) {
        $stmt = $this->pdo->prepare($sql); // Prepared statement
        $stmt->execute($params);           // Sin SQL injection
        return $this->pdo->lastInsertId();
    }
}
```

**Ventajas:**
- ✅ Validación centralizada en Service
- ✅ SQL injection prevenida con PDO
- ✅ Sin lógica duplicada
- ✅ Responsabilidades claras
- ✅ Fácil de testear

---

### 2. Login

#### ❌ ANTIGUO (login.php)
```php
<?php
$usuario = decrypt($_REQUEST['username']);
$password = decrypt($_REQUEST['password']);

if ($datos->login($usuario, $password)) {
    $registro = $datos->getGuerrroRegistradoByEmail($usuario);
    // Comparación de contraseña sin hash
    $_SESSION['guerrero'] = $registro[0];
    echo json_encode($response);
}
?>
```

**Problemas:**
- Contraseñas en texto plano (gravísimo!)
- Lógica de seguridad en el endpoint
- Hardcoded encryption/decryption

#### ✅ NUEVO
```php
// Controllers/AuthController.php
class AuthController extends Controller {
    public function login() {
        try {
            $input = $this->getInput();
            $result = $this->authService->login($input['email'], $input['password']);
            $this->success($result, 200, 'Login successful');
        } catch (AuthenticationException $e) {
            $this->unauthorized($e->getMessage());
        }
    }
}

// Services/AuthService.php
class AuthService extends Service {
    public function login($email, $password) {
        // Validar formato
        if (!$this->validateEmail($email)) {
            throw new ValidationException('Invalid email');
        }
        
        // Buscar usuario
        $user = $this->repository->findByEmail($email);
        if (!$user) {
            throw new AuthenticationException('Invalid credentials');
        }
        
        // Verificar contraseña con hash bcrypt
        if (!password_verify($password, $user['password'])) {
            throw new AuthenticationException('Invalid credentials');
        }
        
        // Generar token
        $token = $this->generateToken($user['id']);
        
        return [
            'user' => $user,
            'token' => $token
        ];
    }
}
```

**Ventajas:**
- ✅ Contraseñas hasheadas con BCRYPT
- ✅ Validación email centralizada
- ✅ Lógica de seguridad en Service
- ✅ Token seguro
- ✅ Mensajes de error genéricos (sin enumerar usuarios)

---

### 3. Actualizar Perfil

#### ❌ ANTIGUO
```php
<?php
// Sin ruteo claro
$id = $_REQUEST['id'];
$nombre = $_POST['nombre'];
// ... actualizar directamente en DAO
?>
```

#### ✅ NUEVO
```php
// routes/api.php
$router->put('/api/v1/registration/profile/{id}', 'RegistrationController@updateProfile');

// Controllers/RegistrationController.php
public function updateProfile() {
    try {
        $userId = $this->getParam('id');
        $input = $this->getInput();
        
        $this->registrationService->updateProfile($userId, $input);
        $user = $this->userRepository->find($userId);
        
        $this->success($user, 200, 'Profile updated');
    } catch (ValidationException $e) {
        $this->validationError($e->errors);
    }
}

// Services/RegistrationService.php
public function updateProfile($userId, $data) {
    // Validar email único
    if (!empty($data['email']) && $data['email'] !== $currentEmail) {
        if ($this->repository->emailExists($data['email'], $userId)) {
            throw new ValidationException('Email already in use');
        }
    }
    
    // Filtrar campos permitidos
    $updateData = [
        'nombre' => $data['nombre'] ?? null,
        'email' => $data['email'] ?? null,
        // ... solo campos permitidos
    ];
    
    return $this->repository->update($userId, $updateData);
}
```

**Ventajas:**
- ✅ Ruta versionada clara
- ✅ Validación de unicidad
- ✅ Filtrado de campos
- ✅ Respuesta JSON estructurada

---

## Patrón de Migración

### Step 1: Identificar Feature (ej: Login)
```
Antiguo: login.php → RetoUrbanoDao->login()
Nuevo: AuthController -> AuthService -> UserRepository
```

### Step 2: Mapear Métodos DAO

| Antiguo | Nuevo |
|---------|-------|
| `RetoUrbanoDao::getInstance()` | `new UserRepository($connection)` |
| `$datos->login($email, $pass)` | `$authService->login($email, $pass)` |
| `$datos->getGuerrroRegistradoByEmail()` | `$repository->findByEmail()` |

### Step 3: Crear Estructura Nueva

1. **Crear/Actualizar Repository:**
```php
class UserRepository extends Repository {
    protected $table = 'guerreros';
    
    public function findByEmail($email) {
        return $this->findBy('email', '=', $email);
    }
}
```

2. **Crear Service:**
```php
class AuthService extends Service {
    public function login($email, $password) {
        // Lógica de negocio
        $user = $this->repository->findByEmail($email);
        // ... validar, hashear, etc
        return $result;
    }
}
```

3. **Crear Controller:**
```php
class AuthController extends Controller {
    public function login() {
        try {
            $result = $this->authService->login(...);
            $this->success($result);
        } catch (Exception $e) {
            $this->error($e->getMessage(), $e->getCode());
        }
    }
}
```

4. **Agregar Ruta:**
```php
$router->post('/api/v1/auth/login', 'AuthController@login');
```

---

## Llamadas desde Frontend

### ❌ ANTIGUO
```typescript
// Angular component
this.http.post('login.php', {
  username: encrypted,
  password: encrypted
}).subscribe(response => {
  // Respuesta inconsistente
});
```

### ✅ NUEVO
```typescript
// auth.service.ts
login(email: string, password: string): Observable<LoginResponse> {
  return this.http.post<LoginResponse>(
    `${this.apiUrl}/api/v1/auth/login`,
    { email, password }
  ).pipe(
    catchError(error => this.handleError(error))
  );
}

// Component
this.authService.login(email, password).subscribe(
  response => {
    if (response.success) {
      localStorage.setItem('token', response.data.token);
    }
  },
  error => this.showError(error.error.message)
);
```

---

## Testing

### Ejemplo: Testear AuthService

```php
<?php
class AuthServiceTest {
    private $authService;
    private $mockRepository;
    
    public function setUp() {
        $this->mockRepository = $this->createMock(UserRepository::class);
        $this->authService = new AuthService($this->mockRepository);
    }
    
    public function testLoginWithValidCredentials() {
        $this->mockRepository->expects($this->once())
            ->method('findByEmail')
            ->willReturn(['id' => 1, 'password' => password_hash('pass', PASSWORD_BCRYPT)]);
        
        $result = $this->authService->login('user@example.com', 'pass');
        
        $this->assertIsArray($result);
        $this->assertArrayHasKey('token', $result);
    }
}
?>
```

---

## Checklist de Migración

Para cada feature (Login, Register, etc):

- [ ] Crear Repository si no existe
- [ ] Crear Service con lógica de negocio
- [ ] Crear Controller para HTTP
- [ ] Agregar rutas en `/routes/api.php`
- [ ] Testear con Postman
- [ ] Actualizar frontend para usar nuevos endpoints
- [ ] Eliminar archivos antiguos (cuando todo funciona)

---

## Rollback

Si algo falla durante la migración:

1. **Los archivos antiguos aún existen** en `retourbano/`
2. **Mantener ambos sistemas corriendo en paralelo** durante transición
3. **Probar nuevos endpoints con Postman** antes de cambiar frontend
4. **Una feature a la vez** para minimizar riesgo

---

## Tiempo Estimado

- **Migrar 1 feature**: ~2-3 horas (primera toma más)
- **Migrar 10 features**: ~20-30 horas
- **Testing completo**: ~10 horas
- **Total**: ~40-50 horas (~1-2 semanas)

---

## Preguntas Frecuentes

**P: ¿Necesito migrar TODO de una vez?**
R: No. Puedes mantener ambos sistemas corriendo. Migra una feature a la vez.

**P: ¿Y los datos existentes?**
R: Los datos no cambian. La estructura de BD es igual. Solo la forma de acceder cambia.

**P: ¿Y los clientes antiguos?**
R: Los endpoints antiguos pueden coexistir hasta que migres completamente. O crea redirects.

**P: ¿Qué pasa si un endpoint usa múltiples tablas?**
R: Crea un Service que combine múltiples Repositories.

---

Para dudas específicas, ver [ru-api/php/README.md](./ru-api/php/README.md)
