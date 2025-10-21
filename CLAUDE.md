# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Nix flake-based project for the presentation "Beyond the Prompt: Lessons from Building with Claude Code". This project demonstrates using **Skills** for AI implementation guidance and **ADRs** for human documentation.

**Key Concept**: Skills provide scalable AI context (100s of patterns, minimal tokens), while ADRs document architectural rationale for humans.

## Project Structure

```
.
├── flake.nix                 # Nix flake with apps and devShell
├── CLAUDE.md                 # This file
├── skills/                   # AI implementation skills (auto-loaded)
│   ├── nix-http-server/      # HTTP server creation skill
│   ├── revealjs-presentation/# Reveal.js presentation skill
│   └── adr-documentation/    # ADR creation skill
├── docs/
│   ├── adr/                  # Architecture Decision Records (human docs)
│   │   ├── 001-presentation-technology.md
│   │   ├── 002-nix-flake-architecture.md
│   │   ├── 003-demo-implementation-strategy.md
│   │   └── README.md
│   └── demo/                 # Conversation transcript and demo materials
│       └── README.md
└── presentation/
    ├── index.html            # Reveal.js presentation
    ├── slides/
    └── assets/
```

## Development Commands

### Nix Commands

```bash
# Enter development shell with all tools
nix develop

# Start presentation server (http://localhost:8000)
nix run .#present

# Start full demo (presentation + conversation viewer)
# - Presentation: http://localhost:8000
# - Conversation: http://localhost:8001
nix run .#demo
```

### Direct Development (Live Reload)

For rapid iteration without rebuilding:

```bash
nix develop
caddy file-server --root ./presentation --listen :8000
```

## Architecture

### Technology Stack

- **Presentation**: Reveal.js (CDN-hosted for simplicity)
- **HTTP Server**: Caddy (configured via Nix-generated Caddyfile)
- **Process Orchestration**: process-compose (YAML generated from Nix)
- **Multi-Platform**: Supports x86_64/aarch64 on Linux and macOS

### Available Skills (AI Guidance)

Claude Code auto-loads these skills for implementation guidance:

1. **nix-http-server**: Create HTTP servers using Caddy (NEVER Python). Enforces no-Python constraint from ADR 002.
2. **revealjs-presentation**: Build Reveal.js presentations optimized for large screens. Based on ADR 001 decision.
3. **adr-documentation**: Create ADRs for human documentation (not AI context).

**Context Efficiency**: 3 skills × ~100 tokens = 300 tokens for all metadata. Instructions only loaded when triggered.

### Architectural Decisions (Human Documentation)

ADRs in `docs/adr/` explain WHY (for humans, not AI):

1. **ADR 001**: Why Reveal.js (alternatives: Marp, Slidev, Beamer)
2. **ADR 002**: Why Caddy + process-compose (Python is verboten)
3. **ADR 003**: Why conversation-as-demo (meta-awareness approach)

### Flake Implementation

The flake uses:
- `forAllSystems` helper for multi-platform support
- `pkgs.writeText` to generate Caddyfile and process-compose configs
- `pkgs.writeScript` to create app wrappers
- No Python dependencies (Caddy replaces Python HTTP server)

## Configuration as Code

All configuration is generated from Nix expressions, not stored in the repo:

**Caddyfile generation**:
```nix
makeCaddyConfig = pkgs: port: root: pkgs.writeText "Caddyfile" ''
  :${toString port} {
    root * ${root}
    file_server browse
    encode gzip
  }
'';
```

**process-compose YAML** (via JSON):
```nix
makeProcessComposeConfig = pkgs: processes:
  pkgs.writeText "process-compose.yaml" (builtins.toJSON {
    version = "0.5";
    inherit processes;
  });
```

## Development Workflow

### Making Changes

1. **Presentation updates**: Edit `presentation/index.html` or files in `presentation/`
2. **ADR updates**: Modify files in `docs/adr/`
3. **Flake updates**: Edit `flake.nix` based on ADR decisions
4. **Testing**: Run `nix run .#present` or `nix run .#demo`

### The Skills + ADRs Pattern

This project demonstrates the modern pattern:

```
Architectural Decision
         ↓
    ┌────┴────┐
    ▼         ▼
  ADR      Skill
(Human)   (AI)
    ↓         ↓
Explains  Implements
  WHY       HOW
```

**Workflow**:
1. Skills auto-load to guide implementation (no manual prompting needed)
2. ADRs available in `docs/adr/` when humans need to understand WHY
3. Update both when architecture evolves:
   - ADR explains new decision rationale
   - Skill encodes new implementation patterns

## Key Constraints

- **No Python**: Use Caddy or other nixpkgs servers
- **All deps from nixpkgs**: No external package managers
- **Configuration as code**: Generate configs, don't commit them
- **Multi-platform**: Support all major systems (Linux/macOS, x64/ARM)

## Demo Concept

The presentation demonstrates the Skills + ADRs pattern by using itself as the example:

- **ADRs** documented architectural decisions for humans
- **Skills** encoded those decisions as AI-executable patterns
- Constraints applied iteratively ("no Python" → enforced by skill)
- The conversation itself became the demo
- Implementation validates the approach

**Meta-insight**: This project evolved from ADR-driven to Skills+ADRs pattern during development, proving the context efficiency advantage.

## Commands Reference

```bash
# Development
nix develop                    # Enter dev shell
nix flake check               # Validate flake (when checks added)

# Running apps
nix run .#present             # Presentation only
nix run .#demo                # Full demo environment

# Direct commands (from devShell)
caddy file-server --root ./presentation --listen :8000
process-compose up -f <config>
```

## Additional Notes

- Reveal.js loaded from CDN (can be vendored if offline needed)
- process-compose provides TUI for monitoring services
- Readiness probes ensure services are up before declaring ready
- Git history shows the evolution of the project
