#!/bin/bash

# Script para verificar el estado del servidor antes del deploy
# Usage: ./scripts/check-server-status.sh

set -e

echo "🔍 Verificando estado del servidor..."

cd ansible

# Verificar conectividad SSH
echo "📡 Verificando conectividad SSH..."
ansible all -m shell -a 'whoami'

# Verificar espacio en disco detallado
echo "💾 Verificando espacio en disco..."
ansible all -m shell -a 'df -h /'
echo ""
echo "📁 Verificando uso de espacio por directorios principales..."
ansible all -b -m shell -a 'du -h --max-depth=1 / 2>/dev/null | sort -hr | head -10 || echo "No se pudo acceder a algunos directorios"'

# Verificar memoria
echo "🧠 Verificando memoria..."
ansible all -m shell -a 'free -h'

# Verificar servicios Docker si están instalados
echo "🐳 Verificando Docker..."
ansible all -m shell -a 'docker --version || echo "Docker no instalado"'

# Verificar si n8n está corriendo
echo "⚙️ Verificando estado de n8n..."
ansible all -b -m shell -a 'docker-compose -f /opt/n8n/docker-compose.yml ps || echo "n8n no está instalado o no está corriendo"'

# Verificar logs recientes del sistema
echo "📋 Verificando logs del sistema..."
ansible all -b -m shell -a 'journalctl --since "1 hour ago" --no-pager | tail -10 || echo "No se pudieron obtener logs"'

# Verificar packages que se pueden actualizar
echo "📦 Verificando actualizaciones disponibles..."
ansible all -b -m shell -a 'apt list --upgradable 2>/dev/null | wc -l || echo "No se pudo verificar actualizaciones"'

echo ""
echo "✅ Verificación completada"