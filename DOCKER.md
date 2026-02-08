# Docker Compose Documentation & Tips

## Overview

This project uses Docker Compose to orchestrate multiple services:

- **PostgreSQL** - Relational database
- **Redis** - In-memory cache
- **Kafka & Zookeeper** - Message queue
- **Kafka UI** - Kafka monitoring
- **Flask AI Service** - Python chatbot backend
- **Spring Boot Backend** - Java e-commerce service
- **React Frontend** - Customer UI
- **Kafka Worker** - Async message processor
- **Airflow** - Data pipeline orchestration

## Quick Commands

### Starting Services

```bash
# Start all services in background
docker-compose up -d

# Start specific service
docker-compose up -d ai-service

# Start and view logs
docker-compose up

# Rebuild and start
docker-compose up --build
```

### Managing Services

```bash
# View status
docker-compose ps

# View logs
docker-compose logs -f
docker-compose logs -f ai-service

# Stop services
docker-compose stop
docker-compose stop ai-service

# Remove services
docker-compose down
docker-compose down -v  # Remove volumes too

# Restart
docker-compose restart
```

### Executing Commands

```bash
# Run command in service
docker-compose exec ai-service bash
docker-compose exec postgres psql -U ecommerce_user -d ecommerce

# Get service stats
docker-compose stats
```

## Service Details

### Port Mapping

| Service | Port | URL |
|---------|------|-----|
| Frontend | 3000 | http://localhost:3000 |
| AI Service | 5000 | http://localhost:5000 |
| Backend | 8080 | http://localhost:8080 |
| PostgreSQL | 5432 | localhost:5432 |
| Redis | 6379 | localhost:6379 |
| Kafka | 9092 | localhost:9092 |
| Kafka UI | 8001 | http://localhost:8001 |
| Airflow | 8888 | http://localhost:8888 |

### Service Dependencies

```
Frontend
├── AI Service (port 5000)
└── Backend (port 8080)

AI Service
├── Kafka (for message queue)
├── PostgreSQL (for data)
└── Redis (for caching)

Backend
├── Kafka (for events)
├── PostgreSQL (for data)
└── Redis (for caching)

Kafka
└── Zookeeper (for coordination)

Kafka Worker
└── Kafka (message consumer)

Airflow
└── PostgreSQL (for airflow metadata)
```

## Health Checks

Each service includes health checks:

```bash
# View health check results
docker-compose ps

# Manual health checks
curl http://localhost:5000/
curl http://localhost:8080/actuator/health
curl http://localhost:3000/
```

## Database Operations

### PostgreSQL

```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U ecommerce_user -d ecommerce

# Common SQL commands
\l                          # List databases
\dt                         # List tables
\d table_name               # Describe table
SELECT * FROM users;        # Query data

# Backup
docker-compose exec postgres pg_dump -U ecommerce_user ecommerce > backup.sql

# Restore
docker-compose exec postgres psql -U ecommerce_user ecommerce < backup.sql
```

### Redis

```bash
# Connect to Redis CLI
docker-compose exec redis redis-cli

# Common commands
PING                        # Check connection
KEYS *                      # List all keys
GET key_name               # Get value
DEL key_name               # Delete key
FLUSHDB                    # Clear database
```

### Kafka

```bash
# List topics
docker-compose exec kafka kafka-topics.sh --list --bootstrap-server localhost:9092

# Create topic
docker-compose exec kafka kafka-topics.sh \
  --create \
  --bootstrap-server localhost:9092 \
  --topic test-topic \
  --partitions 1 \
  --replication-factor 1

# Describe topic
docker-compose exec kafka kafka-topics.sh \
  --describe \
  --bootstrap-server localhost:9092 \
  --topic test-topic

# Produce message
docker-compose exec kafka kafka-console-producer.sh \
  --bootstrap-server localhost:9092 \
  --topic test-topic

# Consume messages
docker-compose exec kafka kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic test-topic \
  --from-beginning
```

## Environment Variables

Create a `.env` file to override defaults:

```env
# Database
DB_USER=custom_user
DB_PASSWORD=custom_password
DB_NAME=custom_db

# Flask
FLASK_ENV=production
GROQ_API_KEY=your_key
PINECONE_API_KEY=your_key

# Kafka
KAFKA_BROKER=kafka:9092

# JWT
JWT_SECRET=your_secret
```

## Volume Management

### Persistent Volumes

```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect postgres_data

# Remove unused volumes
docker volume prune

# Clear all volumes (WARNING: deletes data)
docker-compose down -v
```

## Networking

### Inter-service Communication

Services can communicate using service names:

```python
# In AI Service
DB_URL = "postgresql://postgres:5432/ecommerce"
KAFKA_BROKER = "kafka:9092"
REDIS_URL = "redis://redis:6379"

# In Backend
spring.datasource.url=jdbc:postgresql://postgres:5432/ecommerce
spring.kafka.bootstrap-servers=kafka:9092
```

### Connecting from Host

Use localhost with mapped ports:

```bash
psql -h localhost -U ecommerce_user ecommerce
redis-cli -h localhost
```

## Performance Tuning

### Memory Limits

Edit `docker-compose.yml`:

```yaml
services:
  ai-service:
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
```

### CPU Allocation

```yaml
services:
  postgres:
    deploy:
      resources:
        limits:
          cpus: '2'
```

## Troubleshooting

### Service won't start

```bash
# Check logs
docker-compose logs ai-service

# Check dependencies
docker-compose ps

# Restart dependent service
docker-compose restart kafka
docker-compose restart ai-service
```

### Port conflicts

```bash
# Find process using port
lsof -i :5000

# Kill process
kill -9 PID

# Or use different port in docker-compose.yml
```

### Volumes not persisting

```bash
# Check volume mount
docker-compose exec ai-service df -h

# Verify docker-compose.yml volume configuration
grep -A 5 "volumes:" docker-compose.yml
```

### Services unable to communicate

```bash
# Check network
docker network ls
docker network inspect ecommerce-network

# Test connectivity
docker-compose exec ai-service ping redis
docker-compose exec ai-service curl http://ecommerce-service:8080/health
```

## Monitoring

### View Resource Usage

```bash
# CPU and memory usage
docker-compose stats

# Detailed stats
docker stats --no-stream
```

### Check Service Logs

```bash
# Real-time logs
docker-compose logs -f

# Last 100 lines
docker-compose logs --tail=100

# Since specific time
docker-compose logs --since 2024-02-09T10:00:00
```

## Production vs Development

### Development (docker-compose.yml)

- Hot reload enabled
- Debug mode on
- Verbose logging
- All ports exposed

### Production (docker-compose.prod.yml)

- Images from registry
- No volume mounts
- Minimal logging
- Resource limits set
- Security options enabled
- Health checks strict

## Cleanup & Maintenance

```bash
# Remove unused resources
docker system prune

# Remove volumes (WARNING: data loss)
docker system prune -a --volumes

# Check disk usage
docker system df
```

## Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Networking](https://docs.docker.com/network/)
- [Docker Volumes](https://docs.docker.com/storage/volumes/)

---

Last Updated: February 9, 2026
