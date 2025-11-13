#!/usr/bin/env bash

sudo -u \#1000 -iH brew install neovim luarocks ripgrep claude-code lazygit tree-sitter-cli fd ag btop bat fzf ast-grep

if command -v gem &>/dev/null; then
  gem install syntax_tree neovim
else
  sudo -u \#1000 -iH brew install ruby
  sudo -u \#1000 -iH gem install syntax_tree neovim
fi

if command -v node &>/dev/null; then
  echo "Node is already installed"
else
  sudo -u \#1000 -iH brew install node
fi
