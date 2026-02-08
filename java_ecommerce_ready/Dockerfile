# Multi-stage build for E-commerce Service

# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17 as builder

WORKDIR /app

# Copy POM and source code
COPY pom.xml .
COPY src src/

# Build the application
RUN mvn clean package -DskipTests -q

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache \
    curl \
    jq \
    && rm -rf /var/cache/apk/*

# Copy JAR from builder
COPY --from=builder /app/target/ecommerce-platform-1.0.0.jar app.jar

# Create directories for logs and data
RUN mkdir -p /app/logs /app/data

# Set environment variables
ENV JAVA_OPTS="-Xms512m -Xmx2g -XX:+UseG1GC -XX:MaxGCPauseMillis=200" \
    SPRING_PROFILES_ACTIVE=production \
    SERVER_PORT=8080

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Run the application
CMD ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
