#!/bin/bash

###############################################################################
# ERROR: Let the user know if the script fails
###############################################################################

# Exit handler - runs if script fails
trap 'if [ $? -ne 0 ]; then
  echo -e "\n   ❌ Omakos setup failed"
  exit $?
fi' EXIT

set -e

# Source utility functions
source ./scripts/utils.sh

chapter() {
  local fmt="$1"
  shift
  printf "\n✦  ${bold}$((count++)). $fmt${normal}\n└─────────────────────────────────────────────────────○\n" "$@"
}

###############################################################################
# Initial Ascii Art and Introduction
###############################################################################

source ./scripts/ascii.sh

printf "\nWelcome to Omakos! 🚀\n"
printf "Omakos turns your new mac laptop into a full configured development system in a single command.\n"
printf "It is safe to rerun this multiple times.\n"
printf "You can cancel at any time by pressing ctrl+c.\n"
printf "Let's get started!\n"

###############################################################################
# CHECK: Internet
###############################################################################
chapter "Checking internet connection…"
check_internet_connection

###############################################################################
# PROMPT: Password
###############################################################################
chapter "Caching password…"
ask_for_sudo

###############################################################################
# PROMPT: User info
###############################################################################
# Each prompt is skipped if the corresponding env var is already set, so this
# script can run non-interactively via:
#   GIT_NAME=... GIT_EMAIL=... GITHUB_USER=... MAC_HOSTNAME=... ./setup.sh
# Otherwise we offer existing values (git config, gh auth, scutil) as defaults
# so re-runs become Enter-to-accept.
chapter "Gathering user info…"
prompt_or_env GIT_NAME     "Git display name" "$(git config --global user.name  2>/dev/null)"
prompt_or_env GIT_EMAIL    "Git email"        "$(git config --global user.email 2>/dev/null)"
prompt_or_env GITHUB_USER  "GitHub username"  "$(gh api user --jq .login        2>/dev/null)"
prompt_or_env MAC_HOSTNAME "Computer hostname (e.g. matts-work-mac)" "$(scutil --get LocalHostName 2>/dev/null || echo 'mac')"

###############################################################################
# INSTALL: Dependencies
###############################################################################
chapter "Installing Dependencies…"

# -----------------------------------------------------------------------------
# XCode Command Line Tools
# -----------------------------------------------------------------------------
# We use xcode-select --install rather than softwareupdate because the latter's
# --list regex matching is fragile and frequently produces false positives
# (reporting "already installed" when git/clang are missing). xcode-select
# pops a GUI installer; the script polls until git becomes available.
clt_path=$(xcode-select -p 2>/dev/null || true)
if [ -n "$clt_path" ] && [ -x "$clt_path/usr/bin/git" ]; then
  print_success_muted 'Command Line Tools already installed.'
else
  step 'Installing Command Line Tools...'
  print_warning 'A GUI dialog will appear shortly. Click "Install" and accept the license.'
  xcode-select --install 2>/dev/null || true

  print_muted 'Waiting for Command Line Tools install to complete (this can take 5-10 minutes)...'
  while ! { clt_path=$(xcode-select -p 2>/dev/null) && [ -x "$clt_path/usr/bin/git" ]; }; do
    sleep 10
  done
  print_success 'Command Line Tools installed.'
fi

# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------
if ! [ -x "$(command -v brew)" ]; then
  step "Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ "$(uname -m)" == "arm64" ]]; then
    # Apple Silicon M1/M2 Macs
    export PATH=/opt/homebrew/bin:$PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    # Intel Macs
    export PATH=/usr/local/bin:$PATH
  fi
  print_success "Homebrew installed!"
else
  print_success_muted "Homebrew already installed. Updating Homebrew formulae…"
  brew update --quiet >/dev/null 2>&1
fi

###############################################################################
# INSTALL: Homebrew Packages
###############################################################################
chapter "Installing Homebrew Packages…"
source ./scripts/brew.sh

###############################################################################
# INSTALL: Setup ZSH and oh-my-zsh
###############################################################################
chapter "Setting up ZSH…"
source ./scripts/zsh.sh

###############################################################################
# SETUP: VS Code
###############################################################################
chapter "Setting up VS Code…"
source ./scripts/vscode.sh

###############################################################################
# SETUP: Git
###############################################################################
chapter "Setting up Git…"
source ./scripts/git.sh

###############################################################################
# SETUP: SSH
###############################################################################
chapter "Setting up SSH…"
source ./scripts/ssh.sh

###############################################################################
# SETUP: Rubocop
###############################################################################
chapter "Setting up Rubocop…"
source ./scripts/rubocop.sh

###############################################################################
# SETUP: Gemrc
###############################################################################
chapter "Setting up Gem configuration…"
source ./scripts/gemrc.sh

###############################################################################
# SETUP: IRB
###############################################################################
chapter "Setting up IRB configuration…"
source ./scripts/irbrc.sh

###############################################################################
# SETUP: Zshrc
###############################################################################
chapter "Setting up Zsh configuration…"
source ./scripts/zshrc.sh

###############################################################################
# SETUP: iTerm2
###############################################################################
chapter "Setting up iTerm2…"
source ./scripts/iterm2.sh

###############################################################################
# SETUP: Development Tools with mise
###############################################################################
chapter "Setting up Development Tools…"
source ./scripts/mise.sh

###############################################################################
# SETUP: Mac Settings
###############################################################################
chapter "Setting up Mac Settings…"
source ./scripts/mac.sh

###############################################################################
# SETUP: Login Items
###############################################################################
chapter "Registering login items…"
source ./scripts/login_items.sh

###############################################################################
# SETUP: Complete
###############################################################################
chapter "Setup Complete!"
print_success "Your Mac is now ready to use! 🎉"
print_success_muted "You may need to restart your computer for all changes to take effect."
