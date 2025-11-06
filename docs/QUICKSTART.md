# ⚡ Quick Start Guide

Get your Ancient Medicine automation running in under 30 minutes!

---

## 🎯 What You'll Achieve

By the end of this guide, you'll have:
- ✅ n8n workflow automation running
- ✅ Archive.org content discovery working
- ✅ AI script generation with Gemini (free tier)
- ✅ Your first automated video pipeline

---

## 📦 Prerequisites (5 minutes)

You need:
1. **Mac M1/M2/M3** with 24GB RAM
2. **Docker Desktop** installed ([download](https://www.docker.com/products/docker-desktop))
3. **Gemini API key** (free) from [Google AI Studio](https://aistudio.google.com/)

That's it! Everything else is optional for the MVP.

---

## 🚀 Installation (10 minutes)

### Step 1: Configure Environment

```bash
cd /home/user/medicine

# Copy environment template
cp config/.env.example .env

# Edit and add your Gemini API key
nano .env
# Set: GEMINI_API_KEY=your_actual_key_here
# Save and exit (Ctrl+X, Y, Enter)
```

### Step 2: Start n8n

```bash
# Make setup script executable
chmod +x scripts/setup.sh

# Run setup
./scripts/setup.sh

# Start n8n with Docker
docker-compose up -d

# Check it's running
docker ps
# Should see: n8n_medicine container running

# View logs (optional)
docker logs -f n8n_medicine
```

### Step 3: Access n8n

1. Open browser: http://localhost:5678
2. Login with:
   - Username: `admin`
   - Password: `changeme123` (change this later!)

### Step 4: Import Workflows

In n8n web interface:

1. Click **"Workflows"** in left sidebar
2. Click **"Import"** button (top right)
3. Select file: `n8n/workflows/01-content-discovery.json`
4. Click **"Import"**
5. Repeat for: `02-content-processing.json`

---

## 🧪 Test Your First Run (5 minutes)

### Test Workflow 1: Content Discovery

1. In n8n, open workflow: **"01 - Archive.org Content Discovery"**
2. Click **"Execute Workflow"** button (play icon, top right)
3. Watch nodes turn green as they execute (takes 30-60 seconds)
4. Check output:

```bash
# Should see discovered book
cat data/discovered-books.jsonl
```

**Expected**: JSON line with German book metadata from Archive.org

### Test Workflow 2: Content Processing

1. Open workflow: **"02 - AI Content Processing & Script Generation"**
2. This workflow is triggered by Workflow 1 automatically
3. Or manually trigger by clicking **"Execute Workflow"**
4. Wait 1-2 minutes for AI processing
5. Check output:

```bash
# Should see generated script
ls data/scripts/
cat data/scripts/*.json
```

**Expected**: JSON file with video script, hooks, and visual prompts

---

## ✅ You're Done with MVP!

**Congratulations!** 🎉 You now have:
- Automated German book discovery from Archive.org
- AI-powered fact extraction
- Viral video script generation
- All running for FREE

---

## 🎬 Next Steps (Optional)

Want to complete the video generation? Follow these additional setup steps:

### A. Install ComfyUI (30 minutes)

ComfyUI generates the actual videos. This is optional - you can start by just generating scripts.

```bash
# Clone ComfyUI
cd ~/Applications
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI

# Install
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Download models (requires ~10GB disk space)
# See: docs/SETUP.md for model download links

# Start ComfyUI
python main.py
# Open: http://localhost:8188
```

### B. Install TTS for Voiceovers (15 minutes)

```bash
# Install Coqui TTS
pip install TTS

# Test German voice
tts --text "Hallo Welt" --model_name "tts_models/de/thorsten/tacotron2-DDC" --out_path test.wav
```

### C. Schedule Daily Automation

```bash
# Edit .env
nano .env

# Set:
AUTO_PROCESS=true

# Restart n8n
docker-compose restart
```

Now it runs daily at 9 AM automatically! ⏰

---

## 📊 Understanding the Workflow

Here's what happens when you run it:

```
1. Archive.org Search
   └─> Finds German medical books matching keywords
   └─> Ranks by quality (downloads, text availability)
   └─> Selects best book for today

2. Text Extraction
   └─> Downloads OCR text from Archive.org
   └─> Cleans and chunks into processable segments
   └─> Prepares for AI analysis

3. AI Fact Extraction (Gemini)
   └─> Analyzes German text
   └─> Extracts 3-5 interesting facts
   └─> Identifies viral angles
   └─> Tags with keywords

4. Script Generation (Gemini)
   └─> Selects best fact
   └─> Writes 50-second viral script
   └─> Creates hook, story arc, reveal
   └─> Generates visual prompts

5. (Optional) Video Generation (ComfyUI)
   └─> Creates visuals from prompts
   └─> Adds voiceover (TTS)
   └─> Adds background music
   └─> Exports final MP4
```

---

## 🎯 Daily Workflow (Once Fully Set Up)

**Automated Mode:**
- 9:00 AM: Workflow starts automatically
- 1:00 PM: Video ready in `/output/videos/`
- Review and post to platforms manually

**Your Work:**
- Check video quality (2 minutes)
- Post to TikTok/Twitter/Instagram (5 minutes)
- Total time: ~7 minutes per day

---

## 💡 Tips for Success

### Content Quality
- First 3-5 videos: Review scripts carefully
- Adjust prompts in Workflow 2 if needed
- Save best-performing script styles

### Cost Management
- Gemini free tier: 1,500 requests/day (plenty!)
- Archive.org: Completely free
- ComfyUI: Free (runs locally)
- Total cost: **$0/month** for 30 videos

### Optimization
- Start with 1 video/day
- Test different hook styles
- Track which content performs best
- Iterate on successful patterns

---

## 🐛 Common Issues

### "Gemini API key invalid"
```bash
# Check your .env file
cat .env | grep GEMINI

# Test API key
curl "https://generativelanguage.googleapis.com/v1beta/models?key=YOUR_KEY"
```

### "n8n workflow fails"
```bash
# Check logs
docker logs n8n_medicine

# Restart n8n
docker-compose restart
```

### "No books found"
- Archive.org might be slow - try again
- Check your internet connection
- Try different search terms in `config/archive-search-terms.json`

---

## 📚 Learn More

- **Full Setup Guide**: [docs/SETUP.md](SETUP.md)
- **Troubleshooting**: [docs/TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **n8n Documentation**: https://docs.n8n.io
- **Gemini API Docs**: https://ai.google.dev/docs

---

## 🎉 What's Next?

You're now generating automated content! Here's your growth path:

**Week 1: Learn & Iterate**
- Generate 5-7 videos manually
- Find your best content style
- Learn what resonates with audience

**Week 2: Optimize**
- Enable full automation
- Set up ComfyUI for video generation
- Add voiceovers

**Week 3: Scale**
- Track performance metrics
- Create multiple variations (A/B test)
- Optimize for viral success

**Month 2+: Grow**
- Build audience across platforms
- Monetize (ad revenue, sponsors)
- Expand to related niches

---

**Ready to create your first viral video about ancient medicine?** 🌿✨

Let's go! Run that first workflow now! 🚀
