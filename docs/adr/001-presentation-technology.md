# ADR 001: Presentation Technology Choice

## Status
Proposed

## Context
We need to create a presentation for "Beyond the Prompt: Lessons from Building with Claude Code" that:
- Can be served via simple HTTP server
- Works well with Nix flake distribution
- Supports code syntax highlighting
- Allows for presenter notes
- Is version-controllable (text-based)
- Can be easily edited and previewed

## Decision
Use **Reveal.js** for the presentation framework.

## Rationale

### Reveal.js Advantages
- **Static HTML/JS/CSS**: Can be served with any simple HTTP server
- **Rich features**: Code highlighting, presenter notes, speaker view, PDF export
- **Nix-friendly**: Available via nixpkgs, no complex build process
- **Offline-capable**: All assets can be bundled
- **Markdown support**: Can write slides in Markdown within HTML
- **Wide adoption**: Well-documented, stable, extensive plugin ecosystem

### Alternatives Considered

**Marp**
- Pros: Pure Markdown, simpler syntax
- Cons: Requires CLI tool, more complex Nix integration, fewer interactive features
- Verdict: Too limiting for technical demos

**Slidev**
- Pros: Vue-based, modern developer experience
- Cons: Requires Node.js build process, heavier Nix integration
- Verdict: Unnecessary complexity for this use case

**Beamer/LaTeX**
- Pros: Academic standard, precise control
- Cons: PDF-only, no interactive demos, steep learning curve
- Verdict: Not suitable for live coding demonstrations

## Implementation Details

### Directory Structure
```
presentation/
├── index.html          # Main presentation file
├── css/
│   └── theme/         # Custom themes if needed
├── js/
│   └── reveal.js      # Vendored or symlinked
└── assets/
    ├── images/
    └── code-samples/
```

### Serving
- Development: `nix run .#present` → lightweight HTTP server from nixpkgs (e.g., darkhttpd, caddy, or miniserve)
- Production: Static hosting (GitHub Pages, Netlify, etc.)

### Reveal.js Integration in Nix
Use nixpkgs to fetch reveal.js dependencies:
- Option 1: `fetchFromGitHub` to get reveal.js source
- Option 2: Use `buildNpmPackage` if npm-based tooling needed
- Option 3: Direct vendoring with `fetchurl` for specific release

Recommended: **fetchFromGitHub** for reproducibility and ease of updates.

## Consequences

### Positive
- Simple development workflow
- No build step required for basic presentations
- Easy to version control
- Works offline
- Familiar to many developers

### Negative
- Manual Reveal.js updates (if vendored)
- Larger repo size if vendoring full Reveal.js
- Less separation between content and presentation (vs. pure Markdown)

### Mitigation
- Keep Reveal.js minimal (only required files)
- Use Markdown mode for slide content where possible
- Document update process for Reveal.js version bumps
