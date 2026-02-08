#!/bin/bash
# Build and push Docker images to registry
# Usage: ./deploy.sh <docker_username> <version>

set -e

DOCKER_USERNAME=${1:-your_docker_username}
VERSION=${2:-latest}
REGISTRY="docker.io"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Building and pushing Docker images...${NC}"
echo "Registry: $REGISTRY"
echo "Username: $DOCKER_USERNAME"
echo "Version: $VERSION"
echo ""

if [ "$DOCKER_USERNAME" = "your_docker_username" ]; then
    echo -e "${RED}✗ Please set your Docker username${NC}"
    echo "Usage: ./deploy.sh <docker_username> <version>"
    exit 1
fi

# Check if logged in to Docker
if ! docker info | grep -q "Username"; then
    echo -e "${BLUE}Please log in to Docker Hub:${NC}"
    docker login -u $DOCKER_USERNAME
fi

echo ""
echo -e "${BLUE}Building AI Service...${NC}"
docker build \
    -f ai-service/Dockerfile \
    -t $REGISTRY/$DOCKER_USERNAME/ecommerce-ai-service:$VERSION \
    -t $REGISTRY/$DOCKER_USERNAME/ecommerce-ai-service:latest \
    ./ai-service
echo -e "${GREEN}✓ AI Service built${NC}"

echo ""
echo -e "${BLUE}Building E-commerce Backend...${NC}"
docker build \
    -f java_ecommerce_ready/Dockerfile \
    -t $REGISTRY/$DOCKER_USERNAME/ecommerce-backend:$VERSION \
    -t $REGISTRY/$DOCKER_USERNAME/ecommerce-backend:latest \
    ./java_ecommerce_ready
echo -e "${GREEN}✓ E-commerce Backend built${NC}"

echo ""
echo -e "${BLUE}Building Frontend...${NC}"
docker build \
    -f frontend/Dockerfile \
    -t $REGISTRY/$DOCKER_USERNAME/ecommerce-frontend:$VERSION \
    -t $REGISTRY/$DOCKER_USERNAME/ecommerce-frontend:latest \
    ./frontend
echo -e "${GREEN}✓ Frontend built${NC}"

echo ""
echo -e "${BLUE}Building Kafka Worker...${NC}"
docker build \
    -f chat_kafka_service/Dockerfile \
    -t $REGISTRY/$DOCKER_USERNAME/ecommerce-kafka-worker:$VERSION \
    -t $REGISTRY/$DOCKER_USERNAME/ecommerce-kafka-worker:latest \
    ./chat_kafka_service
echo -e "${GREEN}✓ Kafka Worker built${NC}"

echo ""
echo -e "${BLUE}Pushing images to registry...${NC}"

echo "Pushing AI Service..."
docker push $REGISTRY/$DOCKER_USERNAME/ecommerce-ai-service:$VERSION
docker push $REGISTRY/$DOCKER_USERNAME/ecommerce-ai-service:latest
echo -e "${GREEN}✓ AI Service pushed${NC}"

echo "Pushing E-commerce Backend..."
docker push $REGISTRY/$DOCKER_USERNAME/ecommerce-backend:$VERSION
docker push $REGISTRY/$DOCKER_USERNAME/ecommerce-backend:latest
echo -e "${GREEN}✓ E-commerce Backend pushed${NC}"

echo "Pushing Frontend..."
docker push $REGISTRY/$DOCKER_USERNAME/ecommerce-frontend:$VERSION
docker push $REGISTRY/$DOCKER_USERNAME/ecommerce-frontend:latest
echo -e "${GREEN}✓ Frontend pushed${NC}"

echo "Pushing Kafka Worker..."
docker push $REGISTRY/$DOCKER_USERNAME/ecommerce-kafka-worker:$VERSION
docker push $REGISTRY/$DOCKER_USERNAME/ecommerce-kafka-worker:latest
echo -e "${GREEN}✓ Kafka Worker pushed${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    Deployment Complete!                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Your images are ready at:"
echo "  - $REGISTRY/$DOCKER_USERNAME/ecommerce-ai-service:$VERSION"
echo "  - $REGISTRY/$DOCKER_USERNAME/ecommerce-backend:$VERSION"
echo "  - $REGISTRY/$DOCKER_USERNAME/ecommerce-frontend:$VERSION"
echo "  - $REGISTRY/$DOCKER_USERNAME/ecommerce-kafka-worker:$VERSION"
echo ""
