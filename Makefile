# Quick reference Makefile for common development tasks

.PHONY: help up down build logs clean test lint format
.DEFAULT_GOAL := help

DOCKER_COMPOSE := docker-compose
DOCKER_COMPOSE_PROD := docker-compose -f docker-compose.prod.yml

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Display this help message
	@echo "$(BLUE)E-commerce Chatbot POC - Development Commands$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

## Docker Commands

up: ## Start all services with Docker Compose
	@echo "$(BLUE)Starting services...$(NC)"
	$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)✓ Services started$(NC)"
	@make health-check

down: ## Stop all services
	@echo "$(BLUE)Stopping services...$(NC)"
	$(DOCKER_COMPOSE) down
	@echo "$(GREEN)✓ Services stopped$(NC)"

build: ## Build all Docker images
	@echo "$(BLUE)Building Docker images...$(NC)"
	$(DOCKER_COMPOSE) build
	@echo "$(GREEN)✓ Build complete$(NC)"

build-ai: ## Build AI Service Docker image
	@echo "$(BLUE)Building AI Service...$(NC)"
	docker build -f ai-service/Dockerfile -t ecommerce-ai-service:latest ./ai-service
	@echo "$(GREEN)✓ AI Service built$(NC)"

build-backend: ## Build Backend Docker image
	@echo "$(BLUE)Building Backend Service...$(NC)"
	docker build -f java_ecommerce_ready/Dockerfile -t ecommerce-backend:latest ./java_ecommerce_ready
	@echo "$(GREEN)✓ Backend built$(NC)"

build-frontend: ## Build Frontend Docker image
	@echo "$(BLUE)Building Frontend...$(NC)"
	docker build -f frontend/Dockerfile -t ecommerce-frontend:latest ./frontend
	@echo "$(GREEN)✓ Frontend built$(NC)"

restart: down up ## Restart all services

logs: ## View logs from all services
	$(DOCKER_COMPOSE) logs -f

logs-ai: ## View AI Service logs
	$(DOCKER_COMPOSE) logs -f ai-service

logs-backend: ## View Backend Service logs
	$(DOCKER_COMPOSE) logs -f ecommerce-service

logs-frontend: ## View Frontend logs
	$(DOCKER_COMPOSE) logs -f frontend

ps: ## Show running containers
	$(DOCKER_COMPOSE) ps

health-check: ## Check health of all services
	@echo "$(BLUE)Checking service health...$(NC)"
	@echo "AI Service: $$(curl -s -o /dev/null -w '%{http_code}' http://localhost:5000/ || echo 'down')"
	@echo "Backend: $$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/actuator/health || echo 'down')"
	@echo "Frontend: $$(curl -s -o /dev/null -w '%{http_code}' http://localhost:3000/ || echo 'down')"

## Development Commands

test: ## Run all tests
	@echo "$(BLUE)Running tests...$(NC)"
	cd ai-service && pytest && cd ..
	cd java_ecommerce_ready && mvn test && cd ..
	cd frontend && npm test -- --watchAll=false && cd ..
	@echo "$(GREEN)✓ All tests passed$(NC)"

test-ai: ## Run AI Service tests
	@echo "$(BLUE)Running AI Service tests...$(NC)"
	cd ai-service && pytest && cd ..
	@echo "$(GREEN)✓ Tests passed$(NC)"

test-backend: ## Run Backend tests
	@echo "$(BLUE)Running Backend tests...$(NC)"
	cd java_ecommerce_ready && mvn test && cd ..
	@echo "$(GREEN)✓ Tests passed$(NC)"

test-frontend: ## Run Frontend tests
	@echo "$(BLUE)Running Frontend tests...$(NC)"
	cd frontend && npm test -- --watchAll=false && cd ..
	@echo "$(GREEN)✓ Tests passed$(NC)"

lint: lint-ai lint-backend lint-frontend ## Run linting for all services

lint-ai: ## Lint AI Service
	@echo "$(BLUE)Linting AI Service...$(NC)"
	cd ai-service && pylint src/ || true && cd ..

lint-backend: ## Lint Backend Service
	@echo "$(BLUE)Linting Backend Service...$(NC)"
	cd java_ecommerce_ready && mvn checkstyle:check || true && cd ..

lint-frontend: ## Lint Frontend
	@echo "$(BLUE)Linting Frontend...$(NC)"
	cd frontend && npm run lint || true && cd ..

format: format-ai format-backend format-frontend ## Format all code

format-ai: ## Format AI Service code
	@echo "$(BLUE)Formatting AI Service...$(NC)"
	cd ai-service && black src/ && cd ..

format-backend: ## Format Backend code
	@echo "$(BLUE)Formatting Backend...$(NC)"
	cd java_ecommerce_ready && mvn spotless:apply && cd ..

