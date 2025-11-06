#!/bin/bash

# Ancient Medicine Automation - Setup Script
# This script initializes the project structure and checks dependencies

set -e  # Exit on any error

echo "======================================"
echo "Ancient Medicine Automation - Setup"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_warning "This script is optimized for macOS. You may need to adjust for your OS."
fi

# Check for required commands
echo "Checking prerequisites..."
echo ""

MISSING_DEPS=false

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    print_success "Python $PYTHON_VERSION found"
else
    print_error "Python 3 not found"
    MISSING_DEPS=true
fi

# Check Docker
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | sed 's/,//')
    print_success "Docker $DOCKER_VERSION found"
else
    print_error "Docker not found - required for n8n"
    MISSING_DEPS=true
fi

# Check Git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    print_success "Git $GIT_VERSION found"
else
    print_error "Git not found"
    MISSING_DEPS=true
fi

# Check curl
if command -v curl &> /dev/null; then
    print_success "curl found"
else
    print_error "curl not found"
    MISSING_DEPS=true
fi

echo ""

if [ "$MISSING_DEPS" = true ]; then
    print_error "Missing required dependencies. Please install them first."
    echo ""
    echo "Installation instructions:"
    echo "  Python: https://www.python.org/downloads/"
    echo "  Docker: https://www.docker.com/products/docker-desktop"
    echo "  Git: brew install git"
    exit 1
fi

# Create directory structure
echo "Creating directory structure..."

mkdir -p docs
mkdir -p n8n/workflows n8n/credentials
mkdir -p comfyui/workflows comfyui/models
mkdir -p scripts
mkdir -p config
mkdir -p data/manuscripts data/extracted-texts data/scripts
mkdir -p output/videos output/thumbnails output/metadata

print_success "Directory structure created"

# Initialize data files
echo ""
echo "Initializing data files..."

touch data/discovered-books.jsonl
touch data/facts-database.jsonl
echo '{"initialized": true, "date": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"}' > data/scripts/placeholder.json

print_success "Data files initialized"

# Check for .env file
echo ""
if [ -f ".env" ]; then
    print_success ".env file already exists"
else
    if [ -f "config/.env.example" ]; then
        print_warning ".env file not found"
        read -p "Would you like to create .env from template? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp config/.env.example .env
            print_success ".env file created from template"
            print_warning "Please edit .env and add your API keys"
            echo "  Required: GEMINI_API_KEY"
            echo "  Optional: MUBERT_LICENSE, DEEPSEEK_API_KEY"
        fi
    else
        print_error "config/.env.example not found"
    fi
fi

# Check for Gemini API key
echo ""
if [ -f ".env" ]; then
    if grep -q "your_gemini_api_key_here" .env; then
        print_warning "Gemini API key not configured in .env"
        echo "  Get your free API key at: https://aistudio.google.com/"
    else
        print_success "Gemini API key configured"
    fi
fi

# Check ComfyUI installation
echo ""
echo "Checking ComfyUI installation..."

if [ -d "$HOME/Applications/ComfyUI" ]; then
    print_success "ComfyUI found at ~/Applications/ComfyUI"
else
    print_warning "ComfyUI not found at default location"
    echo "  Install ComfyUI: https://github.com/comfyanonymous/ComfyUI"
    echo "  Or specify custom path in .env: COMFYUI_PATH=/path/to/ComfyUI"
fi

# Check Docker Compose
echo ""
echo "Checking n8n setup..."

if [ -f "docker-compose.yml" ]; then
    print_success "docker-compose.yml found"
else
    print_warning "docker-compose.yml not found"
    read -p "Would you like to create it? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cat > docker-compose.yml <<'EOF'
version: '3.8'

services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=changeme123
      - N8N_HOST=localhost
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - WEBHOOK_URL=http://localhost:5678/
      - GENERIC_TIMEZONE=Europe/Berlin
      - TZ=Europe/Berlin
    volumes:
      - ./n8n_data:/home/node/.n8n
      - .:/home/user/medicine:rw
    networks:
      - n8n-network

networks:
  n8n-network:
    driver: bridge
EOF
        print_success "docker-compose.yml created"
    fi
fi

# Summary
echo ""
echo "======================================"
echo "Setup Summary"
echo "======================================"
echo ""

if [ -f ".env" ] && ! grep -q "your_gemini_api_key_here" .env && [ -f "docker-compose.yml" ]; then
    print_success "All core components configured"
    echo ""
    echo "Next steps:"
    echo "  1. Start n8n: docker-compose up -d"
    echo "  2. Open n8n: http://localhost:5678"
    echo "  3. Import workflows from n8n/workflows/"
    echo "  4. Start ComfyUI: cd ~/Applications/ComfyUI && python main.py"
    echo "  5. Test first workflow manually"
    echo ""
    echo "See docs/SETUP.md for detailed instructions"
else
    print_warning "Some configuration still needed"
    echo ""
    echo "Please complete:"
    if [ ! -f ".env" ] || grep -q "your_gemini_api_key_here" .env; then
        echo "  - Configure .env with your API keys"
    fi
    if [ ! -f "docker-compose.yml" ]; then
        echo "  - Create docker-compose.yml for n8n"
    fi
    if [ ! -d "$HOME/Applications/ComfyUI" ]; then
        echo "  - Install ComfyUI"
    fi
    echo ""
    echo "See docs/SETUP.md for detailed instructions"
fi

echo ""
print_success "Setup script complete!"
