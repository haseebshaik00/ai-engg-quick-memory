# AI Engg Quick — Project Knowledge Base

_Last consolidated: July 19, 2026_

## 1. Scope and Status

This knowledge base records only material discussed inside the AI Engg Quick project. It is the canonical record of learned concepts, working mental models, corrections, decisions, examples, confidence, open questions, and learning priorities.

The project focuses on practical AI engineering and AI-tool fluency, including LLM foundations, context and memory, prompt and context engineering, RAG, MCP, tool integrations, agent workflows, no-code/low-code systems, accounting automation, and knowledge management.

## 2. Current Learning Goals

The current goals are to:

- become proactive and knowledgeable about modern AI tools;
- choose appropriately among ChatGPT, Claude, Claude Code, Gemini, NotebookLM, Notion, Obsidian, Cursor, and related tools;
- understand LLM internals at an application-builder level without deep research mathematics;
- understand context windows, context layers, memory, projects, source files, and knowledge bases;
- learn prompt engineering and context engineering;
- understand RAG, vectorless RAG, connectors, APIs, plugins, and MCP;
- design reliable AI agents and workflows;
- build no-code and low-code agent workflows, especially for accounting and Google Sheets;
- maintain useful notes, quizzes, reviews, and an evolving project knowledge base.

## 3. Canonical Mental Model: Knowledge, Context, and Memory

### 3.1 Model Knowledge

Model knowledge is information learned during training and encoded in the model's parameters. It is not an uploaded file, the current conversation, saved memory, project instructions, or retrieved web information.

Ordinary chat use performs inference. It does not continuously retrain the underlying model from each conversation.

### 3.2 Context

Context is everything made available to the model for the current response. Depending on the product and task, it may contain:

- system and project instructions;
- the current prompt;
- recent or selected conversation history;
- retrieved excerpts from project files;
- selected saved memories;
- tool results;
- fetched external information.

The important distinction is that information can exist in a project or product without being present in the active context for a particular invocation.

### 3.3 Context Window

The context window is the maximum token budget that can be processed in one model invocation. It includes input material and, depending on the API or product's accounting, may constrain space available for generated output.

When available material exceeds the usable window, the application may retrieve only relevant pieces, summarize older content, truncate content, or reject the request. The exact behavior is product-dependent.

The “lost in the middle” effect is a reliability concern: a model may use information near the beginning or end more reliably than equally relevant information buried in a long context. It is not a rule that middle content is always ignored.

### 3.4 Context Layer

The context layer is the product or system mechanism that selects, gathers, filters, structures, and refreshes material before the model responds.

Notes-ready distinction:

> Context is the information available right now; the context layer is the mechanism that assembles and organizes it.

A simplified flow is:

**Durable sources → selection/retrieval/summarization → active context → model inference → response**

The context layer is normally assembled again for each invocation. Problems described as “stale context” may come from an outdated source, an old summary, failed retrieval, or the wrong memory being selected—not necessarily from one permanently frozen context.

### 3.5 Knowledge Base and Source Files

Uploaded source files remain external to the trained model. Relevant portions may be retrieved into the active context.

Uploading a file does not retrain the model, and the whole file should not be assumed to enter every prompt automatically.

### 3.6 Saved Memory, Project Context, and Agent Memory

- **Saved memory** is product-managed information retained across conversations.
- **Project context** is project instructions, files, and accessible project conversations made available through the product.
- **Agent memory** is application-managed state such as a scratchpad, summary, database, state object, or prior tool result.

“The model's memory” is therefore ambiguous. It may refer to model knowledge, active context, saved memory, project context, conversation history, or agent memory. These should be named separately.

## 4. Training, Inference, and the Transformer Flow

### 4.1 Training versus Inference

- Training updates learned model parameters.
- Inference uses fixed trained parameters to process the current context and generate output.
- A product can retain conversation data or memory without changing the model's parameters during that conversation.

### 4.2 Input and Generation Flow

Current working flow:

**Text → tokens → token IDs → embedding lookup → token embeddings + positional information → transformer layers → contextual hidden states → output logits → constrained/sampled token selection → generated token**

The process repeats autoregressively for each generated token.

### 4.3 Token IDs, Embeddings, and Hidden States

- A token ID is a discrete vocabulary index.
- An embedding is a learned vector retrieved using that token ID.
- A contextual hidden state is the representation produced after the embedding interacts with surrounding context through transformer layers.

A word or token can therefore have the same initial embedding lookup but a different contextual representation in different sentences.

### 4.4 Attention Parameters

- `Wq`, `Wk`, and `Wv` are learned model parameters.
- The same learned matrices are applied across prompts.
- Different input hidden states produce different queries, keys, values, and attention patterns.

