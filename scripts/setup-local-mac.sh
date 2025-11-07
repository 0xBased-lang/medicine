#!/bin/bash

# =====================================================
# MEDICINE AUTOMATION - LOCAL MAC SETUP SCRIPT
# =====================================================
# This script sets up everything locally on your M1 Mac
# =====================================================

set -e

echo "🔧 Medicine Automation - Local Mac Setup"
echo "========================================"
echo ""

# Check prerequisites
echo "✅ Checking prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker Desktop for Mac:"
    echo "   https://www.docker.com/products/docker-desktop"
    exit 1
fi
echo "✅ Docker found: $(docker --version)"

# Check Git
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed"
    exit 1
fi
echo "✅ Git found"

# Check if medicine directory exists
if [ ! -d "$(pwd)/medicine" ] && [ "$(basename "$(pwd)")" != "medicine" ]; then
    echo "❌ Please run this script from the medicine directory"
    echo "   cd ~/medicine && bash scripts/setup-local-mac.sh"
    exit 1
fi

MEDICINE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "📁 Working directory: $MEDICINE_DIR"
echo ""

# =====================================================
# STEP 1: Check Ollama
# =====================================================
echo "📦 Step 1: Checking Ollama installation..."
if command -v ollama &> /dev/null; then
    echo "✅ Ollama is installed: $(ollama --version)"

    # Check if model is already downloaded
    echo "⏳ Checking for Ollama models..."
    if ollama list | grep -q "llama3.2"; then
        echo "✅ llama3.2:3b model found"
    else
        echo "⚠️  llama3.2:3b not found. Run this to download:"
        echo "   ollama pull llama3.2:3b"
    fi
else
    echo "⚠️  Ollama not installed. Install with:"
    echo "   curl -fsSL https://ollama.com/install.sh | sh"
    echo ""
    echo "Then download a model:"
    echo "   ollama pull llama3.2:3b"
    echo ""
    read -p "Press Enter once Ollama is installed and model is downloaded..."
fi
echo ""

# =====================================================
# STEP 2: Start Ollama (if not running)
# =====================================================
echo "🚀 Step 2: Starting Ollama..."
if pgrep -xq ollama; then
    echo "✅ Ollama is already running"
else
    echo "⏳ Starting Ollama daemon..."
    ollama serve > /dev/null 2>&1 &
    OLLAMA_PID=$!
    echo "✅ Ollama started (PID: $OLLAMA_PID)"

    # Wait for Ollama to be ready
    echo "⏳ Waiting for Ollama to be ready..."
    sleep 3
    for i in {1..30}; do
        if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
            echo "✅ Ollama is ready"
            break
        fi
        if [ $i -eq 30 ]; then
            echo "❌ Ollama took too long to start"
            exit 1
        fi
        sleep 1
    done
fi
echo ""

# =====================================================
# STEP 3: Start Docker containers
# =====================================================
echo "🐳 Step 3: Starting Docker containers..."
cd "$MEDICINE_DIR"

# Check if containers are already running
if docker ps | grep -q "n8n_medicine"; then
    echo "⚠️  n8n container is already running"
    echo "   To restart: docker-compose restart"
else
    echo "⏳ Starting n8n container..."
    docker-compose up -d

    # Wait for n8n to be ready
    echo "⏳ Waiting for n8n to be ready..."
    for i in {1..60}; do
        if curl -s http://localhost:5678/healthz > /dev/null 2>&1; then
            echo "✅ n8n is ready"
            break
        fi
        if [ $i -eq 60 ]; then
            echo "⚠️  n8n healthcheck timed out (might still be starting)"
        fi
        sleep 1
    done
fi
echo ""

# =====================================================
# STEP 4: Verify ComfyUI
# =====================================================
echo "🎬 Step 4: Checking ComfyUI..."
if curl -s http://localhost:8188/api/system/stats > /dev/null 2>&1; then
    echo "✅ ComfyUI is running on http://localhost:8188"
else
    echo "⚠️  ComfyUI is not accessible at http://localhost:8188"
    echo "   Make sure ComfyUI is running separately"
fi
echo ""

# =====================================================
# STEP 5: Create necessary directories
# =====================================================
echo "📁 Step 5: Setting up directories..."
mkdir -p "$MEDICINE_DIR/data/manuscripts"
mkdir -p "$MEDICINE_DIR/data/extracted-texts"
mkdir -p "$MEDICINE_DIR/data/scripts"
mkdir -p "$MEDICINE_DIR/output/videos"
mkdir -p "$MEDICINE_DIR/output/thumbnails"
mkdir -p "$MEDICINE_DIR/output/metadata"
echo "✅ Directories created"
echo ""

# =====================================================
# STEP 6: Display access information
# =====================================================
echo "✨ Setup Complete!"
echo "========================================"
echo ""
echo "🌐 Access these services:"
echo "   n8n:     http://localhost:5678 (admin / medicine2025secure)"
echo "   Ollama:  http://localhost:11434"
echo "   ComfyUI: http://localhost:8188"
echo ""
echo "📝 Next steps:"
echo "   1. Open http://localhost:5678 in your browser"
echo "   2. Import workflows from n8n/workflows/"
echo "   3. Test the discovery workflow"
echo ""
echo "🛑 To stop everything:"
echo "   docker-compose down"
echo "   pkill ollama"
echo ""
