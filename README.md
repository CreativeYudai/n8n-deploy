
# 🚀 n8n Deploy Project

**Solución completa de deployment automatizado para n8n (workflow automation) con Docker y Ansible.**

[![Deployment Status](https://img.shields.io/badge/deployment-successful-brightgreen)](https://n8n.yudaicreator.com)
[![Docker](https://img.shields.io/badge/docker-ready-blue)](https://www.docker.com/)
[![Ansible](https://img.shields.io/badge/ansible-automated-red)](https://www.ansible.com/)
[![SSL](https://img.shields.io/badge/ssl-lets%20encrypt-orange)](https://letsencrypt.org/)

## ✨ Características

### 🐳 **Stack Dockerizado Completo**
- **n8n** - Plataforma de automatización de workflows
- **PostgreSQL 15** - Base de datos principal con optimizaciones
- **Redis 7** - Cache y almacenamiento en memoria
- **Nginx Alpine** - Reverse proxy con configuración de seguridad
- **Certbot** - Certificados SSL automáticos de Let's Encrypt

### 🤖 **Automatización con Ansible**
- ✅ Instalación completa de Docker y Docker Compose  
- ✅ Configuración de firewall UFW con reglas optimizadas
- ✅ Protección fail2ban contra ataques de fuerza bruta
- ✅ Configuración de swap automática para optimización de memoria
- ✅ Certificados SSL automáticos con renovación programada
- ✅ Auto-inicio de servicios con systemd
- ✅ Limpieza automática de sistema y mantenimiento
- ✅ Resolución automática de conflictos de puertos

### 🔒 **Seguridad Enterprise**
- 🛡️ HTTPS obligatorio con certificados Let's Encrypt
- 🛡️ Rate limiting y protección DDoS
- 🛡️ Security headers optimizados
- 🛡️ Firewall configurado (puertos 22, 80, 443)
- 🛡️ Fail2ban activo contra ataques SSH y web
- 🛡️ Passwords seguros generados automáticamente

## 📁 Estructura del Proyecto

```
n8n-deploy/
├── 📄 Makefile                    # Comandos automatizados principales
├── 🐳 docker-compose.yml          # Stack completo de servicios
├── 🔧 .env.example               # Template de variables de entorno
├── 📖 README.md                  # Documentación completa
│
├── 🌐 nginx/                     # Configuración de Nginx
│   ├── nginx.conf               # Configuración principal
│   └── sites-available/
│       └── n8n.conf            # Site específico con SSL
│
├── 🗄️ postgres/                  # Configuración de PostgreSQL
│   └── init/
│       └── init-n8n-db.sh      # Script de inicialización
│
├── 🔄 n8n/
│   └── custom-nodes/            # Nodos personalizados
│
├── 🤖 ansible/                   # Automatización de deployment
│   ├── site.yml                # Playbook principal
│   ├── ansible.cfg             # Configuración de Ansible
│   ├── requirements.yml        # Colecciones necesarias
│   ├── inventory/
│   │   └── hosts.yml           # Configuración de servidores
│   ├── tasks/                  # Tareas modulares
│   │   ├── cleanup.yml         # Limpieza de sistema
│   │   ├── docker.yml          # Instalación Docker
│   │   ├── fail2ban.yml        # Configuración seguridad
│   │   ├── firewall.yml        # Configuración UFW
│   │   ├── n8n.yml            # Deploy de n8n
│   │   ├── ssl.yml            # Certificados SSL
│   │   └── swap.yml           # Configuración swap
│   └── templates/              # Templates Jinja2
│       ├── docker-compose.yml.j2
│       ├── .env.j2
│       ├── nginx.conf.j2
│       ├── n8n.conf.j2
│       └── init-n8n-db.sh.j2
│
└── 🛠️ scripts/                   # Scripts de utilidad
    ├── generate-keys.sh        # Generación de claves seguras
    ├── local-deploy.sh         # Deploy local
    ├── production-deploy.sh    # Deploy producción
    ├── backup.sh              # Backup automático
    ├── check-server-status.sh  # Verificación de servidor
    ├── cleanup-server.sh      # Limpieza de servidor
    ├── fix-port-conflicts.sh  # Resolución conflictos
    ├── fix-ssl-links.sh       # Reparación SSL
    └── inspect-server.sh      # Inspección completa
```

## 🛠️ Requisitos del Sistema

### **Para Desarrollo Local:**
- 🐳 Docker 20.10+
- 🐳 Docker Compose 2.0+
- 💾 4GB RAM mínimo
- 💾 10GB espacio libre

### **Para Producción:**
- 🤖 Ansible 2.9+
- 🖥️ Servidor Ubuntu 20.04/22.04 LTS o Debian 11+
- 🌐 Dominio con DNS configurado
- 🔑 Acceso SSH con sudo
- 💾 8GB RAM recomendado
- 💾 30GB espacio en disco

## ⚡ Quick Start

### 🏠 **Deploy Local (5 minutos)**

```bash
# 1. Clonar repositorio
git clone https://github.com/CreativeYudai/n8n-deploy.git
cd n8n-deploy

# 2. Setup completo automático
make setup

# 3. Deploy local
make install-local

# 4. ¡Listo! Acceder a n8n
open http://localhost:5678
```

### 🌐 **Deploy Producción (10 minutos)**

```bash
# 1. Configurar servidor en inventario
cp ansible/inventory/hosts.yml.example ansible/inventory/hosts.yml
# Editar hosts.yml con datos de tu servidor

# 2. Deploy completo automático
make install-prod

# 3. ¡Listo! n8n disponible con HTTPS
# URL: https://tu-dominio.com
```

## 🎯 Comandos Principales (Makefile)

### **📦 Setup y Deploy**
```bash
make setup          # Configuración inicial completa
make install-local   # Deploy local para desarrollo  
make install-prod    # Deploy producción con SSL
make clean          # Limpiar entorno local
```

### **🔧 Mantenimiento**
```bash
make server-status   # Estado completo del servidor
make inspect        # Inspección detallada (archivos, logs, certificados)
make backup         # Backup de n8n y base de datos
make cleanup-server # Limpieza automática de servidor
```

### **🔐 Solución de Problemas**
```bash
make fix-ports      # Resolver conflictos de puertos 80/443
make fix-ssl        # Reparar enlaces de certificados SSL
make ansible-check  # Verificar conectividad SSH
```

### **📊 Monitoreo**
```bash
make logs           # Ver logs de n8n (local)
make ansible-logs   # Ver logs de n8n (producción)
make ansible-status # Estado de contenedores en producción
make ansible-restart # Reiniciar servicios en producción
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
