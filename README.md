# 🌿 Ancient Medicine Content Automation Workflow

Automated n8n workflow for scraping German medical manuscripts from Archive.org and generating viral short-form videos.

## 🎯 Project Overview

This workflow automatically:
1. **Discovers** German medical/herbalism books on Archive.org
2. **Extracts** text content using OCR
3. **Analyzes** content with AI to find interesting facts
4. **Generates** viral short video scripts
5. **Creates** videos using ComfyUI with voiceover and music
6. **Exports** ready-to-post content for TikTok, Twitter, Instagram

**Target**: 1 video per day | **Budget**: Free/low-cost | **Language**: German → English/German shorts

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    WORKFLOW PIPELINE                         │
└─────────────────────────────────────────────────────────────┘

PHASE 1: Content Discovery (Daily Cron)
  ↓
  Archive.org Search API → Filter German Books → Extract Metadata
  ↓
PHASE 2: Text Extraction & Processing
  ↓
  Download PDF/Images → OCR Text Extraction → Clean Text
  ↓
PHASE 3: AI Content Analysis
  ↓
  Gemini 2.0 Flash → Extract Interesting Facts → Generate Script
  ↓
PHASE 4: Video Generation (Local ComfyUI)
  ↓
  Script → ComfyUI (LTX Video) → Coqui TTS → Add Music → Export
  ↓
PHASE 5: Output & Distribution
  ↓
  Save to /output → Manual/Auto Post to Platforms
```

---

## 💰 Cost Breakdown (Monthly Estimate)

| Service | Tier | Cost |
|---------|------|------|
| Archive.org API | Free | $0 |
| Google Gemini 2.0 Flash | Free (1M tokens/day) | $0 |
| Coqui XTTS (TTS) | Self-hosted | $0 |
| Mubert Music API | Free tier | $0 |
| ComfyUI (Local M1) | Self-hosted | $0 |
| n8n (Docker) | Self-hosted | $0 |
| **TOTAL** | | **$0/month** |

*Note: Free tiers sufficient for 1 video/day (30/month)*

---

## 🛠️ Tech Stack

### Core Services
- **n8n**: Workflow orchestration (Docker)
- **ComfyUI**: Video generation (Local M1 Mac 24GB)
- **Archive.org**: Content source
- **Gemini 2.0 Flash**: Script generation
- **Coqui XTTS-v2**: German TTS
- **Mubert API**: Background music

### ComfyUI Models (M1 Optimized)
- **LTX Video v0.9.5**: Lightweight video generation
- **FLUX.1-schnell**: Fast image generation
- **Hunyuan 1.3B**: Backup video model

---

## 📁 Project Structure

```
medicine/
├── README.md                          # This file
├── docs/
│   ├── SETUP.md                      # Detailed setup guide
│   ├── WORKFLOW_GUIDE.md             # Workflow explanation
│   └── TROUBLESHOOTING.md            # Common issues
├── n8n/
│   ├── workflows/
│   │   ├── 01-content-discovery.json # Archive.org scraping
│   │   ├── 02-content-processing.json # OCR + AI analysis
│   │   ├── 03-video-generation.json  # ComfyUI integration
│   │   └── 04-master-workflow.json   # Complete pipeline
│   └── credentials/
│       └── credentials-template.json  # API key templates
├── comfyui/
│   ├── workflows/
│   │   ├── text-to-video-ltx.json    # LTX Video workflow
│   │   ├── image-to-video.json       # Image animation
│   │   └── simple-image-gen.json     # FLUX image generation
│   └── models/
│       └── MODELS.md                 # Model download links
├── scripts/
│   ├── setup.sh                      # Initial setup script
│   ├── install-dependencies.sh       # Install all dependencies
│   ├── test-comfyui.py              # Test ComfyUI connection
│   └── test-apis.py                 # Test API connections
├── config/
│   ├── .env.example                 # Environment variables template
│   ├── archive-search-terms.json    # German medical search terms
│   └── video-config.json            # Video generation settings
├── data/
│   ├── manuscripts/                 # Downloaded books (temp)
│   ├── extracted-texts/             # OCR results (temp)
│   ├── scripts/                     # Generated video scripts
│   └── facts-database.json          # Interesting facts cache
└── output/
    ├── videos/                      # Final videos
    ├── thumbnails/                  # Video thumbnails
    └── metadata/                    # Video descriptions/tags
```

---

## 🚀 Quick Start

### Prerequisites
- **Mac M1/M2/M3** with 24GB+ RAM
- **Docker Desktop** installed
- **ComfyUI** installed on Mac
- **Python 3.10+** and **Git**

### Installation

```bash
# 1. Clone repository (already done)
cd /home/user/medicine

# 2. Run setup script
chmod +x scripts/setup.sh
./scripts/setup.sh

# 3. Configure environment variables
cp config/.env.example .env
# Edit .env with your API keys

# 4. Install ComfyUI models
cd comfyui/models
# Follow MODELS.md for download instructions

# 5. Start n8n
docker-compose up -d

# 6. Import workflows
# Open http://localhost:5678
# Import workflows from n8n/workflows/

