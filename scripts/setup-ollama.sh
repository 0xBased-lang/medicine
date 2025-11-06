#!/bin/bash

# Setup Ollama for Ancient Medicine Automation
# 100% FREE AI - Runs locally on your M1 Mac

set -e

echo "======================================"
echo "Ollama Setup for Medicine Automation"
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Check if Ollama is already installed
if command -v ollama &> /dev/null; then
    print_success "Ollama is already installed"
    ollama --version
else
    print_info "Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
    print_success "Ollama installed successfully"
fi

echo ""
print_info "Downloading AI model (this may take 5-10 minutes)..."
echo ""

# Ask user which model to download
echo "Which model would you like to use?"
echo ""
echo "1) llama3.2:3b (2GB) - RECOMMENDED - Fast, multilingual"
echo "2) sauerkrautlm-7b-hero (7GB) - Best German quality"
echo "3) aya (5GB) - 23 languages including German"
echo "4) llama3.1:8b (4.7GB) - Balanced performance"
echo ""
read -p "Enter choice [1-4] (default: 1): " choice
choice=${choice:-1}

case $choice in
    1)
        MODEL="llama3.2:3b"
        print_info "Downloading llama3.2:3b (2GB)..."
        ;;
    2)
        MODEL="sroecker/sauerkrautlm-7b-hero"
        print_info "Downloading SauerkrautLM (7GB)..."
        ;;
    3)
        MODEL="aya"
        print_info "Downloading Aya multilingual (5GB)..."
        ;;
    4)
        MODEL="llama3.1:8b"
        print_info "Downloading LLaMA 3.1 8B (4.7GB)..."
        ;;
    *)
        MODEL="llama3.2:3b"
        print_info "Downloading llama3.2:3b (2GB)..."
        ;;
esac

# Download the model
ollama pull $MODEL

print_success "Model downloaded: $MODEL"

echo ""
print_info "Testing model..."
echo ""

# Test the model
ollama run $MODEL "Erstelle einen kurzen Satz über deutsche Heilkräuter" --verbose

echo ""
print_success "Model test successful!"

# Update .env file
echo ""
print_info "Updating .env configuration..."

if [ -f "/home/user/medicine/.env" ]; then
    # Update existing .env
    if grep -q "AI_PROVIDER=" /home/user/medicine/.env; then
        sed -i "s/AI_PROVIDER=.*/AI_PROVIDER=ollama/" /home/user/medicine/.env
    else
        echo "AI_PROVIDER=ollama" >> /home/user/medicine/.env
    fi

    if grep -q "OLLAMA_MODEL=" /home/user/medicine/.env; then
        sed -i "s|OLLAMA_MODEL=.*|OLLAMA_MODEL=$MODEL|" /home/user/medicine/.env
    else
        echo "OLLAMA_MODEL=$MODEL" >> /home/user/medicine/.env
    fi

    print_success ".env file updated"
else
    # Create new .env from example
    cp /home/user/medicine/config/.env.example /home/user/medicine/.env
    sed -i "s/AI_PROVIDER=.*/AI_PROVIDER=ollama/" /home/user/medicine/.env
    sed -i "s|OLLAMA_MODEL=.*|OLLAMA_MODEL=$MODEL|" /home/user/medicine/.env
    print_success ".env file created"
fi

echo ""
echo "======================================"
echo "Ollama Setup Complete! 🎉"
echo "======================================"
echo ""
print_success "AI Provider: Ollama (100% FREE)"
print_success "Model: $MODEL"
print_success "API URL: http://localhost:11434"
echo ""
echo "Next steps:"
echo "  1. Keep Ollama running (it auto-starts)"
echo "  2. Start n8n: docker-compose up -d"
echo "  3. Import workflows in n8n UI"
echo "  4. Run first workflow to test!"
echo ""
echo "Test Ollama anytime with:"
echo "  ollama run $MODEL \"Your prompt here\""
echo ""
print_success "Cost: \$0 forever! 🚀"