### 4.5 Decoder-Only Models

GPT-style models are commonly described as decoder-only transformers. They still tokenize and encode input into internal representations; they simply do not use a separate encoder stack like an encoder-decoder architecture. Calling all input processing an “encoder phase” can therefore create confusion.

## 5. Generation Controls, Output Constraints, and Tool Use

Generation controls are inference-time settings, not knowledge stored in feed-forward or attention weights.

| Control | Working meaning |
| --- | --- |
| Temperature | Reshapes the probability distribution; higher values generally increase variation. |
| Top-p | Restricts sampling to a probability-mass nucleus. |
| Top-k | Restricts sampling to the highest-probability `k` candidates when supported. |
| Frequency penalty | Discourages tokens according to how often they have already appeared. |
| Presence penalty | Discourages tokens that have appeared at least once. |
| Output-token limit | Caps generated length. |
| Stop condition | Ends generation when a specified sequence or condition is reached. |
| Response format | Constrains the shape or syntax of the response. |
| Tool choice | Controls whether or which external tool the model may request. |

These settings do not all belong to one category:

- temperature, top-p, and top-k are sampling controls;
- penalties modify token selection scores;
- output-token limits and stop sequences control termination;
- JSON mode and structured outputs constrain format;
- function calling exposes operations with defined arguments;
- tool choice governs tool-selection behavior.

Structured output is stronger than merely asking for JSON in prose when a supported schema is enforced. Function calling does not itself execute a function; the surrounding application receives the requested call, validates it, executes the tool, and returns the result to the model.

## 6. Prompt Engineering and Context Engineering

### 6.1 Prompt Frameworks Discussed

**CTFS**

- Context
- Task
- Format
- Style

**ICC**

- Instruction
- Context
- Constraints

Both are organizational aids, not mandatory formulas. A useful prompt clearly states the task, supplies relevant context, defines constraints, specifies the desired output, and is refined based on observed failures.

### 6.2 Prompt Engineering versus Context Engineering

Prompt engineering focuses on the instructions and input wording given to the model. Context engineering is broader: it determines which instructions, files, history, memories, retrieved evidence, tools, and state should be assembled for the task.

The quality of an AI application therefore depends not only on wording, but also on selecting the right information and tool results at the right time.

## 7. Product and Workspace Distinctions

### 7.1 ChatGPT and Claude

The current project-level working distinction is:

- ChatGPT is often approached as a broad, mixed-task assistant where product-managed memory and connected capabilities may support continuity.
- Claude is often approached through explicitly scoped projects and, for coding, Claude Code.

This is a workflow heuristic, not a universal capability ranking. Exact memory behavior, project access, integrations, and skill support are product features that can change and should be checked against current official documentation before making a firm comparison.

A new chat should never be assumed to contain the full history of all earlier chats. A product may select saved memories or earlier context, but the entire account history is not automatically placed in every context window.

Any generated user profile, summary, or “wiki” is best understood as product-managed memory or summarization, not continuous retraining of the base model.

### 7.2 Projects versus Reusable Assistants or Skills

- A **ChatGPT Project** is an evolving workspace for related chats, project instructions, files, and project context.
- A **Custom GPT** is a reusable configured assistant with a defined role, instructions, optional files, and optional tools/actions.
- A **Claude Project** is a scoped workspace for project instructions, files, and related chats.
- A **Claude Skill** is a reusable packaged procedure or capability that may define a task, steps, tools, constraints, outputs, and validation.

Mental model:

> A project organizes the changing context of one body of work; a reusable assistant or skill standardizes behavior across repeated tasks.

The exact Claude surfaces that support skills, and how behavior differs between Claude Code and other Claude products, remains unresolved in this project.

### 7.3 Tool-Selection Heuristic

Do not ask which tool is universally best. Choose according to the job: continuity, isolated project work, codebase operations, source-grounded research, structured collaboration, local-first notes, or reusable workflows.

## 8. RAG, Connectors, APIs, Plugins, and MCP

These areas have been introduced but are not yet fully consolidated.

### 8.1 RAG

Retrieval-augmented generation keeps external knowledge outside the model, retrieves relevant material for a query, and inserts that material into the active context before generation.

RAG is therefore a context-assembly pattern, not model retraining.

“Vectorless RAG” is a broad label for retrieval approaches that do not depend primarily on vector similarity, such as lexical search, metadata filters, structured queries, graph traversal, or model-guided search. The decision rules for choosing it over vector retrieval remain an open learning topic.

### 8.2 Integration Terms

