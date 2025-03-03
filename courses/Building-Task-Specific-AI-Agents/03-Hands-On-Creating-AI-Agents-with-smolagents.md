---
title: "Creating AI Agents with smolagents"
author: "Laszlo Racz"
theme: ../../themes/np-slides-theme
date: "2025-03-03"
description: >
  Fundamentals of building AI agents using the lightweight and modular smolagents framework.
revealOptions:
  transition: slide
layout: intro

---
# AI Agent Architecture and Design

## From Models to Implementation 

###  Session #3 - hands on


---
# Creating AI Agents with smolagents

Welcome to this class on designing and implementing AI agents using smolagents. 

We'll explore why smolagents is a great choice, how to build various types of agents, and how to integrate them into robust multi-agent systems. 

This session combines theoretical insights with practical demonstrations, ideal for anyone looking to deepen their understanding of AI agent development.

---

# Agenda

- **Why Use smolagents**
- **CodeAgents**
- **ToolCallingAgents**
- **Tools**
- **Retrieval Agents**
- **Multi-Agent Systems**
- **Vision and Browser Agents**

This agenda provides a roadmap for our session, ensuring we cover foundational principles before advancing to more complex integrations.

---

# Why Use smolagents

**Key Benefits:**
- **Lightweight & Modular:** Built to be simple yet powerful, reducing overhead while maintaining capability.
- **Clarity & Debuggability:** Minimal abstractions make it easier to trace and understand agent behavior.
- **Flexibility:** Easily adaptable to a range of projects and custom requirements.
- **Rapid Prototyping:** Allows quick iterations to test ideas without the bloat of larger frameworks.
- **Interoperability:** Designed to integrate seamlessly with external tools and APIs.

<!-- Speaker Notes: 
- Highlight the minimalistic design of smolagents, which enhances debugging and maintenance by reducing complexity and making it easier to trace agent behavior.
- Provide real-world examples where rapid prototyping with smolagents has been crucial, such as in startup environments or during hackathons.
- Compare and contrast smolagents with more monolithic agent frameworks, highlighting the benefits and potential trade-offs of each approach.
- Emphasize the importance of flexibility and how smolagents can be adapted to various project requirements.
-->

---

# Advantages of smolagents

**Rapid Prototyping:**
- Turn ideas into working prototypes quickly.
- Adapt easily as project requirements evolve.

**Minimalism:**
- Less hidden complexity means transparency in operations.
- Simplifies learning curves for students and new developers.

**Interoperability:**
- Plug in external libraries, APIs, and tools with minimal configuration.
- Future-proof your projects by keeping integrations straightforward.

<!-- Speaker Notes:
- Discuss how smolagents is ideal for understanding core agent behaviors without overwhelming details.
- Provide clear insights into how different components interact within the framework.
- Share examples of projects that have benefited from rapid prototyping with smolagents.
- Discuss experiences where minimal design led to easier maintenance and scalability.
- Highlight the importance of interoperability and how it allows for seamless integration with other tools and APIs.
-->

---

# CodeAgents

**Definition:**
- Agents that autonomously generate, modify, or execute code.
- They take natural language or structured input and translate it into executable code.

**Use Cases:**
- Automated generation of code snippets or functions.
- Code refactoring and optimization tasks.
- Interactive programming assistance during development.

**Considerations:**
- Balancing the autonomy of code generation with necessary human oversight.
- Verification and validation strategies to ensure generated code is correct and secure.

<!-- Speaker Notes:
- Explain how CodeAgents interpret and convert natural language into code.
- Discuss the security implications when agents generate or modify code, emphasizing the need for robust verification and validation strategies.
- Provide real examples, such as creating a Python sorting function or generating unit tests on demand.
- Highlight the importance of balancing autonomy with human oversight to ensure the generated code is both correct and secure.
-->

---

# CodeAgents Example

A simple example where a CodeAgent generates a code snippet from a natural language prompt.

```python
def generate_code(prompt):
    if "sort" in prompt.lower():
        return "def sort_list(lst):\n    return sorted(lst)"
    return "# No code generated"

code = generate_code("Generate a Python function to sort a list")
print(code)
```

---

# ToolCallingAgents

**Definition:**
- Agents designed to interface with external tools and APIs.
- They act as a bridge between the internal logic of an agent and the external environment.

**Capabilities:**
- Execute system commands and scripts.
- Communicate with various web services and APIs.
- Manage orchestration across different third-party tools.

**Example Scenario:**
- An agent receives a query about current weather, calls a weather API, processes the response, and returns a formatted summary.
- Emphasize error handling when external calls fail and the importance of modular design to swap out tools easily.