# 7. Test connections
python scripts/test-apis.py
python scripts/test-comfyui.py

# 8. Run first workflow
# Trigger "01-content-discovery" workflow in n8n
```

---

## 📖 Workflow Details

### Phase 1: Content Discovery
- **Trigger**: Daily cron (9 AM)
- **Search Terms**: German keywords (Heilkunde, Kräuterkunde, Schamanismus, etc.)
- **Filters**: Language=German, Format=PDF, Subject=Medicine
- **Output**: List of book IDs with metadata

### Phase 2: Content Processing
- **Input**: Archive.org book ID
- **OCR**: Extract text from PDFs using Archive.org API
- **Cleaning**: Remove artifacts, fix formatting
- **Output**: Clean text chunks (500-1000 words)

### Phase 3: AI Analysis & Scripting
- **LLM**: Gemini 2.0 Flash (free tier)
- **Task 1**: Extract 3-5 interesting facts per text chunk
- **Task 2**: Generate viral script (50-60 seconds, 140-160 words)
- **Hook Styles**: Entertainment/storytelling angle
- **Output**: Ready-to-narrate script + video prompt

### Phase 4: Video Generation
- **ComfyUI Workflow**: LTX Video (text-to-video)
- **TTS**: Coqui XTTS-v2 (German or English voice)
- **Music**: Mubert API (ambient/ASMR style)
- **Format**: 1080x1920 (vertical), 24fps, 30-60 seconds
- **Output**: MP4 video file

### Phase 5: Export & Distribution
- **Metadata**: Auto-generate title, description, hashtags
- **Thumbnail**: Extract frame or generate custom
- **Platforms**: Save to /output for manual posting

---

## 🎨 Video Style Guidelines

- **Visual**: Elegant, harmonic, ASMR-friendly
- **Aesthetic**: Ancient/mystical but modern
- **Colors**: Earth tones, warm palettes
- **Pacing**: Calm, not rushed
- **Text**: Minimal, key facts only
- **Voiceover**: Clear, storytelling tone

---

## 🔑 Required API Keys

1. **Google Gemini API** (FREE tier)
   - Get at: https://aistudio.google.com/
   - Limit: 1M tokens/day, 15 requests/min

2. **Mubert API** (FREE tier)
   - Get at: https://mubert.com/
   - Limit: Varies, check current limits

3. **ComfyUI Local** (No API key needed)
   - Runs on your M1 Mac

---

## 🎯 Daily Workflow Execution

**Automated Mode:**
```
9:00 AM  → Search Archive.org for new books
9:15 AM  → Extract text from 1 selected book
9:30 AM  → AI analyzes and generates script
10:00 AM → ComfyUI generates video (2-4 hours)
2:00 PM  → Video ready in /output
```

**Manual Review:**
- Check video quality
- Verify facts if needed
- Add custom edits (optional)
- Post to platforms

---

## 📊 Performance Expectations

### M1 Mac 24GB Performance
- **Image generation**: 10-30 seconds (FLUX.1-schnell)
- **Video generation**: 2-4 hours (LTX Video, 30-60 sec video)
- **TTS generation**: 5-10 seconds
- **Total pipeline**: 2-5 hours per video

### Quality Targets
- **Script quality**: High (Gemini 2.0 Flash is excellent)
- **Video quality**: Medium-High (limited by M1, but acceptable)
- **TTS quality**: High (Coqui XTTS is very good)
- **Overall**: Professional enough for social media

---

## 🛡️ Content Safety

- **Attribution**: Auto-added to video descriptions
- **Disclaimers**: "Historical information, not medical advice"
- **Fact-checking**: Minimal (entertainment focus)
- **Cultural sensitivity**: Respectful framing
- **Platform compliance**: Avoid health misinformation claims

---

## 📈 Future Enhancements

- [ ] A/B testing (multiple versions per script)
- [ ] Engagement tracking integration
- [ ] Auto-posting to platforms
- [ ] Multi-language support (English scripts from German sources)
- [ ] Feedback loop (optimize based on performance)
- [ ] Larger model support (when budget allows)

---

## 🐛 Troubleshooting

See [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for common issues.

**Quick Fixes:**
- ComfyUI not responding: Check if server is running on http://localhost:8188
- n8n workflow fails: Check logs in Docker
- Gemini API errors: Verify API key and rate limits
- TTS errors: Ensure Coqui XTTS is properly installed

---

## 📚 Resources

- [n8n Documentation](https://docs.n8n.io)
- [ComfyUI Wiki](https://comfyui-wiki.com)
- [Archive.org API Docs](https://archive.org/developers)
- [Gemini API Docs](https://ai.google.dev/docs)
- [Coqui XTTS GitHub](https://github.com/coqui-ai/TTS)

---

## 📄 License

This project is for educational and creative purposes. Respect Archive.org's terms of service and copyright laws.

---

## 🤝 Contributing

This is a personal automation project. Feel free to fork and adapt for your needs.

---

**Built with ❤️ for preserving ancient wisdom through modern technology**