- An **API** is a programmatic interface for direct requests to a service.
- A **connector** is usually a product-managed integration with an external data source or application.
- **MCP** is a protocol-oriented way for AI applications to discover and use external tools, resources, or prompts through a consistent interface.
- A **plugin** is a packaged extension; its exact structure and capabilities depend on the host product.

The implementation, authentication, permission, privacy, and security differences between connectors and MCP remain a priority for deeper study.

## 9. Agents, Loops, and Deterministic Workflows

### 9.1 Workflow

A workflow follows a controlled sequence of predefined steps.

### 9.2 Agent

An agent uses a model to decide what action to take based on a goal, current observations, available tools, prior results, and stopping conditions.

### 9.3 Agent Loop

A common loop is:

**Observe → plan/reason → select action → use tool → inspect result → repeat or stop**

A multi-step workflow is not automatically an agent. For predictable and auditable work, a deterministic workflow may be safer and easier to validate than open-ended agent autonomy.

### 9.4 Reliable Agent Contract

Each agent should have:

- one clear responsibility;
- explicit inputs and outputs;
- a restricted set of tools;
- separate read and write permissions;
- exact write ownership;
- stopping conditions;
- failure and retry behavior;
- structured handoff fields;
- validation before completion.

## 10. Accounting Google Sheets Workflow

The project designed a four-stage no-code/low-code workflow around these workbook areas:

- GL;
- Year End Entries;
- Year-End Worksheet;
- Income Statement;
- Balance Sheet;
- Cash Flows.

### 10.1 Planned Sequence

1. Agent 1 reads the GL and Year End Entries and completes the Year-End Worksheet.
2. Agent 2 reads the completed worksheet and completes the Income Statement.
3. Agent 3 completes the Balance Sheet.
4. Agent 4 completes Cash Flows and performs final reconciliation across the outputs.

### 10.2 Range Ownership Discussed

- `E10:F53` — Trial Balance
- `H10:J53` — Adjusting Entries
- `K10:L55` — Adjusted Trial Balance
- `M33:N57` — Income Statement
- `O10:P57` — Balance Sheet

### 10.3 Reliability Rules

- Restrict every agent to its assigned sheet and range.
- Separate read tools from write tools.
- Distinguish formulas from static values; formulas must begin with `=`.
- Inspect prefilled cells before bulk writes and avoid unintended overwrites.
- Re-read the written cells before claiming completion.
- Validate debit/credit balance.
- Reconcile net income across the worksheet, income statement, and retained earnings.
- Reconcile the balance sheet and cash flow outputs.
- Use structured handoffs containing status, calculated figures, validation results, and the next agent's required inputs.

### 10.4 Known Failure Mode

Some target cells were already populated. A bulk-update tool may fail, reject mixed inputs, or overwrite valid content unless the update range and row payload exactly match writable cells. The workflow should first test a small known-safe write, verify it by reading the cell back, and only then expand the write scope.

## 11. API and FastAPI Mental Model

The project used a FastAPI example to understand endpoints and OpenAI model calls.

Established points:

- A route such as `POST /generate` becomes an endpoint when a server framework binds a path and HTTP method to handler code.
- In FastAPI, a simple handler parameter not declared as a path parameter, request-body model, or dependency may be interpreted as a query parameter; this is why a value can appear as `?prompt=...`.
- An API key is a credential the receiving service uses to authenticate or authorize a caller.
- A server-side OpenAI API key should remain on the server, typically in an environment variable, rather than being exposed in browser or client code.
- A typical application flow is: client request → application server → OpenAI API → application validation/processing → client response.

## 12. Knowledge-Management Tools

### 12.1 Obsidian and Notion

- Obsidian is a local-first Markdown knowledge system centered on files and links.
- Notion is a collaborative workspace with page and database-oriented organization.

They overlap as note-taking tools but differ in storage model, linking, collaboration, and database behavior.

### 12.2 Obsidian Graph and Bases

Obsidian's graph represents links between notes. Folder membership, file presence in a Base, or a Base query selecting a note does not automatically create a graph edge. To see an edge, notes generally need an explicit Markdown link or another relationship recognized by the graph.

PNG attachments are separate files even when embedded or linked from Markdown. Removing or moving them can break the link unless Obsidian updates it.

### 12.3 NotebookLM

NotebookLM is part of the tool-learning roadmap for source-grounded exploration of an uploaded set of materials. Its exact role relative to project files and general-purpose chat remains a learning priority.

## 13. Project Document Architecture

The project now has two canonical documents:

1. **Project Instructions** — stable preferences, terminology, scope, and operating rules.
2. **Project Knowledge Base** — learned concepts, decisions, examples, corrections, confidence, open questions, and priorities.

