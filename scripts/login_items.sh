#!/bin/bash

set -e

source ./scripts/utils.sh

# Apps to register as hidden login items. The script is idempotent: any app
# that is already a login item, or whose .app bundle isn't present, is skipped.
LOGIN_ITEMS=(
  "/Applications/Rectangle.app"
  "/Applications/Raycast.app"
  "/Applications/Maccy.app"
  "/Applications/Karabiner-Elements.app"
  "/Applications/Ice.app"
  "/Applications/Granola.app"
  "/Applications/Slack.app"
)

# Snapshot existing login item names once.
existing=$(osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null || echo "")

for app in "${LOGIN_ITEMS[@]}"; do
  name=$(basename "$app" .app)

  if [ ! -d "$app" ]; then
    print_success_muted "Skipping $name (not installed)"
    continue
  fi

  if echo "$existing" | grep -q "$name"; then
    print_success_muted "$name already a login item"
    continue
  fi

  step "Registering $name as a hidden login item..."
  osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$app\", hidden:true}" >/dev/null
  print_success_muted "$name registered"
done

echo ""
print_warning "Karabiner-Elements requires manual approval on first launch (Input Monitoring + driver extension)."
