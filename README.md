
# n8n Deploy Project

Este proyecto proporciona una solución completa para el despliegue de n8n (workflow automation) usando Docker y Ansible.

## 🚀 Características

1. **Instancia dockerizada de n8n** con todas sus dependencias:
   - PostgreSQL 15 como base de datos
   - Redis para caché
   - Nginx como reverse proxy
   - Certbot para certificados SSL automáticos

2. **Playbook de Ansible** para instalación automatizada en servidor:
   - Instalación de Docker y Docker Compose
   - Configuración de firewall (UFW)
   - Configuración de fail2ban para seguridad
   - Configuración de swap
   - Configuración SSL con Let's Encrypt
   - Auto-inicio de contenedores Docker en boot del sistema

## 📁 Estructura del Proyecto

```
n8n-deploy/
├── docker-compose.yml          # Configuración de servicios Docker
├── .env.example               # Variables de entorno (template)
├── nginx/                     # Configuración de Nginx
│   ├── nginx.conf
│   └── sites-available/
│       └── n8n.conf
├── postgres/                  # Configuración de PostgreSQL
│   └── init/
│       └── init-n8n-db.sh
├── n8n/
│   └── custom-nodes/         # Directorio para nodos personalizados
├── ansible/                  # Playbook de Ansible
│   ├── site.yml
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── hosts.yml
│   ├── tasks/               # Tareas de Ansible
│   └── templates/           # Templates de configuración
└── scripts/                 # Scripts de utilidad
    ├── generate-keys.sh
    ├── local-deploy.sh
    ├── production-deploy.sh
    └── backup.sh
```

## 🛠️ Requisitos

### Para desarrollo local:
- Docker
- Docker Compose

### Para producción:
- Ansible
- Servidor Ubuntu/Debian con acceso SSH
- Dominio configurado apuntando al servidor

## 🚀 Deploy Local (Desarrollo)

1. **Clonar el repositorio:**
   ```bash
   git clone <repository-url>
   cd n8n-deploy
   ```

2. **Generar claves de seguridad:**
   ```bash
   ./scripts/generate-keys.sh
   ```

3. **Configurar variables de entorno:**
   ```bash
   cp .env.example .env
   # Editar .env con tus configuraciones
   ```

4. **Deploy local:**
   ```bash
   ./scripts/local-deploy.sh
   ```

5. **Acceder a n8n:**
   - URL: http://localhost:5678
   - Usuario: admin
   - Contraseña: (definida en .env)

## 🌐 Deploy en Producción

1. **Configurar inventario de Ansible:**
   ```bash
   cp ansible/inventory/hosts.yml.example ansible/inventory/hosts.yml
   # Editar con los datos de tu servidor
   ```

2. **Generar claves de seguridad para producción:**
   ```bash
   ./scripts/generate-keys.sh
   # Copiar las claves generadas al inventario
   ```

3. **Ejecutar deploy:**
   ```bash
   ./scripts/production-deploy.sh
   ```

## 🔧 Configuración

### Variables de Entorno Importantes

- `N8N_BASIC_AUTH_USER`: Usuario para acceso básico
- `N8N_BASIC_AUTH_PASSWORD`: Contraseña para acceso básico
- `N8N_HOST`: Dominio de tu instancia
- `N8N_ENCRYPTION_KEY`: Clave de encriptación (32 caracteres)
- `N8N_JWT_SECRET`: Secreto JWT
- `POSTGRES_PASSWORD`: Contraseña de PostgreSQL

### Configuración de Nginx

El proyecto incluye configuración optimizada de Nginx con:
- SSL/TLS (Let's Encrypt)
- Rate limiting
- Security headers
- Gzip compression
- Proxy para WebSockets

### Seguridad

- Firewall configurado (UFW)
- Fail2ban para protección contra ataques
- Rate limiting en Nginx
- SSL obligatorio en producción
- Contraseñas seguras generadas automáticamente

## 📊 Mantenimiento

### Backups

```bash
./scripts/backup.sh
```

### Ver logs

```bash
# Local
docker-compose logs -f n8n

# Producción
ansible all -m shell -a 'docker-compose -f /opt/n8n/docker-compose.yml logs n8n'
```

### Actualizar n8n

```bash
# Local
docker-compose pull
docker-compose up -d

# Producción
ansible all -m shell -a 'cd /opt/n8n && docker-compose pull && docker-compose up -d'
```

## 🔍 Troubleshooting

### Verificar estado de servicios
```bash
# Local
docker-compose ps

# Producción
ansible all -m shell -a 'docker-compose -f /opt/n8n/docker-compose.yml ps'
```

### Reiniciar servicios
```bash
# Local
docker-compose restart

# Producción
ansible all -m shell -a 'cd /opt/n8n && docker-compose restart'
```

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver `LICENSE` para más detalles.
