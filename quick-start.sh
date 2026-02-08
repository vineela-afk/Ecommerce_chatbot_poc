#!/bin/bash
# Quick start script for the E-commerce Chatbot POC
# This script sets up the development environment

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   E-commerce Chatbot POC - Quick Start Setup               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker is not installed. Please install Docker first.${NC}"
    echo "Visit: https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo -e "${GREEN}✓ Docker found${NC}"

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}✗ Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker Compose found${NC}"

# Check if .env file exists
if [ ! -f .env ]; then
    echo ""
    echo -e "${BLUE}Creating .env file from template...${NC}"
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}✓ .env file created${NC}"
        echo ""
        echo -e "${BLUE}IMPORTANT: Please edit the .env file and add your API keys:${NC}"
        echo "  - GROQ_API_KEY"
        echo "  - PINECONE_API_KEY"
        echo "  - PINECONE_ENVIRONMENT"
        echo ""
        echo "Edit with: nano .env"
        echo ""
        read -p "Have you edited the .env file? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Please edit .env file first: nano .env"
            exit 0
        fi
    else
        echo -e "${RED}✗ .env.example not found${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ .env file exists${NC}"

# Pull latest images
echo ""
echo -e "${BLUE}Pulling latest Docker images...${NC}"
docker-compose pull

# Build custom images
echo ""
echo -e "${BLUE}Building service images...${NC}"
docker-compose build

# Start services
echo ""
echo -e "${BLUE}Starting services...${NC}"
docker-compose up -d

# Wait for services to be ready
echo ""
echo -e "${BLUE}Waiting for services to be ready...${NC}"
sleep 10

# Check if services are running
echo ""
echo -e "${BLUE}Checking service health...${NC}"

services_ready=0
max_retries=5
retry=0

while [ $retry -lt $max_retries ]; do
    if curl -s http://localhost:5000/ > /dev/null 2>&1; then
        echo -e "${GREEN}✓ AI Service is ready${NC}"
        services_ready=$((services_ready + 1))
    fi
    
    if curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; then
        echo -e "${GREEN}✓ E-commerce Backend is ready${NC}"
        services_ready=$((services_ready + 1))
    fi
    
    if curl -s http://localhost:3000/ > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Frontend is ready${NC}"
        services_ready=$((services_ready + 1))
    fi
    
    if [ $services_ready -ge 3 ]; then
        break
    fi
    
    if [ $retry -lt $((max_retries - 1)) ]; then
        echo "Retrying... ($((retry + 1))/$max_retries)"
        sleep 5
    fi
    
    retry=$((retry + 1))
    services_ready=0
done

# Show final status
echo ""
docker-compose ps

# Print access information
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    Setup Complete!                         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Services are running at:"
echo -e "  ${BLUE}Frontend${NC}:        http://localhost:3000"
echo -e "  ${BLUE}AI Service${NC}:      http://localhost:5000"
echo -e "  ${BLUE}Backend API${NC}:     http://localhost:8080"
echo -e "  ${BLUE}Kafka UI${NC}:        http://localhost:8001"
echo -e "  ${BLUE}Airflow${NC}:         http://localhost:8888"
echo ""
echo "Useful commands:"
echo "  View logs:              docker-compose logs -f"
echo "  Stop services:          docker-compose down"
echo "  Restart services:       docker-compose restart"
echo "  Open frontend:          open http://localhost:3000"
echo ""
echo "For more information, see:"
echo "  - README.md for overview"
echo "  - DEVELOPMENT.md for setup details"
echo "  - DOCKER.md for Docker commands"
echo ""
