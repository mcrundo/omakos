#! /bin/bash

set -e

source ./scripts/utils.sh

step "Installing Homebrew packages from configs/Brewfile"
echo ""
echo "--------------------------------------------------------"
# --verbose prints each formula's install output (downloads, build steps).
# Without it, slow installs look hung because brew bundle goes quiet for
# minutes while a single package compiles or downloads.
brew bundle --file=configs/Brewfile --verbose
echo "--------------------------------------------------------"
print_success "Homebrew packages installed!"