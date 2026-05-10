#!/bin/bash

set -e

source ./scripts/utils.sh

# Check VS Code is installed via Homebrew
if ! brew list --cask 2>/dev/null | grep -q "^visual-studio-code$"; then
  print_error "VS Code is not installed. Please ensure it was installed via Homebrew."
  exit 1
fi

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

step "Setting up VS Code configuration directory..."
mkdir -p "$VSCODE_USER_DIR"

# Backup existing settings if present
if [ -f "$VSCODE_USER_DIR/settings.json" ]; then
  cp "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR/settings.json.backup"
  print_success_muted "Backed up existing settings.json"
fi

step "Installing VS Code settings..."
cp configs/vscode/settings.json "$VSCODE_USER_DIR/settings.json"
print_success "VS Code settings installed"

# Install extensions from the manifest
if [ -f configs/vscode/extensions.txt ] && command -v code &>/dev/null; then
  step "Installing VS Code extensions..."
  while IFS= read -r ext; do
    [ -z "$ext" ] && continue
    [[ "$ext" == \#* ]] && continue
    code --install-extension "$ext" --force >/dev/null 2>&1 \
      && print_success_muted "Installed $ext" \
      || print_warning "Failed to install $ext"
  done < configs/vscode/extensions.txt
elif ! command -v code &>/dev/null; then
  print_warning "'code' CLI not on PATH; skipping extension install. Run \"Shell Command: Install 'code' command in PATH\" from VS Code and re-run this script."
fi

print_success "VS Code setup completed!"
