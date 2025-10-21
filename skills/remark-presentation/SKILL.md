---
name: remark-presentation
description: Create Remark.js markdown-based presentations for technical talks. Use when building slide decks from markdown files. Optimized for large screens and code-heavy content.
---

# Remark.js Presentation Skill

## When to Use

- User needs to create a presentation or slide deck
- User wants markdown-based presentations (easy to version control)
- User needs technical presentations with lots of code
- User wants simple, minimal presentation framework

## Technology Choice

**Use Remark.js** (markdown-driven slideshow) because:
- Pure markdown content - extremely simple
- No build process - just HTML + markdown file
- Excellent code highlighting
- Works perfectly with version control
- Very lightweight

## Basic Structure

**index.html**:
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Presentation Title</title>
    <link rel="stylesheet" href="assets/theme.css">
</head>
<body>
    <script src="https://remarkjs.com/downloads/remark-latest.min.js"></script>
    <script>
        var slideshow = remark.create({
            sourceUrl: 'slides.md',
            highlightStyle: 'monokai',
            highlightLines: true,
            ratio: '16:9'
        });
    </script>
</body>
</html>
```

**slides.md**:
```markdown
class: center, middle

# Presentation Title

Subtitle

---

# Slide Title

Content

- Point 1
- Point 2

---

# Code

\`\`\`nix
{ apps.present = ...; }
\`\`\`
```

## Slide Separators

- `---` creates new slide
- `--` creates incremental reveal
- `???` adds presenter notes

## Large Screen Optimization (100" at 15ft)

```css
body { font-size: 38px; }
h1 { font-size: 3em; }
h2 { font-size: 2.5em; }
```

## Related Documentation

See: `docs/adr/001-presentation-technology.md`
