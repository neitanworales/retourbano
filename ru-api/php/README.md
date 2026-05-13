# RetOurbano API v1 - New Architecture

## Overview

This is the refactored backend architecture for RetOurbano, implementing clean code principles with separated concerns using the MVC pattern and Repository pattern.

## Architecture

### Directory Structure

```
ru-api/php/
├── config/
│   ├── Database.php         # Database configuration
│   └── Constants.php        # Application constants
├── src/
│   ├── Core/
│   │   ├── Exception.php    # Custom exceptions
│   │   ├── Controller.php   # Base controller
│   │   ├── Service.php      # Base service
│   │   └── Router.php       # Simple router
│   ├── Database/
│   │   └── Connection.php   # PDO connection manager
│   ├── Middleware/
│   │   └── Middleware.php   # CORS, Auth, Rate Limit
│   ├── Models/
│   │   ├── User.php         # User model
│   │   └── Campamento.php   # Campamento model
│   ├── Repository/
│   │   ├── Repository.php   # Base repository (CRUD)
│   │   ├── UserRepository.php
│   │   └── CampamentoRepository.php
│   ├── Services/
│   │   ├── AuthService.php         # Authentication logic
│   │   └── RegistrationService.php # Registration logic
│   └── Controllers/
│       ├── AuthController.php         # Auth endpoints
│       └── RegistrationController.php # Registration endpoints
├── routes/
│   └── api.php              # API routes definition
├── public/
│   ├── index.php            # Entry point
│   └── .htaccess            # URL rewriting rules
├── bootstrap.php            # Application bootstrap
├── .env                     # Environment variables
└── .env.example             # Environment example
```

## Key Improvements

### 1. **Security**
- **PDO with Prepared Statements**: All database queries use parameterized queries to prevent SQL injection
- **Password Hashing**: Uses PHP's `password_hash()` for secure password storage
- **CORS Middleware**: Handles cross-origin requests safely
- **Input Validation**: Centralized validation in Service layer
- **Error Handling**: Doesn't leak sensitive information in production

### 2. **Code Organization**
- **Separation of Concerns**: Models, Services, Repositories, Controllers are clearly separated
- **DRY Principle**: Base classes for Repository, Controller, Service eliminate code duplication
- **Single Responsibility**: Each class has one clear purpose
- **Dependency Injection**: Services receive dependencies (repositories) in constructor

### 3. **Maintainability**
- **Clear Code Structure**: Easy to find and modify business logic
- **Testable Code**: Dependencies are injected, making unit tests easier
- **Documented**: Each class and method has clear documentation
- **Scalable**: New features can be added without affecting existing code

### 4. **API Design**
- **Versioned Routes**: All endpoints start with `/api/v1/`
- **RESTful**: Follows REST conventions for endpoints
- **Consistent Response Format**: All responses follow a standard JSON format
- **Proper HTTP Status Codes**: Uses correct codes (200, 201, 400, 401, 404, 422, 500)

## Getting Started

### 1. Setup Environment

```bash
# Copy environment file
cp .env.example .env

# Edit .env with your database credentials
nano .env
```

### 2. Update Apache/Nginx Configuration

Make sure your web server points to the `public/` directory:

**Apache:**
```apache
<VirtualHost *:80>
    ServerName api.retourbano.local
    DocumentRoot /path/to/ru-api/php/public
    
    <Directory /path/to/ru-api/php/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

**Nginx:**
```nginx
server {
    listen 80;
    server_name api.retourbano.local;
    root /path/to/ru-api/php/public;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
}
```

### 3. Test the API

```bash
# Test health check
curl http://localhost:8000/api/v1/health

# Login
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password"
  }'
```

## API Endpoints

### Authentication
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/logout` - Logout user
- `POST /api/v1/auth/forgot-password` - Request password reset
- `POST /api/v1/auth/reset-password` - Reset password with token
- `PUT /api/v1/auth/change-password` - Change password for authenticated user

### Registration
- `POST /api/v1/registration/register` - Register with campamento
- `GET /api/v1/registration/profile/{id}` - Get user profile
- `PUT /api/v1/registration/profile/{id}` - Update user profile
- `POST /api/v1/registration/reregister` - Re-register in campamento
- `POST /api/v1/registration/confirm-email` - Confirm email address
- `GET /api/v1/registration/my-registrations/{id}` - Get user registrations

## Adding New Endpoints

### 1. Create Model
```php
// src/Models/YourModel.php
class YourModel {
    // Define properties
}
```

### 2. Create Repository
```php
// src/Repository/YourRepository.php
class YourRepository extends Repository {
    protected $table = 'your_table';
    // Add custom query methods
}
```

### 3. Create Service
```php
// src/Services/YourService.php
class YourService extends Service {
    public function yourMethod() {
        // Business logic here
        return $this->repository->yourCustomMethod();
    }
}
```

### 4. Create Controller
```php
// src/Controllers/YourController.php
class YourController extends Controller {
    public function yourEndpoint() {
        // Handle request and call service
        $this->success($data);
    }
}
```

### 5. Add Routes
```php
// routes/api.php
$router->get('/api/v1/your-endpoint', 'YourController@yourEndpoint');
```

## Response Format

All responses follow this format:

**Success:**
```json
{
  "success": true,
  "code": 200,
  "message": "Operation successful",
  "data": {}
}
```

**Error:**
```json
{
  "success": false,
  "code": 400,
  "error": "ERROR_CODE",
  "message": "Error message",
  "errors": {}
}
```

## Database Migrations

To update the database structure, modify your tables to include necessary columns. Key fields:

### Users Table (guerreros)
- id (INT, PRIMARY KEY)
- nombre (VARCHAR)
- email (VARCHAR, UNIQUE)
- password (VARCHAR)
- status (VARCHAR)
- fechahora_registro (DATETIME)
- And all other existing fields...

### Campamentos Table
- id (INT, PRIMARY KEY)
- nombre (VARCHAR)
- descripcion (TEXT)
- fecha_inicio (DATE)
- fecha_fin (DATE)
- ubicacion (VARCHAR)
- capacidad (INT)
- costo (DECIMAL)
- estado (VARCHAR)
- año (INT)

## Debugging

Set `APP_DEBUG=true` in `.env` to see detailed error messages. In production, always set to `false`.

## Future Enhancements

- [ ] JWT token implementation
- [ ] Email service integration
- [ ] Rate limiting with Redis
- [ ] API documentation with Swagger/OpenAPI
- [ ] Database query logging
- [ ] Request/Response logging
- [ ] Unit tests
- [ ] Integration tests

## Common Issues

### 404 Not Found
- Check that route is defined in `routes/api.php`
- Verify controller and method names
- Check .htaccess is enabled

### Database Connection Error
- Verify credentials in `.env`
- Check database server is running
- Verify user has correct permissions

### CORS Error
- Check CorsMiddleware is enabled
- Verify request headers are correct

## Migration from Old Code

See [MIGRATION.md](../../Migration.md) for detailed migration guide.
