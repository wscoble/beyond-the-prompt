# Beyond the Prompt: Lessons from Building with Claude Code

A presentation about using Skills and Subagents to guide AI-assisted development, demonstrated through the FLUO project's FluoDSL sandboxing decision.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/beyond-the-prompt.git
cd beyond-the-prompt

# Start the presentation (requires Nix)
nix run .#present
```

Open http://localhost:8000 in your browser.

## Prerequisites

- [Nix](https://nixos.org/download.html) package manager with flakes enabled

## Commands

### Run Presentation Only

```bash
nix run .#present
```

Serves the presentation at http://localhost:8000

### Run Full Demo

```bash
nix run .#demo
```

Serves:
- Presentation at http://localhost:8000
- Conversation viewer at http://localhost:8001 (if available)

### Development Mode

```bash
# Enter development shell with all tools
nix develop

# Start presentation server with live reload
caddy file-server --root ./presentation --listen :8000
```

## Presenter Mode

Press `P` during the presentation to toggle presenter mode with speaker notes and timing.

Press `C` to clone the slideshow for dual-screen presentation.

## Key Keyboard Shortcuts

- `→` / `Space` - Next slide
- `←` - Previous slide
- `P` - Toggle presenter mode
- `C` - Clone slideshow
- `F` - Toggle fullscreen
- `?` - Show help

## Project Structure

```
.
├── flake.nix                 # Nix flake with apps and devShell
├── README.md                 # This file
├── CLAUDE.md                 # Instructions for Claude Code
├── docs/
│   ├── adr/                  # Architecture Decision Records
│   └── demo/                 # Demo materials
└── presentation/
    ├── index.html            # Reveal.js presentation
    ├── slides.md             # Presentation content
    ├── assets/               # Images, CSS, themes
    └── vendor/               # Vendored dependencies
```

## Content

This presentation covers:

1. **Context Window Economics** - Progressive disclosure and token efficiency
2. **Skills + Subagents Pattern** - HOW to implement vs SHOULD we build
3. **Preventing Waste** - Evaluation before execution

## Learn More

- FLUO Project: https://github.com/fluohq/fluo
- See `.skills/` and `.subagents/` directories in FLUO for implementation examples
- Read ADRs in `docs/adr/` for architectural context

## License

[Your License Here]
