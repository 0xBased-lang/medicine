# 🍎 Install Ollama on Your M1 Mac

## Quick Commands (Copy & Paste)

Open **Terminal** on your Mac and run these commands:

---

## Step 1: Install Ollama (1 minute)

```bash
# Download and install Ollama
curl -fsSL https://ollama.com/install.sh | sh
```

**Alternative:** Download the Mac app from https://ollama.com/download

---

## Step 2: Download AI Model (5 minutes)

```bash
# Download small, fast, multilingual model (2GB)
ollama pull llama3.2:3b
```

**Other options if you want better German:**
```bash
# Best German quality (7GB - takes longer)
ollama pull sroecker/sauerkrautlm-7b-hero

# OR multilingual with 23 languages (5GB)
ollama pull aya
```

---

## Step 3: Test It Works

```bash
# Test with German prompt
ollama run llama3.2:3b "Erstelle einen Satz über deutsche Heilkräuter"
```

**Expected:** A German sentence about medicinal herbs!

---

## Step 4: Check Ollama is Running

```bash
# Check the API is accessible
curl http://localhost:11434/api/tags
```

**Should see:** JSON with your installed models

---

## ✅ That's It!

Ollama is now running on your Mac at: **http://localhost:11434**

Your n8n workflows will automatically connect to it!

---

## Next Steps

Once Ollama is installed on your Mac:

1. **Keep Ollama running** (it auto-starts)
2. **Start n8n** (on this server):
   ```bash
   cd /home/user/medicine
   docker-compose up -d
   ```
3. **Access n8n**: http://localhost:5678
4. **Import workflows** and test!

---

## 🚀 Quick Test Commands

```bash
# Test Ollama is responding
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2:3b",
  "prompt": "Say hello in German",
  "stream": false
}'

# List all models
ollama list

# Remove a model (if needed)
ollama rm llama3.2:3b

# Update Ollama
curl -fsSL https://ollama.com/install.sh | sh
```

---

## Troubleshooting

### "ollama: command not found"
- Restart your terminal
- Or download Mac app: https://ollama.com/download

### "Error: model not found"
```bash
ollama pull llama3.2:3b
```

### "Connection refused"
- Check Ollama is running: `ps aux | grep ollama`
- Restart Ollama: Open the Ollama app

---

## 📊 Model Comparison

| Model | Size | Speed | German Quality | Best For |
|-------|------|-------|----------------|----------|
| llama3.2:3b | 2GB | ⚡⚡⚡ Fast | ⭐⭐⭐ Good | Testing |
| sauerkrautlm-7b | 7GB | ⚡⚡ Medium | ⭐⭐⭐⭐⭐ Excellent | Production |
| aya | 5GB | ⚡⚡ Medium | ⭐⭐⭐⭐ Great | Multilingual |
| llama3.1:8b | 4.7GB | ⚡⚡ Medium | ⭐⭐⭐⭐ Great | Balanced |

**Recommendation:** Start with **llama3.2:3b** for testing!

---

## 💰 Cost

**$0/month** forever! Only uses:
- ~3GB disk space per model
- ~4GB RAM while running
- Minimal CPU/GPU (M1 handles it easily)

---

**Ready?** Run the commands above on your Mac Terminal now! 🚀
