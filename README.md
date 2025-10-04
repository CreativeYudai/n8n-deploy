
# 🚀 n8n Deploy Project

**Complete automated deployment solution for n8n (workflow automation) with Docker and Ansible.**

[![Deployment Status](https://img.shields.io/badge/deployment-successful-brightgreen)](https://n8n.yudaicreator.com)
[![Docker](https://img.shields.io/badge/docker-ready-blue)](https://www.docker.com/)
[![Ansible](https://img.shields.io/badge/ansible-automated-red)](https://www.ansible.com/)
[![SSL](https://img.shields.io/badge/ssl-lets%20encrypt-orange)](https://letsencrypt.org/)

## ✨ Features

### 🐳 **Complete Docker Stack**
- **n8n** - Workflow automation platform
- **PostgreSQL 15** - Main database with optimizations
- **Redis 7** - Cache and in-memory storage
- **Nginx Alpine** - Reverse proxy with security configuration
- **Certbot** - Automatic SSL certificates from Let's Encrypt

### 🤖 **Ansible Automation**
- ✅ Complete Docker and Docker Compose installation  
- ✅ UFW firewall configuration with optimized rules
- ✅ Fail2ban protection against brute force attacks
- ✅ Automatic swap configuration for memory optimization
- ✅ Automatic SSL certificates with scheduled renewal
- ✅ Auto-start services with systemd
- ✅ Automatic system cleanup and maintenance
- ✅ Automatic resolution of port conflicts

### 🔒 **Enterprise Security**
- 🛡️ Mandatory HTTPS with Let's Encrypt certificates
- 🛡️ Rate limiting and DDoS protection
- 🛡️ Optimized security headers
- 🛡️ Configured firewall (ports 22, 80, 443)
- 🛡️ Active fail2ban against SSH and web attacks
- 🛡️ Secure passwords generated automatically

## 📁 Project Structure

```
n8n-deploy/
├── 📄 Makefile                    # Main automated commands
├── 🐳 docker-compose.yml          # Complete services stack
├── 🔧 .env.example               # Environment variables template
├── 📖 README.md                  # Complete documentation
│
├── 🌐 nginx/                     # Nginx configuration
│   ├── nginx.conf               # Main configuration
│   └── sites-available/
│       └── n8n.conf            # SSL-specific site
│
├── 🗄️ postgres/                  # PostgreSQL configuration
│   └── init/
│       └── init-n8n-db.sh      # Initialization script
│
├── 🔄 n8n/
│   └── custom-nodes/            # Custom nodes
│
├── 🤖 ansible/                   # Deployment automation
│   ├── site.yml                # Main playbook
│   ├── ansible.cfg             # Ansible configuration
│   ├── requirements.yml        # Required collections
│   ├── inventory/
│   │   └── hosts.yml           # Server configuration
│   ├── tasks/                  # Modular tasks
│   │   ├── cleanup.yml         # System cleanup
│   │   ├── docker.yml          # Docker installation
│   │   ├── fail2ban.yml        # Security configuration
│   │   ├── firewall.yml        # UFW configuration
│   │   ├── n8n.yml            # n8n deployment
│   │   ├── ssl.yml            # SSL certificates
│   │   └── swap.yml           # Swap configuration
│   └── templates/              # Jinja2 templates
│       ├── docker-compose.yml.j2
│       ├── .env.j2
│       ├── nginx.conf.j2
│       ├── n8n.conf.j2
│       └── init-n8n-db.sh.j2
│
├── 📖 docs/                      # Documentation
│   └── GIT_DEPLOYMENT.md       # Git-based deployment guide
│
└── 🛠️ scripts/                   # Utility scripts
    ├── deploy.sh               # Automated Git deployment
    ├── generate-keys.sh        # Secure key generation
    ├── local-deploy.sh         # Local deployment
    ├── production-deploy.sh    # Production deployment
    ├── backup.sh              # Automatic backup
    ├── check-server-status.sh  # Server verification
    ├── cleanup-server.sh      # Server cleanup
    ├── fix-port-conflicts.sh  # Conflict resolution
    ├── fix-ssl-links.sh       # SSL repair
    └── inspect-server.sh      # Complete inspection
```

## 🛠️ System Requirements

### **For Local Development:**
- 🐳 Docker 20.10+
- 🐳 Docker Compose 2.0+
- 💾 4GB RAM minimum
- 💾 10GB free space

### **For Production:**
- 🤖 Ansible 2.9+
- 🖥️ Servidor Ubuntu 20.04/22.04 LTS o Debian 11+
- 🌐 Dominio con DNS configurado
- 🔑 Acceso SSH con sudo
- 💾 8GB RAM recomendado
- 💾 30GB espacio en disco

## ⚡ Quick Start

### 🏠 **Local Deploy (5 minutes)**

```bash
# 1. Clone repository
git clone https://github.com/CreativeYudai/n8n-deploy.git
cd n8n-deploy

# 2. Complete automatic setup
make setup

# 3. Local deploy
make install-local

# 4. Ready! Access n8n
open http://localhost:5678
```

### 🌐 **Production Deploy (10 minutes)**

```bash
# 1. Configure server in inventory
cp ansible/inventory/hosts.yml.example ansible/inventory/hosts.yml
# Edit hosts.yml with your server data

# 2. Complete automatic deploy
make install-prod

# 3. Ready! n8n available with HTTPS
# URL: https://your-domain.com
```

## 🔄 Git-Based Deployment (New)

### **Git-Based Deployment - Recommended for Production**

Now you can make changes to your configuration and deploy them using Git, without needing to run Ansible every time.

#### **🚀 Initial Setup (One time only)**
```bash
# 1. Initial deploy with Ansible (includes Git setup)
cd ansible
ansible-playbook -i inventory/hosts.yml site.yml
```

#### **📦 Deploy Changes (Automatic Method)**
```bash
# Make changes to nginx, docker-compose, etc.
git add .
git commit -m "Configuration update"

# Automatic deploy with one command
./scripts/deploy.sh
```

#### **📦 Manual Deploy**
```bash
# 1. Push changes
git push origin main

# 2. Update server
ssh user@server "update-n8n"
```

#### **🔄 Update Server Only**
```bash
# If someone else made changes and you want to update them
ssh user@server "update-n8n"
```

> 📖 **[See complete Git Deployment documentation](docs/GIT_DEPLOYMENT.md)**

## 🎯 Main Commands (Makefile)

### **📦 Setup and Deploy**
```bash
make setup          # Complete initial configuration
make install-local   # Local deploy for development  
make install-prod    # Production deploy with SSL
make clean          # Clean local environment
```

### **🔧 Maintenance**
```bash
make server-status   # Complete server status
make inspect        # Detailed inspection (files, logs, certificates)
make backup         # n8n and database backup
make cleanup-server # Automatic server cleanup
```

### **🔐 Troubleshooting**
```bash
make fix-ports      # Resolve port conflicts 80/443
make fix-ssl        # Repair SSL certificate links
make ansible-check  # Verify SSH connectivity
```

### **📊 Monitoring**
```bash
make logs           # View n8n logs (local)
make ansible-logs   # View n8n logs (production)
make ansible-status # Container status in production
make ansible-restart # Restart services in production
```

## ⚙️ Configuración

### 🔧 **Variables de Entorno Principales**

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `N8N_HOST` | Dominio de tu instancia | `n8n.tudominio.com` |
| `N8N_ENCRYPTION_KEY` | Clave de encriptación (32 chars) | Auto-generada |
| `N8N_JWT_SECRET` | Secreto JWT para autenticación | Auto-generada |
| `POSTGRES_PASSWORD` | Contraseña de PostgreSQL | Auto-generada |
| `REDIS_PASSWORD` | Contraseña de Redis | Auto-generada |

> 🔐 **Todas las contraseñas se generan automáticamente de forma segura**

### 🌐 **Configuración de Nginx (Optimizada)**

- ✅ **SSL/TLS** con certificados Let's Encrypt
- ✅ **HTTP/2** para mejor rendimiento  
- ✅ **Rate Limiting** (20 req/min por IP)
- ✅ **Security Headers** completos
- ✅ **Gzip Compression** habilitada
- ✅ **WebSocket Proxy** para n8n
- ✅ **Timeouts optimizados** (86400s para workflows largos)

### 🛡️ **Configuraciones de Seguridad**

#### **Firewall UFW:**
- Puerto 22 (SSH) - Solo IPs autorizadas
- Puerto 80 (HTTP) - Redirigido a HTTPS
- Puerto 443 (HTTPS) - Abierto
- Todo lo demás bloqueado

#### **Fail2ban:**
- Protección SSH (5 intentos = ban 10min)
- Protección Nginx (10 intentos = ban 1h)
- Filtros personalizados para n8n

#### **SSL/HTTPS:**
- Certificados Let's Encrypt automáticos
- Renovación automática cada 12h
- HSTS habilitado (1 año)
- Ciphers seguros únicamente

## 📊 Administración y Mantenimiento

### 🔄 **Backups Automáticos**
```bash
make backup                    # Backup manual completo
crontab -e                     # Agregar backup automático:
# 0 2 * * * cd /path/to/n8n-deploy && make backup
```

### 📈 **Monitoreo en Tiempo Real**
```bash
make ansible-logs             # Logs en vivo
make server-status            # CPU, RAM, Disk
watch 'make ansible-status'   # Estado contenedores cada 2s
```

### 🔄 **Actualizaciones**
```bash
# Actualizar n8n a última versión
make ansible-restart          # Reinicia con última imagen

# Actualizar todo el stack
cd ansible && ansible-playbook site.yml
```

### 🧹 **Limpieza Automática**
```bash
make cleanup-server           # Limpia logs, cache, imágenes Docker
# Se ejecuta automáticamente en cada deploy
```

## � Troubleshooting y Diagnósticos

### 🔍 **Diagnóstico Completo**
```bash
make inspect                   # Inspección completa: archivos, logs, certificados
make server-status            # Recursos del servidor: CPU, RAM, Disk
make ansible-check            # Verificar conectividad SSH
```

### 🐳 **Problemas con Contenedores**

#### **Nginx no inicia:**
```bash
make fix-ports                # Liberar puertos 80/443 ocupados
make fix-ssl                  # Reparar enlaces de certificados SSL
make ansible-logs             # Ver logs detallados
```

#### **n8n no se conecta a la base de datos:**
```bash
make ansible-status           # Verificar estado PostgreSQL
make ansible-restart          # Reiniciar servicios en orden
```

### 💾 **Problemas de Espacio en Disco**
```bash
# Error: "No space left on device"
make cleanup-server           # Limpieza automática completa
make server-status            # Verificar espacio liberado

# Si persiste el problema:
ansible n8n-prod -i ansible/inventory/hosts.yml -m shell -a "df -h"
ansible n8n-prod -i ansible/inventory/hosts.yml -m shell -a "docker system prune -a -f"
```

### 🔐 **Problemas SSL/HTTPS**
```bash
# Certificados no funcionan:
make fix-ssl                  # Crear enlaces simbólicos faltantes

# Verificar certificados:
make inspect                  # Ver estado completo SSL

# Regenerar certificados:
ansible n8n-prod -i ansible/inventory/hosts.yml -m shell -a "certbot renew --force-renewal"
```

### 🌐 **Problemas de Conectividad**
```bash
# No se puede acceder al sitio:
make fix-ports                # Resolver conflictos de puertos
make ansible-status           # Verificar estado de nginx

# Verificar DNS:
nslookup tu-dominio.com
dig tu-dominio.com

# Verificar firewall:
ansible n8n-prod -i ansible/inventory/hosts.yml -m shell -a "ufw status"
```

### 📋 **Comandos de Estado Rápido**
```bash
make ansible-status           # Estado de todos los contenedores
make ansible-logs             # Logs de n8n en tiempo real
docker ps                     # Estado local (desarrollo)
```

### 🔄 **Reinicio de Servicios**
```bash
# Reinicio completo:
make ansible-restart          # Todos los servicios

# Reinicio selectivo:
ansible n8n-prod -i ansible/inventory/hosts.yml -m shell -a "cd /ubuntu/n8n && docker-compose restart nginx"
ansible n8n-prod -i ansible/inventory/hosts.yml -m shell -a "cd /ubuntu/n8n && docker-compose restart n8n"
```

### 📞 **Obtener Ayuda**
Si los problemas persisten:

1. **Ejecutar diagnóstico completo:** `make inspect`
2. **Revisar logs:** `make ansible-logs`  
3. **Verificar recursos:** `make server-status`
4. **Abrir issue** en GitHub con la salida de los comandos anteriores

## 🌐 URLs y Accesos

### **Producción (HTTPS)**
- 🌍 **n8n Web Interface:** https://n8n.yudaicreator.com
- 🔒 **SSL Grade:** A+ (Let's Encrypt)
- ⚡ **HTTP/2:** Habilitado
- 🛡️ **Security Headers:** Completos

### **Desarrollo Local**
- 🏠 **n8n Interface:** http://localhost:5678
- 🗄️ **PostgreSQL:** localhost:5432
- 🔄 **Redis:** localhost:6379
- 🌐 **Nginx:** localhost:80

## 📈 Stack Tecnológico

| Componente | Versión | Función |
|------------|---------|---------|
| **n8n** | Latest | Plataforma de automatización |
| **PostgreSQL** | 15 | Base de datos principal |
| **Redis** | 7-alpine | Cache y sesiones |
| **Nginx** | Alpine | Reverse proxy + SSL |
| **Certbot** | Latest | Certificados SSL automáticos |
| **Docker** | 20.10+ | Contenedorización |
| **Ansible** | 2.9+ | Automatización de deploy |

## 🎯 Casos de Uso

### **Automatización Empresarial**
- ✅ Integración de APIs y servicios
- ✅ Workflows de marketing automation
- ✅ Procesamiento de datos en tiempo real
- ✅ Sincronización entre sistemas

### **DevOps y CI/CD**
- ✅ Deploy automático de aplicaciones
- ✅ Monitoreo y alertas personalizadas
- ✅ Backup y sincronización de datos
- ✅ Gestión de infraestructura

### **E-commerce y CRM**
- ✅ Sincronización inventario/ventas
- ✅ Automatización de emails
- ✅ Procesamiento de pedidos
- ✅ Análisis de datos de clientes

## 🏆 Características Destacadas

- 🚀 **Deploy en 10 minutos** con un solo comando
- 🔄 **Zero-downtime updates** con Docker
- 📊 **Monitoreo integrado** y alertas
- 🔐 **Seguridad enterprise** desde el inicio
- 📱 **Responsive design** para móviles
- 🌍 **Multi-región** ready
- 📈 **Escalable horizontalmente**
- 🔧 **Mantenimiento automatizado**

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! 

### **Proceso de Contribución:**
1. 🍴 Fork el proyecto
2. 🌱 Crea una rama: `git checkout -b feature/nueva-funcionalidad`
3. ✨ Commit tus cambios: `git commit -m 'Add: nueva funcionalidad'`
4. 📤 Push a la rama: `git push origin feature/nueva-funcionalidad`
5. 🔄 Abre un Pull Request

### **Áreas de Contribución:**
- 📚 Documentación y guías
- 🐛 Reportes de bugs y fixes
- ✨ Nuevas funcionalidades
- 🧪 Tests y validaciones
- 🔐 Mejoras de seguridad
- 📊 Monitoreo y métricas

## 📞 Soporte

- 📧 **Email:** support@yudaicreator.com
- � **Issues:** [GitHub Issues](https://github.com/CreativeYudai/n8n-deploy/issues)
- 💬 **Discussions:** [GitHub Discussions](https://github.com/CreativeYudai/n8n-deploy/discussions)
- 📖 **Wiki:** [Documentación completa](https://github.com/CreativeYudai/n8n-deploy/wiki)

## �📄 Licencia

Este proyecto está bajo la **Licencia MIT**. Ver [LICENSE](LICENSE) para más detalles.

---

<div align="center">

**🚀 Hecho con ❤️ por [CreativeYudai](https://yudaicreator.com)**

[![GitHub stars](https://img.shields.io/github/stars/CreativeYudai/n8n-deploy?style=social)](https://github.com/CreativeYudai/n8n-deploy/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/CreativeYudai/n8n-deploy?style=social)](https://github.com/CreativeYudai/n8n-deploy/network/members)
[![GitHub issues](https://img.shields.io/github/issues/CreativeYudai/n8n-deploy)](https://github.com/CreativeYudai/n8n-deploy/issues)

**¿Te gustó el proyecto? ¡Dale una ⭐ y compártelo!**

</div>
