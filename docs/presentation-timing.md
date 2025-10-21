# Presentation Timing Guide
**Target Duration**: 110 minutes total
**Format**: Cumulative timestamps for each slide

---

## Introduction & Setup (15 min total)

| Slide # | Title | Time | Cumulative | Notes |
|---------|-------|------|------------|-------|
| 1 | Beyond the Prompt (Title) | 2 min | 0:02 | Welcome, introduce topic |
| 2 | Who Am I? | 2 min | 0:04 | Brief intro, keep it tight |
| 3 | Let's Dive In (Image) | 0:30 | 0:04:30 | Visual transition only |
| 4 | The Request | 2 min | 0:06:30 | Set up the problem, audience question |
| 5 | So I Asked Claude Code | 1:30 | 0:08 | Bridge to context windows |
| 6 | Part 1: The Problem | 0:30 | 0:08:30 | Section title card |
| 7 | The Context Window Problem | 3 min | 0:11:30 | Audience question about ADRs, relatable |
| 8 | Progressive Disclosure | 4 min | 0:15:30 | Core concept, needs time to land |

---

## Part 1: Context Window Economics (20 min total from start)

| Slide # | Title | Time | Cumulative | Notes |
|---------|-------|------|------------|-------|
| 9 | FLUO's Token Budget | 3 min | 0:18:30 | Show the math, 95% reduction |
| 10 | Quick Check | 2 min | 0:20:30 | Audience calculates their ADRs |

---

## Part 2: The Pattern - Dream Team Story (40 min total from start)

| Slide # | Title | Time | Cumulative | Notes |
|---------|-------|------|------------|-------|
| 11 | Back to Sandboxing | 1 min | 0:21:30 | Remind the problem |
| 12 | Part 2: Building a Dream Team | 1 min | 0:22:30 | Section title, metaphor intro |
| 13 | The Implementer Speaks | 3 min | 0:25:30 | First agent, audience interaction |
| 14 | Round 2: Architecture Guardian | 4 min | 0:29:30 | **KEY SLIDE** - Java 17 deprecation reveal |
| 15 | Round 3: Security Expert | 3 min | 0:32:30 | Security rating, audience question |
| 16 | Round 4: QA Expert | 2 min | 0:34:30 | Testing requirements |
| 17 | Round 5: Product Manager | 4 min | 0:38:30 | **KEY SLIDE** - ROI calculation, decision |
| 18 | The Punchline | 5 min | 0:43:30 | **KEY SLIDE** - 3 days actual, 12 weeks saved |
| 19 | Next Steps | 2 min | 0:45:30 | Transition to Part 3 |

---

## Part 3: How to Build This (50 min total from start)

| Slide # | Title | Time | Cumulative | Notes |
|---------|-------|------|------------|-------|
| 20 | Part 3: How to Build This | 1 min | 0:46:30 | Section title |
| 21 | Your Dream Team | 5 min | 0:51:30 | **KEY SLIDE** - 4 agents, start with 2 |
| 22 | Subagent Anatomy | 8 min | 0:59:30 | **MAJOR SLIDE** - Walk through YAML, Q&A |
| 23 | Skill Anatomy | 7 min | 1:06:30 | **MAJOR SLIDE** - Example code, explain parts |
| 24 | The Evaluation Loop | 5 min | 1:11:30 | Workflow, timing breakdown |
| 25 | Real Numbers from FLUO | 4 min | 1:15:30 | ROI, concrete results |

---

## Closing & Comparison (30 min remaining)

| Slide # | Title | Time | Cumulative | Notes |
|---------|-------|------|------------|-------|
| 26 | FLUO's Results | 2 min | 1:17:30 | Summary stats |
| 27 | The Pattern | 2 min | 1:19:30 | "Evaluate first" principle |
| 28 | Skills vs Subagents | 5 min | 1:24:30 | **KEY SLIDE** - Clarify difference, table |
| 29 | The Three Topics | 3 min | 1:27:30 | Recap the structure |
| 30 | The Real Story | 4 min | 1:31:30 | Circle back to PRD-005 |
| 31 | Try It Yourself | 3 min | 1:34:30 | FLUO repo, getting started |
| 32 | Thank You / Questions | 15:30 | 1:50 | **Q&A** - buffer for audience questions |

---

## Key Time Allocations

**Longest slides (need most time):**
1. **Subagent Anatomy** (8 min) - Walking through code, explaining structure
2. **Skill Anatomy** (7 min) - Concrete example with explanation
3. **Your Dream Team** (5 min) - Critical decision point for audience
4. **The Punchline** (5 min) - Payoff moment, needs to land
5. **Skills vs Subagents** (5 min) - Clarifying core concepts
6. **The Evaluation Loop** (5 min) - Practical workflow

**Story beats that need room:**
- Architecture Guardian catching Java 17 issue (4 min)
- Product Manager ROI calculation (4 min)
- Real Numbers from FLUO (4 min)

**Quick transitions:**
- Section title cards (0:30-1 min each)
- Visual slides (0:30)
- Bridge slides (1-2 min)

---

## Pacing Strategy

**First 20 minutes**: Build the problem (context windows)
- Hook them with relatable pain
- Show the constraint clearly

**Minutes 20-45**: Tell the story (dream team saves the day)
- Drama: almost shipped bad code
- Resolution: team caught it
- Payoff: 3 days vs 12 weeks

**Minutes 45-75**: Teach the specifics (how to build it)
- Slow down here, give them copy-able templates
- This is what they'll use on Monday

**Minutes 75-95**: Wrap up and context (comparison, recap)
- Tie it together
- Answer "where do I start?"

**Minutes 95-110**: Q&A
- Reserve 15 minutes minimum
- Likely to run over if audience is engaged

---

## Emergency Adjustments

**If running long:**
- Skip slide 26 (FLUO's Results) - covered in slide 25
- Shorten Q&A to 10 minutes
- Reduce Subagent/Skill Anatomy by 2 min each

**If running short:**
- Extend Q&A
- Add war stories during Part 2
- Deep dive on Skills vs Subagents table

**Critical slides (never skip):**
- #8: Progressive Disclosure
- #14: Architecture Guardian (Java 17)
- #17: Product Manager (ROI)
- #18: The Punchline
- #22-23: Anatomy slides
- #28: Skills vs Subagents

---

## Checkpoints

- **30 minutes**: Should be at slide 14 (Architecture Guardian)
- **60 minutes**: Should be at slide 22 (Subagent Anatomy)
- **90 minutes**: Should be at slide 30 (The Real Story)
- **95 minutes**: Start Q&A

If you're behind at any checkpoint, tighten up the next section. If ahead, add stories or extend Q&A.
