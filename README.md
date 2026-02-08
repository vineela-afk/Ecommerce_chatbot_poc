# E-commerce Chatbot POC

A comprehensive e-commerce platform with an AI-powered chatbot, built with microservices architecture using Spring Boot, Flask, React, and Kafka.

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Services](#services)
- [API Documentation](#api-documentation)
- [Configuration](#configuration)
- [Development](#development)
- [Deployment](#deployment)
- [Docker Setup](#docker-setup)
- [CI/CD Pipeline](#cicd-pipeline)
- [Contributing](#contributing)

## 🎯 Project Overview

This project is a proof-of-concept (POC) for an e-commerce platform that integrates an AI-powered chatbot for product recommendations and customer interactions. It uses a microservices architecture with the following components:

- **AI Service**: Flask-based Python service hosting the LLM chatbot with vector search capabilities
- **E-commerce Backend**: Spring Boot service managing orders, inventory, payments, and authentication
- **Frontend**: React-based UI for customer interactions
- **Data Pipeline**: Apache Airflow orchestration for data processing and cleaning
- **Message Queue**: Apache Kafka for asynchronous communication between services

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Frontend (React)                     │
│                   Port: 3000 (dev), 80   │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────────┐
│              API Gateway / Load Balancer                 │
└──────┬──────────────────────────────────────┬────────────┘
       │                                      │
┌──────▼──────────────────────┐   ┌──────────▼──────────────────┐
│  AI Service (Flask)          │   │  E-commerce Service (Spring)│
│  Port: 5000                  │   │  Port: 8080                 │
│  - Chatbot Engine            │   │  - Orders API               │
│  - Recommendations           │   │  - Inventory API            │
│  - Vector Search (Pinecone)  │   │  - Payments API             │
│  - Data Processing           │   │  - Authentication           │
└──────┬──────────────────────┘   └──────────┬──────────────────┘
       │                                      │
┌──────┴──────────────────────────────────────┴────────────┐
│              Apache Kafka Cluster                         │
│           (Message Queue & Event Bus)                    │
└──────────────────────────────────────────────────────────┘
       │
┌──────▼──────────────────────────────────────────────────┐
│   External Services & Databases                          │
│   - Pinecone (Vector Store)                              │
│   - PostgreSQL (Application DB)                          │
│   - Redis (Cache)                                        │
└──────────────────────────────────────────────────────────┘
```

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Docker** 20.10+
- **Docker Compose** 2.0+
- **Git** 2.30+
- **Java** 17+ (for local Java development)
- **Python** 3.10+ (for local Python development)
- **Node.js** 18+ (for local React development)

### Environment Variables Required

Create a `.env` file in the project root:

```env
# AI Service
FLASK_ENV=production
GROQ_API_KEY=your_groq_api_key
PINECONE_API_KEY=your_pinecone_api_key
PINECONE_ENVIRONMENT=your_pinecone_env

# E-commerce Service
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/ecommerce
SPRING_DATASOURCE_USERNAME=ecommerce_user
SPRING_DATASOURCE_PASSWORD=secure_password
JWT_SECRET=your_jwt_secret_key

# Kafka
KAFKA_BROKER=kafka:9092
KAFKA_ZOOKEEPER=zookeeper:2181

# Redis
REDIS_URL=redis://redis:6379

# Docker
DOCKER_REGISTRY=docker.io
DOCKER_USERNAME=your_docker_username
```

## 🚀 Quick Start

### Using Docker Compose (Recommended)

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ecommerce-chatbot-poc.git
   cd Ecommerce_chatbot_poc
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your actual values
   ```

3. **Start all services**
   ```bash
   docker-compose up -d
   ```

4. **Verify services are running**
   ```bash
   docker-compose ps
   ```

5. **Access the application**
   - Frontend: http://localhost:3000
   - AI Service: http://localhost:5000
   - E-commerce API: http://localhost:8080
   - Kafka UI: http://localhost:8001

### Local Development Setup

#### AI Service (Python)

```bash
cd ai-service

# Create virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the service
python app.py
```

#### E-commerce Service (Java)

```bash
cd java_ecommerce_ready

# Build the project
mvn clean package

# Run the service
mvn spring-boot:run
```

#### Frontend (React)

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm start
```

## 🔧 Services

### 1. AI Service (Flask)

**Port**: 5000

**Endpoints**:
- `GET /` - Health check and home page
- `POST /chat` - Send message to chatbot
- `POST /recommend` - Get product recommendations
- `GET /health` - Service health status

**Environment Variables**:
- `GROQ_API_KEY` - Groq API key for LLM
- `PINECONE_API_KEY` - Pinecone API key
- `FLASK_ENV` - Environment (development/production)
- `IS_AIRFLOW` - Whether running in Airflow context

**Dependencies**:
- Flask
- LangChain
- Pinecone
- Kafka Python
- Pandas
- Numpy

### 2. E-commerce Service (Spring Boot)

**Port**: 8080

**Endpoints**:
- `GET /api/products` - Get all products
- `POST /api/orders` - Create order
- `GET /api/orders/{id}` - Get order by ID
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/inventory` - Get inventory status
- `POST /api/payments` - Process payment

**Database**: PostgreSQL

**Message Queue**: Apache Kafka

### 3. Frontend (React)

**Port**: 3000 (development) / 80 (production)

**Features**:
- Chat interface with real-time messaging
- Product browsing and search
- Shopping cart functionality
- Order management
- User authentication

**Build Output**: `/frontend/build/`

### 4. Data Pipeline (Apache Airflow)

**Port**: 8080

**Features**:
- Scheduled data collection
- Data cleaning and processing
- Vector embedding generation
- Pinecone index updates

## 📚 API Documentation

### Chat Endpoint

**Request**:
```bash
curl -X POST http://localhost:5000/chat \
  -H "Content-Type: application/json" \
  -d '{
    "input": "What sarees do you have?"
  }'
```

**Response**:
```json
{
  "answer": "We have a variety of sarees including ...",
  "session_id": "chat_1"
}
```

### Recommendation Endpoint

**Request**:
```bash
curl -X POST http://localhost:5000/recommend \
  -H "Content-Type: application/json" \
  -d '{
    "query": "red saree under 5000"
  }'
```

**Response**:
```json
{
  "ai_result": "[AI Engine] Generated recommendation for: red saree under 5000",
  "products": [...]
}
```

### Product API

**Request**:
```bash
curl http://localhost:8080/api/products
```

**Response**:
```json
[
  {
    "id": "1",
    "name": "Silk Saree",
    "price": 5000,
    "category": "sarees"
  }
]
```

## ⚙️ Configuration

### Database Configuration

The project uses PostgreSQL for persistent storage. Connection details are configured via environment variables:

```properties
spring.datasource.url=jdbc:postgresql://postgres:5432/ecommerce
spring.datasource.username=ecommerce_user
spring.datasource.password=secure_password
spring.jpa.hibernate.ddl-auto=update
```

### Kafka Configuration

Kafka is used for inter-service communication:

```yaml
kafka:
  brokers: ["kafka:9092"]
  topics:
    - orders
    - recommendations
    - inventory-updates
  partitions: 3
  replication-factor: 2
```

### Pinecone Vector Store

Vector embeddings are stored in Pinecone for semantic search:

```env
PINECONE_API_KEY=your_api_key
PINECONE_ENVIRONMENT=us-east-1
PINECONE_INDEX=ecommerce-chatbot
```

## 💻 Development

### Project Structure

```
Ecommerce_chatbot_poc/
├── ai-service/
│   ├── app.py
│   ├── requirements.txt
│   ├── Dockerfile
│   ├── src/
│   │   ├── components/
│   │   ├── utils/
│   │   └── main.py
│   ├── airflow/
│   │   └── dags/
│   ├── data/
│   ├── artifacts/
│   └── templates/
├── java_ecommerce_ready/
│   ├── pom.xml
│   ├── Dockerfile
│   └── src/
│       └── main/
│           ├── java/
│           └── resources/
├── frontend/
│   ├── package.json
│   ├── Dockerfile
│   ├── public/
│   └── src/
├── chat_kafka_service/
│   ├── kafka_ai_worker.py
│   └── Dockerfile
├── docker-compose.yml
├── .env.example
└── README.md
```

### Running Tests

```bash
# AI Service tests
cd ai-service
pytest tests/

# E-commerce Service tests
cd java_ecommerce_ready
mvn test

# Frontend tests
cd frontend
npm test
```

### Code Standards

- **Python**: Follow PEP 8 standards
- **Java**: Follow Google Java Style Guide
- **JavaScript/React**: Use ESLint and Prettier
- **Git**: Use conventional commits

## 🐳 Docker Setup

### Building Individual Services

```bash
# AI Service
docker build -f ai-service/Dockerfile -t ecommerce-ai-service:latest ./ai-service

# E-commerce Service
docker build -f java_ecommerce_ready/Dockerfile -t ecommerce-backend:latest ./java_ecommerce_ready

# Frontend
docker build -f frontend/Dockerfile -t ecommerce-frontend:latest ./frontend
```

### Docker Compose Commands

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f ai-service

# Stop all services
docker-compose down

# Remove all volumes
docker-compose down -v

# Rebuild containers
docker-compose up -d --build
```

### Container Ports

| Service | Port | URL |
|---------|------|-----|
| Frontend | 3000 | http://localhost:3000 |
| AI Service | 5000 | http://localhost:5000 |
| E-commerce API | 8080 | http://localhost:8080 |
| PostgreSQL | 5432 | localhost:5432 |
| Kafka | 9092 | localhost:9092 |
| Zookeeper | 2181 | localhost:2181 |
| Redis | 6379 | localhost:6379 |
| Kafka UI | 8001 | http://localhost:8001 |

