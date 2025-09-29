#!/bin/bash

# Script para deploy en producción usando Ansible
# Usage: ./scripts/production-deploy.sh

set -e

echo "🚀 Iniciando deploy de n8n en producción..."

# Verificar que Ansible está instalado
if ! command -v ansible-playbook &> /dev/null; then
    echo "❌ Ansible no está instalado"
    echo "Instala Ansible: pip install ansible"
    exit 1
fi

# Verificar que existe el inventario
if [ ! -f ansible/inventory/hosts.yml ]; then
    echo "❌ No se encontró ansible/inventory/hosts.yml"
    echo "Configura el inventario de Ansible con los datos de tu servidor"
    exit 1
fi

# Cambiar al directorio de Ansible
cd ansible

# Ejecutar el playbook
echo "🏗️ Ejecutando playbook de Ansible..."
ansible-playbook site.yml

echo ""
echo "✅ Deploy en producción completado!"
echo "🌐 n8n debería estar disponible en: https://n8n.yudaicreator.com"
echo ""
echo "Para verificar el estado:"
echo "  ansible all -m shell -a 'docker-compose -f /opt/n8n/docker-compose.yml ps'"
echo ""
echo "Para ver logs:"
echo "  ansible all -m shell -a 'docker-compose -f /opt/n8n/docker-compose.yml logs n8n'"