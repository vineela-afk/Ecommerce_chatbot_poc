# Contributing to E-commerce Chatbot POC

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please be respectful and professional in all interactions. We're committed to providing a welcoming and inclusive environment for all contributors.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
3. **Create a feature branch** for your changes
4. **Make your changes** and commit them with clear messages
5. **Push to your fork** and **submit a Pull Request**

## Development Setup

### Prerequisites

- Docker & Docker Compose 2.0+
- Git 2.30+
- Python 3.10+ (for AI service development)
- Java 17+ (for backend development)
- Node.js 18+ (for frontend development)

### Setting Up Development Environment

```bash
# Clone the repository
git clone https://github.com/yourusername/ecommerce-chatbot-poc.git
cd Ecommerce_chatbot_poc

# Copy environment template
cp .env.example .env

# Edit .env with your configuration
# Add your API keys: GROQ_API_KEY, PINECONE_API_KEY, etc.

# Start all services
docker-compose up -d

# Check if all services are running
docker-compose ps
```

### Working on Individual Services

#### AI Service (Python)

```bash
cd ai-service

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run tests
pytest

# Run the service locally
python app.py
```

#### Backend Service (Java)

```bash
cd java_ecommerce_ready

# Run tests
mvn clean test

# Build the project
mvn clean package

# Run locally
mvn spring-boot:run
```

#### Frontend (React)

```bash
cd frontend

# Install dependencies
npm install

# Run development server
npm start

# Run tests
npm test

# Build for production
npm run build
```

## Code Style Guide

### Python

- Follow PEP 8 standards
- Use 4 spaces for indentation
- Max line length: 100 characters
- Use type hints where possible

```python
def calculate_score(items: List[str], threshold: float) -> Dict[str, float]:
    """Calculate score for items above threshold."""
    pass
```

### Java

- Follow Google Java Style Guide
- Use meaningful variable names
- Add Javadoc comments for public methods

```java
/**
 * Processes the order and updates inventory.
 *
 * @param order the order to process
 * @return the processing result
 */
public OrderResult processOrder(Order order) {
    // implementation
}
```

### JavaScript/React

- Use ES6+ syntax
- Use functional components with hooks
- Name components in PascalCase
- Name functions and variables in camelCase

```javascript
const ChatWindow = ({ messages, onSendMessage }) => {
  const [inputValue, setInputValue] = useState('');

  return (
    <div className="chat-window">
      {/* JSX */}
    </div>
  );
};
```

## Commit Message Guidelines

Use conventional commits format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Changes that don't affect code meaning
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvement
- `test`: Adding or updating tests
- `chore`: Changes to build process, dependencies, etc.

**Examples:**

```
feat(chatbot): add context window management to chat service
fix(ai-service): resolve pinecone connection timeout issue
docs(readme): update Docker setup instructions
test(backend): add integration tests for order processing
```

## Pull Request Process

1. **Update the README.md** with any new features or documentation changes
2. **Add tests** for any new functionality
3. **Update CHANGELOG** if applicable
4. **Ensure all tests pass** before submitting
5. **Request review** from maintainers

### PR Title Format

```
[Service] Brief description of changes
```

Examples:
- `[AI-Service] Improve vector search performance`
- `[Backend] Add authentication middleware`
- `[Frontend] Fix chat message rendering bug`

## Testing Requirements

### Minimum Coverage

- **Python**: 80% code coverage
- **Java**: 75% code coverage
- **JavaScript**: 70% code coverage

### Running Tests

```bash
# AI Service
cd ai-service
pytest --cov=src

# Backend
cd java_ecommerce_ready
mvn jacoco:report

# Frontend
cd frontend
npm test -- --coverage
```

## Build & Deployment Testing

```bash
# Build Docker images
docker-compose build

# Test the build
docker-compose up -d
docker-compose ps
docker-compose logs -f

# Clean up
docker-compose down -v
```

## Documentation

- Update relevant documentation when adding features
- Include docstrings/comments for complex logic
- Update README if adding new dependencies or configuration

## Reporting Issues

When reporting bugs, please include:

1. **Description** of the issue
2. **Steps to reproduce**
3. **Expected behavior**
4. **Actual behavior**
5. **Environment** (OS, Python/Java/Node version, etc.)
6. **Logs or error messages**
7. **Screenshots** if applicable

## Feature Requests

Describe:
1. **Use case** - Why do you need this feature?
2. **Expected behavior** - How should it work?
3. **Possible implementation** - Any suggestions on how to implement it?

## Code Review Process

- All PRs require at least 2 approvals
- CI/CD checks must pass
- Discussions must be resolved
- Code should follow project standards

## Merge Conflicts

If you encounter merge conflicts:

1. Fetch the latest main branch
2. Rebase your feature branch
3. Resolve conflicts
4. Push the resolved branch

```bash
git fetch origin
git rebase origin/main
# Resolve conflicts in your editor
git add .
git rebase --continue
git push origin feature/your-feature --force
```

## Questions?

- Open an issue with question tag
- Check existing discussions
- Contact maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT).

## Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- GitHub contributors page
- Release notes

Thank you for contributing to make this project better!

---

Last Updated: February 9, 2026
