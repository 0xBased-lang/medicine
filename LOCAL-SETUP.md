# 🍎 Medicine Automation - Local Mac Setup Guide

This guide sets up the medicine automation pipeline locally on your M1 Mac with Ollama for AI and ComfyUI for video generation.

---

## 📋 Prerequisites Checklist

- ✅ macOS (M1 or Intel)
- ✅ Docker Desktop installed ([Download here](https://www.docker.com/products/docker-desktop))
- ✅ ComfyUI already installed and ready
- ⏳ Ollama (we'll install this)
- ✅ Git (pre-installed on Mac)

---

## 🚀 Quick Start (5 minutes)

### Step 1: Install Ollama

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Download AI model (choose one):

# Option A: German-optimized (recommended for German medical content)
ollama pull sroecker/sauerkrautlm-7b-hero

# Option B: Fast & lightweight (recommended for testing)
ollama pull llama3.2:3b

# Option C: Multilingual (good if you need multiple languages)
ollama pull aya
```

**Test Ollama works:**
```bash
ollama run llama3.2:3b "Sag hallo auf Deutsch"
# Should respond: "Hallo! Wie kann ich dir helfen?"
```

### Step 2: Verify Docker Desktop

```bash
# Check Docker is running
docker --version
docker ps

# Should show: "Docker version X.X.X"
```

### Step 3: Run Setup Script

```bash
cd ~/medicine

# Make script executable
chmod +x scripts/setup-local-mac.sh

# Run setup
bash scripts/setup-local-mac.sh
```

**This script will:**
- ✅ Check all prerequisites
- ✅ Start Ollama daemon
- ✅ Start n8n Docker container
- ✅ Verify ComfyUI is running
- ✅ Create necessary directories
- ✅ Display access information

---

## 🔑 Manual Setup (If Script Fails)

### 1. Start Ollama

```bash
# Background daemon (recommended)
ollama serve &

# Or foreground (for testing)
ollama serve

# Verify it's running
curl http://localhost:11434/api/tags
```

### 2. Start n8n

```bash
cd ~/medicine

# Start Docker container
docker-compose up -d

# Check logs
docker logs -f n8n_medicine

# Access n8n
# Open: http://localhost:5678
# Login: admin / medicine2025secure
```

### 3. Verify ComfyUI

```bash
# Check if ComfyUI is accessible
curl http://localhost:8188/api/system/stats

# If accessible, you should see JSON response with system stats
```

---

## 📦 Service Access

Once everything is running, access these services:

| Service | URL | Login | Purpose |
|---------|-----|-------|---------|
| **n8n** | http://localhost:5678 | admin / medicine2025secure | Workflow orchestration |
| **Ollama** | http://localhost:11434 | — | Local AI model |
| **ComfyUI** | http://localhost:8188 | — | Video generation |

---

## 📥 Import Workflows

In n8n web interface (http://localhost:5678):

1. Click **"Workflows"** in left sidebar
2. Click **"Import from File"** button (top right)
3. Navigate to: `~/medicine/n8n/workflows/`
4. Import these files in order:
   - `01-content-discovery.json` - Discovers German medical books
   - `02-content-processing.json` - Generates scripts with AI

**Result**: You should see 2 workflows imported ✅

---

## 🧪 Test the Pipeline

### Test 1: Content Discovery

```bash
# In n8n Web UI:
1. Open: "01 - Archive.org Content Discovery"
2. Click: "Execute Workflow" (play icon)
3. Wait 30-60 seconds for completion

# Check results:
cat ~/medicine/data/discovered-books.jsonl
# Should see: JSON with German book metadata from Archive.org
```

### Test 2: AI Script Generation

```bash
# In n8n Web UI:
1. Open: "02 - AI Content Processing & Script Generation"
2. Click: "Execute Workflow"
3. Wait 2-3 minutes (Ollama is processing on your Mac)

# Check results:
ls ~/medicine/data/scripts/
cat ~/medicine/data/scripts/script_*.json
# Should see: Complete 50-second video script with hooks and visual prompts
```

### Test 3: End-to-End Pipeline

```bash
# Run discovery workflow first
# Then verify processing workflow runs automatically (via webhook)

# Or manually trigger processing:
curl -X POST http://localhost:5678/webhook/process \
  -H "Content-Type: application/json" \
  -d '{"book_id":"test","title":"Test Book"}'
```

---

## 🔧 Configuration

### Change Ollama Model

Edit `~/medicine/.env`:
```bash
# Current (fast, lightweight)
OLLAMA_MODEL=llama3.2:3b

# Alternative: German-optimized (slower, better German)
OLLAMA_MODEL=sroecker/sauerkrautlm-7b-hero
```

### Enable Automatic Scheduling

Edit `~/medicine/.env`:
```bash
# Change from:
AUTO_PROCESS=false

# To:
AUTO_PROCESS=true
CRON_SCHEDULE=0 9 * * *  # Run at 9 AM daily
```

### Add API Keys (Optional)

For cloud AI providers, edit `~/medicine/.env`:

**Gemini API** (Google):
```bash
GEMINI_API_KEY=your_key_here
AI_PROVIDER=gemini
```

**Groq API** (Free tier, 500k tokens/day):
```bash
GROQ_API_KEY=your_key_here
AI_PROVIDER=groq
```

---

## 🔍 Troubleshooting

### Problem: "Ollama not found"

```bash
# Make sure Ollama is installed
which ollama

# If not found, install:
curl -fsSL https://ollama.com/install.sh | sh

# If installed but not running, start it:
ollama serve &
```

### Problem: "Cannot connect to Docker daemon"

```bash
# Make sure Docker Desktop is running
# Open Docker Desktop from Applications menu

# Or check Docker status:
docker ps
```

### Problem: "n8n container fails to start"

```bash
# Check Docker logs:
docker logs n8n_medicine

# Remove and restart:
docker-compose down
docker-compose up -d
```

### Problem: "ComfyUI not responding"

```bash
# Make sure ComfyUI is running separately
# You need to start ComfyUI before running workflows that generate videos

# Check if it's accessible:
curl http://localhost:8188/api/system/stats
```

### Problem: "Ollama very slow"

```bash
# Check available models:
ollama list

# If using large model (7B), consider switching to smaller:
ollama pull llama3.2:3b

# Update .env:
OLLAMA_MODEL=llama3.2:3b
```

---

## 📊 Monitoring

### View n8n Execution Logs

```bash
# In n8n Web UI:
1. Open any workflow
2. Click "Executions" tab
3. See all execution history with timing and errors
```

### View Docker Logs

```bash
# Real-time logs:
docker logs -f n8n_medicine

# Last 100 lines:
docker logs --tail=100 n8n_medicine
```

### View Ollama Activity

```bash
# Check if Ollama is processing
ps aux | grep ollama

# Check available models
ollama list

# View Ollama logs (if running in foreground):
# Check terminal where you ran `ollama serve`
```

---

## 🛑 Stopping Everything

```bash
# Stop all Docker containers
docker-compose down

# Stop Ollama daemon
pkill ollama

# Or kill all related processes:
lsof -i :5678  # Find process on port 5678
lsof -i :11434 # Find process on port 11434
lsof -i :8188  # Find process on port 8188
```

---

## 📈 Next Steps

1. ✅ **Setup complete** - Everything running locally
2. ✅ **Test discovery** - Verify Archive.org search works
3. ✅ **Test processing** - Verify AI script generation works
4. 📋 **Configure APIs** - Add Gemini key for advanced features (optional)
5. 📋 **Enable scheduling** - Set AUTO_PROCESS=true for daily automation
6. 📋 **Monitor pipeline** - Set up notifications for failed workflows

---

## 💡 Tips for Best Performance

### Speed Up Ollama
- Use `llama3.2:3b` (fastest) instead of larger models
- Make sure nothing else is using your GPU
- Restart Mac if Ollama gets slow

### Reduce Memory Usage
- Close unnecessary applications before running workflows
- Reduce SCRIPT_WORD_COUNT_MAX in .env if processing is slow
- Monitor Activity Monitor during execution

### Improve Script Quality
- Use `sroecker/sauerkrautlm-7b-hero` for better German understanding
- Add GEMINI_API_KEY for even better script generation
- Create custom prompts in workflow nodes

---

## 📞 Need Help?

If you encounter issues:

1. Check the troubleshooting section above
2. View logs: `docker logs -f n8n_medicine`
3. Verify all services are running: `docker ps`
4. Check Ollama: `curl http://localhost:11434/api/tags`

---

**Happy content automation! 🚀**