<!-- Speaker Notes:
**Security and Safety:**
- Discuss potential risks and the necessity of sandboxing when executing external commands.
- Outline strategies for robust error management and secure integration with external tools and APIs.

**Talking Points:**
- Best practices for integrating third-party APIs, including handling rate limits and authentication.
- Ensuring reliability when external services are unstable or unresponsive, and how to implement fallback mechanisms.
- Highlight the importance of modular design to facilitate easy swapping of tools and APIs.
-->

---

# ToolCallingAgents Example

This example shows a ToolCallingAgent interacting with an external tool.

```python
class ToolCallingAgent:
    def __init__(self, tool):
        self.tool = tool
    def perform_task(self, query):
        return self.tool(query)

def weather_tool(query):
    return {"temp": 72, "desc": "Sunny"}

agent = ToolCallingAgent(weather_tool)
print(agent.perform_task("What's the weather?"))
```

---

# Tools

**Definition:**
- External libraries, APIs, or system commands that extend an agent's capabilities.
- Serve as the building blocks for enhancing agent functionality beyond basic logic.

**Integration in smolagents:**
- Tools are integrated through thin wrappers that abstract their usage.
- Emphasis on clear, minimal interfaces to avoid unnecessary complexity.

**Examples:**
- Data processing libraries for handling and analyzing large datasets.
- Communication APIs for messaging, emailing, or notifications.
- File system utilities to read, write, and manage files.

<!-- Speaker Notes:
**Best Practices:**
- Emphasize the importance of creating abstractions to manage tool calls efficiently.
- Discuss the need for robust error handling and response validation to ensure reliable tool integration.
- Highlight the use of testing strategies, such as mocks, to simulate tool behavior during development.

**Discussion Points:**
- Explain how abstraction helps maintain clean and maintainable code.
- Share experiences with troubleshooting and integrating various tools in real-world projects.
- Discuss the importance of clear and minimal interfaces to avoid unnecessary complexity in tool integration.
-->

---

# Retrieval Agents

**Definition:**
- Agents focused on fetching and processing information from external sources.
- Specialize in retrieving, filtering, and summarizing data.

**Use Cases:**
- Querying databases or document repositories.
- Integrating search engines or web APIs to gather current information.
- Summarizing large volumes of data for concise insights.

**Mechanism:**
- An agent receives a query (e.g., "Find recent articles on AI advancements").
- It uses a retrieval module to search and collect relevant data.
- The data is processed and formatted before being delivered as a response.

<!-- Speaker Notes:
**Challenges:**
- Handling ambiguous queries and ensuring result relevance.
- Integrating data from diverse and heterogeneous sources.
- Balancing speed with accuracy in data retrieval.

**Talking Points:**
- Techniques to enhance the accuracy and relevance of retrieval agents.
- Strategies for aggregating and synthesizing information from multiple sources.
- Discuss the importance of balancing speed and accuracy in data retrieval to meet user expectations.
-->

---

# Retrieval Agents Example

A RetrievalAgent that filters data from a list based on a query.

```python
class RetrievalAgent:
    def __init__(self, data_source):
        self.data_source = data_source
    def retrieve(self, query):
        return [item for item in self.data_source if query.lower() in item.lower()]

data_source = ["Deep Learning", "Machine Learning", "AI Research"]
agent = RetrievalAgent(data_source)
print(agent.retrieve("learning"))
```

---

# Multi-Agent Systems

**Overview:**
- Systems where multiple agents collaborate to achieve common goals.
- Can operate under centralized control or as decentralized, autonomous units.

**Key Concepts:**
- **Coordination:** Mechanisms for agents to share information and delegate tasks.
- **Collaboration vs. Competition:** Finding the right balance between independent operation and cooperative behavior.
- **Scalability:** Managing the complexities of numerous interacting agents.

**Architectural Patterns:**
- **Centralized:** A single controller coordinates all agent activities.
- **Decentralized:** Agents communicate directly through messaging or events.
- **Hybrid:** Combines centralized oversight with decentralized execution for flexibility.

---

# Multi-Agent Systems cont.

**Real-World Applications:**
- Customer support systems where different agents handle distinct tasks (e.g., query retrieval, response generation, quality control).
- Simulations and modeling environments where agents represent different components of a larger system.
- Autonomous vehicles where multiple agents manage navigation, obstacle detection, and decision-making processes.
- Smart grid management systems where agents optimize energy distribution and consumption.
- Financial trading systems where agents analyze market trends, execute trades, and manage portfolios.

<!-- Speaker Notes:
**Coordination and Collaboration:**
- Discuss the importance of coordination mechanisms for effective multi-agent systems.
- Highlight the balance between collaboration and competition among agents to achieve optimal performance.

**Scalability:**
- Address the challenges of scaling multi-agent systems and strategies to manage complexity.
- Provide examples of real-world applications where multi-agent systems have been successfully implemented.

