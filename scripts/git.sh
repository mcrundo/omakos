#!/bin/bash

set -e

source ./scripts/utils.sh

if ! command -v git &>/dev/null; then
  print_error "Git is not installed. Please install Git first."
  exit 1
fi

if [ -z "${GIT_NAME:-}" ] || [ -z "${GIT_EMAIL:-}" ]; then
  print_error "GIT_NAME and GIT_EMAIL must be set (setup.sh prompts for them)."
  exit 1
fi

if [ ! -f "configs/git/gitconfig" ]; then
  print_error "No gitconfig template found at configs/git/gitconfig."
  exit 1
fi

# Render the template to a temp file so we can diff/copy idempotently.
rendered=$(mktemp)
trap 'rm -f "$rendered"' EXIT
envsubst < configs/git/gitconfig > "$rendered"

if [ ! -f "$HOME/.gitconfig" ]; then
  print_muted "Installing .gitconfig (name: $GIT_NAME, email: $GIT_EMAIL)..."
  cp "$rendered" "$HOME/.gitconfig"
  print_success "Git configuration installed"
elif files_are_identical "$HOME/.gitconfig" "$rendered"; then
  print_success_muted "Git configuration already up to date"
elif confirm_override "$HOME/.gitconfig" "$rendered" ".gitconfig file"; then
  cp "$rendered" "$HOME/.gitconfig"
  print_success "Git configuration updated"
else
  print_success_muted "Git configuration skipped"
fi
