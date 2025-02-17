---
title: Building Task-Specific AI Agents
subtitle: University Course Session (90 Minutes)
theme: ../../themes/np-slides-theme
background: https://source.unsplash.com/1600x900/?technology,ai
transition: slide-left
mdc: true
layout: intro
---
# Building Task-Specific AI Agents

## From Models to Implementation 

###  Session #2


---

# Agenda

- Introduction to AI Agents
- Agent Architectures & Chain-of-Thought Reasoning
- Chain-of-Thought Prompt & Example Output
- Deep Dive into Agent Reasoning
- Example Agent Code Walkthrough
- Tools, Integration & JSON Output
- Live Demo & Interactive Exercise
- Handling Errors and Iterative Learning
- Summary, Q&A, and References

---

# What are AI Agents?

**Definition:**

An AI agent is an autonomous system that perceives its environment, reasons through data, and acts to achieve specific goals. They can be built using rule-based methods or advanced learning models.

**Key Features:**
- Autonomy in decision making
- Goal-oriented actions
- Adaptive learning from feedback

---

# AI Agent Architectures

**The Three Pillars**

<div grid="~ cols-3 gap-4">
<div>

## Perception  

- Collect data via sensors  
- Preprocess and filter inputs
</div>
<div>

## Reasoning  

- Analyze and interpret data  
- Utilize chain-of-thought to plan actions
</div>
<div>

## Action  

- Execute decisions  
- Evaluate outcomes and refine strategies
</div>
</div>

---

# Chain-of-Thought Reasoning

Chain-of-thought (CoT) is a process where an AI agent breaks down complex tasks into sequential reasoning steps, making its decision process explicit.

**Benefits:**
- Transparency in decision-making
- Easier debugging and error detection
- Iterative improvement through clear reasoning steps



---

# Chain-of-Thought Example: Process Overview

Consider an agent tasked with solving a problem. The reasoning process can be broken down as:

- Understand the problem and identify key variables.
- Decompose the problem into manageable steps.
- Solve each step sequentially.
- Verify that the final solution meets the initial goal.

---

# Example Prompt for Chain-of-Thought Reasoning

**Prompt:**  
```
Using chain-of-thought, solve the following task:  
Calculate the result of (2 + 3) × 4 - 5.  
Explain each reasoning step clearly."
```

**Agent's Step-by-Step Reasoning:**

```
1. Step 1: Calculate the sum inside the parentheses: 2 + 3 = 5  
2. Step 2: Multiply the result by 4: 5 × 4 = 20  
3. Step 3: Subtract 5 from the product: 20 - 5 = 15  

Final Answer: 15
```

---

# Introduction to ReAct

**ReAct** (Reasoning and Acting) is an advanced framework that integrates chain-of-thought reasoning with explicit action planning.  

Enables AI agents to:
- Generate reasoning steps while simultaneously deciding on actions.
- Seamlessly interleave thought processes with real-world operations.

This innovative approach represents a significant advancement over traditional AI frameworks by combining deliberate reasoning with dynamic action execution. ReAct enables agents to not only think through problems systematically but also take concrete steps toward solutions in real-time.


---

# How ReAct Works

ReAct combines two key components:
- **Reasoning**: The agent develops a chain-of-thought to analyze and understand the problem.
- **Action:** The agent performs concrete operations (like API calls or tool usage) based on its reasoning.

The typical process involves:

- **Observation:** Gather input data.
- **Reasoning:** Generate a detailed chain-of-thought to guide decision making.
- **Acting:** Execute actions informed by the reasoning.
- **Feedback:** Process results to refine future decisions.

---

# ReAct: Example Prompt and Output

**Example Prompt:**  
"Using ReAct, determine if a given number is even or odd and explain your reasoning."

**ReAct Output Example:**  
- **Reasoning:** "I observe that the number is 7. Dividing 7 by 2 gives 3 with a remainder of 1, which means the number is odd."  
- **Action:** "Return the result: 'odd'"  

This example shows how ReAct interleaves detailed reasoning with an explicit action output.

---

# Benefits and Challenges of ReAct

