# Medicine Content Automation - ComfyUI Integration Plan

## 🎯 Project Overview

**Goal**: Create a fully automated content generation pipeline that:
1. Discovers German medical books from Archive.org
2. Generates viral TikTok scripts using Ollama (local AI)
3. Creates professional videos using ComfyUI
4. Outputs ready-to-post social media content

**Status**: Phase 1 & 2 Complete ✅ | Phase 3 In Progress 🔄

---

## ✅ Completed Components

### 1. Ollama AI (Local LLM)
- **Status**: ✅ Operational
- **Model**: llama3.2:3b
- **Location**: Running locally on Mac
- **API**: http://localhost:11434
- **Usage**: Script generation (150-word viral content)

### 2. n8n Workflow Engine
- **Status**: ✅ Operational
- **Location**: Docker container
- **UI**: http://localhost:5678
- **API Key**: Configured and working
- **Workflows**: 2/3 complete

### 3. Workflow 1: Content Discovery
- **ID**: f3qvwr4K33SdOsuz
- **Status**: ✅ Tested & Working
- **Speed**: ~30 seconds
- **Function**: Search Archive.org for German medical books
- **Output**: Book metadata (title, author, URL, identifier)

### 4. Workflow 2: Script Generation
- **ID**: YpeRQjw9yRzrEVps
- **Status**: ✅ Tested & Working  
- **Speed**: ~2-3 minutes
- **Function**: Generate viral script using Ollama
- **Output**: 150-word script with hook, narrative, hashtags

---

## 🔄 In Progress

### 5. ComfyUI Setup (Phase 3)
- **Status**: 🔄 Installing dependencies
- **Location**: ~/medicine/ComfyUI_app/
- **Installation Method**: Python virtualenv
- **Progress**: 
  - ✅ Repository cloned
  - 🔄 Python dependencies installing
  - ⏳ AI models download (next)
  - ⏳ Server startup
  - ⏳ Test workflow

**Current Command**:
```bash
cd ~/medicine/ComfyUI_app && source venv/bin/activate && pip install -r requirements.txt
```

---

## 📋 Next Steps

### Step 1: Complete ComfyUI Installation (20-40 min)
1. ✅ Clone repository
2. 🔄 Install Python dependencies (2-5 min)
3. ⏳ Download AI models (10-30 min, ~5-10GB)
   - Stable Diffusion 1.5 or SDXL
   - AnimateDiff (for video)
