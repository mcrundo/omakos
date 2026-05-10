#!/bin/bash

set -e

source ./scripts/utils.sh

# Ensure ~/.ssh exists with correct permissions
if [ ! -d "$HOME/.ssh" ]; then
  step "Creating .ssh directory..."
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  print_success ".ssh directory created"
fi

# Install SSH config
step "Installing SSH config..."
if [ ! -f "$HOME/.ssh/config" ]; then
  cp ./configs/ssh/config "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
  print_success "SSH config installed"
elif files_are_identical "$HOME/.ssh/config" "./configs/ssh/config"; then
  print_success_muted "SSH config already up to date"
elif confirm_override "$HOME/.ssh/config" "./configs/ssh/config" "SSH config"; then
  cp ./configs/ssh/config "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
  print_success "SSH config updated"
else
  print_success_muted "SSH config skipped"
fi

# Generate an ed25519 key if one doesn't exist
ssh_key="$HOME/.ssh/id_ed25519"
if [ -f "$ssh_key" ]; then
  print_success_muted "SSH key already exists at $ssh_key"
else
  if [ -z "${GIT_EMAIL:-}" ]; then
    print_warning "GIT_EMAIL not set; skipping SSH key generation"
  else
    step "Generating SSH key (ed25519)..."
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$ssh_key" -N ""
    chmod 600 "$ssh_key"
    chmod 644 "$ssh_key.pub"
    print_success "SSH key generated"
  fi
fi

# Add the key to the agent, storing the passphrase (if any) in the Keychain
if [ -f "$ssh_key" ]; then
  step "Adding SSH key to ssh-agent..."
  ssh-add --apple-use-keychain "$ssh_key" 2>/dev/null || true
  print_success_muted "SSH key added to agent"

  if [ -n "${GITHUB_USER:-}" ]; then
    echo ""
    print_muted "Add this public key to your GitHub account (${GITHUB_USER}):"
    print_muted "  https://github.com/settings/ssh/new"
  else
    echo ""
    print_muted "Add this public key to your GitHub account:"
    print_muted "  https://github.com/settings/ssh/new"
  fi
  echo ""
  cat "$ssh_key.pub"
  echo ""
fi