ReAct represents a powerful paradigm shift in AI agent development, combining the analytical power of chain-of-thought reasoning with practical action execution.

**Benefits:**
- **Transparency:** Clear visibility into both the thought process and the actions taken.
- **Dynamic Adaptation:** Allows real-time adjustments based on feedback from executed actions.
- **Enhanced Debuggability:** Makes it easier to trace and fix errors in both reasoning and execution.

**Challenges:**
- **Increased Complexity:** Requires sophisticated logic to balance reasoning and action planning.
- **Error Propagation:** Mistakes in the reasoning phase can lead to incorrect actions if not properly managed.

---

# ReAct vs. Traditional Chain-of-Thought

**Traditional Chain-of-Thought:**
- Focuses solely on internal reasoning without performing explicit actions.
- Provides a linear explanation of the thought process.

**ReAct Approach:**
- Merges reasoning with actionable outputs.
- Delivers an interactive framework that is ideal for tasks requiring both explanation and immediate execution.
- Enhances responsiveness by acting on intermediate conclusions.

---

# ReAct Agent Prompt Example: Web Search

**Task:** Retrieve recent news on breakthrough developments in artificial intelligence.

**Prompt for ReAct Agent:**  

```markdown
Using ReAct, please search for recent news articles about breakthrough developments in artificial intelligence. 
Begin by reasoning about the need for the latest information, then execute the web_search tool call with
the query 'recent AI breakthroughs'.

Provide your chain-of-thought and then output the tool action command.
```

**Expected Output:**  

```markdown
Chain-of-Thought: 
- I need the most current information on AI breakthroughs. 
- The web_search tool can retrieve recent news articles. 
- I will query for 'recent AI breakthroughs'.  

Action:
 Execute web_search with query: ["recent AI breakthroughs"]
```



---

# ReAct Agent Prompt Example: Run Python Code

**Task:** Compute the factorial of 5 using Python code.

**Prompt for ReAct Agent:**  
```markdown 
Using ReAct, compute the factorial of 5.

You have access to the run_python_code tool which allows you to execute Python code. 
```

**Example Output:**

```markdown
Chain-of-Thought: 
- Factorial is a mathematical operation that multiplies a number by all positive integers less than it.
- To compute factorial(5), I need to implement a function tha t multiplies 5 by all positive integers less than it.
- I will now run a Python function to provide the final answer.

Action: 
Execute run_python_code with code:  

def factorial(n):  
    return 1 if n == 0 else n * factorial(n-1)  
print(factorial(5))
```

---

# Tools & Integration in AI Agents

AI agents often rely on external tools to extend their capabilities. These tools can include:

- **APIs and Web Services:** Accessing external data or performing computations.
- **Databases:** Storing and retrieving structured data.
- **Custom Utilities:** Specific functions designed to solve sub-tasks.

Tools communicate with agents using standardized data formats such as JSON.

---

# Tool Usage and JSON Integration

When an agent utilizes a tool, the interaction might look like this:

1. **Request Formation:**  The agent sends a JSON-formatted request.  
   ```json
   {
     "tool": "calculator",
     "operation": "add",
     "operands": [2, 3]
   }
   ```

2. **Tool Execution:**  The external tool processes the request and returns a JSON response.

3. **Response Parsing:**  The agent parses the JSON output.  
   ```json
   {
     "status": "success",
     "result": 5
   }
   ```

This standardized communication ensures clear and consistent interactions between the agent and its tools.

---

# Advanced Tool Integration

- **Dynamic Decision-Making:**  
  Agents can decide at runtime which tool to use based on the task.
- **Error Handling:**  
  Agents verify the JSON response and handle errors gracefully.
- **Extensibility:**  
  New tools can be integrated as long as they adhere to the JSON protocol.

---

# AI Agent Framework Comparison

The rapid evolution of AI has led to a new era of autonomous systems. This analysis compares five prominent frameworks based on their architectural design, operational capabilities, and implementation challenges:
- LangGraph
- CrewAI
- Smolagents
- Autogen
- Phidata

---

# AI Agent Framework: LangGraph
Stateful Workflow Orchestration

