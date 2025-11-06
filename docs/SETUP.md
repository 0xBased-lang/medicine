# 🚀 Setup Guide - Ancient Medicine Content Automation

Complete step-by-step setup instructions for your n8n + ComfyUI automation workflow.

---

## 📋 Prerequisites

### Required Software
- **macOS** with M1/M2/M3 chip (24GB+ RAM recommended)
- **Docker Desktop** for Mac (latest version)
- **Python 3.10+** installed
- **Git** installed
- **Homebrew** (for package management)

### Required Accounts
- **Google AI Studio** account (free) for Gemini API
- **Mubert** account (optional, for music API)
- **Archive.org** account (optional, recommended)

---

## 🔧 Installation Steps

### Step 1: Install ComfyUI on M1 Mac

```bash
# Navigate to your preferred installation directory
cd ~/Applications

# Clone ComfyUI repository
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI

# Create Python virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies for Apple Silicon
pip install --upgrade pip
pip install torch torchvision torchaudio
pip install -r requirements.txt

# Test installation
python main.py

# ComfyUI should start and be accessible at http://localhost:8188
```

**Important**: Keep ComfyUI running in a terminal window while using the workflow.

---

### Step 2: Download ComfyUI Models

Create models directory and download recommended lightweight models:

```bash
cd ~/Applications/ComfyUI/models

# Create subdirectories
mkdir -p checkpoints vae loras upscale_models

# Download FLUX.1-schnell (fast image generation)
cd checkpoints
# Download from: https://huggingface.co/black-forest-labs/FLUX.1-schnell
# Place in: ComfyUI/models/checkpoints/

# Download LTX Video model (lightweight video)
# Visit: https://huggingface.co/Lightricks/LTX-Video
# Download ltx-video-2b-v0.9.5.safetensors
# Place in: ComfyUI/models/checkpoints/

# Note: Models are large (2-10GB each). Download only what you need initially.
```

**Model Recommendations for M1 Mac 24GB:**
- **FLUX.1-schnell**: 4-step fast image generation (~5GB)
- **LTX Video 0.9.5**: Efficient video generation (~2GB)
- **Hunyuan 1.3B**: Backup video model (~3GB)

See [comfyui/models/MODELS.md](../comfyui/models/MODELS.md) for download links.

---

### Step 3: Install Coqui TTS (Text-to-Speech)

```bash
# Create new virtual environment for TTS
cd ~/
mkdir -p tts-server
cd tts-server
python3 -m venv venv
source venv/bin/activate

# Install Coqui TTS
pip install TTS

# Test installation with German voice
tts --text "Hallo, dies ist ein Test" --model_name "tts_models/de/thorsten/tacotron2-DDC" --out_path test.wav

# Install openedai-speech (OpenAI-compatible TTS server)
pip install openedai-speech

# Or clone and install
git clone https://github.com/matatonic/openedai-speech.git
cd openedai-speech
pip install -r requirements.txt

# Start TTS server (keep running)
python -m openedai_speech.server --port 8020
# Server will be at http://localhost:8020
```

**German Voice Models:**
- `tts_models/de/thorsten/tacotron2-DDC` (recommended)
- `tts_models/multilingual/multi-dataset/xtts_v2` (best quality, slower)

---

### Step 4: Install n8n with Docker

```bash
# Create n8n directory
mkdir -p ~/n8n
cd ~/n8n

# Create docker-compose.yml file
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
      - /home/user/medicine:/home/user/medicine:rw
    networks:
      - n8n-network

networks:
  n8n-network:
    driver: bridge
EOF

# Start n8n
docker-compose up -d

# Check logs
docker-compose logs -f n8n

# Access n8n at http://localhost:5678
# Username: admin
# Password: changeme123 (change this!)
```

---

### Step 5: Configure Environment Variables

```bash
cd /home/user/medicine

# Copy environment template
cp config/.env.example .env

# Edit with your favorite editor
nano .env

# Required variables to set:
# GEMINI_API_KEY=your_key_here  (get from https://aistudio.google.com)
# OUTPUT_LANGUAGE=de (or en)
# COMFYUI_URL=http://localhost:8188
```

**Get Gemini API Key:**
1. Visit https://aistudio.google.com/
2. Click "Get API Key"
3. Create new API key
4. Copy and paste into `.env` file

**Free tier includes**: 1,500 requests/day, 1M tokens/day - more than enough for 1 video/day!

---

### Step 6: Import n8n Workflows

```bash
# Workflows are located in: /home/user/medicine/n8n/workflows/

# In n8n web interface (http://localhost:5678):
# 1. Click on "Workflows" in sidebar
# 2. Click "Import from File"
# 3. Select: n8n/workflows/01-content-discovery.json
# 4. Repeat for: 02-content-processing.json
# 5. Activate each workflow after import
```

**Workflow Setup in n8n:**

For each workflow:
1. Open workflow
2. Click "Workflow Settings" (gear icon)
3. Set "Execution Order" to v1
4. Set "Save Manual Executions" to true
5. Click "Save"

---

### Step 7: Test Each Component

#### Test 1: Archive.org API
```bash
curl "https://archive.org/advancedsearch.php?q=Heilkunde+language:ger&fl[]=identifier,title&rows=5&output=json"

# Should return JSON with German medical books
```

