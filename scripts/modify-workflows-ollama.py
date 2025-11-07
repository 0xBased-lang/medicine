#!/usr/bin/env python3
"""
Modify n8n workflows to use Ollama instead of Gemini API
"""

import json
import sys
from pathlib import Path

def modify_processing_workflow(input_file, output_file):
    """
    Replace Gemini API calls with Ollama API calls in the processing workflow
    """

    with open(input_file, 'r') as f:
        workflow = json.load(f)

    # Find and modify the "Extract Facts with Gemini" node
    for node in workflow['nodes']:
        if node['id'] == 'extract-facts':
            node['name'] = 'Extract Facts with Ollama'
            node['parameters']['method'] = 'POST'
            node['parameters']['url'] = 'http://localhost:11434/api/generate'
            node['parameters']['authentication'] = 'none'

            # Ollama request format
            prompt = """You are an expert in ancient medicine, herbalism, and healing practices. Analyze the following German historical text and extract the 3-5 most interesting, surprising, or educational facts about healing, medicine, plants, or rituals.

For each fact, provide:
1. The main fact (1-2 sentences)
2. Why it's interesting (1 sentence)
3. A potential viral hook angle (1 sentence)
4. Relevant keywords

Text to analyze:

{{ $json.text_content }}

Return your response in JSON format with this structure:
{
  "facts": [
    {
      "fact": "...",
      "why_interesting": "...",
      "viral_angle": "...",
      "keywords": ["..."]
    }
  ]
}"""

            node['parameters']['bodyParametersJson'] = f"""={{{{
  "model": "llama3.2:3b",
  "prompt": {json.dumps(prompt)},
  "stream": false,
  "temperature": 0.7
}}}}"""

        # Modify the "Parse Facts" node to handle Ollama response
        elif node['id'] == 'parse-facts':
            node['parameters']['jsCode'] = """// Parse Ollama response and extract facts
const response = $input.item.json;
const textContent = response.response || '{"facts": []}';

let factsData;
try {
  factsData = JSON.parse(textContent);
} catch (e) {
  // Try to extract JSON from the response text
  const jsonMatch = textContent.match(/\\{[\\s\\S]*\\}/);
  if (jsonMatch) {
    try {
      factsData = JSON.parse(jsonMatch[0]);
    } catch (e2) {
      factsData = { facts: [] };
    }
  } else {
    factsData = { facts: [] };
  }
}

const facts = factsData.facts || [];

return facts.map((fact, index) => ({
  json: {
    fact_id: `${$node['Clean & Chunk Text'].json.book_info.identifier}_chunk${$node['Clean & Chunk Text'].json.chunk_index}_fact${index}`,
    fact: fact.fact,
    why_interesting: fact.why_interesting,
    viral_angle: fact.viral_angle,
    keywords: fact.keywords || [],
    source_book: $node['Clean & Chunk Text'].json.book_info,
    chunk_index: $node['Clean & Chunk Text'].json.chunk_index,
    extracted_timestamp: new Date().toISOString()
  }
}));"""

        # Find and modify "Generate Script with Gemini" node
        elif node['id'] == 'generate-script':
            node['name'] = 'Generate Script with Ollama'
            node['parameters']['method'] = 'POST'
            node['parameters']['url'] = 'http://localhost:11434/api/generate'
            node['parameters']['authentication'] = 'none'

            script_prompt = """You are a viral short-form video scriptwriter specializing in historical and educational content. Create an engaging 50-second video script (approximately 150 words) based on this fact about ancient medicine/healing:

FACT: {{ $json.selected_fact.fact }}

VIRAL ANGLE: {{ $json.selected_fact.viral_angle }}

Script Requirements:
1. START with a powerful hook (first 3 seconds) that stops scrolling
2. Use storytelling narrative style
3. Include a surprising reveal or "but here's the twist" moment
4. Make it educational but entertaining
5. End with a thought-provoking question or statement
6. Write in a conversational, engaging tone
7. Keep it exactly 140-160 words for 50-second duration
8. Target language: {{ $env.OUTPUT_LANGUAGE || 'de' }}

Return JSON format:
{
  "hook": "First 10 words",
  "full_script": "Complete 150-word script",
  "word_count": 150,
  "key_visual_moments": ["moment1", "moment2"],
  "emotional_tone": "mysterious/fascinating/shocking/etc",
  "suggested_hashtags": ["hashtag1", "hashtag2"]
}"""

            node['parameters']['bodyParametersJson'] = f"""={{{{
  "model": "llama3.2:3b",
  "prompt": {json.dumps(script_prompt)},
  "stream": false,
  "temperature": 0.8
}}}}"""

        # Modify the "Parse Script" node to handle Ollama response
        elif node['id'] == 'parse-script':
            node['parameters']['jsCode'] = """// Parse Ollama script response
const response = $input.item.json;
const textContent = response.response || '{}';

let scriptData;
try {
  scriptData = JSON.parse(textContent);
} catch (e) {
  // Try to extract JSON from the response text
  const jsonMatch = textContent.match(/\\{[\\s\\S]*\\}/);
  if (jsonMatch) {
    try {
      scriptData = JSON.parse(jsonMatch[0]);
    } catch (e2) {
      throw new Error('Failed to parse script JSON from Ollama');
    }
  } else {
    throw new Error('Failed to parse script JSON from Ollama');
  }
}

const fact = $node['Select Best Fact'].json.selected_fact;

return {
  json: {
    script_id: `script_${Date.now()}`,
    fact_id: fact.fact_id,
    hook: scriptData.hook,
    full_script: scriptData.full_script,
    word_count: scriptData.word_count,
    estimated_duration: Math.round((scriptData.word_count / 3) * 1000),
    key_visual_moments: scriptData.key_visual_moments || [],
    emotional_tone: scriptData.emotional_tone || 'mysterious',
    suggested_hashtags: scriptData.suggested_hashtags || [],
    source_fact: fact.fact,
    source_book: fact.source_book,
    created_timestamp: new Date().toISOString(),
    status: 'ready_for_video_generation'
  }
};"""

        # Find and modify "Generate Visual Prompt" node
        elif node['id'] == 'generate-visual':
            node['name'] = 'Generate Visual Prompt with Ollama'
            node['parameters']['method'] = 'POST'
            node['parameters']['url'] = 'http://localhost:11434/api/generate'
            node['parameters']['authentication'] = 'none'

            visual_prompt = """Based on this video script about ancient medicine, create a detailed visual prompt for AI video generation. The visual should be elegant, harmonic, ASMR-friendly with ancient/mystical atmosphere.

SCRIPT: {{ $json.full_script }}

KEY MOMENTS: {{ JSON.stringify($json.key_visual_moments) }}

TONE: {{ $json.emotional_tone }}

Create a prompt for ComfyUI video generation that:
1. Describes the overall aesthetic (earth tones, warm, mystical)
2. Specifies visual elements (ancient texts, herbs, nature, sacred geometry)
3. Describes camera movement (slow zoom, gentle pan)
4. Sets the mood (calming, mysterious, ancient wisdom)
5. Keeps it under 200 words

Return JSON:
{
  "video_prompt": "Detailed visual description",
  "style_keywords": ["keyword1", "keyword2"],
  "color_palette": ["color1", "color2"],
  "camera_movements": "movement description"
}"""

            node['parameters']['bodyParametersJson'] = f"""={{{{
  "model": "llama3.2:3b",
  "prompt": {json.dumps(visual_prompt)},
  "stream": false,
  "temperature": 0.7
}}}}"""

    # Save modified workflow
    with open(output_file, 'w') as f:
        json.dump(workflow, f, indent=2)

    print(f"✅ Modified workflow saved to {output_file}")

if __name__ == '__main__':
    input_file = Path('/Users/seman/medicine/n8n/workflows/02-content-processing.json')
    output_file = Path('/Users/seman/medicine/n8n/workflows/02-content-processing-OLLAMA.json')

    if not input_file.exists():
        print(f"❌ Input file not found: {input_file}")
        sys.exit(1)

    try:
        modify_processing_workflow(input_file, output_file)
        print(f"✅ Workflow modification complete!")
        print(f"📝 New workflow: {output_file}")
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)