Auxiliary files previously discussed—AI news, quiz template, memory-loop log, and notes—can remain useful, but they should not duplicate or override the canonical documents.

Existing project chats are source material, not automatically a clean knowledge base. Useful information should be consolidated, deduplicated, corrected, and written into the canonical knowledge base.

## 14. Corrections and Established Decisions

- **Correction:** Context and context layer are related but not identical. Context is the assembled input; the context layer assembles it.
- **Correction:** A large collection of past chats, memories, and files is not inserted into every prompt in full.
- **Correction:** Uploaded files and ordinary conversations do not immediately retrain the model.
- **Correction:** “Model memory” is not one technical object; identify model knowledge, context, saved memory, project context, conversation history, or agent state.
- **Correction:** GPT-style models do not need a separate encoder stack to process input.
- **Correction:** Temperature, top-p, penalties, output limits, response formats, and tool choice are not feed-forward weights and do not all perform the same function.
- **Correction:** A project and a skill are not interchangeable: a project holds evolving context; a skill defines reusable behavior.
- **Correction:** Obsidian Base membership does not itself create graph links.
- **Decision:** Use a task-fit comparison instead of declaring ChatGPT or Claude universally better.
- **Decision:** Prefer deterministic, range-restricted workflows for auditable accounting work; use agents only where model judgment is needed.
- **Decision:** Maintain two canonical project documents and keep temporary logs/templates auxiliary.

## 15. Confidence Snapshot

These levels are provisional because they are inferred from the discussion history rather than a formal quiz.

| Area | Confidence | Basis |
| --- | --- | --- |
| Context vs. context layer | High | Repeatedly restated in the user's own words with the core distinction intact. |
| Model knowledge vs. files/context | High | The user formed the correct separation after follow-up clarification. |
| Training vs. inference | Medium–High | Core distinction is established; product retention can still cause wording confusion. |
| Context window and overflow | Medium | Basic limit is understood; retrieval, truncation, and lost-in-the-middle behavior need practice. |
| Saved memory and project context | Medium | Conceptual categories are clear; product-specific selection behavior remains unresolved. |
| ChatGPT/Claude/Projects/Skills | Medium | Primary distinctions are forming; current feature boundaries require verification. |
| Generation controls and structured output | Medium | Categories have been discussed; API-specific support and practical usage need consolidation. |
| Agents vs. workflows | Medium | Core distinction is understood; implementation reliability remains an active exercise. |
| RAG and vectorless RAG | Low–Medium | Introduced, but selection criteria and architectures need deeper study. |
| Connectors, plugins, APIs, and MCP | Low–Medium | Basic terms are present; implementation and security differences remain open. |
| No-code multi-agent Sheets workflow | Medium | A detailed design exists, but tool contracts and safe writes caused implementation issues. |

## 16. Open Questions

- Is the July 19, 2026 consolidation date correct, given that the currently available project conversation history ends on July 18, 2026?
- How exactly do current ChatGPT project settings select earlier project chats and saved memories for a response?
- How does current Claude memory or profile generation work, and which information crosses chat or project boundaries?
- Which Claude surfaces currently support Skills, and how does behavior differ between Claude Code and other Claude products?
- What are the implementation, permission, authentication, and security differences among connectors, plugins, APIs, and MCP?
- When should lexical, structured, graph-based, or model-guided “vectorless” retrieval be preferred over vector retrieval?
- How should growing source files be updated without duplicating or contradicting canonical knowledge?
- What is the best supported way to consolidate older chats into project knowledge without assuming every chat is automatically retrieved?
- Which no-code/low-code platform best supports restricted, validated, multi-step Google Sheets workflows?
- What exact payload shape does the chosen Sheets bulk-write tool require when some destination cells are prefilled?

## 17. Current Learning Priorities

1. Reinforce context, context-layer, context-window, source-file, and memory distinctions with applied examples.
2. Verify current ChatGPT and Claude memory/project behavior using official documentation when external research is allowed.
3. Consolidate Projects, Custom GPTs, Claude Projects, Claude Code, and Claude Skills into one task-selection framework.
4. Complete the practical LLM inference model, including context limits and token generation.
5. Practice structured outputs, JSON schemas, function calling, and tool contracts.
6. Learn RAG architecture and compare vector, lexical, structured, graph, and vectorless retrieval.
7. Study connectors, plugins, APIs, and MCP with permissions and security boundaries.
8. Distinguish deterministic workflows from agents using concrete failure cases.
9. Repair and validate the Google Sheets workflow with small read-after-write tests and protected ranges.
10. Run a weekly quiz to replace provisional confidence estimates with evidence-based levels.
