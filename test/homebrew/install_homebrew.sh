#!/bin/bash
set -e

echo "Running Homebrew tests..."

# Check brew version
if brew --version; then
    echo "PASS: brew version"
else
    echo "FAIL: brew version"
    exit 1
fi

# Check HOMEBREW_PREFIX
if echo $HOMEBREW_PREFIX | grep "/home/linuxbrew/.linuxbrew"; then
    echo "PASS: HOMEBREW_PREFIX is correct"
else
    echo "FAIL: HOMEBREW_PREFIX is incorrect ($HOMEBREW_PREFIX)"
    exit 1
fi

echo "All tests passed!"