#### Test 2: Gemini API
```bash
cd /home/user/medicine
source .env

curl -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=${GEMINI_API_KEY}" \
  -H 'Content-Type: application/json' \
  -d '{
    "contents": [{
      "parts": [{
        "text": "Say hello in German"
      }]
    }]
  }'

# Should return German greeting
```

#### Test 3: ComfyUI
```bash
# ComfyUI should be running at http://localhost:8188
# Open in browser and test basic workflow

# Or test API:
curl http://localhost:8188/system_stats

# Should return JSON with GPU/memory stats
```

#### Test 4: TTS Server
```bash
# If using openedai-speech:
curl http://localhost:8020/v1/models

# Should return available voices
```

---

### Step 8: Initialize Project Data

```bash
cd /home/user/medicine

# Create empty database files
touch data/discovered-books.jsonl
touch data/facts-database.jsonl

# Create placeholder script
echo '{"initialized": true}' > data/scripts/placeholder.json

# Set permissions
chmod -R 755 data/
chmod -R 755 output/
chmod -R 755 config/

# Verify structure
tree -L 2 .
```

---

### Step 9: Run First Workflow Test

**Manual Test (Recommended for first run):**

1. Open n8n: http://localhost:5678
2. Navigate to "01 - Archive.org Content Discovery"
3. Click "Execute Workflow" button
4. Watch each node execute (green = success)
5. Check output in: `/home/user/medicine/data/discovered-books.jsonl`

**Expected Result:**
- Workflow finds German medical books
- Selects one book for processing
- Saves metadata to `data/discovered-books.jsonl`
- Triggers next workflow (02-content-processing)

**If workflow fails:**
- Check n8n logs: `docker logs n8n`
- Verify environment variables are set
- Check Archive.org API is responding
- See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

### Step 10: Enable Automatic Scheduling

Once manual tests work:

```bash
# Edit .env file
nano .env

# Change:
AUTO_PROCESS=true

# Restart n8n
cd ~/n8n
docker-compose restart
```

The workflow will now run daily at 9 AM automatically.

---

## 🎬 ComfyUI Workflow Setup

### Install Required Custom Nodes

```bash
cd ~/Applications/ComfyUI/custom_nodes

# Install ComfyUI Manager (for easy node management)
git clone https://github.com/ltdrdata/ComfyUI-Manager.git

# Restart ComfyUI
# In browser, click "Manager" button to install additional nodes as needed
```

### Load Video Generation Workflow

1. Open ComfyUI: http://localhost:8188
2. Click "Load" button
3. Navigate to: `/home/user/medicine/comfyui/workflows/`
4. Load: `text-to-video-ltx.json` (once created)
5. Save as default workflow

**Note**: ComfyUI workflow creation requires manual setup based on your specific models. See [ComfyUI Wiki](https://comfyui-wiki.com) for tutorials.

---

## 🔐 Security Best Practices

### Protect Your API Keys

```bash
# Ensure .env is not committed to git
echo ".env" >> .gitignore

# Set restrictive permissions
chmod 600 .env

# Never share .env file publicly
```

### Change n8n Password

```bash
# Edit docker-compose.yml
nano ~/n8n/docker-compose.yml

# Change:
# N8N_BASIC_AUTH_PASSWORD=your_strong_password_here

# Restart n8n
docker-compose restart
```

---

## 📊 Monitoring & Logs

### n8n Logs
```bash
# View live logs
docker logs -f n8n

# View recent errors
docker logs n8n 2>&1 | grep ERROR
```

### ComfyUI Logs
```bash
# Check terminal where ComfyUI is running
# Errors will appear in red
```

### Workflow Execution Logs
```bash
# In n8n web interface:
# Click "Executions" in sidebar
# View history of all workflow runs
# Click on any execution to see details
```

---

## 🔄 Daily Workflow Execution Pattern

```
09:00 - Cron triggers content discovery
09:01 - Archive.org search completes
09:02 - Best book selected
09:05 - Text downloaded and processed
09:10 - Gemini extracts facts
09:12 - Gemini generates script
09:15 - Visual prompt created
09:20 - ComfyUI begins video generation
11:00 - TTS audio generated
13:00 - Video complete (2-4 hours on M1)
13:05 - Final video saved to /output/videos/
```

**Manual Review:** Check `/output/videos/` folder after 1-2 PM for today's video.

---

## 🎯 Next Steps

Once setup is complete:

1. **Test each workflow manually** before enabling automation
2. **Review first 3-5 generated videos** for quality
3. **Adjust prompts** in workflows if needed
4. **Create posting schedule** for platforms
5. **Track engagement** and iterate on what works

---

## 📚 Additional Resources

- [n8n Documentation](https://docs.n8n.io)
- [ComfyUI Wiki](https://comfyui-wiki.com)
- [Gemini API Docs](https://ai.google.dev/docs)
- [Archive.org API](https://archive.org/developers)
- [Coqui TTS Documentation](https://github.com/coqui-ai/TTS)

---

## 🆘 Need Help?

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

For ComfyUI-specific help:
- [ComfyUI Discord](https://discord.gg/comfyui)
- [ComfyUI GitHub Issues](https://github.com/comfyanonymous/ComfyUI/issues)

For n8n help:
- [n8n Community Forum](https://community.n8n.io)
- [n8n Discord](https://discord.gg/n8n)

---

**🎉 Setup Complete!** You're ready to start generating ancient medicine content automatically.
