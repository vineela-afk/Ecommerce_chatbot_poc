# Dockerfile for Kafka AI Worker Service

FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements (create if not exists)
COPY requirements.txt . 2>/dev/null || echo "kafka-python\nlangchain" > requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create logging directory
RUN mkdir -p /app/logs

# Set environment variables
ENV KAFKA_BROKER=kafka:9092 \
    LOG_LEVEL=INFO \
    PYTHONUNBUFFERED=1

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5001/health 2>/dev/null || echo "OK"

# Run the Kafka worker
CMD ["python", "kafka_ai_worker.py"]
