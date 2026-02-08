# Project Structure Documentation

This document describes the organization and purpose of each directory and file in the project.

## Root Level Files

```
├── README.md                 # Main project documentation
├── CHANGELOG.md             # Version history and changes
├── CONTRIBUTING.md          # Contribution guidelines
├── DEVELOPMENT.md           # Development setup and guide
├── DOCKER.md                # Docker and docker-compose documentation
├── LICENSE                  # Project license (MIT)
├── Makefile                 # Common development commands
├── .env.example             # Environment variables template
├── .dockerignore            # Docker build ignore file
├── .gitignore               # Git ignore file
├── docker-compose.yml       # Development docker-compose configuration
└── docker-compose.prod.yml  # Production docker-compose configuration
```

## Service Directories

### ai-service/
Flask-based Python service for AI/chatbot functionality.

```
ai-service/
├── app.py                   # Main Flask application entry point
├── requirements.txt         # Python dependencies
├── Dockerfile              # Docker image configuration
├── .dockerignore            # Docker ignore patterns
├── src/
│   ├── __init__.py
│   ├── main.py             # Main execution file
│   ├── components/         # Core business logic
│   │   ├── __init__.py
│   │   ├── chatbot_builder.py      # Chatbot initialization
│   │   ├── data_cleaning.py        # Data preprocessing
│   │   ├── data_collection.py      # Data gathering
│   │   ├── scraper.py              # Web scraping
│   │   └── vectorstore_builder.py  # Pinecone integration
│   └── utils/              # Utility modules
│       ├── __init__.py
│       ├── chatbot_utils.py        # Chatbot helpers
│       ├── exception.py            # Custom exceptions
│       └── logger.py               # Logging configuration
├── templates/              # HTML templates
│   └── home_page.html      # Home page template
├── data/                   # Input data files
│   ├── data_sarees.csv
│   ├── data_shirts.csv
│   └── data_watches.csv
├── artifacts/              # Generated output files
│   └── data_cleaned.csv
├── Logs/                   # Service logs
└── airflow/                # Apache Airflow configuration
    └── dags/
        └── pipeline.py     # Data pipeline definition
```

**Purpose**: Provides AI-powered chatbot with LangChain and Pinecone vector search.

### java_ecommerce_ready/
Spring Boot Java service for e-commerce backend.

```
java_ecommerce_ready/
├── pom.xml                 # Maven configuration and dependencies
├── Dockerfile             # Docker image configuration
├── .dockerignore           # Docker ignore patterns
├── wait-for-db.sh          # Health check script
├── src/
│   └── main/
│       ├── java/
│       │   └── com/ecommerce/
│       │       ├── Application.java     # Main Spring Boot app
│       │       ├── config/              # Configuration classes
│       │       │   └── SecurityConfig.java
│       │       ├── controller/          # REST endpoints
│       │       │   ├── AuthController.java
│       │       │   ├── InventoryController.java
│       │       │   ├── OrderController.java
│       │       │   ├── PaymentController.java
│       │       │   └── ProductController.java
│       │       ├── kafka/               # Kafka integration
│       │       │   └── KafkaProducer.java
│       │       ├── model/               # Data models
│       │       │   └── Order.java
│       │       └── service/             # Business logic
│       │           └── OrderService.java
│       └── resources/
│           └── application.properties   # Spring configuration
└── target/                 # Build output (generated)
```

**Purpose**: Provides REST APIs for orders, inventory, products, payments, and authentication.

### frontend/
React-based user interface.

```
frontend/
├── package.json            # Node.js dependencies
├── package-lock.json       # Dependency lock file
├── Dockerfile             # Docker image configuration
├── .dockerignore           # Docker ignore patterns
├── public/                 # Static assets
│   └── index.html         # HTML entry point
├── src/
│   ├── index.js           # React entry point
│   ├── App.js             # Main React component
│   ├── index.css           # Global styles
│   ├── App.css             # App styles
│   ├── components/        # React components
│   │   ├── Chat.css
│   │   ├── ChatInput.js    # Chat input component
│   │   ├── ChatWindow.js   # Chat display component
│   │   └── MessageBubble.js # Message display component
│   └── services/          # API integration
│       └── api.js         # API client (axios)
└── build/                 # Production build output (generated)
```

**Purpose**: Provides user interface for chatbot interaction and e-commerce functionality.

### chat_kafka_service/
Python service for processing Kafka messages.

```
chat_kafka_service/
├── kafka_ai_worker.py      # Main Kafka worker script
├── Dockerfile             # Docker image configuration
├── .dockerignore           # Docker ignore patterns
└── artifacts/             # Generated files
    └── data_cleaned.csv
```

**Purpose**: Consumes Kafka messages for asynchronous AI processing.

## GitHub Configuration

```
.github/
├── workflows/              # GitHub Actions CI/CD
│   ├── build-test.yml      # Build and test pipeline
│   ├── code-quality.yml    # Code quality checks
│   ├── deploy.yml          # Production deployment
│   └── scheduled-maintenance.yml # Scheduled tasks
├── ISSUE_TEMPLATE/        # Issue templates
│   ├── bug_report.md
│   ├── feature_request.md
│   └── pull_request_template.md
└── PULL_REQUEST_TEMPLATE.md # PR template
```

## Key Files Description

### Configuration Files

- **docker-compose.yml**: Development environment with all services
- **docker-compose.prod.yml**: Production environment optimized setup
- **.env.example**: Template for environment variables
- **Makefile**: Convenience commands for common tasks
- **pom.xml**: Java Maven dependencies
- **package.json**: Node.js/React dependencies
- **requirements.txt**: Python dependencies

### Documentation Files

- **README.md**: Main project overview and quick start
- **DEVELOPMENT.md**: Setup and development guide
- **CONTRIBUTING.md**: Guidelines for contributing
- **DOCKER.md**: Docker and compose documentation
- **CHANGELOG.md**: Version history

### Workflow Files

- **.github/workflows/build-test.yml**: CI/CD for building and testing
- **.github/workflows/code-quality.yml**: Linting and security scans
- **.github/workflows/deploy.yml**: Production deployment
- **.github/workflows/scheduled-maintenance.yml**: Scheduled maintenance tasks

## Data Flow

```
User (Web Browser)
    ↓
Frontend (React)
    ↓
API Gateway / Load Balancer
    ├── → AI Service (Flask) ← Kafka Worker
    │       ├── LangChain Chatbot
    │       ├── Pinecone Vector Store
    │       └── Kafka Producer
    │
    └── → Backend Service (Spring Boot)
            ├── Order Management
            ├── Inventory Service
            ├── Payment Processing
            ├── Authentication
            └── Kafka Producer

    ├── Database (PostgreSQL)
    ├── Cache (Redis)
    ├── Message Queue (Kafka)
    └── External Services
        └── Pinecone Vector DB
```

## Environment Setup

All environment variables should be defined in `.env` file (copy from `.env.example`).

Key variables:
- `GROQ_API_KEY` - LLM API key
- `PINECONE_API_KEY` - Vector store credentials
- `DB_USER`, `DB_PASSWORD` - Database credentials
- `JWT_SECRET` - Authentication secret
- `KAFKA_BROKER` - Message queue address

## Deployment Paths

For deployment, the following directories are important:

- **Build artifacts**: `java_ecommerce_ready/target/`, `frontend/build/`
- **Configuration**: `.env`, `docker-compose.prod.yml`
- **Logs**: `ai-service/Logs/`, `java_ecommerce_ready/logs/`
- **Data**: `ai-service/data/`, `ai-service/artifacts/`

---

Last Updated: February 9, 2026
