#!/bin/bash

# Script para limpiar el servidor y liberar espacio en disco
# Usage: ./scripts/cleanup-server.sh

set -e

echo "🧹 Limpiando servidor para liberar espacio en disco..."

cd ansible

# Verificar conectividad primero
echo "📡 Verificando conectividad..."
ansible all -m shell -a 'whoami'

echo ""
echo "📊 Espacio en disco ANTES de la limpieza:"
ansible all -m shell -a 'df -h /'

echo ""
echo "�️ Iniciando limpieza del sistema..."

# Limpiar cache de apt
echo "  • Limpiando cache de apt..."
ansible all -b -m shell -a 'apt clean'
ansible all -b -m shell -a 'apt autoremove -y'
ansible all -b -m shell -a 'apt autoclean'

# Limpiar logs del sistema (mantener solo 7 días)
echo "  • Limpiando logs del sistema..."
ansible all -b -m shell -a 'journalctl --vacuum-time=7d'

# Limpiar archivos temporales
echo "  • Limpiando archivos temporales..."
ansible all -b -m shell -a 'find /tmp -type f -atime +7 -delete 2>/dev/null || true'
ansible all -b -m shell -a 'find /var/tmp -type f -atime +7 -delete 2>/dev/null || true'

# Limpiar cache de usuario
echo "  • Limpiando cache de usuario..."
ansible all -b -m shell -a 'find /home -name ".cache" -type d -exec rm -rf {}/* \; 2>/dev/null || true'

# Limpiar archivos de log antiguos
echo "  • Limpiando logs antiguos..."
ansible all -b -m shell -a 'find /var/log -name "*.log.*" -type f -mtime +7 -delete 2>/dev/null || true'
ansible all -b -m shell -a 'find /var/log -name "*.gz" -type f -mtime +7 -delete 2>/dev/null || true'

# Limpiar Docker si está instalado
echo "  • Limpiando Docker (imágenes no utilizadas)..."
ansible all -b -m shell -a 'docker system prune -f || echo "Docker no disponible o sin contenido para limpiar"'

# Limpiar archivos de instalación de packages
echo "  • Limpiando archivos de instalación..."
ansible all -b -m shell -a 'rm -rf /var/cache/debconf/*-old 2>/dev/null || true'
ansible all -b -m shell -a 'rm -rf /var/lib/apt/lists/partial/* 2>/dev/null || true'

echo ""
echo "📊 Espacio en disco DESPUÉS de la limpieza:"
ansible all -m shell -a 'df -h /'

echo ""
echo "📁 Directorios que más espacio ocupan:"
ansible all -b -m shell -a 'du -h --max-depth=1 / 2>/dev/null | sort -hr | head -10 || echo "No se pudo acceder a algunos directorios"'

echo ""
echo "✅ Limpieza completada"
echo "💡 Si aún necesitas más espacio, considera expandir el volumen EBS en AWS"