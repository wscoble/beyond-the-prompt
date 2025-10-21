---
name: nix-http-server
description: Create HTTP servers for Nix flake projects. Use when serving static files or running development servers. CRITICAL CONSTRAINT - Never suggest Python dependencies.
---

# Nix HTTP Server Skill

## Core Constraint

**NEVER suggest Python-based HTTP servers** (python -m http.server, etc.)
All dependencies MUST come from nixpkgs only.

## When to Use

- User needs to serve static files from a Nix project
- User wants to create development servers
- User needs process orchestration for multiple services
- Project has a flake.nix file

## Implementation Pattern

### 1. Use Caddy for HTTP Serving

Caddy is the approved HTTP server because:
- Available in nixpkgs
- Supports configuration as code
- Better features than simple Python server
- Works with process-compose orchestration

### 2. Configuration Generation

Generate configurations at build time using Nix expressions:

```nix
makeCaddyConfig = pkgs: port: root: pkgs.writeText "Caddyfile" ''
  :${toString port} {
    root * ${root}
    file_server browse
    encode gzip
    log {
      output stdout
      format console
    }
  }
'';
```

OR generate at runtime for development flexibility:

```bash
# Generate Caddyfile at runtime
CADDY_CONFIG=$(mktemp)
cat > "$CADDY_CONFIG" <<EOF
:8000 {
  root * $PWD/presentation
  file_server browse
  encode gzip
}
EOF

caddy run --config "$CADDY_CONFIG" --adapter caddyfile
```

### 3. Process Orchestration

For multiple services, use process-compose:

```nix
makeProcessComposeConfig = pkgs: processes: pkgs.writeText "process-compose.yaml" (
  builtins.toJSON {
    version = "0.5";
    inherit processes;
  }
);
```

### 4. Flake App Pattern

Create apps in flake.nix that:
- Check for required directories in $PWD
- Generate configs at runtime (for dev flexibility)
- Use --tui=false for process-compose (avoids /dev/tty errors)
- Add --adapter caddyfile flag when using Caddyfile format

## Example Implementation

See `/Users/sscoble/Projects/beyond-the-prompt/flake.nix` for working examples:
- `nix run .#present` - Single server
- `nix run .#demo` - Multiple servers with process-compose

## Key Technical Details

### Caddy Flags
- `--config <path>` - Path to config file
- `--adapter caddyfile` - Parse as Caddyfile format (not JSON)
- `run` - Run server (blocking)

### Process-Compose Flags
- `--tui=false` - Disable TUI (required for non-interactive environments)
- `-f <config>` - Config file path

### Runtime Config Pattern
```bash
#!/usr/bin/env bash
set -euo pipefail

# Validate directory exists
CONTENT_ROOT="$PWD/presentation"
if [ ! -d "$CONTENT_ROOT" ]; then
  echo "Error: presentation/ directory not found"
  exit 1
fi

# Generate config at runtime (allows serving from working directory)
CADDY_CONFIG=$(mktemp)
trap "rm -f $CADDY_CONFIG" EXIT

cat > "$CADDY_CONFIG" <<EOF
:8000 {
  root * $CONTENT_ROOT
  file_server browse
  encode gzip
}
EOF

# Run server
caddy run --config "$CADDY_CONFIG" --adapter caddyfile
```

## Anti-Patterns (DO NOT DO)

❌ **Never** suggest `python -m http.server`
❌ **Never** suggest `python3 -m http.server`
❌ **Never** add Python to buildInputs/devShell for HTTP serving
❌ **Never** suggest `npx http-server` (requires Node.js, use nixpkgs)
❌ **Never** hardcode absolute paths in Nix expressions (breaks portability)

## Multi-Platform Support

Always use `forAllSystems` pattern for cross-platform compatibility:

```nix
supportedSystems = [
  "x86_64-linux"
  "aarch64-linux"
  "x86_64-darwin"
  "aarch64-darwin"
];

forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems
  (system: f system (import nixpkgs { inherit system; }));
```

## Related Documentation

Human-readable architectural rationale in: `docs/adr/002-nix-flake-architecture.md`

## Templates

See `templates/` directory for:
- Caddyfile examples
- process-compose.yaml examples
- Flake app script templates