**Architectural Foundations:**
- Graph-based state machines modeling workflows as directed acyclic graphs (DAGs).
- Maintains context via built-in memory modules for both short-term interactions and long-term retention.
- Supports human intervention points with checkpoint nodes.
- Features error recovery through time-travel (rollback to previous states).

**Enterprise Implementation:**
- Proven in customer service automation (e.g., telecommunications case study).
- Enables dynamic routing, real-time quality assurance, and continuous learning.
- Onboarding can take 6–8 weeks due to a steep learning curve.
- Offers 23% faster resolution times but consumes 40% more cloud resources.

---

# AI Agent Framework: CrewAI
Collaborative Intelligence for Team-Based Workflows

**Role-Based Agent Design:**
- Assigns AI agents detailed professional profiles (e.g., Research Analyst, Risk Assessment, Client Reporting).
- Specialization reduces task completion variance by 38% and achieves 92% efficient inter-agent communication.
- Delegation protocols allow autonomous task reassignments based on workload balancing.

**Memory and Context Management:**
- Combines a short-term cache, long-term knowledge base, and entity recognition.
- Increases accuracy by 71% in applications like adverse event prediction.
- However, the memory subsystem uses on average 2.3× more resources than equivalent features in LangGraph.

---

# AI Agent Framework: Smolagents
Rapid Prototyping for Experimental Systems

**Minimalist Design Philosophy:**
- Microkernel architecture with core functionality under 1,500 lines of code.
- Simple decorator-based instantiation (e.g., using @smolagent).
- Lacks advanced features such as persistent memory or multi-agent coordination.
- Integrates seamlessly with Hugging Face Hub, offering access to 250+ preconfigured agent templates.

**Prototyping Efficiency:**
- 68% faster initial deployment compared to LangGraph.
- 83% reduction in code compared to Autogen for similar functionality.
- Enables up to 12× faster iteration cycles during user testing.

---

# AI Agent Framework: Autogen
Conversational Agents for Real-Time Systems

**Event-Driven Architecture:**
- Treats agent workflows as threaded conversation histories for contextual dialog management.
- Supports dynamic tool invocation via natural language prompts.
- Incorporates automatic state recovery through checkpointed dialog states.

**Strengths and Challenges:**
- Excels in high-frequency, mixed-initiative environments with rapid integration into microservices.
- Challenges include multi-step planning (limited to 5–7 actions), maintaining consistency in parallel threads, and higher error rates in complex tasks.

---

# AI Agent Framework: Phidata
Multimodal Agents for Cross-Domain Applications

**Unified Data Processing:**
- Natively integrates text, image, and audio processing.
- Utilizes advanced retrieval-augmented generation (RAG) with self-correcting queries, vision transformers, and Whisper-based speech recognition.
- In retail, its multimodal approach has reduced customer escalations by 27%.

**Agentic RAG Advancements:**
- Offers self-optimizing queries and contextual citation for source tracking.
- Includes confidence scoring to indicate answer certainty.
- Achieves hallucination rates as low as 2.1% in legal document review applications.

---

# AI Agent Framework Analysis
Comparative Framework Analysis

**Execution Paradigms:**
- **LangGraph:** Graph-based control with explicit debugging interfaces.
- **CrewAI:** Role-based design simulating team dynamics.
- **Autogen:** Conversation-first approach for real-time responses.
- **Phidata:** Multimodal processing ideal for cross-domain applications.

**Development Complexity:**
- **LangGraph:** High learning curve; longer onboarding.
- **CrewAI:** Balanced capability with moderate complexity.
- **Smolagents:** Minimal configuration; best for rapid prototyping.
- **Autogen & Phidata:** Moderate-to-high complexity with domain-specific strengths.

---

# Conclusion: Selecting the Right Framework

- **CrewAI:** Best for enterprise environments requiring role-based collaboration and auditability.
- **LangGraph:** Ideal for mission-critical systems with stateful recovery and human oversight.
- **Smolagents:** Perfect for academic research and rapid prototyping.
- **Autogen:** Suited for real-time, high-frequency interactions.
- **Phidata:** Excels in multimodal scenarios with cross-domain data processing.

