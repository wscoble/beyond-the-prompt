# ADR 003: Demo Implementation Strategy

## Status
Accepted

## Context
The presentation "Beyond the Prompt: Lessons from Building with Claude Code" needs to demonstrate:
- How to use ADRs to guide AI-assisted development
- Effective prompt engineering and task decomposition
- Iterative refinement with architectural constraints
- Real-world workflow patterns with Claude Code

The demo must be:
- Authentic and realistic
- Reproducible for attendees
- Illustrative of actual development patterns
- Version-controlled and sharable

## Decision
**The demo IS the development conversation itself** - specifically, the conversation that builds this presentation system using ADRs to guide Claude Code.

The demo consists of:
1. The ADRs that define the architecture (stored in `docs/adr/`)
2. The conversation transcript showing iterative development
3. The resulting implementation (flake, presentation, etc.)

## Rationale

### Why Conversation-as-Demo

**Authenticity**: Shows real Claude Code usage, not simulation
- Actual tool interactions
- Real decision-making process
- Genuine iterative refinement
- True constraint handling

**Educational Value**: Demonstrates the meta-pattern
- ADRs provide clear boundaries and context
- Constraints drive better design (e.g., "no Python", "use nixpkgs")
- Iterative improvement based on feedback
- Architecture emerges from conversation

**Reproducibility**: Attendees can recreate the pattern
- ADRs are templates for their own projects
- Conversation style is learnable
- Git history shows evolution
- Implementation validates the approach

### Alternative Approaches Considered

**1. Scripted Demo with Simulated Output**
- Pros: Predictable, rehearsable, no live risk
- Cons: Inauthentic, doesn't show real tool, feels staged
- Verdict: Misses the point of "beyond the prompt"

**2. Live Coding Session**
- Pros: Shows real tool, spontaneous
- Cons: Unpredictable, time pressure, can't capture nuance
- Verdict: Too risky for complex architecture decisions

**3. Pre-recorded Video**
- Pros: Perfect execution, editing possible
- Cons: Not interactive, can't adapt to audience questions
- Verdict: Loses conversational flow and learning opportunities

## Implementation Details

### Demo Artifacts

**1. Architecture Decision Records** (`docs/adr/`)
- `001-presentation-technology.md` - Reveal.js choice
- `002-nix-flake-architecture.md` - process-compose + Caddy
- `003-demo-implementation-strategy.md` - This document (meta!)
- `README.md` - ADR index and usage guide

**2. Conversation Transcript** (`docs/demo/`)
Store the actual Claude Code conversation showing:
- Initial requirements gathering
- ADR creation and refinement
- Constraint application ("no Python")
- Architecture evolution (simple → process-compose)
- Decision rationale and tradeoffs

**3. Implementation Artifacts**
- `flake.nix` - The actual working implementation
- `presentation/` - Reveal.js presentation
- Git commits showing progression

### Demo Execution Flow

**Stage 1: Setup** (2 minutes)
- Show empty repo with just README
- Explain the goal: build a presentation system
- Introduce ADRs as the guiding pattern

**Stage 2: ADR Creation** (3 minutes)
- Walk through creating ADR 001 (presentation tech)
- Show how it evaluates alternatives
- Demonstrate decision rationale

**Stage 3: Constraint Refinement** (3 minutes)
- Show conversation applying constraints
- Example: "No Python" → rearchitecture to Caddy
- Demonstrate ADR updates reflecting new decisions

**Stage 4: Implementation Validation** (2 minutes)
- Run `nix run .#present` to prove it works
- Show generated configs (Caddyfile, process-compose.yaml)
- Demonstrate configuration-as-code

**Stage 5: Meta-Reflection** (2 minutes)
- Highlight the pattern: ADRs → Conversation → Implementation
- Show how this approach is reusable
- Provide takeaways for attendees

### Presentation Integration

Embed demo artifacts in the presentation:
```markdown
# Slide: "The Power of ADRs"
- Show ADR 001 side-by-side with implementation
- Highlight how decisions map to code

# Slide: "Iterative Refinement"
- Show conversation excerpt about Python → Caddy
- Display the updated ADR section
- Show the resulting Nix code

# Slide: "Meta Demo"
- Reveal that THIS presentation was built this way
- Show the actual conversation
- Provide GitHub link for full exploration
```

### Nix Integration

The demo app serves the conversation transcript:

```nix
demo = {
  type = "app";
  program = "${pkgs.writeScript "demo" ''
    #!/usr/bin/env bash

    # Generate demo config for process-compose
    config="${pkgs.writeText "demo-compose.yaml" (builtins.toJSON {
      processes = {
        conversation-viewer = {
          command = "${pkgs.caddy}/bin/caddy file-server --root ${self}/docs/demo --listen :8001";
        };
        presentation = {
          command = "${pkgs.caddy}/bin/caddy file-server --root ${self}/presentation --listen :8000";
        };
      };
    })}"

    exec ${pkgs.process-compose}/bin/process-compose up -f "$config"
  ''}";
};
```

This runs:
- Presentation on `:8000`
- Conversation transcript viewer on `:8001`

## Technical Considerations

### Conversation Capture
- Export Claude Code conversation to markdown
- Format with syntax highlighting
- Preserve timestamps and flow
- Annotate with insights

### Presentation Structure
```
presentation/
├── index.html              # Main reveal.js presentation
├── slides/
│   ├── 01-introduction.md
│   ├── 02-the-adr-pattern.md
│   ├── 03-demo-reveal.md   # The meta moment
│   └── 04-takeaways.md
└── assets/
    ├── conversation.md     # Embedded transcript excerpts
    ├── adr-examples/       # ADR screenshots
    └── implementation/     # Code snippets
```

### Git History as Artifact
Commit strategy:
```
feat: initial ADRs for presentation architecture
feat: update ADR 002 with process-compose approach
feat: rewrite ADR 003 as conversation-based demo
feat: implement flake based on ADR decisions
docs: add conversation transcript to demo/
```

Git history itself becomes part of the demo narrative.

## Consequences

### Positive
- **Authentic**: Real Claude Code usage, not simulation
- **Educational**: Shows thinking process, not just results
- **Reusable**: Pattern applicable to any project
- **Transparent**: All decisions documented and traceable
- **Self-documenting**: The demo explains itself
- **Meta-awareness**: Presentation about AI development, built with AI

### Negative
- **Complexity**: More sophisticated than simple script
- **Preparation**: Requires curating conversation for clarity
- **Length**: Full conversation may be too detailed for presentation
- **Assumption**: Assumes audience familiarity with ADRs

### Mitigation
- Curate conversation to key decision points
- Provide full transcript as supplementary material
- Include ADR primer in presentation intro
- Offer simplified "getting started" guide for newcomers

## Future Enhancements
- Interactive conversation explorer (search, filter by topic)
- Side-by-side view: ADR ↔ Conversation ↔ Implementation
- Jupyter notebook walking through the process step-by-step
- Template repository: "instant ADR-driven development"
- Video walkthrough with narration over the conversation
- Browser extension to capture Claude Code conversations automatically

## Key Insight

**This ADR is itself part of the demo** - it documents the decision to use the conversation as the demo, demonstrating the recursive, self-referential nature of effective AI-assisted development.

The presentation is its own case study.
