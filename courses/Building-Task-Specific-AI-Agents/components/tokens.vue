<script setup>
import { ref, computed } from 'vue'

const inputText = ref('unhappy123 playing! How are you?')
const showExplanation = ref(false)

// Common prefixes and suffixes in English
const prefixes = ['un', 'pre', 're', 'dis', 'anti']
const suffixes = ['ing', 'ed', 'ly', 'tion', 'able', 'ible']

// Enhanced tokenization rules
const tokens = computed(() => {
  let result = []
  const words = inputText.value.split(/([.,!?]|\s+)/)
  
  for (let word of words) {
    if (!word.trim()) continue
    
    if (word.match(/^[.,!?]$/)) {
      result.push({ text: word, type: 'punctuation' })
      continue
    }
    
    if (word.match(/\d+/)) {
      const parts = word.split(/(\d+)/)
      for (let part of parts) {
        if (!part) continue
        if (part.match(/^\d+$/)) {
          result.push({ text: part, type: 'number' })
        } else {
          let processed = false
          
          for (let prefix of prefixes) {
            if (part.toLowerCase().startsWith(prefix) && part.length > prefix.length) {
              result.push({ text: part.slice(0, prefix.length), type: 'prefix' })
              result.push({ text: part.slice(prefix.length), type: 'word' })
              processed = true
              break
            }
          }
          
          if (!processed) {
            for (let suffix of suffixes) {
              if (part.toLowerCase().endsWith(suffix) && part.length > suffix.length) {
                result.push({ text: part.slice(0, part.length - suffix.length), type: 'word' })
                result.push({ text: part.slice(part.length - suffix.length), type: 'suffix' })
                processed = true
                break
              }
            }
          }
          
          if (!processed) {
            result.push({
              text: part,
              type: part.match(/^[A-Z]/) ? 'capitalized' : 'word'
            })
          }
        }
      }
    } else {
      let processed = false
      
      for (let prefix of prefixes) {
        if (word.toLowerCase().startsWith(prefix) && word.length > prefix.length) {
          result.push({ text: word.slice(0, prefix.length), type: 'prefix' })
          result.push({ text: word.slice(prefix.length), type: 'word' })
          processed = true
          break
        }
      }
      
      if (!processed) {
        for (let suffix of suffixes) {
          if (word.toLowerCase().endsWith(suffix) && word.length > suffix.length) {
            result.push({ text: word.slice(0, word.length - suffix.length), type: 'word' })
            result.push({ text: word.slice(word.length - suffix.length), type: 'suffix' })
            processed = true
            break
          }
        }
      }
      
      if (!processed) {
        result.push({
          text: word,
          type: word.match(/^[A-Z]/) ? 'capitalized' : 'word'
        })
      }
    }
  }
  
  return result
})

const tokenCount = computed(() => tokens.value.length)

function toggleExplanation() {
  showExplanation.value = !showExplanation.value
}
</script>

<template>
  <div class="tokens-container" :class="{ 'explanation-visible': showExplanation }">
    <h3>LLM Token Visualizer</h3>
    <p class="subtitle">See how language models break down text into meaningful pieces</p>
    
    <div class="input-section">
      <input 
        v-model="inputText"
        type="text"
        placeholder="Enter text to tokenize"
        class="text-input"
      />
    </div>

    <div class="token-display">
      <div 
        v-for="(token, index) in tokens" 
        :key="index"
        class="token"
        :class="token.type"
      >
        {{ token.text }}
      </div>
    </div>

    <div class="stats">
      <p class="token-count">Tokens: {{ tokenCount }}</p>
      <button @click="toggleExplanation" class="explain-btn">
        {{ showExplanation ? 'Hide' : 'Show' }} Info
      </button>
    </div>

    <div v-if="showExplanation" class="explanation">
      <h4>How Tokenization Works:</h4>
      <div class="token-types">
        <span class="token prefix">un-</span> prefixes
        <span class="token suffix">-ing</span> suffixes
        <span class="token capitalized">Hello</span> capitalized
        <span class="token word">word</span> words
        <span class="token punctuation">!</span> punctuation
        <span class="token number">42</span> numbers
      </div>
      <p class="explanation-text">
        LLMs break text into smaller pieces (tokens) including word parts, numbers, and punctuation.
      </p>
    </div>
  </div>
</template>

<style scoped>
.tokens-container {
  padding: 0.75rem;
  border-radius: 6px;
  background: #f8f9fa;
  width: 100%;
  max-width: 100%;
  margin: 0 auto;
  font-size: 0.9rem;
}

h3 {
  margin: 0 0 0.25rem 0;
  font-size: 1.1rem;
}

.subtitle {
  color: #6c757d;
  margin: 0 0 0.5rem 0;
  font-size: 0.8rem;
}

.input-section {
  margin: 0.5rem 0;
}

.text-input {
  width: 100%;
  padding: 0.4rem;
  font-size: 0.9rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.text-input:focus {
  border-color: #007bff;
  outline: none;
}

.token-display {
  display: flex;
  flex-wrap: wrap;
  gap: 0.3rem;
  margin: 0.5rem 0;
  padding: 0.5rem;
  background: white;
  border-radius: 4px;
  min-height: 40px;
}

.token {
  padding: 0.15rem 0.3rem;
  border-radius: 3px;
  font-family: monospace;
  font-size: 0.8rem;
  transition: transform 0.2s;
  cursor: pointer;
}

.token:hover {
  transform: scale(1.1);
}

.prefix {
  background: #ffe5cc;
  border: 1px solid #ffd1a3;
}

.suffix {
  background: #fff3cd;
  border: 1px solid #ffeeba;
}

.capitalized {
  background: #cce5ff;
  border: 1px solid #b8daff;
}

.word {
  background: #d4edda;
  border: 1px solid #c3e6cb;
}

.punctuation {
  background: #f8d7da;
  border: 1px solid #f5c6cb;
}

.number {
  background: #e2d9f3;
  border: 1px solid #d6c8f1;
}

.stats {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 0.5rem 0;
  font-size: 0.8rem;
}

.token-count {
  margin: 0;
  color: #666;
}

.explain-btn {
  padding: 0.25rem 0.5rem;
  background: #007bff;
  color: white;
  border: none;
  border-radius: 3px;
  cursor: pointer;
  font-size: 0.8rem;
}

.explain-btn:hover {
  background: #0056b3;
}

.explanation {
  margin-top: 0.5rem;
  padding: 0.75rem;
  background: white;
  border-radius: 4px;
  border-left: 3px solid #007bff;
  font-size: 0.8rem;
}

.explanation h4 {
  margin: 0 0 0.5rem 0;
  color: #343a40;
  font-size: 0.9rem;
}

.token-types {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  align-items: center;
  margin-bottom: 0.5rem;
  font-size: 0.8rem;
  color: #666;
}

.explanation-text {
  margin: 0.5rem 0 0 0;
  color: #666;
  line-height: 1.4;
}

@media (max-width: 640px) {
  .tokens-container {
    padding: 0.5rem;
  }
  
  .token-types {
    font-size: 0.75rem;
  }
}
</style>
