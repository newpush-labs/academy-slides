<script setup>
import { ref, computed } from 'vue'

const inputText = ref('unhappy123 playing!')
const showExplanation = ref(false)
const animationActive = ref(false)

// Reuse tokenization logic from tokens component
const prefixes = ['un', 'pre', 're', 'dis', 'anti']
const suffixes = ['ing', 'ed', 'ly', 'tion', 'able', 'ible']

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

function toggleAnimation() {
  animationActive.value = !animationActive.value
}

function toggleExplanation() {
  showExplanation.value = !showExplanation.value
}
</script>

<template>
  <div class="neural-container">
    <h3>Neural Network Token Processing</h3>
    
    <div class="input-section">
      <input 
        v-model="inputText"
        type="text"
        placeholder="Enter text to process"
        class="text-input"
      />
    </div>

    <div class="neural-visualization">
      <!-- Input Layer -->
      <div class="layer input-layer">
        <div 
          v-for="(token, index) in tokens" 
          :key="'input-' + index"
          class="token neuron"
          :class="[token.type, { 'animate': animationActive }]"
        >
          {{ token.text }}
        </div>
      </div>

      <!-- Hidden Layers -->
      <div class="connections">
        <svg width="100%" height="100%" class="connection-lines">
          <line 
            v-for="i in 4"
            :key="'line1-' + i"
            x1="0%" y1="20%" 
            x2="100%" y2="80%"
            :class="{ 'animate': animationActive }"
          />
        </svg>
      </div>

      <div class="layer hidden-layer">
        <div 
          v-for="i in 4" 
          :key="'hidden-' + i"
          class="neuron hidden-neuron"
          :class="{ 'animate': animationActive }"
        />
      </div>

      <div class="connections">
        <svg width="100%" height="100%" class="connection-lines">
          <line 
            v-for="i in 2"
            :key="'line2-' + i"
            x1="0%" y1="20%" 
            x2="100%" y2="80%"
            :class="{ 'animate': animationActive }"
          />
        </svg>
      </div>

      <!-- Output Layer -->
      <div class="layer output-layer">
        <div 
          v-for="i in 2" 
          :key="'output-' + i"
          class="neuron output-neuron"
          :class="{ 'animate': animationActive }"
        />
      </div>
    </div>

    <div class="controls">
      <button @click="toggleAnimation" class="control-btn">
        {{ animationActive ? '⏹' : '▶' }}
      </button>
      <button @click="toggleExplanation" class="explain-btn">
        {{ showExplanation ? 'Hide' : 'Show' }} Info
      </button>
    </div>

    <div v-if="showExplanation" class="explanation">
      <div class="explanation-text">
        <p><b>1.</b> Input tokens are embedded as vectors</p>
        <p><b>2.</b> Hidden layer processes relationships</p>
        <p><b>3.</b> Output layer generates predictions</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.neural-container {
  padding: 0.75rem;
  border-radius: 6px;
  background: #f8f9fa;
  width: 100%;
  max-width: 100%;
  margin: 0 auto;
  font-size: 0.9rem;
}

h3 {
  margin: 0 0 0.5rem 0;
  font-size: 1.1rem;
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

.neural-visualization {
  background: white;
  padding: 1rem;
  border-radius: 4px;
  margin: 0.5rem 0;
  height: 200px;
  display: grid;
  grid-template-columns: auto 1fr auto 1fr auto;
  align-items: center;
  gap: 0.5rem;
}

.layer {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  z-index: 1;
}

.connections {
  position: relative;
  height: 100%;
}

.connection-lines {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.connection-lines line {
  stroke: #ddd;
  stroke-width: 1;
}

.connection-lines line.animate {
  animation: pulse 1.5s infinite;
}

.token {
  padding: 0.15rem 0.3rem;
  border-radius: 3px;
  font-family: monospace;
  font-size: 0.8rem;
  text-align: center;
}

.token.animate {
  animation: glow 1.5s infinite;
}

.neuron {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: #f8f9fa;
  border: 1px solid #ddd;
}

.hidden-neuron.animate, .output-neuron.animate {
  animation: process 1.5s infinite;
}

.prefix { background: #ffe5cc; border: 1px solid #ffd1a3; }
.suffix { background: #fff3cd; border: 1px solid #ffeeba; }
.capitalized { background: #cce5ff; border: 1px solid #b8daff; }
.word { background: #d4edda; border: 1px solid #c3e6cb; }
.punctuation { background: #f8d7da; border: 1px solid #f5c6cb; }
.number { background: #e2d9f3; border: 1px solid #d6c8f1; }

.controls {
  display: flex;
  gap: 0.5rem;
  margin: 0.5rem 0;
}

.control-btn, .explain-btn {
  padding: 0.25rem 0.5rem;
  border: none;
  border-radius: 3px;
  cursor: pointer;
  font-size: 0.8rem;
  color: white;
}

.control-btn {
  background: #28a745;
  min-width: 2rem;
}

.explain-btn {
  background: #007bff;
}

.explanation {
  margin-top: 0.5rem;
  padding: 0.75rem;
  background: white;
  border-radius: 4px;
  border-left: 3px solid #007bff;
  font-size: 0.8rem;
}

.explanation-text {
  color: #666;
  line-height: 1.4;
}

.explanation-text p {
  margin: 0.25rem 0;
}

@keyframes glow {
  0% { transform: scale(1); box-shadow: none; }
  50% { transform: scale(1.1); box-shadow: 0 0 5px rgba(0,123,255,0.5); }
  100% { transform: scale(1); box-shadow: none; }
}

@keyframes process {
  0% { transform: scale(1); background: #f8f9fa; }
  50% { transform: scale(1.1); background: #e3f2fd; }
  100% { transform: scale(1); background: #f8f9fa; }
}

@keyframes pulse {
  0% { stroke: #ddd; stroke-width: 1; }
  50% { stroke: #007bff; stroke-width: 1.5; }
  100% { stroke: #ddd; stroke-width: 1; }
}

@media (max-width: 640px) {
  .neural-container {
    padding: 0.5rem;
  }
  
  .neural-visualization {
    height: 180px;
    padding: 0.75rem;
  }
  
  .neuron {
    width: 20px;
    height: 20px;
  }
}
</style>
