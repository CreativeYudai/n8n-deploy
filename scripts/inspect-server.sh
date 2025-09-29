#!/bin/bash

# Script para inspeccionar el estado completo del servidor n8n

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Inspeccionando servidor n8n...${NC}"

# Verificar ubicación de archivos
echo -e "\n${YELLOW}📁 Estructura de directorios en /ubuntu/n8n:${NC}"
ansible n8n-prod -m shell -a "find /ubuntu/n8n -type f -exec ls -la {} \; 2>/dev/null | head -50"

echo -e "\n${YELLOW}📄 Contenido del archivo .env:${NC}"
ansible n8n-prod -m shell -a "cat /ubuntu/n8n/.env"

echo -e "\n${YELLOW}🐳 Contenido del docker-compose.yml:${NC}"
ansible n8n-prod -m shell -a "cat /ubuntu/n8n/docker-compose.yml"

echo -e "\n${YELLOW}🌐 Configuración de nginx:${NC}"
ansible n8n-prod -m shell -a "cat /ubuntu/n8n/nginx/sites-available/n8n.conf"

echo -e "\n${YELLOW}🔒 Estado de certificados SSL:${NC}"
ansible n8n-prod -m shell -a "ls -la /ubuntu/n8n/certbot/conf/ 2>/dev/null || echo 'No SSL certificates found'"

echo -e "\n${YELLOW}📋 Estado de contenedores Docker:${NC}"
ansible n8n-prod -m shell -a "docker ps -a"

echo -e "\n${YELLOW}🔍 Logs del contenedor nginx:${NC}"
ansible n8n-prod -m shell -a "docker logs \$(docker ps -q --filter name=nginx) --tail 20 2>/dev/null || echo 'Nginx container not running'"

echo -e "\n${YELLOW}🔍 Logs del contenedor n8n:${NC}"
ansible n8n-prod -m shell -a "docker logs \$(docker ps -q --filter name=n8n-n8n) --tail 10 2>/dev/null || echo 'n8n container not running'"

echo -e "\n${YELLOW}🌐 Verificar puertos en uso:${NC}"
ansible n8n-prod -m shell -a "ss -tlnp | grep -E ':(80|443|5678)'"

echo -e "\n${YELLOW}💾 Uso de disco:${NC}"
ansible n8n-prod -m shell -a "df -h /"

echo -e "\n${YELLOW}🔐 Estado del firewall UFW:${NC}"
ansible n8n-prod -m shell -a "ufw status"

echo -e "\n${YELLOW}📊 Estado de los servicios systemd:${NC}"
ansible n8n-prod -m shell -a "systemctl status docker --no-pager -l"

echo -e "\n${GREEN}✅ Inspección completada${NC}"