**Architectural Patterns:**
- Explain the different architectural patterns (centralized, decentralized, hybrid) and their respective advantages and trade-offs.
- Discuss scenarios where each pattern might be most appropriate.
-->

---

# Multi-Agent Systems Example

A basic demonstration of agent communication in a multi-agent system.

```python
class Agent:
    def __init__(self, name):
        self.name = name
    def send_message(self, msg, other):
        print(f"{self.name} sends '{msg}' to {other.name}")
        other.receive_message(msg, self)
    def receive_message(self, msg, sender):
        print(f"{self.name} received '{msg}' from {sender.name}")

agent_a = Agent("Agent A")
agent_b = Agent("Agent B")
agent_a.send_message("Hello, how are you?", agent_b)
```


---

# Vision and Browser Agents

**Vision Agents:**
- Designed to process and interpret visual data such as images and videos.
- Common applications include object detection, optical character recognition (OCR), and image-based searches.
- Consider how integrating computer vision libraries can significantly enhance agent capabilities.

**Browser Agents:**
- Focused on interacting with web pages, simulating user actions to navigate and extract information.
- Use cases include web scraping, automated testing, and interaction with dynamic web applications.
- Emphasize the ability to extract structured data from unstructured web content.

**Design Considerations:**
- **Dynamic Content:** Strategies for handling frequently changing web pages.
- **Robustness:** Ensuring agents adapt to different website structures.
- **Integration:** Combining visual and browser capabilities with other agent types to build comprehensive systems.

<!-- Speaker Notes:
**Vision Agents:**
- Discuss the role of vision agents in processing and interpreting visual data.
- Provide examples of common applications, such as object detection and OCR.
- Highlight the benefits of integrating computer vision libraries to enhance agent capabilities.

**Browser Agents:**
- Explain the functionality of browser agents in interacting with web pages and extracting information.
- Discuss use cases like web scraping and automated testing.
- Emphasize the importance of handling dynamic content and ensuring robustness in agent design.

**Integration:**
- Discuss how vision and browser agents can complement each other in real-world scenarios.
- Highlight the challenges in maintaining and updating browser agents in a rapidly evolving web landscape.
- Explain the role of vision agents in enhancing data extraction and analysis.
-->

---

# Vision and Browser Agents Example

Simulated examples for VisionAgent and BrowserAgent.

```python
class VisionAgent:
    def analyze_image(self, image_path):
        return {"objects": ["cat", "sofa"], "confidence": 0.85}

vision_agent = VisionAgent()
print(vision_agent.analyze_image("sample.jpg"))

class BrowserAgent:
    def navigate(self, url):
        return f"Navigated to {url}"

browser_agent = BrowserAgent()
print(browser_agent.navigate("https://example.com"))
```

---

# Practical Demonstration

**Live Coding Session:**
- Build a simple CodeAgent that translates a natural language prompt into code.
- Integrate a ToolCallingAgent to fetch data from a public API.
- Develop a Retrieval Agent to summarize data from a mock source.

<!-- Speaker Notes:
**Interactive Discussion:**
- Engage the class in brainstorming potential enhancements and real-world applications for the agents being demonstrated.
- Discuss how to combine these agents into a cohesive multi-agent system.
- Share common pitfalls and strategies for effective debugging and testing during the development process.
- Encourage participants to ask questions and provide feedback throughout the demonstration.
-->

---

# Summary & Key Takeaways

**Key Points:**
- **smolagents** is a lightweight yet powerful framework ideal for building diverse AI agents.
- Each agent type (Code, ToolCalling, Retrieval, Vision, Browser) offers unique benefits and serves a specific role.
- The modular design of smolagents facilitates rapid prototyping and seamless integration.
- Emphasis on clarity and minimalism makes it an excellent educational tool and a robust solution for production systems.

**Final Thoughts:**
- Experimentation is key—don't hesitate to try new configurations and integrations.
- Future research can explore advanced topics like security enhancements, real-time multi-agent coordination, and learning-based improvements.
- Robust testing and clear documentation are essential for maintaining complex systems.

---

# References & Further Reading

- **smolagents Documentation:** Explore detailed technical guides and implementation examples.
- **Multi-Agent Systems Literature:** Recommended textbooks, research papers, and case studies.
- **Tool Integration Best Practices:** Articles and blogs on robust API and tool integrations.
- **Additional Resources:** Online tutorials, community forums, and code repositories for further learning.

--- 

# QA 

We now welcome your questions and discussions.

---

# Thank You!

Thank you for attending today's class on creating AI agents with smolagents. 

For further questions, discussions, or access to additional materials, please feel free to reach out. 

Happy coding and innovating!
