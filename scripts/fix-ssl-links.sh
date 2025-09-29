#!/bin/bash

# Script para crear los enlaces simbólicos de certificados SSL faltantes

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Cambiar al directorio de Ansible
cd "$(dirname "$0")/../ansible"

echo -e "${BLUE}🔒 Creando enlaces simbólicos SSL faltantes...${NC}"

DOMAIN="n8n.yudaicreator.com"
LIVE_DIR="/ubuntu/n8n/certbot/conf/live/${DOMAIN}"
ARCHIVE_DIR="/ubuntu/n8n/certbot/conf/archive/${DOMAIN}"

echo -e "${YELLOW}📁 Verificando directorios de certificados...${NC}"
ansible n8n-prod -i inventory/hosts.yml -m shell -a "ls -la ${ARCHIVE_DIR}/"

echo -e "${YELLOW}🔗 Creando enlaces simbólicos en live/...${NC}"

# Crear enlaces simbólicos con sudo
ansible n8n-prod -i inventory/hosts.yml -m shell -a "sudo rm -f ${LIVE_DIR}/cert.pem ${LIVE_DIR}/chain.pem ${LIVE_DIR}/fullchain.pem ${LIVE_DIR}/privkey.pem" -b
ansible n8n-prod -i inventory/hosts.yml -m shell -a "sudo ln -sf ../../archive/${DOMAIN}/cert1.pem ${LIVE_DIR}/cert.pem" -b
ansible n8n-prod -i inventory/hosts.yml -m shell -a "sudo ln -sf ../../archive/${DOMAIN}/chain1.pem ${LIVE_DIR}/chain.pem" -b
ansible n8n-prod -i inventory/hosts.yml -m shell -a "sudo ln -sf ../../archive/${DOMAIN}/fullchain1.pem ${LIVE_DIR}/fullchain.pem" -b
ansible n8n-prod -i inventory/hosts.yml -m shell -a "sudo ln -sf ../../archive/${DOMAIN}/privkey1.pem ${LIVE_DIR}/privkey.pem" -b

echo -e "${YELLOW}✅ Verificando enlaces creados...${NC}"
ansible n8n-prod -i inventory/hosts.yml -m shell -a "ls -la ${LIVE_DIR}/"

echo -e "${YELLOW}🔐 Verificando que los certificados sean válidos...${NC}"
ansible n8n-prod -i inventory/hosts.yml -m shell -a "sudo openssl x509 -in ${LIVE_DIR}/fullchain.pem -text -noout | grep -E '(Subject:|Issuer:|Not After :)' || echo 'Error leyendo certificado'" -b

echo -e "${YELLOW}🐳 Reiniciando contenedor nginx...${NC}"
ansible n8n-prod -i inventory/hosts.yml -m shell -a "cd /ubuntu/n8n && sudo docker-compose restart nginx" -b

echo -e "${YELLOW}📊 Verificando estado final de contenedores...${NC}"
ansible n8n-prod -i inventory/hosts.yml -m shell -a "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"

echo -e "${GREEN}✅ Enlaces simbólicos SSL creados exitosamente${NC}"