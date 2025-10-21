{
  description = "Beyond the Prompt: Lessons from Building with Claude Code";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Systems to support
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # Helper function to generate outputs for all systems
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system (import nixpkgs { inherit system; }));

      # Generate Caddyfile for presentation
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

      # Generate process-compose config
      makeProcessComposeConfig = pkgs: processes: pkgs.writeText "process-compose.yaml" (
        builtins.toJSON {
          version = "0.5";
          inherit processes;
        }
      );

    in
    {
      # Apps for each system
      apps = forAllSystems (system: pkgs: {
        # Presentation server
        present = {
          type = "app";
          program = "${pkgs.writeScript "present" ''
#!/usr/bin/env bash
set -euo pipefail

# Use current working directory for development
PRESENTATION_ROOT="$PWD/presentation"

if [ ! -d "$PRESENTATION_ROOT" ]; then
  echo "Error: presentation/ directory not found in current directory"
  echo "Please run this command from the project root"
  exit 1
fi

# Generate Caddyfile at runtime
CADDY_CONFIG=$(mktemp)
trap "rm -f $CADDY_CONFIG" EXIT
cat > "$CADDY_CONFIG" <<EOF
:8000 {
  root * $PRESENTATION_ROOT
  file_server browse
  encode gzip
  log {
    output stdout
    format console
  }
}
EOF

# Generate process-compose config at runtime
COMPOSE_CONFIG=$(mktemp)
trap "rm -f $COMPOSE_CONFIG" EXIT
cat > "$COMPOSE_CONFIG" <<EOF
{
  "version": "0.5",
  "processes": {
    "presentation": {
      "command": "${pkgs.caddy}/bin/caddy run --config $CADDY_CONFIG --adapter caddyfile",
      "readiness_probe": {
        "http_get": {
          "host": "localhost",
          "port": 8000
        }
      }
    }
  }
}
EOF

echo "Starting presentation server on http://localhost:8000"
exec ${pkgs.process-compose}/bin/process-compose up -f "$COMPOSE_CONFIG" --tui=false
          ''}";
        };

        # Demo: serves both presentation and conversation transcript
        demo = {
          type = "app";
          program = "${pkgs.writeScript "demo" ''
#!/usr/bin/env bash
set -euo pipefail

# Use current working directory for development
PRESENTATION_ROOT="$PWD/presentation"
DEMO_ROOT="$PWD/docs/demo"

if [ ! -d "$PRESENTATION_ROOT" ]; then
  echo "Error: presentation/ directory not found in current directory"
  echo "Please run this command from the project root"
  exit 1
fi

if [ ! -d "$DEMO_ROOT" ]; then
  echo "Error: docs/demo/ directory not found in current directory"
  echo "Please run this command from the project root"
  exit 1
fi

# Generate Caddyfiles at runtime
PRESENTATION_CADDY_CONFIG=$(mktemp)
DEMO_CADDY_CONFIG=$(mktemp)
COMPOSE_CONFIG=$(mktemp)
trap "rm -f $PRESENTATION_CADDY_CONFIG $DEMO_CADDY_CONFIG $COMPOSE_CONFIG" EXIT

cat > "$PRESENTATION_CADDY_CONFIG" <<EOF
:8000 {
  root * $PRESENTATION_ROOT
  file_server browse
  encode gzip
  log {
    output stdout
    format console
  }
}
EOF

cat > "$DEMO_CADDY_CONFIG" <<EOF
:8001 {
  root * $DEMO_ROOT
  file_server browse
  encode gzip
  log {
    output stdout
    format console
  }
}
EOF

# Generate process-compose config at runtime
cat > "$COMPOSE_CONFIG" <<EOF
{
  "version": "0.5",
  "processes": {
    "presentation": {
      "command": "${pkgs.caddy}/bin/caddy run --config $PRESENTATION_CADDY_CONFIG --adapter caddyfile",
      "readiness_probe": {
        "http_get": {
          "host": "localhost",
          "port": 8000
        }
      }
    },
    "conversation": {
      "command": "${pkgs.caddy}/bin/caddy run --config $DEMO_CADDY_CONFIG --adapter caddyfile",
      "readiness_probe": {
        "http_get": {
          "host": "localhost",
          "port": 8001
        }
      }
    }
  }
}
EOF

echo "Starting demo environment:"
echo "  - Presentation: http://localhost:8000"
echo "  - Conversation: http://localhost:8001"
exec ${pkgs.process-compose}/bin/process-compose up -f "$COMPOSE_CONFIG" --tui=false
          ''}";
        };
      });

      # Development shells
      devShells = forAllSystems (system: pkgs: {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.caddy
            pkgs.process-compose
            pkgs.bash
            # Optional tools (uncomment as needed)
            # pkgs.nodejs
            # pkgs.asciinema
            # pkgs.bat
            # pkgs.alejandra  # Nix formatter
          ];

          shellHook = ''
            echo "Welcome to 'Beyond the Prompt' development environment!"
            echo ""
            echo "Available commands:"
            echo "  nix run .#present  - Start presentation server (http://localhost:8000)"
            echo "  nix run .#demo     - Start demo environment (presentation + conversation)"
            echo ""
            echo "Direct development (with live reload):"
            echo "  caddy file-server --root ./presentation --listen :8000"
            echo ""
            echo "Project structure:"
            echo "  docs/adr/       - Architecture Decision Records"
            echo "  presentation/   - Reveal.js presentation files"
            echo "  docs/demo/      - Conversation transcript and demo materials"
            echo ""
          '';
        };
      });
    };
}
