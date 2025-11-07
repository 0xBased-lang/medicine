# 🎯 Medicine Automation - Local Setup COMPLETE

## ✅ What's Done

- ✅ **Ollama Installed**: llama3.2:3b model (2GB) ready
- ✅ **Ollama Verified**: Running and responding
- ✅ **.env Configuration**: Set up for local Ollama (no Gemini needed)
- ✅ **Workflows Modified**: Ollama API versions created
- ⏳ **Docker Desktop**: Needs to be started (you'll do this)

---

## 🚀 Next Steps (Simple)

### Step 1: Start Docker Desktop (2 minutes)

1. Open **Applications** folder
2. Find **Docker.app**
3. Double-click to start (wait for whale icon in menu bar)
4. Verify: `docker ps` in Terminal (should show no error)

### Step 2: Start n8n (1 minute)

```bash
cd ~/medicine
docker-compose up -d
```

Check it's running:
```bash
docker ps | grep n8n
```

Wait ~30 seconds for n8n to fully start, then:
```bash
curl http://localhost:5678/healthz
# Should respond with: "OK"
```

### Step 3: Import Workflows (2 minutes)

1. Open: **http://localhost:5678**
2. Login: `admin` / `medicine2025secure`
3. Click **"Workflows"** → **"Import from File"**
4. Select: `~/medicine/n8n/workflows/01-content-discovery.json`
5. Click **Import**

Repeat for:
- `~/medicine/n8n/workflows/02-content-processing-OLLAMA.json` ← Use this one!

### Step 4: Test Discovery Workflow (1 minute)

1. In n8n, click: **"01 - Archive.org Content Discovery"**
2. Click **▶️ "Execute Workflow"** button (top right)
3. Wait 30-60 seconds
4. Check results:
   ```bash
   cat ~/medicine/data/discovered-books.jsonl
   ```
   Should show: German book metadata

### Step 5: Test Processing Workflow (2-3 minutes)

1. In n8n, click: **"02 - AI Content Processing & Script Generation"**
2. Click **▶️ "Execute Workflow"**
3. Wait 2-3 minutes (Ollama processing)
4. Check results:
   ```bash
   cat ~/medicine/data/scripts/script_*.json
   ```
   Should show: Complete video script with hook, content, visuals

### Step 6: Verify Services (1 minute)

```bash
# Check all services running
echo "=== Ollama ==="
curl http://localhost:11434/api/tags

echo -e "\n=== n8n ==="
curl http://localhost:5678/healthz

echo -e "\n=== ComfyUI ==="
curl http://localhost:8188/api/system/stats || echo "Check if ComfyUI is running separately"
```

---

## 🔗 Access URLs

| Service | URL |
|---------|-----|
| **n8n** | http://localhost:5678 |
| **Ollama** | http://localhost:11434 |
| **ComfyUI** | http://localhost:8188 |

---

## 📊 File Locations

```
~/medicine/
├── .env                                    # Configuration (Ollama-only)
├── n8n/
│   ├── workflows/
│   │   ├── 01-content-discovery.json      # Archive.org search
│   │   ├── 02-content-processing-OLLAMA.json  # ← Use this one!
│   │   └── (03-video-generation.json - coming soon)
├── data/
│   ├── discovered-books.jsonl             # Archive.org results
│   ├── scripts/                           # Generated video scripts
│   └── extracted-texts/                   # Downloaded texts
└── output/
    ├── videos/                            # Generated videos
    ├── thumbnails/                        # Video thumbnails
    └── metadata/                          # Video metadata
```

---

## 🧪 Testing Script (Optional)

```bash
#!/bin/bash

echo "🧪 Testing Medicine Automation Setup"
echo ""

# Test Ollama
echo "Testing Ollama..."
curl -s http://localhost:11434/api/tags | jq '.models[].name' || echo "❌ Ollama not responding"

# Test n8n
echo "Testing n8n..."
curl -s http://localhost:5678/healthz || echo "❌ n8n not responding"

# Test ComfyUI
echo "Testing ComfyUI..."
curl -s http://localhost:8188/api/system/stats | jq '.system' || echo "⚠️ ComfyUI not responding (should be running separately)"

echo ""
echo "✅ All checks complete!"
```

---

## 🛑 Stopping Services

```bash
# Stop Docker containers
docker-compose down

# Stop Ollama
brew services stop ollama

# Or kill specific ports
lsof -i :5678  # n8n
lsof -i :11434 # Ollama
lsof -i :8188  # ComfyUI
```

---

## 🚨 Troubleshooting

### Docker daemon not running
```bash
# Start Docker Desktop from Applications folder
# Or verify:
docker ps
# Should NOT say "Cannot connect to Docker daemon"
```

### Ollama not responding
```bash
# Check if service is running
brew services list | grep ollama

# Restart Ollama
brew services stop ollama && brew services start ollama

# Or run directly
ollama serve
```

### n8n container won't start
```bash
# Check logs
docker logs n8n_medicine

# Remove and restart
docker-compose down
docker-compose up -d
```

### Scripts not generating
```bash
# Check n8n execution logs:
# 1. Open http://localhost:5678
# 2. Click the workflow
# 3. Check "Executions" tab for error messages

# Common issues:
# - Ollama not running
# - Port 11434 in use (Ollama on wrong port)
# - Text download failed (Archive.org unreachable)
```

---

## 📈 What Happens After Step 6

**Fully Automated (after testing):**
1. Enable automatic scheduling in `.env`:
   ```
   AUTO_PROCESS=true
   CRON_SCHEDULE=0 9 * * *  # 9 AM daily
   ```

2. Workflow runs automatically each day:
   - 9 AM: Discovery (find German medical book)
   - Automatically: Processing (extract facts, generate script)
   - Manually: Video generation (ComfyUI)

**Output:**
- Scripts saved: `~/medicine/data/scripts/`
- Videos saved: `~/medicine/output/videos/`
- Ready for TikTok/Instagram/Twitter posting

---

## ✨ Architecture

```
DISCOVERY WORKFLOW (01)
├─ Archive.org API
└─ Find German medical book
   └─ Webhook → PROCESSING WORKFLOW

PROCESSING WORKFLOW (02 - OLLAMA)
├─ Download book text
├─ Extract facts (Ollama)
├─ Generate script (Ollama)
├─ Generate visual prompt (Ollama)
└─ Webhook → VIDEO GENERATION (ComfyUI)

VIDEO GENERATION (ComfyUI)
├─ Text to Speech (Coqui)
├─ Video generation (ComfyUI)
├─ Background music (Mubert)
└─ Export to ~/medicine/output/
```

---

## 🎯 Key Features

- ✅ **100% Local AI**: Ollama (no API keys needed!)
- ✅ **No Gemini**: Completely free alternative
- ✅ **Fast**: llama3.2:3b is lightweight & quick
- ✅ **German Support**: Good multilingual understanding
- ✅ **Archive.org Integration**: Free, unlimited German books
- ✅ **ComfyUI Ready**: Videos generated locally (when ready)

---

## 📞 Quick Help

**Port already in use?**
```bash
lsof -i :5678   # Check what's using port 5678
kill -9 <PID>   # Kill that process
```

**Want to use different Ollama model?**
Edit `~/.env`:
```bash
OLLAMA_MODEL=sroecker/sauerkrautlm-7b-hero  # Better German
# Then restart n8n
```

**Want to reset everything?**
```bash
docker-compose down
docker-compose up -d
# Workflows will need to be imported again
```

---

**You're all set! Follow the 6 steps above and you'll have a fully functional local AI pipeline running on your Mac. 🚀**

