#!/usr/bin/env bash
# ===========================================================================
# install-pi-packages.sh
# ===========================================================================
# Bootstrap pi-coding-agent and its ecosystem packages for GengsuWiki.
# Designed to work on Windows (Git Bash / WSL), Linux, and macOS.
#
# Run from the repo root:
#   bash .pi/install-pi-packages.sh
#
# What it does:
#   1. Installs (or updates) @earendil-works/pi-coding-agent globally via npm
#   2. Installs pi ecosystem packages via `pi install npm:<pkg>`
#      (installed at user level ~/.pi/agent/npm/, NOT repo-local)
#   3. Prints setup summary (local extensions, skills, context files)
#
# Repository-local resources (already in .pi/):
#   - .pi/extensions/     – pi extensions auto-discovered at startup
#   - .opencode/Skills/   – skills loaded via .pi/settings.json
#   - AGENTS.md/CLAUDE.md – context files loaded automatically
# ===========================================================================

set -euo pipefail

# ── Colors ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()  { printf "${CYAN}[INFO]${NC}  %s\n" "$*"; }
ok()    { printf "${GREEN}[OK]${NC}    %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${NC}  %s\n" "$*"; }
err()   { printf "${RED}[ERROR]${NC} %s\n" "$*"; }

# ── Detect OS ──────────────────────────────────────────────────────────────
case "$(uname -s)" in
  Linux*)   OS=linux;;
  Darwin*)  OS=mac;;
  CYGWIN*|MINGW*|MSYS*) OS=windows;;
  *)
    warn "Unknown OS: $(uname -s). Assuming Linux-like."
    OS=linux;;
esac
info "Detected OS: ${OS}"

# ── 1. Ensure Node.js and npm are installed ────────────────────────────────
if ! command -v node &>/dev/null; then
  err "Node.js is not installed. Please install Node.js v18 or later."
  err "  https://nodejs.org/en/download/"
  exit 1
fi
if ! command -v npm &>/dev/null; then
  err "npm is not installed (it usually comes with Node.js)."
  exit 1
fi

NODE_VER="$(node -v)"
NPM_VER="$(npm -v)"
info "Node.js ${NODE_VER}  |  npm ${NPM_VER}"

# ── 2. Install / update pi-coding-agent globally ───────────────────────────
info "Step 1/2 — Installing / updating @earendil-works/pi-coding-agent globally..."
npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# Try to locate the pi CLI
if ! command -v pi &>/dev/null; then
  warn "'pi' command not found in PATH after global install."

  # Check common global bin directories
  case "${OS}" in
    windows)
      NPM_PREFIX="$(npm config get prefix 2>/dev/null || echo "$APPDATA/npm")"
      warn "Try adding this to your PATH:"
      warn "  export PATH=\"${NPM_PREFIX}:\$PATH\""
      warn "Add it to ~/.bashrc (or ~/.zshrc) to persist across sessions."
      # Try with the discovered prefix
      export PATH="${NPM_PREFIX}:${PATH}"
      ;;
    *)
      NPM_PREFIX="$(npm config get prefix 2>/dev/null || echo "/usr/local")"
      export PATH="${NPM_PREFIX}/bin:${PATH}"
      ;;
  esac

  if command -v pi &>/dev/null; then
    ok "pi CLI found after adding global bin to PATH."
  else
    err "pi CLI still not in PATH. Add npm's global bin directory to your PATH"
    err "and re-run this script."
    exit 1
  fi
fi

PI_VER="$(pi --version 2>/dev/null || echo "unknown")"
ok "pi-coding-agent ${PI_VER}"

# ── 3. Install pi ecosystem packages (user-level) ──────────────────────────
info "Step 2/2 — Installing pi ecosystem packages..."
echo ""

PI_PACKAGES=(  
 "npm:context-mode"
  "npm:pi-web-access"
  "npm:@plannotator/pi-extension"
  "npm:pi-studio"
)

for pkg in "${PI_PACKAGES[@]}"; do
  pkg_name="${pkg#npm:}"
  if pi list 2>/dev/null | grep -qiF "${pkg_name}"; then
    ok "Already installed: ${pkg_name}"
  else
    info "Installing ${pkg}..."
    pi install "${pkg}"
    ok "Installed: ${pkg_name}"
  fi
done

# ── Done ───────────────────────────────────────────────────────────────────
echo ""
ok "All packages installed successfully!"
echo ""
echo "─────────────────────────────────────────────────────────────"
echo "  Repo-local resources (already in place, no install needed)"
echo "─────────────────────────────────────────────────────────────"
echo ""
echo "  Local extensions (auto-discovered by pi):"
echo "    .pi/extensions/"
echo "      └─ graphify-gate.ts  — knowledge graph gate"
echo "      └─ utils.ts          — /vscode, /code commands"
echo ""
echo "  Skills (loaded via .pi/settings.json):"
echo "    .opencode/Skills/"
for skill in "$(dirname "$0")/../.opencode/Skills/"*/; do
  [ -d "$skill" ] && echo "      └─ $(basename "$skill")"
done
echo ""
echo "  Context files (auto-loaded by pi and Claude Code):"
echo "    AGENTS.md  (symlinked as CLAUDE.md)"
echo ""
echo "  Settings:"
echo "    .pi/settings.json"
echo ""
echo "─────────────────────────────────────────────────────────────"
echo "  Installed packages:"
echo "─────────────────────────────────────────────────────────────"
pi list 2>/dev/null || true
echo ""
info "Ready. Run 'pi' to start working."