format-frontend: ## Format Frontend code
	@echo "$(BLUE)Formatting Frontend...$(NC)"
	cd frontend && npm run format && cd ..

## Database Commands

db-init: ## Initialize database
	@echo "$(BLUE)Initializing database...$(NC)"
	$(DOCKER_COMPOSE) exec postgres psql -U ecommerce_user -d ecommerce -c "CREATE EXTENSION IF NOT EXISTS uuid-ossp;"
	@echo "$(GREEN)✓ Database initialized$(NC)"

db-reset: ## Reset database (WARNING: deletes all data)
	@echo "$(RED)WARNING: This will delete all database data$(NC)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		$(DOCKER_COMPOSE) down -v; \
		$(DOCKER_COMPOSE) up -d postgres; \
		sleep 5; \
		make db-init; \
		echo "$(GREEN)✓ Database reset complete$(NC)"; \
	fi

db-shell: ## Connect to database shell
	$(DOCKER_COMPOSE) exec postgres psql -U ecommerce_user -d ecommerce

## Development Environment

install-ai: ## Install AI Service dependencies
	@echo "$(BLUE)Installing AI Service dependencies...$(NC)"
	cd ai-service && pip install -r requirements.txt && cd ..
	@echo "$(GREEN)✓ Dependencies installed$(NC)"

install-backend: ## Install Backend dependencies
	@echo "$(BLUE)Installing Backend dependencies...$(NC)"
	cd java_ecommerce_ready && mvn install && cd ..
	@echo "$(GREEN)✓ Dependencies installed$(NC)"

install-frontend: ## Install Frontend dependencies
	@echo "$(BLUE)Installing Frontend dependencies...$(NC)"
	cd frontend && npm install && cd ..
	@echo "$(GREEN)✓ Dependencies installed$(NC)"

env: ## Create .env file from template
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "$(GREEN)✓ .env file created. Please edit with your values.$(NC)"; \
	else \
		echo "$(BLUE).env file already exists$(NC)"; \
	fi

## Production Commands

prod-up: ## Start production environment (use docker-compose.prod.yml)
	@echo "$(BLUE)Starting production environment...$(NC)"
	$(DOCKER_COMPOSE_PROD) up -d
	@echo "$(GREEN)✓ Production environment started$(NC)"

prod-down: ## Stop production environment
	@echo "$(BLUE)Stopping production environment...$(NC)"
	$(DOCKER_COMPOSE_PROD) down
	@echo "$(GREEN)✓ Production environment stopped$(NC)"

prod-logs: ## View production logs
	$(DOCKER_COMPOSE_PROD) logs -f

## Utility Commands

clean: ## Clean up volumes and containers
	@echo "$(RED)Removing all containers and volumes...$(NC)"
	$(DOCKER_COMPOSE) down -v
	@echo "$(GREEN)✓ Cleanup complete$(NC)"

clean-prod: ## Clean up production environment
	@echo "$(RED)Removing production containers and volumes...$(NC)"
	$(DOCKER_COMPOSE_PROD) down -v
	@echo "$(GREEN)✓ Production cleanup complete$(NC)"

shell-ai: ## Access AI Service container shell
	$(DOCKER_COMPOSE) exec ai-service bash

shell-backend: ## Access Backend container shell
	$(DOCKER_COMPOSE) exec ecommerce-service bash

shell-frontend: ## Access Frontend container shell
	$(DOCKER_COMPOSE) exec frontend sh

version: ## Show versions of key tools
	@echo "$(BLUE)Tool Versions:$(NC)"
	@echo "Docker: $$(docker --version)"
	@echo "Docker Compose: $$(docker-compose --version)"
	@echo "Python: $$(python3 --version 2>&1)"
	@echo "Java: $$(java -version 2>&1 | head -1)"
	@echo "Node.js: $$(node --version)"
	@echo "npm: $$(npm --version)"

git-setup: ## Configure git hooks
	@echo "$(BLUE)Setting up git hooks...$(NC)"
	@chmod +x .git/hooks/pre-commit || true
	@echo "$(GREEN)✓ Git hooks configured$(NC)"

## Documentation

docs: ## Open documentation in browser
	@echo "$(BLUE)Opening documentation...$(NC)"
	@open README.md || xdg-open README.md || true

docs-dev: ## Open development guide in browser
	@echo "$(BLUE)Opening development guide...$(NC)"
	@open DEVELOPMENT.md || xdg-open DEVELOPMENT.md || true

docs-contrib: ## Open contributing guide in browser
	@echo "$(BLUE)Opening contributing guide...$(NC)"
	@open CONTRIBUTING.md || xdg-open CONTRIBUTING.md || true
