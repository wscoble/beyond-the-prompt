# Demo: The Conversation

This directory contains the actual conversation that built this presentation system, demonstrating the ADR-driven development approach with Claude Code.

## What's Here

- **conversation-transcript.md** - The full development conversation
- **key-moments.md** - Highlighted decision points from the conversation
- **lessons-learned.md** - Insights and patterns discovered

## Viewing the Demo

When you run `nix run .#demo`, this content is served on http://localhost:8001 alongside the presentation on http://localhost:8000.

## The Meta Pattern

This demo demonstrates:

1. **ADRs as guardrails** - How Architecture Decision Records guide AI development
2. **Iterative refinement** - Constraint application (e.g., "no Python" → Caddy)
3. **Conversation as artifact** - The dialogue itself becomes valuable documentation
4. **Meta-awareness** - Building a presentation about AI development, with AI

## Key Decision Points

### Initial Setup
- Created ADRs to define architecture
- Established technology choices (Reveal.js, Nix)

### Constraint Application
- "Python is verboten" → Evaluated alternatives
- Chose Caddy over darkhttpd/miniserve
- Added process-compose for orchestration

### Meta Realization
- "The demo IS this conversation"
- Shifted from scripted demo to conversation-as-demo
- Updated ADR 003 to reflect this approach

### Implementation
- Built flake.nix based on ADR 002
- Generated configs from Nix expressions
- Multi-platform support with forAllSystems

## Lessons Learned

1. **ADRs provide crucial context** - They help AI understand not just what to build, but why
2. **Constraints drive better design** - "No Python" led to a more robust architecture
3. **Iterative refinement works** - First solutions improved through dialogue
4. **Meta-awareness is powerful** - Using the tool to understand the tool

## Try It Yourself

1. Read through the ADRs in `docs/adr/`
2. Study the conversation transcript
3. Examine the resulting `flake.nix`
4. Apply the pattern to your own projects

The pattern is simple:
```
ADRs → Conversation → Implementation → Refinement → Better ADRs
```

This creates a virtuous cycle of improvement.
