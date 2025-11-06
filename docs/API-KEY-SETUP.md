# 🔑 Gemini API Key Setup & Troubleshooting

## ⚠️ Current Issue: 403 Forbidden Error

Your API key is configured but getting a 403 error. This typically means:

1. **The Generative Language API needs to be enabled**
2. **API restrictions might be set**
3. **Billing might need to be enabled (even for free tier)**

---

## ✅ Fix: Enable Gemini API Properly

### Step 1: Go to Google AI Studio

Visit: **https://aistudio.google.com/app/apikey**

### Step 2: Check Your API Key

1. Click on your existing API key: **archive-medicine**
2. Look for any warnings or errors
3. Check if there's a message about enabling APIs

### Step 3: Enable Generative AI API

Visit: **https://console.cloud.google.com/apis/library/generativelanguage.googleapis.com**

1. Make sure you're in the correct project: **projects/164029983088**
2. Click **"Enable"** button
3. Wait for API to be enabled (takes 1-2 minutes)

### Step 4: Alternative - Create New API Key

If the above doesn't work:

1. Go to: https://aistudio.google.com/
2. Click **"Get API Key"** in top right
3. Click **"Create API Key in new project"**
4. Copy the new key
5. Update `.env` file with new key

---

## 🧪 Test Your API Key

Once you've enabled the API, test it:

```bash
cd /home/user/medicine

# Source the environment
source .env

# Test with curl
curl -X POST \
  "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}" \
  -H 'Content-Type: application/json' \
  -d '{
    "contents": [{
      "parts": [{
        "text": "Say hello in German"
      }]
    }]
  }'
```

**Expected Response:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "Hallo!"
          }
        ]
      }
    }
  ]
}
```

**If you get 403 error:**
- API is not enabled yet
- Wait a few minutes after enabling
- Try creating a new API key

---

## 🔄 Alternative: Use OpenAI or Local Models

If Gemini continues to have issues, you can use alternatives:

### Option A: OpenAI (Free Trial Credits)

1. Get API key: https://platform.openai.com/api-keys
2. Update `.env`:
   ```bash
   OPENAI_API_KEY=sk-your-key-here
   USE_OPENAI=true
   ```
3. Modify n8n workflows to use OpenAI instead

### Option B: Local Ollama (100% Free)

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Download a model
ollama pull llama3.2

# Update .env
OLLAMA_URL=http://localhost:11434
USE_OLLAMA=true
```

---

## 📝 Current Status

**Your API Key:**
- Key: `AIzaSyDY02tCcAYEEl4R88Qb2KFh6bKCQQVWiak`
- Name: `archive-medicine`
- Project: `164029983088`
- Status: ❌ Getting 403 errors (needs API enabled)

**Next Steps:**
1. ✅ Enable Generative Language API in Google Cloud Console
2. ✅ Wait 2-3 minutes for propagation
3. ✅ Test with curl command above
4. ✅ Once working, proceed with n8n workflow test

---

## 🎯 Once API Key Works

After enabling and testing:

```bash
# Start n8n if not running
docker-compose up -d

# Access n8n
open http://localhost:5678

# Import workflows and test!
```

---

## 🆘 Still Having Issues?

### Common Problems:

**Problem: 403 Forbidden**
- Solution: Enable API in Google Cloud Console (link above)
- Wait 5 minutes after enabling
- Check billing is enabled (even for free tier)

**Problem: 429 Rate Limit**
- Solution: You've hit the rate limit
- Free tier: 15 requests per minute
- Wait a minute and try again

**Problem: 400 Bad Request**
- Solution: Wrong model name
- Use: `gemini-1.5-flash` or `gemini-1.5-pro`
- Not: `gemini-2.0-flash-exp` (experimental might not be available)

---

## 📚 Useful Links

- **Google AI Studio**: https://aistudio.google.com/
- **API Documentation**: https://ai.google.dev/docs
- **Enable API**: https://console.cloud.google.com/apis/library/generativelanguage.googleapis.com
- **Pricing**: https://ai.google.dev/pricing (Free: 15 req/min, 1M tokens/day)

---

## ✅ Verification Checklist

Before proceeding:
- [ ] Generative Language API is enabled
- [ ] API key works (curl test returns valid response)
- [ ] No billing errors or warnings
- [ ] Rate limits understood (15 req/min)
- [ ] .env file has correct API key

Once all checked, you're ready to run the n8n workflows! 🚀
