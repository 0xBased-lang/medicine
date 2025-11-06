# 🚀 Getting Started with FREE AI (Zero Cost Setup)

## ✅ **Best Approach: Use Ollama (100% Free)**

Since you don't have billing set up with Google, here's the **fastest, simplest, free** path:

---

## 📦 **Step 1: Install Ollama (5 minutes)**

```bash
cd /home/user/medicine

# Make setup script executable
chmod +x scripts/setup-ollama.sh

# Run the automated setup
./scripts/setup-ollama.sh
```

**What this does:**
1. ✅ Installs Ollama on your Mac
2. ✅ Downloads a German-capable AI model (your choice)
3. ✅ Tests that it works
4. ✅ Updates your `.env` file automatically

**Recommended model:** llama3.2:3b (2GB, fast, multilingual)

---

## 🧪 **Step 2: Test Ollama Works**

```bash
# Test with a German prompt
ollama run llama3.2:3b "Erstelle einen Satz über deutsche Heilkräuter"

# Should return a German sentence about medicinal herbs!
```

**Expected output:** A sentence in German about healing herbs.

---

## 🐳 **Step 3: Start n8n**

```bash
# Start n8n container
docker-compose up -d

# Check it's running
docker ps
# Should see: n8n_medicine running

# Access n8n in your browser
open http://localhost:5678

# Login:
# Username: admin
# Password: medicine2025secure
```

---

## 📥 **Step 4: Import Workflows**

In n8n web interface:

1. Click **"Workflows"** (left sidebar)
2. Click **"Import from File"** button
3. Navigate to: `/home/user/medicine/n8n/workflows/`
4. Import `01-content-discovery.json`
5. Import `02-content-processing.json`

---

## 🎯 **Step 5: Run Your First Workflow**

### Test Workflow 1: Find German Books

1. Open workflow: **"01 - Archive.org Content Discovery"**
2. Click **"Execute Workflow"** (play button, top right)
3. Watch nodes turn green as they execute
4. Takes 30-60 seconds

### Check Output:

```bash
# See discovered books
cat /home/user/medicine/data/discovered-books.jsonl

# Should show JSON with German medical book metadata!
```

---

## 🤖 **Step 6: Generate Your First Script**

### Workflow 2 triggers automatically, but you can also run manually:

1. Open workflow: **"02 - AI Content Processing"**
2. Click **"Execute Workflow"**
3. Wait 2-3 minutes (Ollama is processing)
4. Watch the magic happen! ✨

### Check Output:

```bash
# See generated script
ls /home/user/medicine/data/scripts/

# Read the script
cat /home/user/medicine/data/scripts/script_*.json
```

**You should see:**
- ✅ Full video script (50 seconds)
- ✅ Viral hook
- ✅ Key facts extracted
- ✅ Visual prompts for video

---

## 💰 **Cost Breakdown**

| Component | Cost |
|-----------|------|
| Ollama AI | $0 |
| Archive.org | $0 |
| n8n (Docker) | $0 |
| Storage (minimal) | $0 |
| **TOTAL** | **$0/month** |

---

## 📊 **What You Can Do Now**

With this setup, you can:
- ✅ Generate unlimited scripts (100% free)
- ✅ Process German medical texts
- ✅ Extract interesting facts
- ✅ Create viral video hooks
- ✅ Test your entire workflow

---

## 🎓 **Understanding the Workflow**

```
1. Archive.org Search
   └─> Finds German medical books
   └─> Ranks by quality

2. Text Extraction
   └─> Downloads OCR text
   └─> Cleans and chunks it

3. Ollama AI Analysis
   └─> Extracts 3-5 interesting facts
   └─> Scores them for viral potential
   └─> Selects best fact

4. Ollama Script Generation
   └─> Creates 50-second video script
   └─> Generates hooks
   └─> Creates visual prompts

5. Ready for Video
   └─> Script saved to data/scripts/
   └─> Visual prompts ready for ComfyUI
```

---

## 🔧 **Troubleshooting**

### "Ollama command not found"
```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh
```

### "Model not downloaded"
```bash
# Download the model
ollama pull llama3.2:3b
```

### "n8n workflow fails"
```bash
# Check n8n logs
docker logs n8n_medicine

# Restart n8n
docker-compose restart
```

### "Ollama API not responding"
```bash
# Check Ollama is running
curl http://localhost:11434/api/tags

# Should return JSON with your models
```

---

## 🚀 **Next Steps**

### This Week:
1. ✅ Run workflows 3-5 times manually
2. ✅ Review generated scripts
3. ✅ Adjust prompts if needed (in workflow 02)
4. ✅ Save your best scripts

### Next Week:
1. Install ComfyUI for video generation
2. Set up TTS for German voiceovers
3. Generate your first complete video
4. Post to TikTok/Twitter!

### Future:
1. Enable daily automation (9 AM cron)
2. Track engagement metrics
3. Iterate on successful formats
4. Scale to multiple videos per day

---

## 🌟 **Alternative: Use Groq (Still Free, Cloud-Based)**

If you want **faster processing** and **cloud-based** (still free):

### Setup Groq Instead:

```bash
# 1. Get free API key: https://console.groq.com/
# No credit card needed!

# 2. Update .env
nano /home/user/medicine/.env

# Change:
AI_PROVIDER=groq
GROQ_API_KEY=your_key_here

# 3. That's it! Same workflows, cloud AI
```

**Groq Benefits:**
- ⚡ 10x faster than Ollama
- ☁️ No local GPU usage
- 🆓 500,000 tokens/day free
- 🌍 Better for production

---

## 📝 **Daily Workflow (Once Automated)**

```
9:00 AM  - Cron triggers workflow
9:01 AM  - German book discovered
9:05 AM  - Text extracted
9:07 AM  - AI analyzes content
9:10 AM  - Script generated
9:15 AM  - Script saved to output/

YOUR WORK:
- Review script (2 min)
- (Optional) Generate video
- Post to platforms (5 min)
- Total: 7 minutes per day
```

---

## 🎉 **You're All Set!**

You now have:
- ✅ 100% free AI automation
- ✅ German content discovery
- ✅ Viral script generation
- ✅ Ready for video creation

**Cost:** $0/month forever! 🚀

---

## 📚 **Need Help?**

- **Ollama Documentation**: https://ollama.com/
- **n8n Documentation**: https://docs.n8n.io/
- **Free AI Alternatives**: See `docs/FREE-AI-ALTERNATIVES.md`
- **Detailed Setup**: See `docs/SETUP.md`

---

## 💬 **Quick Commands Reference**

```bash
# Test Ollama
ollama run llama3.2:3b "Test prompt"

# Start n8n
docker-compose up -d

# View n8n logs
docker logs -f n8n_medicine

# Check generated scripts
ls data/scripts/

# Check discovered books
cat data/discovered-books.jsonl

# Stop everything
docker-compose down
```

---

**Ready to create your first viral ancient medicine short?** 🌿✨

Run `./scripts/setup-ollama.sh` now! 🚀
