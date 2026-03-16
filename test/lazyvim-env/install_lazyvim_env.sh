#!/bin/bash
set -e

echo "Running LazyVim Environment tests..."

# Check nvim
if nvim --version; then
    echo "PASS: nvim is installed"
else
    echo "FAIL: nvim is not installed"
    exit 1
fi

# Check ripgrep
if rg --version; then
    echo "PASS: ripgrep is installed"
else
    echo "FAIL: ripgrep is not installed"
    exit 1
fi

# Check Node and Ruby
if node --version; then
    echo "PASS: node is installed"
else
    echo "FAIL: node is not installed"
    exit 1
fi

if ruby --version; then
    echo "PASS: ruby is installed"
else
    echo "FAIL: ruby is not installed"
    exit 1
fi

echo "All tests passed!"
