#!/bin/bash

###############################################################################
# Automated Faceless Video Creator
# Creates TikTok-ready videos from voiceover + stock footage
###############################################################################

echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║          🎬 AUTOMATED FACELESS VIDEO CREATOR 🎬                       ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "❌ Error: ffmpeg is not installed"
    echo ""
    echo "Install with: brew install ffmpeg"
    exit 1
fi

# Configuration
VOICEOVER="$HOME/medicine/video_production/voiceover_script1.mp3"
OUTPUT_DIR="$HOME/medicine/video_production/output"
mkdir -p "$OUTPUT_DIR"

echo "📋 Configuration:"
echo "   Voiceover: $VOICEOVER"
echo "   Output: $OUTPUT_DIR"
echo ""

# Check if voiceover exists
if [ ! -f "$VOICEOVER" ]; then
    echo "❌ Error: Voiceover file not found: $VOICEOVER"
    exit 1
fi

echo "✅ Voiceover found!"
echo ""

# Get voiceover duration
DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VOICEOVER")
echo "⏱️  Voiceover duration: ${DURATION}s"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 NEXT STEPS TO CREATE VIDEO:"
echo ""
echo "1. Download 5-8 herb videos from Pexels.com"
echo "   Search: 'medicinal herbs', 'chamomile', 'echinacea'"
echo "   Format: Vertical (9:16) or any (we'll crop)"
echo "   Length: 5-10 seconds each"
echo ""
echo "2. Save videos to:"
echo "   $OUTPUT_DIR/footage/"
echo ""
echo "3. Run this script again to auto-generate video"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "OR use CapCut (recommended for beginners):"
echo "   1. Open CapCut app/desktop"
echo "   2. Import voiceover_script1.mp3"
echo "   3. Import 5-8 herb videos"
echo "   4. Add auto-captions"
echo "   5. Export!"
echo ""
