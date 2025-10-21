# Skills Directory

This directory contains Claude Code skills that provide AI implementation guidance for this project.

## Purpose: AI Context

**Skills are for AI, not humans.** They encode HOW to implement architectural decisions with step-by-step procedures, templates, and validation scripts. Claude Code automatically loads skill metadata and selects relevant skills based on the task.

**For human-readable architectural rationale**, see the `/docs/adr` directory.

## Available Skills

### 1. nix-http-server
**Description**: Create HTTP servers for Nix flake projects. NEVER suggest Python dependencies.

**Use when**: Serving static files, creating dev servers, running multi-service environments.

**Key constraints**:
- All dependencies from nixpkgs only
- Use Caddy, never Python http.server
- Generate configs at runtime for dev flexibility
- Use process-compose for orchestration

**Corresponds to**: ADR 002 (Nix Flake Architecture)

### 2. revealjs-presentation
**Description**: Create and style Reveal.js presentations for technical talks. Optimized for large screens.

**Use when**: Building slide decks, HTML-based presentations, technical talks.

**Key patterns**:
- CDN-hosted Reveal.js (no build process)
- Large screen optimization (38px base font for 100" @ 15ft)
- Custom theme system with CSS variables
- Code highlighting with language-specific classes

**Corresponds to**: ADR 001 (Presentation Technology Choice)

### 3. adr-documentation
**Description**: Create and maintain Architecture Decision Records for human documentation.

**Use when**: Documenting architectural decisions, explaining WHY to team members.

**Key patterns**:
- ADRs are for humans, skills are for AI
- Document rationale and alternatives
- Preserve historical context
- Immutable once accepted (create superseding ADR instead)

**Corresponds to**: ADR 003 (Demo Implementation Strategy)

## How Skills Work

### Progressive Disclosure

Skills use a three-tier loading system:

1. **Metadata** (~100 tokens/skill, always loaded)
   - Name and description for discovery
   - Claude scans all skills at session start

2. **Instructions** (<5k tokens, loaded when triggered)
   - Full SKILL.md content
   - Only loaded for relevant skills

3. **Resources** (unlimited, on-demand)
   - Scripts, templates, reference files
   - Accessed via filesystem when needed

### Context Efficiency

**Traditional approach** (loading ADRs):
```
3 ADRs × 1,500 tokens = 4,500 tokens
Doesn't scale beyond ~10-20 documents
```

**Skills approach**:
```
3 skills × 100 tokens metadata = 300 tokens
+ ~2 triggered skills × 5k instructions = 10,300 tokens total
Scales to 100s of skills
```

## The Skills + ADRs Pattern

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

### Integration Example

**ADR 002**: "Use Caddy for HTTP serving, not Python"
- Location: `docs/adr/002-nix-flake-architecture.md`
- Audience: Human developers
- Purpose: Explain WHY (dependency management, nixpkgs-only)

**Skill**: `nix-http-server`
- Location: `skills/nix-http-server/SKILL.md`
- Audience: Claude AI
- Purpose: Enforce HOW (never suggest Python, use Caddy)

## Creating New Skills

### When to Create a Skill

After writing an ADR, create a skill if:
- [ ] Decision involves repetitive implementation patterns
- [ ] AI should automatically enforce constraints
- [ ] Pattern can be automated with templates/scripts
- [ ] You want perfect consistency

### Skill Structure

```
skills/
└── my-skill/
    ├── SKILL.md              # Required: metadata + instructions
    ├── scripts/              # Optional: executable scripts
    │   └── validate.sh
    └── templates/            # Optional: code templates
        └── example.template
```

### SKILL.md Format

```markdown
---
name: skill-identifier
description: When to use this skill (max 1024 chars). Be specific about triggers.
---

# Skill Name

## When to Use

Be specific about what triggers this skill.

## Implementation Pattern

Step-by-step procedures, examples, templates.

## Anti-Patterns (DO NOT DO)

What NOT to do, with examples.

## Related Documentation

Link to corresponding ADR for human context.
```

### Best Practices

✅ **Do**:
- Write clear descriptions that help Claude select the skill
- Provide concrete examples and templates
- Document anti-patterns explicitly
- Keep instructions under 5k tokens
- Link to corresponding ADR

❌ **Don't**:
- Duplicate WHY explanations (that's in ADRs)
- Write overly generic descriptions
- Include unnecessary context in metadata
- Exceed 5k tokens for instructions

## Skill Discovery

Claude Code automatically:
1. Scans `skills/*/SKILL.md` at session start
2. Loads metadata (100 tokens per skill)
3. Selects relevant skills based on task
4. Loads full instructions only for selected skills
5. Accesses resources on-demand via filesystem

**You don't need to manually invoke skills** - Claude does it automatically based on task recognition.

## Examples

See existing skills in this directory:
- `nix-http-server/SKILL.md`
- `revealjs-presentation/SKILL.md`
- `adr-documentation/SKILL.md`

## Resources

- Anthropic Skills Documentation: https://docs.claude.com/en/docs/agents-and-tools/agent-skills
- Skills Repository: https://github.com/anthropics/skills
- This project's ADRs: `docs/adr/`