Future developments should focus on improving interoperability and agent provenance tracking to enable hybrid architectures.

---

# Live Demo: Build Your Own AI Agent

In this session, we will build a simple AI agent that:

1. Defines a problem and gathers input.
2. Implements perception, reasoning, and action functions.
3. Integrates a simulated external tool via JSON.
4. Displays a chain-of-thought log for transparency.

Follow along as we code the agent step-by-step.


---

# Live Demo: Getting Started with smolagents
Environment Setup

Before you start coding, ensure you have Python installed. We recommend using pyenv to manage your Python versions.

Steps:
- Install Python 3.9 (or above) with pyenv.
  ```sh
  pyenv install 3.9.12
  ```

- Create a new virtual environment by running:
  
  ```sh
  pyenv virtualenv 3.9.12 smolagents-demo  
  pyenv local smolagents-demo
  ```

- Activate the virtual environment:

  ```sh
  pyenv activate smolagents-demo
  ```

---

# Live Demo: Installing Required Packages

Install the necessary packages for our smolagents demo.

In your terminal, run:

  ```sh
  pip install smolagents requests 
  ```

Ensure that the installation completes without errors. 

---

# Live Demo: Creating a Simple smolagents Demo

```python
from smolagents import CodeAgent, HfApiModel, tool, DuckDuckGoSearchTool, VisitWebpageTool
import datetime

@tool
def calculate_days_since_tool(date_from: str) -> str:
    """
    Calculate the number of days since a a specific date.
    Args:
        date_from: The date the building was constructed in the format YYYY-MM-DD
    Returns:
        A string with the number of days since the building was constructed
    """
    date_from_obj = datetime.datetime.strptime(date_from, "%Y-%m-%d").date()
    today = datetime.date.today()
    days = (today - date_from_obj).days
    return f"It has been {days} days since the date {date_from}."

agent = CodeAgent(
    tools=[DuckDuckGoSearchTool(), VisitWebpageTool(), calculate_days_since_tool],
    model=HfApiModel() # Also possible to use other providers for example: LiteLLMModel(model_id="gpt-4o")

)

agent.run("What is the tallest building in the world and how many days since it has been built?")
```

<style>


</style>

---

# Live Demo: Running Your smolagents Demo
Run your agent and observe the output in your terminal. The agent will use the calculate_days_since_tool to calculate the number of days since the building was constructed.
```shell 
╭─────────────────────────────────────────────────────── New run ────────────────────────────────────────────────────╮
│ What is the tallest building in the world and how many days since it has been built?                               
╰─ LiteLLMModel - gpt-4o ────────────────────────────────────────────────────────────────────────────────────────────╯

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Step 1 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ─ Executing parsed code: ──────────────────────────────────────────────────────────────────────────────────────────── 
  search_result = web_search(query="tallest building in the world and its completion date")                              
  print(search_result)                                                                                                   
 ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Step 2 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ─ Executing parsed code: ──────────────────────────────────────────────────────────────────────────────────────────── 
  days_since_completion = calculate_days_since_tool(date_from="2010-01-04")                                              
  print(days_since_completion)                                                                                           
 ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Step 3 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ─ Executing parsed code: ──────────────────────────────────────────────────────────────────────────────────────────── 
  final_answer("The tallest building in the world is the Burj Khalifa, and it has been 5522 days since it was            
  completed.")                                                                                                           
 ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 
```


# Summary & Recap

**Key Takeaways:**

- AI agents operate through a cycle of perception, reasoning, and action.
- Chain-of-thought reasoning provides transparency and enhances debuggability.
- Hugging Face smolagents offers a modular, lightweight framework for rapid prototyping.
- Integration with external tools using JSON ensures scalable and flexible agent design.
- Iterative learning and error handling are vital for building robust agents.

---

# References & Additional Resources

- Hugging Face smolagents Course Materials: https://huggingface.co/learn/agents-course/unit1/introduction
- Hugging Face smolagents GitHub Repository: https://github.com/huggingface/smolagents
- Hugging Face smolagents Examples: https://github.com/huggingface/smolagents/tree/main/examples

---

# Q&A

We now welcome your questions and discussions.  