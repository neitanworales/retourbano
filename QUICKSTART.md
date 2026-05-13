# 🚀 Quick Start - Fase 2

## Empezar en 5 minutos

### 1️⃣ Configurar entorno
```bash
cd ru-api/php
cp .env.example .env
```

Editar `.env` con tus credenciales:
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=jucum_pachuca
```

### 2️⃣ Verificar instalación
```bash
# Testear que PHP puede cargar los archivos
php -l public/index.php

# Testear que la BD conecta
php -r "require 'bootstrap.php'; echo 'OK';"
```

### 3️⃣ Configurar web server

**Apache** (recomendado):
```apache
<VirtualHost *:8000>
    ServerName api.local
    DocumentRoot /ruta/completa/ru-api/php/public
    
    <Directory /ruta/completa/ru-api/php/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

**Nginx:**
```nginx
server {
    listen 8000;
    server_name api.local;
    root /ruta/completa/ru-api/php/public;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
}
```

### 4️⃣ Testear API
```bash
# Health check
curl http://localhost:8000/api/v1/health

# Expected response:
{
  "success": true,
  "message": "API is running",
  "version": "v1",
  "timestamp": "2026-05-13 10:30:00"
}
```

### 5️⃣ Testear endpoints con curl

**Registrar usuario:**
```bash
curl -X POST http://localhost:8000/api/v1/registration/register \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "John Doe",
    "email": "john@example.com",
    "edad": 20,
    "sexo": "M",
    "campamentoId": 1
  }'
```

**Login:**
```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

---

## 📁 Estructura de Carpetas

```
ru-api/php/
├── src/                    # Código fuente
├── public/                 # Entry point (index.php)
├── routes/                 # Definición de rutas
├── config/                 # Configuración
├── bootstrap.php           # Carga de dependencias
├── .env                    # Variables (GIT IGNORE)
├── .env.example            # Plantilla
├── README.md               # Documentación
└── Postman_Collection.json # Tests para Postman
```

---

## 🔌 Importar en Postman

1. Abrir Postman
2. Click en "Import"
3. Seleccionar archivo `Postman_Collection.json`
4. Todos los endpoints aparecen automáticamente
5. Cambiar variable `{{base_url}}` a `http://localhost:8000`

---

## 🐛 Debugging

### Ver errores detallados
```bash
# Editar .env
APP_DEBUG=true

# Ahora verás stack traces (solo en desarrollo!)
```

### Ver logs
```bash
# Crear carpeta logs (si no existe)
mkdir logs

# Los errores se guardarán aquí
tail -f logs/error.log
```

---

## 📞 Problemas Comunes

### "404 Not Found"
- Verificar que la ruta está en `routes/api.php`
- Verificar que el Controller existe
- Verificar que el método existe en el Controller

### "Database connection failed"
- Verificar BD está corriendo
- Verificar credenciales en `.env`
- Verificar usuario tiene permisos

### "Fatal error: Class not found"
- Verificar que el archivo existe
- Verificar que require/include es correcto
- Verificar namespace (si aplica)

---

## 🎯 Próximo Paso

Ver **[MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md)** para migrar endpoints antiguos a la nueva arquitectura.

---

**¿Necesitas ayuda?** Ver:
- [README.md](./ru-api/php/README.md) - Documentación completa
- [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md) - Cómo migrar código
- [FASE2_RESUMEN.md](./FASE2_RESUMEN.md) - Qué se cambió
