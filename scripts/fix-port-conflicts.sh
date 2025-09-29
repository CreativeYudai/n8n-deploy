#!/bin/bash

# Script para liberar puertos 80 y 443 para n8n
# Usage: ./scripts/fix-port-conflicts.sh

set -e

echo "🔍 Verificando conflictos de puertos..."

cd ansible

echo "📡 Identificando qué está usando los puertos 80 y 443..."
ansible all -b -m shell -a 'lsof -i :80 -i :443 || echo "No se pudo ejecutar lsof"'

echo ""
echo "🛑 Parando servicios web nativos..."

# Parar Apache si está corriendo
echo "  • Parando Apache..."
ansible all -b -m shell -a 'systemctl stop apache2 2>/dev/null || echo "Apache no está corriendo"'
ansible all -b -m shell -a 'systemctl disable apache2 2>/dev/null || echo "Apache no está instalado"'

# Parar nginx nativo si está corriendo
echo "  • Parando nginx nativo..."
ansible all -b -m shell -a 'systemctl stop nginx 2>/dev/null || echo "nginx nativo no está corriendo"'
ansible all -b -m shell -a 'systemctl disable nginx 2>/dev/null || echo "nginx nativo no está instalado"'

# Parar otros servicios web comunes
echo "  • Parando otros servicios web..."
ansible all -b -m shell -a 'systemctl stop lighttpd 2>/dev/null || echo "lighttpd no está corriendo"'
ansible all -b -m shell -a 'systemctl stop httpd 2>/dev/null || echo "httpd no está corriendo"'

echo ""
echo "🔍 Verificando que los puertos estén libres..."
ansible all -b -m shell -a 'ss -tlnp | grep ":80\|:443" || echo "Puertos 80 y 443 están libres"'

echo ""
echo "🐳 Reiniciando contenedores de n8n..."
ansible all -b -m shell -a 'cd /ubuntu/n8n && docker-compose down'
ansible all -b -m shell -a 'cd /ubuntu/n8n && docker-compose up -d'

echo ""
echo "📊 Verificando estado de los contenedores..."
ansible all -b -m shell -a 'cd /ubuntu/n8n && docker-compose ps'

echo ""
echo "✅ Corrección de conflictos de puertos completada"
echo "🌐 n8n debería estar disponible en:"
echo "  - Directo: http://tu-servidor:5678"
echo "  - Con proxy: http://tu-dominio (una vez que nginx esté funcionando)"