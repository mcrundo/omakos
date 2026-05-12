#! /bin/bash

set -e

source ./scripts/utils.sh

step "Installing Homebrew packages from configs/Brewfile"
echo ""
echo "--------------------------------------------------------"
# --verbose prints each formula's install output (downloads, build steps).
# Without it, slow installs look hung because brew bundle goes quiet for
# minutes while a single package compiles or downloads.
# || true keeps the script alive on individual failures — we summarize them below.
brew bundle --file=configs/Brewfile --verbose || true
echo "--------------------------------------------------------"

# Summarize what (if anything) failed. `brew bundle check` exits non-zero
# and lists the missing entries when any Brewfile item isn't installed.
echo ""
step "Verifying install..."
check_log=$(mktemp)
trap 'rm -f "$check_log"' EXIT

if brew bundle check --file=configs/Brewfile --verbose >"$check_log" 2>&1; then
  print_success "All Homebrew packages installed!"
else
  print_warning "Some Brewfile entries failed to install:"
  echo ""
  # `bundle check --verbose` prints lines like:
  #   "→ Cask foo needs to be installed or updated."
  #   "→ Formula bar needs to be installed or updated."
  # Extract the kind + name for a tidy list.
  grep -E "(Cask|Formula|Tap|Brew) .* needs to be installed" "$check_log" \
    | sed -E 's/^[^A-Za-z]*(Cask|Formula|Tap|Brew) (.+) needs to be installed.*$/    - \1: \2/' \
    | sort -u
  echo ""
  print_muted "Retry an individual entry with: brew install <name>  (add --cask for casks)"
fi