---
name: adr-documentation
description: Create and maintain Architecture Decision Records (ADRs) for human documentation. Use when documenting architectural decisions, not for AI implementation guidance.
---

# ADR Documentation Skill

## Purpose

ADRs (Architecture Decision Records) are **human documentation** that explain WHY architectural decisions were made. They are NOT for AI implementation guidance - that's what skills are for.

## When to Use

- Documenting a significant architectural decision
- Explaining technology choices to team members
- Creating governance artifacts for reviews
- Preserving historical context for future maintainers

## When NOT to Use

❌ Don't create ADRs for AI to consume as implementation guidance
✅ Instead, create a **skill** that encodes the decision as executable instructions

## ADR Structure

```markdown
# ADR NNN: Title

## Status

[Proposed | Accepted | Deprecated | Superseded by ADR-XXX]

## Context

What is the issue/situation that motivates this decision?
- What problems are we trying to solve?
- What constraints exist?
- What is the current state?

## Decision

What did we decide to do?

Be specific and concrete. This should be implementable.

## Rationale

Why did we make this decision?

### Alternatives Considered

What other options did we evaluate and why were they rejected?

1. **Alternative A**
   - Pros: ...
   - Cons: ...
   - Reason for rejection: ...

2. **Alternative B**
   - Pros: ...
   - Cons: ...
   - Reason for rejection: ...

## Consequences

### Positive
- What benefits does this decision provide?
- What problems does it solve?

### Negative
- What are the downsides or trade-offs?
- What new problems might this create?

### Mitigations
- How can we address the negative consequences?
- What can we do to minimize downsides?

## Implementation Notes

(Optional) High-level guidance for implementation, but detailed procedures belong in skills, not ADRs.

## Related

- Links to related ADRs
- Links to corresponding skills
- External documentation
```

## ADR Numbering

Use sequential zero-padded numbers:
- `001-first-decision.md`
- `002-second-decision.md`
- `010-tenth-decision.md`

## ADR Lifecycle

1. **Proposed** - Under discussion, not yet accepted
2. **Accepted** - Decision is made and active
3. **Deprecated** - No longer recommended but not superseded
4. **Superseded** - Replaced by a newer ADR (reference it)

**Important**: Never delete ADRs. They preserve historical context.

## Directory Structure

```
docs/
└── adr/
    ├── README.md              # Index and overview
    ├── 001-first.md
    ├── 002-second.md
    └── 003-third.md
```

## Relationship to Skills

**The Modern Pattern**:

```
┌──────────────────────────────────────┐
│  Make Architectural Decision        │
└────────────┬─────────────────────────┘
             │
    ┌────────┴────────┐
    ▼                 ▼
┌──────────┐      ┌─────────┐
│ ADR      │      │ Skill   │
│ (Human)  │      │ (AI)    │
└──────────┘      └─────────┘
    │                 │
    ▼                 ▼
  Explains WHY    Implements HOW
  For humans      For AI
  In docs/adr/    In skills/
```

### Example Integration

**ADR 002**: "Use Caddy for HTTP serving, not Python"
- Location: `docs/adr/002-nix-flake-architecture.md`
- Purpose: Explain WHY we chose Caddy
- Audience: Human developers
- Document: Rationale, alternatives, consequences

**Skill**: `nix-http-server`
- Location: `skills/nix-http-server/SKILL.md`
- Purpose: Automate Caddy server creation, enforce no-Python constraint
- Audience: Claude AI
- Contains: Step-by-step procedures, templates, validation scripts

## ADR Template

See `docs/adr/template.md` for a starter template (if it exists), or use the structure above.

## Best Practices

### Writing Effective ADRs

✅ **Do**:
- Focus on WHY, not HOW
- Document alternatives considered
- Be honest about trade-offs
- Use clear, simple language
- Include concrete examples
- Link to related decisions

❌ **Don't**:
- Document implementation details (use skills instead)
- Write ADRs that AI should consume
- Delete old ADRs (mark as Superseded instead)
- Make decisions in ADRs that should be skills
- Use jargon without explanation

### Context Window Efficiency

**Old pattern** (inefficient):
- ADR contains both WHY and detailed HOW
- AI must load entire ADR into context (500-2000 tokens)
- Doesn't scale beyond ~10-20 ADRs

**New pattern** (efficient):
- ADR contains only WHY (for humans)
- Skill contains HOW (for AI, ~100 tokens metadata)
- Scales to hundreds of patterns

## Validation

When creating or updating an ADR, ensure:

- [ ] Status is one of: Proposed, Accepted, Deprecated, Superseded
- [ ] All sections are present and filled out
- [ ] Alternatives are documented with pros/cons
- [ ] Consequences (positive AND negative) are listed
- [ ] Related ADRs/skills are linked
- [ ] Decision is specific and actionable
- [ ] Language is clear and accessible

## Examples

See existing ADRs in this repository:
- `docs/adr/001-presentation-technology.md` (→ corresponds to `revealjs-presentation` skill)
- `docs/adr/002-nix-flake-architecture.md` (→ corresponds to `nix-http-server` skill)
- `docs/adr/003-demo-implementation-strategy.md` (→ corresponds to this skill)

## Creating a Corresponding Skill

After creating an ADR, ask:

**"Should this have a corresponding skill?"**

If YES to any:
- Does this decision involve repetitive implementation patterns?
- Should AI automatically apply these standards?
- Can this be automated with scripts/templates?
- Do we want perfect consistency in implementation?

Then create a skill in `skills/<name>/SKILL.md` that:
- References the ADR for context
- Provides step-by-step implementation procedures
- Includes templates and examples
- Enforces the constraints from the ADR

## Related Documentation

- `docs/adr/README.md` - Index of all ADRs
- `skills/` - Corresponding AI implementation skills
