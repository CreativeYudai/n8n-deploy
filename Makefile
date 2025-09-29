# Makefile para n8n Deploy Project

.PHONY: help install-local install-prod generate-keys backup clean

# Variables
ANSIBLE_DIR = ansible
SCRIPTS_DIR = scripts

help: ## Mostrar ayuda
	@echo "Comandos disponibles:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install-deps: ## Instalar dependencias necesarias
	@echo "Verificando dependencias..."
	@command -v docker >/dev/null 2>&1 || { echo "Docker no está instalado. Instálalo desde https://docker.com"; exit 1; }
	@command -v docker-compose >/dev/null 2>&1 || { echo "Docker Compose no está instalado"; exit 1; }
	@echo "✅ Dependencias verificadas"

generate-keys: ## Generar claves de seguridad
	@$(SCRIPTS_DIR)/generate-keys.sh

install-local: install-deps ## Deploy local para desarrollo
	@echo "🚀 Iniciando deploy local..."
	@if [ ! -f .env ]; then \
		echo "Creando archivo .env desde template..."; \
		cp .env.example .env; \
		echo "⚠️  Edita el archivo .env con tus configuraciones antes de continuar"; \
		exit 1; \
	fi
	@$(SCRIPTS_DIR)/local-deploy.sh

install-ansible-deps: ## Instalar dependencias de Ansible
	@echo "📦 Instalando colecciones de Ansible..."
	@cd $(ANSIBLE_DIR) && ansible-galaxy collection install -r requirements.yml

install-prod: install-ansible-deps ## Deploy en producción con Ansible
	@echo "🌐 Iniciando deploy en producción..."
	@command -v ansible-playbook >/dev/null 2>&1 || { echo "Ansible no está instalado. Instálalo: pip install ansible"; exit 1; }
	@if [ ! -f $(ANSIBLE_DIR)/inventory/hosts.yml ]; then \
		echo "⚠️  Configura el inventario de Ansible en $(ANSIBLE_DIR)/inventory/hosts.yml"; \
		exit 1; \
	fi
	@$(SCRIPTS_DIR)/production-deploy.sh

backup: ## Crear backup de n8n
	@$(SCRIPTS_DIR)/backup.sh

logs: ## Ver logs de n8n (local)
	@docker-compose logs -f n8n

status: ## Ver estado de servicios (local)
	@docker-compose ps

restart: ## Reiniciar servicios (local)
	@docker-compose restart

stop: ## Parar servicios (local)
	@docker-compose down

update: ## Actualizar imágenes de Docker
	@docker-compose pull
	@docker-compose up -d

clean: ## Limpiar contenedores y volúmenes
	@echo "⚠️  Esto eliminará todos los datos de n8n. ¿Continuar? [y/N]" && read ans && [ $${ans:-N} = y ]
	@docker-compose down -v
	@docker system prune -f

ansible-check: ## Verificar configuración de Ansible
	@cd $(ANSIBLE_DIR) && ansible all -m shell -a 'whoami'

server-status: ## Verificar estado completo del servidor
	@$(SCRIPTS_DIR)/check-server-status.sh

cleanup-server: ## Limpiar archivos temporales y cache en el servidor
	@$(SCRIPTS_DIR)/cleanup-server.sh

fix-ports: ## Liberar puertos 80 y 443 para n8n
	@$(SCRIPTS_DIR)/fix-port-conflicts.sh

inspect: ## Inspeccionar estado del servidor (archivos, configuración, logs)
	@echo "🔍 Inspeccionando estado del servidor..."
	@chmod +x $(SCRIPTS_DIR)/inspect-server.sh
	@$(SCRIPTS_DIR)/inspect-server.sh

fix-ssl: ## Crear enlaces simbólicos SSL faltantes
	@echo "🔒 Reparando enlaces SSL..."
	@chmod +x $(SCRIPTS_DIR)/fix-ssl-links.sh
	@$(SCRIPTS_DIR)/fix-ssl-links.sh

fix-websockets: ## Solucionar problemas de WebSocket (Invalid Origin)
	@echo "🔧 Solucionando WebSockets..."
	@chmod +x $(SCRIPTS_DIR)/fix-websockets.sh
	@$(SCRIPTS_DIR)/fix-websockets.sh

optimize-n8n: ## Optimizar configuración de n8n (eliminar warnings)
	@echo "⚡ Optimizando n8n..."
	@chmod +x $(SCRIPTS_DIR)/optimize-n8n.sh
	@$(SCRIPTS_DIR)/optimize-n8n.sh

ansible-logs: ## Ver logs en producción
	@cd $(ANSIBLE_DIR) && ansible all -m shell -a 'docker-compose -f /opt/n8n/docker-compose.yml logs --tail=50 n8n'

ansible-status: ## Ver estado en producción
	@cd $(ANSIBLE_DIR) && ansible all -m shell -a 'docker-compose -f /opt/n8n/docker-compose.yml ps'

ansible-restart: ## Reiniciar servicios en producción
	@cd $(ANSIBLE_DIR) && ansible all -m shell -a 'cd /opt/n8n && docker-compose restart'