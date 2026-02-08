# Development Guide

Complete guide for setting up and developing the E-commerce Chatbot POC locally.

## Table of Contents

- [System Requirements](#system-requirements)
- [Initial Setup](#initial-setup)
- [Service-Specific Setup](#service-specific-setup)
- [Running Services](#running-services)
- [Debugging](#debugging)
- [Common Issues](#common-issues)

## System Requirements

### Minimum Requirements

- **CPU**: 4 cores
- **RAM**: 8GB
- **Disk**: 20GB free space
- **OS**: Linux, macOS, or Windows with WSL2

### Required Software

| Software | Version | Purpose |
|----------|---------|---------|
| Docker | 20.10+ | Container runtime |
| Docker Compose | 2.0+ | Multi-container orchestration |
| Git | 2.30+ | Version control |
| Python | 3.10+ | AI Service development |
| Java | 17+ | Backend development |
| Node.js | 18+ | Frontend development |
| Maven | 3.8+ | Java build tool |
| npm | 10+ | Node package manager |

## Initial Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/ecommerce-chatbot-poc.git
cd Ecommerce_chatbot_poc
```

### 2. Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Edit with your values
nano .env  # or use your favorite editor
```

Essential environment variables to set:

```env
GROQ_API_KEY=your_groq_key
PINECONE_API_KEY=your_pinecone_key
DB_PASSWORD=your_secure_password
JWT_SECRET=your_jwt_secret
```

### 3. Start Infrastructure (Docker)

```bash
# Start all services (recommended for first run)
docker-compose up -d

# Verify all services are running
docker-compose ps

# View logs
docker-compose logs -f
```

### 4. Initialize Databases

```bash
# Create tables in PostgreSQL
docker-compose exec ecommerce-service ./mvn spring-boot:run -Dspring.jpa.hibernate.ddl-auto=create

# Verify connection
docker-compose exec postgres psql -U ecommerce_user -d ecommerce -c "\dt"
```

## Service-Specific Setup

### AI Service (Flask + LangChain)

#### Option 1: Using Docker

```bash
# Build and run
docker-compose up ai-service -d

# View logs
docker-compose logs -f ai-service

# Test the service
curl -X POST http://localhost:5000/chat \
  -H "Content-Type: application/json" \
  -d '{"input": "test"}'
```

#### Option 2: Local Development

```bash
cd ai-service

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Set environment variables
export FLASK_ENV=development
export GROQ_API_KEY=your_key
export PINECONE_API_KEY=your_key

# Run the service
python app.py

# In another terminal, test
curl -X POST http://localhost:5000/chat \
  -H "Content-Type: application/json" \
  -d '{"input": "Hello"}'
```

**Key Files:**
- `app.py` - Main Flask application
- `src/components/chatbot_builder.py` - Chatbot initialization
- `src/components/data_cleaning.py` - Data processing
- `src/utils/chatbot_utils.py` - Utility functions

### Backend Service (Spring Boot)

#### Option 1: Using Docker

```bash
# Build and run
docker-compose up ecommerce-service -d

# View logs
docker-compose logs -f ecommerce-service

# Test the service
curl http://localhost:8080/actuator/health
```

#### Option 2: Local Development

```bash
cd java_ecommerce_ready

# Build
mvn clean install

# Run tests
mvn test

# Run the service
mvn spring-boot:run

# In another terminal, test
curl http://localhost:8080/actuator/health
```

**Key Files:**
- `src/main/java/com/ecommerce/Application.java` - Main entry point
- `src/main/java/com/ecommerce/controller/` - REST endpoints
- `src/main/java/com/ecommerce/service/` - Business logic
- `src/main/java/com/ecommerce/config/` - Configuration classes

### Frontend (React)

#### Option 1: Using Docker

```bash
# Build and run
docker-compose up frontend -d

# View logs
docker-compose logs -f frontend

# Access at http://localhost:3000
```

#### Option 2: Local Development

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm start

# In another terminal, run tests
npm test

# Build for production
npm run build
```

**Key Files:**
- `src/App.js` - Main React component
- `src/components/` - React components
- `src/services/api.js` - API client
- `package.json` - Dependencies

### Kafka Worker

```bash
cd chat_kafka_service

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install kafka-python langchain

# Run the worker
python kafka_ai_worker.py
```

## Running Services

### All Services with Docker Compose

```bash
# Start all services
docker-compose up -d

# View status
docker-compose ps

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Remove volumes (fresh start)
docker-compose down -v
```

### Individual Service Commands

```bash
# Start specific service
docker-compose up ai-service -d

# Stop specific service
docker-compose stop ecommerce-service

# View service logs
docker-compose logs -f frontend

# Execute command in container
docker-compose exec ai-service bash

# Rebuild specific service
docker-compose up ai-service --build
```

## Debugging

### Accessing Service Containers

```bash
# Connect to a service
docker-compose exec ai-service bash
docker-compose exec ecommerce-service bash
docker-compose exec frontend sh

# View Python imports
docker-compose exec ai-service python -c "import sys; print(sys.path)"

# View Java classpath
docker-compose exec ecommerce-service java -cp . -Xmx1024m com.ecommerce.Application
```

### Viewing Logs

```bash
# All logs
docker-compose logs

# Specific service
docker-compose logs ai-service

# Follow logs in real-time
docker-compose logs -f ai-service

# Last 100 lines
docker-compose logs --tail=100 ecommerce-service

# Logs since timestamp
docker-compose logs --since 2024-02-09T10:00:00 ai-service
```

### Database Debugging

```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U ecommerce_user -d ecommerce

# Useful PostgreSQL commands
\l                    # List databases
\dt                   # List tables
\d table_name         # Describe table
SELECT * FROM users;  # Query data
```

### Network Inspection

```bash
# Check if services can reach each other
docker-compose exec ai-service curl http://ecommerce-service:8080/actuator/health

# View network info
docker network ls
docker network inspect ecommerce-network

# Test Kafka connectivity
docker-compose exec kafka kafka-broker-api-versions.sh --bootstrap-server localhost:9092
```

## Common Issues

### Issue: Services fail to start

**Solution:**
```bash
# Clean up and restart
docker-compose down -v
docker-compose up --build
```

### Issue: Port already in use

**Solution:**
```bash
# Find process using port
lsof -i :5000
kill -9 <PID>

# Or change port in docker-compose.yml
```

### Issue: Database connection failed

**Solution:**
```bash
# Check if postgres is running
docker-compose ps postgres

# Check logs
docker-compose logs postgres

# Restart database
docker-compose restart postgres
```

### Issue: Node modules installation fails

**Solution:**
```bash
# Clear npm cache
npm cache clean --force
cd frontend
rm -rf node_modules package-lock.json
npm install
```

### Issue: Python dependencies conflict

**Solution:**
```bash
cd ai-service
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### Issue: Kafka not accepting messages

**Solution:**
```bash
# Check Kafka is running
docker-compose ps kafka

# Check topics
docker-compose exec kafka kafka-topics.sh --list --bootstrap-server localhost:9092

# Create topic if missing
docker-compose exec kafka kafka-topics.sh --create \
  --bootstrap-server localhost:9092 \
  --topic test \
  --partitions 1 \
  --replication-factor 1
```

## Performance Tuning

### For Development

```yaml
# In docker-compose.yml, reduce resource limits
ai-service:
  deploy:
    resources:
      limits:
        cpus: '0.5'
        memory: 512M
```

### For Production

```yaml
ecommerce-service:
  environment:
    JAVA_OPTS: "-Xms2g -Xmx4g -XX:+UseG1GC"
```

## IDE Configuration

### VS Code

Create `.vscode/settings.json`:

```json
{
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "python.formatting.provider": "black",
  "[java]": {
    "editor.defaultFormatter": "redhat.java"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

### IntelliJ IDEA

1. Import project as Maven project
2. Configure Python SDK in Project Settings
3. Enable code inspections

## Testing

### Run all tests

```bash
# AI Service
cd ai-service && pytest

# Backend
cd java_ecommerce_ready && mvn test

# Frontend
cd frontend && npm test

# With coverage
pytest --cov=src
mvn jacoco:report
npm test -- --coverage
```

## Next Steps

1. Explore individual service documentation
2. Check out contribution guidelines
3. Review project architecture
4. Start building features!

---

Last Updated: February 9, 2026