4. ⏳ Start ComfyUI server
5. ⏳ Verify API access (http://localhost:8188)

### Step 2: Create Video Generation Workflow (15 min)
1. Open ComfyUI UI (http://localhost:8188)
2. Build workflow:
   - Text input (from n8n script)
   - Image generation (Stable Diffusion)
   - Animation (AnimateDiff)
   - Text overlays
   - Video export
3. Test with sample script
4. Export workflow JSON

### Step 3: Build n8n Workflow 3 (15 min)
1. Create new workflow in n8n
2. Add HTTP Request node → ComfyUI API
3. Connect to Workflow 2 output
4. Pass script to ComfyUI
5. Handle video generation response
6. Save output video
7. Test end-to-end

### Step 4: Integration Testing (10 min)
1. Run complete pipeline
2. Verify video quality
3. Optimize settings
4. Document configuration

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    COMPLETE PIPELINE                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Archive.org                                                     │
│      ↓ (HTTP Request)                                            │
│  n8n Workflow 1: Discovery                                       │
│      ↓ (30 sec)                                                  │
│  Book Metadata                                                   │
│      ↓                                                            │
│  n8n Workflow 2: Script Generation                               │
│      ↓ (via HTTP to Ollama)                                      │
│  Ollama (llama3.2:3b)                                            │
│      ↓ (2-3 min)                                                 │
│  150-word Viral Script                                           │
│      ↓                                                            │
│  n8n Workflow 3: Video Generation ← NEW!                         │
│      ↓ (via HTTP to ComfyUI)                                     │
│  ComfyUI (Stable Diffusion + AnimateDiff)                        │
│      ↓ (5-10 min)                                                │
│  Ready-to-Post Video (.mp4)                                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔌 API Endpoints

| Service    | Port | Endpoint                      | Status     |
|------------|------|-------------------------------|------------|
| Ollama     | 11434| http://localhost:11434        | ✅ Running |
| n8n        | 5678 | http://localhost:5678         | ✅ Running |
| ComfyUI    | 8188 | http://localhost:8188         | ⏳ Pending |

---

## 📦 Technology Stack

### AI & ML
- **Ollama**: Local LLM inference (llama3.2:3b)
- **ComfyUI**: Visual workflow for AI image/video generation
- **Stable Diffusion**: Image generation model
- **AnimateDiff**: Video animation from images

### Workflow & Automation
- **n8n**: Visual workflow automation engine
- **Docker**: Container management
- **Python**: ComfyUI runtime environment

### Content Sources
- **Archive.org**: Public domain medical book repository

---

## 💾 File Structure

```
~/medicine/
├── n8n/
│   ├── workflows/
│   │   ├── 01-content-discovery-MINIMAL.json ✅
│   │   └── 02-ai-processing-FIXED.json ✅
│   └── docker-compose.yml ✅
├── ComfyUI_app/
│   ├── models/              ← AI models (to download)
│   ├── output/              ← Generated videos
│   ├── input/               ← Input images
│   ├── workflows/           ← ComfyUI workflows
│   └── venv/                ← Python virtualenv 🔄
├── comfyui/
│   ├── models/              ← Model storage
│   └── workflows/           ← Saved workflows
└── INTEGRATION_PLAN.md      ← This file
```

---

## ⚙️ Configuration

### Ollama
- Model: llama3.2:3b
- Context window: 8K tokens
- Temperature: 0.7 (creative)
- Max tokens: 500

### n8n
- Execution mode: Regular
- Timeout: 5 minutes
- Error handling: Retry on failure
- Background execution: Enabled

### ComfyUI (To Configure)
- Output format: MP4
- Resolution: 1920x1080 or 1080x1920 (vertical)
- FPS: 30
- Duration: ~15-30 seconds

---

## 🧪 Testing Commands

### Test Individual Workflows
```bash
# Test Discovery
docker exec n8n_medicine n8n execute --id f3qvwr4K33SdOsuz

# Test Script Generation  
docker exec n8n_medicine n8n execute --id YpeRQjw9yRzrEVps

# Test Video Generation (once Workflow 3 is built)
docker exec n8n_medicine n8n execute --id [workflow-3-id]
```

### Check Service Status
```bash
# Ollama
ollama list

# n8n
curl http://localhost:5678/healthz

# ComfyUI (when running)
curl http://localhost:8188/system_stats
```

---

## 📊 Performance Metrics

| Stage              | Duration    | Resource Usage      |
|--------------------|-------------|---------------------|
| Discovery          | ~30 sec     | Low (HTTP only)     |
| Script Generation  | ~2-3 min    | Medium (LLM)        |
| Video Generation   | ~5-10 min   | High (GPU/CPU)      |
| **Total Pipeline** | **~8-14 min** | **Varies by stage** |

---

## 🎯 Success Criteria

### Workflow 1: Discovery ✅
- [x] Successfully queries Archive.org
- [x] Returns valid book metadata
- [x] Execution time < 1 minute

### Workflow 2: Script Generation ✅
- [x] Connects to Ollama API
- [x] Generates exactly 150 words
- [x] Includes hook, narrative, hashtags
- [x] Execution time < 5 minutes

### Workflow 3: Video Generation ⏳
- [ ] Connects to ComfyUI API
- [ ] Generates video from script
- [ ] Output is .mp4 format
- [ ] Vertical format (1080x1920)
- [ ] Duration 15-30 seconds
- [ ] Execution time < 15 minutes

---

## 🚀 Future Enhancements

### Phase 4: Optional Features
- [ ] TTS voiceover integration
- [ ] Background music (Mubert API)
- [ ] Automated posting to TikTok/Instagram
- [ ] A/B testing different styles
- [ ] Analytics tracking
- [ ] Batch processing multiple books

---

## 📝 Notes

### Model Requirements
ComfyUI requires specific AI models to be downloaded:
- **Stable Diffusion 1.5**: ~4GB
- **SDXL**: ~7GB (higher quality, slower)
- **AnimateDiff**: ~2-3GB
- **Total**: ~5-10GB disk space

### Resource Requirements
- **Disk**: 15-20GB free (models + outputs)
- **RAM**: 8GB minimum, 16GB recommended
- **GPU**: Optional but strongly recommended (10x faster)
- **Internet**: Fast connection for model downloads

### Known Issues
- ComfyUI CPU-only mode is slow (5-10 min per video)
- Large model downloads can take 10-30 minutes
- First video generation is slower (model loading)

---

## 🔧 Troubleshooting

### Issue: ComfyUI won't start
**Solution**: Check Python version (needs 3.10+), verify dependencies installed

### Issue: Models not downloading
**Solution**: Use ComfyUI Manager or manual download from Hugging Face

### Issue: Video generation too slow
**Solution**: Use GPU, reduce resolution, or use smaller models

### Issue: n8n can't connect to ComfyUI
**Solution**: Use `host.docker.internal:8188` instead of `localhost:8188`

---

## 📚 Resources

- [ComfyUI GitHub](https://github.com/comfyanonymous/ComfyUI)
- [n8n Documentation](https://docs.n8n.io/)
- [Ollama Documentation](https://ollama.ai/docs)
- [Archive.org API](https://archive.org/developers/)

---

**Last Updated**: 2025-11-06
**Status**: Phase 3 in progress - ComfyUI installation
**Next Action**: Complete dependency installation, download models

