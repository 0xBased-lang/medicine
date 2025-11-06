# ✅ Complete Setup Checklist - Start Here!

Follow these steps **on your M1 Mac** to get everything running.

---

## 📋 **Step-by-Step Setup (30 minutes total)**

### ☑️ **Step 1: Clone the Repository (2 minutes)**

```bash
# Open Terminal on your Mac and run:
cd ~
git clone http://local_proxy@127.0.0.1:39685/git/0xBased-lang/medicine
cd medicine
git checkout claude/n8n-automation-setup-011CUsB6egMWc4rNMA8pZTdF
```

**Check it worked:**
```bash
ls -la
# Should see: README.md, docker-compose.yml, scripts/, etc.
```

---

### ☑️ **Step 2: Install Ollama (5 minutes)**

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Download AI model (2GB download)
ollama pull llama3.2:3b

# Test it works (should respond in German)
ollama run llama3.2:3b "Sage Hallo auf Deutsch"
```

**Expected output:** German greeting!

**Verify Ollama API:**
```bash
curl http://localhost:11434/api/tags
```

**Should see:** JSON with "llama3.2:3b" listed

---

### ☑️ **Step 3: Install Docker Desktop (if not installed)**

**Download:** https://www.docker.com/products/docker-desktop

1. Download Docker Desktop for Mac (Apple Silicon)
2. Install and open Docker Desktop
3. Wait for Docker to start (whale icon in menu bar)

**Verify Docker works:**
```bash
docker --version
docker-compose --version
```

---

### ☑️ **Step 4: Start n8n (2 minutes)**

```bash
cd ~/medicine

# Start n8n container
docker-compose up -d

# Check it's running
docker ps
# Should see: n8n_medicine container

# View logs (optional)
docker logs -f n8n_medicine
# Press Ctrl+C to exit logs
```

**Access n8n:**
- Open browser: http://localhost:5678
- Login: `admin` / `medicine2025secure`

---

### ☑️ **Step 5: Import n8n Workflows (3 minutes)**

In n8n web interface (http://localhost:5678):

1. Click **"Workflows"** in left sidebar
2. Click **"Import from File"** button (top right)
3. Navigate to: `~/medicine/n8n/workflows/`
4. Select and import: **`01-content-discovery.json`**
5. Repeat to import: **`02-content-processing.json`**

**You should now see 2 workflows:**
- ✅ 01 - Archive.org Content Discovery
- ✅ 02 - AI Content Processing & Script Generation

---

### ☑️ **Step 6: Run Your First Workflow (2 minutes)**

1. Open workflow: **"01 - Archive.org Content Discovery"**
2. Click **"Execute Workflow"** button (play icon, top right)
3. Watch nodes turn green (takes 30-60 seconds)
4. Wait for completion

**Check the output:**
```bash
# In Terminal, check discovered book
cat ~/medicine/data/discovered-books.jsonl
```

**You should see:** JSON with German book metadata from Archive.org! 🎉

---

### ☑️ **Step 7: Generate Your First Script (3 minutes)**

**Workflow 2 should trigger automatically, but you can also run it manually:**

1. In n8n, open: **"02 - AI Content Processing & Script Generation"**
2. Click **"Execute Workflow"**
3. Wait 2-3 minutes (Ollama is processing on your Mac)
4. Watch the magic happen! ✨

**Check the output:**
```bash
# See generated script
ls ~/medicine/data/scripts/
cat ~/medicine/data/scripts/script_*.json
```

**You should see:**
- ✅ Full 50-second video script
- ✅ Viral hook
- ✅ Extracted facts
- ✅ Visual prompts

---

## 🎉 **SUCCESS! You're Now Generating Content!**

If you got here, you now have:
- ✅ Ollama running locally (free AI)
- ✅ n8n automating workflows
- ✅ Archive.org content discovery working
- ✅ AI script generation working
- ✅ Complete viral video scripts

**Cost so far: $0** 🚀

---

## 🔍 **Quick Health Check**

Run these commands to verify everything:

```bash
# 1. Check Ollama
curl http://localhost:11434/api/tags

# 2. Check n8n
docker ps | grep n8n

# 3. Check workflows created files
ls -la ~/medicine/data/discovered-books.jsonl
ls -la ~/medicine/data/scripts/

