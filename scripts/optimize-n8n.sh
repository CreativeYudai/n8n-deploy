#!/bin/bash

# Script para optimizar configuración de n8n (eliminar warnings)

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Cambiar al directorio de Ansible
cd "$(dirname "$0")/../ansible"

echo -e "${BLUE}⚡ Optimizando configuración de n8n...${NC}"

echo -e "${YELLOW}📝 Actualizando variables de entorno...${NC}"
ansible n8n-prod -i inventory/hosts.yml -m template -a "src=templates/.env.j2 dest=/ubuntu/n8n/.env mode=0600" -b

echo -e "${YELLOW}🔄 Reiniciando n8n para aplicar cambios...${NC}"
ansible n8n-prod -i inventory/hosts.yml -m shell -a "cd /ubuntu/n8n && docker-compose restart n8n" -b

echo -e "${YELLOW}⏳ Esperando que n8n esté listo...${NC}"
sleep 10

echo -e "${YELLOW}🔍 Verificando logs actualizados...${NC}"
ansible n8n-prod -i inventory/hosts.yml -m shell -a "docker logs \$(docker ps -q --filter name=n8n-n8n) --tail 15" -b

echo -e "${GREEN}✅ Optimización completada${NC}"
echo -e "${BLUE}🌐 Los WebSockets deberían funcionar sin warnings ahora${NC}"