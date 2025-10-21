# ADR 002: Nix Flake Architecture

## Status
Proposed

## Context
The project needs a Nix flake that:
- Provides reproducible development environment
- Defines two runnable apps: `present` and `demo`
- Supports multiple platforms (Linux and macOS, both x64 and ARM)
- Minimizes complexity while providing good developer experience
- Follows Nix best practices

## Decision
Implement a multi-platform flake with `forAllSystems` helper, separate apps for presentation and demo, and a comprehensive devShell.

## Architecture

### System Support
```nix
supportedSystems = [
  "x86_64-linux"
  "aarch64-linux"
  "x86_64-darwin"
  "aarch64-darwin"
];
```

### Core Outputs

1. **apps.present**
   - Type: `app`
   - Function: Serve presentation on http://localhost:8000
   - Implementation: process-compose orchestrating Caddy server
   - Configuration: Nix-generated Caddyfile and process-compose.yaml

2. **apps.demo**
   - Type: `app`
   - Function: Execute demonstration script
   - Implementation: process-compose orchestrating demo processes
   - Configuration: Nix-generated process-compose.yaml for demo services

3. **devShells.default**
   - Purpose: Development environment with all necessary tools
   - Contents: bash, caddy, process-compose, and optional tools (asciinema, etc.)
   - Shell hook: Display helpful usage instructions

## Rationale

### Multi-Platform with forAllSystems
**Why**: Developers use various platforms; presentation should work everywhere
**How**: Use `nixpkgs.lib.genAttrs` to generate outputs for all systems
**Alternative**: Single-platform support would exclude contributors

### Separate Apps vs Unified Interface
**Decision**: Two separate apps (`present` and `demo`)
**Why**:
- Clear separation of concerns
- Can run independently
- Better UX (`nix run .#present` is more explicit than `nix run . -- present`)

**Alternative considered**: Single app with subcommands
- Would require argument parsing
- More complex implementation
- Less idiomatic for Nix

### writeScript vs Packages
**Decision**: Use `pkgs.writeScript` for app wrappers
**Why**:
- Simple bash scripts don't need full package machinery
- Reduces boilerplate
- Direct access to flake's `self` reference
- Easier to maintain

**Alternative**: Proper derivations with `stdenv.mkDerivation`
- Overkill for simple wrappers
- More complex to reference source files

### HTTP Server and Process Management
**Decision**: Use **Caddy** for HTTP serving, orchestrated by **process-compose**

**Architecture**:
- **Caddy**: Modern HTTP server with automatic HTTPS, JSON API, config reloading
- **process-compose**: Process orchestrator (alternative to docker-compose for processes)
- **Configuration**: Generated via Nix expressions, no manual config files

**Why Caddy**:
- Configuration as code via Nix
- JSON/Caddyfile generation from Nix expressions
- Powerful features (reverse proxy, file server, API)
- Good developer experience
- Available in nixpkgs

**Why process-compose**:
- Orchestrates multiple services (presentation server, potential demo services)
- YAML config generated from Nix
- Terminal UI for monitoring processes
- Graceful shutdown and dependency management
- Better than ad-hoc bash scripts for multi-process apps

**Configuration Strategy**:
```nix
# Generate Caddyfile
caddyConfig = pkgs.writeText "Caddyfile" ''
  :8000 {
    root * ${self}/presentation
    file_server
    encode gzip
  }
'';

# Generate process-compose config
processComposeConfig = pkgs.writeText "process-compose.yaml" (builtins.toJSON {
  processes = {
    presentation = {
      command = "${pkgs.caddy}/bin/caddy run --config ${caddyConfig}";
      readiness_probe = {
        http_get = {
          host = "localhost";
          port = 8000;
        };
      };
    };
  };
});
```

### DevShell Philosophy
**Decision**: Include common tools, comment optional ones
**Why**:
- Balance between "batteries included" and minimalism
- Comments serve as documentation
- Easy to uncomment tools as needed
- Shell hook provides guidance

## Implementation Details

### Flake Structure
```nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ ... ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems
        (system: f system (import nixpkgs { inherit system; }));
    in {
      apps = forAllSystems (system: pkgs: { ... });
      devShells = forAllSystems (system: pkgs: { ... });
    };
}
```

### App Implementation Pattern
```nix
present = {
  type = "app";
  program = "${pkgs.writeScript "present" ''
    #!/usr/bin/env bash
    exec ${pkgs.process-compose}/bin/process-compose \
      up -f ${processComposeConfig}
  ''}";
};
```

### Configuration File Generation

**Caddy Configuration** (Caddyfile):
```nix
caddyConfig = pkgs.writeText "Caddyfile" ''
  :8000 {
    root * ${self}/presentation
    file_server browse
    encode gzip
    log {
      output stdout
      format console
    }
  }
'';
```

**process-compose Configuration** (YAML via JSON):
```nix
# YAML generation using builtins.toJSON for structured config
processComposeConfig = pkgs.writeText "process-compose.yaml" (
  builtins.toJSON {
    version = "0.5";
    processes = {
      caddy = {
        command = "${pkgs.caddy}/bin/caddy run --config ${caddyConfig}";
        readiness_probe = {
          http_get = {
            host = "localhost";
            port = 8000;
          };
        };
      };
    };
  }
);
```

### Source File References
- Presentation: `${self}/presentation`
- Demo files: `${self}/demo/`
- Configs are generated, not stored in repo

## Consequences

### Positive
- Reproducible across all major platforms
- Configuration as code (no manual config files)
- Process orchestration with monitoring UI
- Clean separation: presentation vs demo
- Graceful shutdown and process management
- Readiness probes ensure services are up
- All dependencies from nixpkgs

### Negative
- process-compose adds complexity vs simple HTTP server
- Files copied to Nix store (not live-reloaded during development)
- Need to re-run `nix run` after file changes
- YAML generation via JSON (no native YAML in Nix)

### Mitigation
- Complexity justified by better orchestration and monitoring
- For rapid iteration, use devShell with direct commands:
  ```bash
  nix develop
  # Then run Caddy directly for live development:
  caddy run --config <(echo ':8000 { root * ./presentation; file_server }')
  ```
- process-compose TUI provides visibility into running services
- JSON→YAML conversion is transparent and well-tested

## Future Considerations
- Add `checks` output for presentation validation (broken links, etc.)
- Add `packages` output for static site generation
- Consider `nix flake init` template for similar presentations
- Add formatter (e.g., alejandra) to devShell
- Explore Caddy admin API for dynamic config updates
- Add hot-reload capability using Caddy's config API
- Consider additional process-compose processes for demo infrastructure