# 4. Check Ollama model
ollama list
```

**All working?** You're ready! ✅

---

## 📊 **What You Have Now**

```
Your Mac:
├── Ollama (AI) → http://localhost:11434
├── n8n (Automation) → http://localhost:5678
└── Medicine Project → ~/medicine/

Automated Pipeline:
Archive.org → Text Extraction → Ollama AI → Script Generation → Output
```

---

## 🚀 **Next Steps**

### **Today:**
- ✅ Generate 2-3 more scripts manually
- ✅ Review the quality
- ✅ Get familiar with n8n interface

### **This Week:**
- Set up ComfyUI for video generation (optional)
- Install TTS for German voiceovers (optional)
- Create your first complete video

### **Next Week:**
- Enable daily automation (9 AM)
- Start posting to TikTok/Twitter
- Track engagement

---

## 🐛 **Troubleshooting**

### **"Ollama not found"**
```bash
# Restart terminal or install manually:
brew install ollama
```

### **"Docker not running"**
- Open Docker Desktop app
- Wait for it to start (whale icon turns normal)

### **"n8n workflow fails"**
```bash
# Check n8n logs
docker logs n8n_medicine

# Restart n8n
docker-compose restart
```

### **"Ollama model not responding"**
```bash
# Check Ollama is running
ps aux | grep ollama

# Test Ollama directly
ollama run llama3.2:3b "test"
```

### **"Can't import workflows"**
- Make sure you're in the right directory: `cd ~/medicine`
- Check files exist: `ls n8n/workflows/`
- Try copying files to Desktop and importing from there

---

## 📁 **Important File Locations**

```
~/medicine/                           # Main project folder
├── .env                             # Your configuration (AI_PROVIDER=ollama)
├── docker-compose.yml               # n8n setup
├── n8n/workflows/                   # Workflows to import
│   ├── 01-content-discovery.json
│   └── 02-content-processing.json
├── data/
│   ├── discovered-books.jsonl      # Books found
│   └── scripts/                     # Generated scripts
├── output/
│   └── videos/                      # Final videos (later)
└── docs/                            # Documentation
```

---

## 💡 **Quick Commands Reference**

```bash
# Start everything
cd ~/medicine
docker-compose up -d

# Stop everything
docker-compose down

# Restart n8n
docker-compose restart

# View n8n logs
docker logs -f n8n_medicine

# Test Ollama
ollama run llama3.2:3b "test prompt"

# List Ollama models
ollama list

# Check what's running
docker ps
ps aux | grep ollama
```

---

## 🎯 **Current Status Checklist**

Mark these as you complete them:

- [ ] Cloned repository to `~/medicine`
- [ ] Ollama installed and running
- [ ] AI model downloaded (llama3.2:3b)
- [ ] Docker Desktop installed
- [ ] n8n container running
- [ ] Accessed n8n at http://localhost:5678
- [ ] Imported both workflows
- [ ] Ran workflow #1 successfully
- [ ] Generated first script with workflow #2
- [ ] Verified output files exist

**All checked?** You're done! 🎉

---

## 🆘 **Need Help?**

If you get stuck:

1. **Check logs:**
   ```bash
   docker logs n8n_medicine
   ```

2. **Restart everything:**
   ```bash
   docker-compose down
   docker-compose up -d
   ```

3. **Test Ollama separately:**
   ```bash
   ollama run llama3.2:3b "Hallo"
   ```

4. **Check the documentation:**
   - `INSTALL-ON-MAC.md` - Ollama details
   - `GETTING-STARTED-FREE.md` - Complete guide
   - `docs/FREE-AI-ALTERNATIVES.md` - Other options

---

## 🎉 **Ready to Start?**

**Open Terminal on your Mac and copy-paste:**

```bash
cd ~
git clone http://local_proxy@127.0.0.1:39685/git/0xBased-lang/medicine
cd medicine
git checkout claude/n8n-automation-setup-011CUsB6egMWc4rNMA8pZTdF
curl -fsSL https://ollama.com/install.sh | sh
ollama pull llama3.2:3b
```

Then come back here and continue with Step 4! 🚀

---

**Let's create some viral ancient medicine content!** 🌿✨
