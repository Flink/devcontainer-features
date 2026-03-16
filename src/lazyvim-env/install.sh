#!/usr/bin/env bash
set -e

# Homebrew absolute path
BREW_PREFIX="/home/linuxbrew/.linuxbrew"
BREW_BIN="${BREW_PREFIX}/bin/brew"

if [ ! -f "${BREW_BIN}" ]; then
  echo "ERROR: Homebrew not found at ${BREW_BIN}. Is the homebrew feature installed?"
  exit 1
fi

# Detect the user who owns Homebrew
USERNAME=$(stat -c '%U' "${BREW_PREFIX}")

# Fallback to _REMOTE_USER if stat fails or returns root
if [ "${USERNAME}" = "root" ] || [ -z "${USERNAME}" ]; then
  USERNAME="${_REMOTE_USER:-"vscode"}"
fi

# Final fallback check
if [ "${USERNAME}" = "root" ]; then
  POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
  for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
    if id -u "${CURRENT_USER}" >/dev/null 2>&1; then
      USERNAME="${CURRENT_USER}"
      break
    fi
  done
fi

echo "Installing LazyVim environment for user: ${USERNAME}"

# Function to run commands as the detected user with Homebrew environment initialized
run_as_user() {
  sudo -u "${USERNAME}" -iH bash -c "eval \"\$(${BREW_BIN} shellenv)\" && $*"
}

# Install core packages via Homebrew
run_as_user "${BREW_BIN}" install neovim luarocks ripgrep claude-code lazygit tree-sitter-cli fd ag btop bat fzf ast-grep gemini-cli oven-sh/bun/bun

# Handle Ruby dependencies
if ! run_as_user command -v ruby &>/dev/null; then
  echo "Installing Ruby via Homebrew..."
  run_as_user "${BREW_BIN}" install ruby
fi

echo "Attempting to install Ruby gems..."
run_as_user gem install syntax_tree neovim || echo "Warning: Failed to install some Ruby gems. Neovim Ruby provider might be missing."

# Handle Node.js
if ! run_as_user command -v node &>/dev/null; then
  echo "Installing Node.js via Homebrew..."
  run_as_user "${BREW_BIN}" install node
fi

echo "LazyVim environment setup complete!"
