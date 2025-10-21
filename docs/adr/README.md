# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) for the "Beyond the Prompt" presentation project.

## Purpose: Human Documentation

**ADRs are for humans, not AI.** They explain WHY architectural decisions were made, document alternatives considered, and preserve historical context for team members.

**For AI implementation guidance**, see the `/skills` directory. Skills encode HOW to implement the decisions documented in ADRs.

## Index

1. [ADR 001: Presentation Technology Choice](./001-presentation-technology.md) → *Skill: `revealjs-presentation`*
   - Decision to use Reveal.js for the presentation
   - Rationale, alternatives, and implementation approach

2. [ADR 002: Nix Flake Architecture](./002-nix-flake-architecture.md) → *Skill: `nix-http-server`*
   - Multi-platform flake design
   - App structure and devShell configuration
   - **Key constraint**: No Python dependencies

3. [ADR 003: Demo Implementation Strategy](./003-demo-implementation-strategy.md) → *Skill: `adr-documentation`*
   - Conversation-as-demo approach
   - Meta-awareness and documentation strategy

## ADR Format

Each ADR follows this structure:
- **Status**: Proposed, Accepted, Deprecated, Superseded
- **Context**: The problem or situation
- **Decision**: What was decided
- **Rationale**: Why this decision was made (including alternatives)
- **Consequences**: Positive, negative, and mitigations

## When to Write an ADR

Create an ADR when making architectural decisions that:
- Affect multiple parts of the system
- Have long-term implications
- Involve trade-offs between alternatives
- Need to be communicated to future contributors

**After writing an ADR**, consider creating a corresponding **Skill** if:
- The decision involves repetitive implementation patterns
- AI should automatically enforce the decision's constraints
- The pattern can be automated with templates/scripts
- You want perfect consistency in implementation

## The ADR + Skill Pattern

```
Make Decision
     ↓
┌────┴────┐
▼         ▼
ADR     Skill
↓         ↓
WHY     HOW
Human    AI
```

**Example**: ADR 002 documents WHY we chose Caddy (no Python constraint). The `nix-http-server` skill enforces this by NEVER suggesting Python servers.

## Context Efficiency

**Old approach**: Load ADRs into AI context
- 3 ADRs × 1,500 tokens = 4,500 tokens before writing code
- Doesn't scale beyond ~10-20 ADRs

**New approach**: Use Skills for AI, ADRs for humans
- 3 skills × 100 tokens metadata = 300 tokens
- Scales to 100s of patterns
- ADRs remain available for human readers

## Updating ADRs

ADRs are immutable once accepted. To change a decision:
1. Create a new ADR that supersedes the old one
2. Update the old ADR's status to "Superseded by ADR XXX"
3. Update or create corresponding skill to reflect new implementation pattern
