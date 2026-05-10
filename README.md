<img src="./configs/images/icon.png" alt="Omakos Icon" width="100"/>

# Omakos

> Omakos turns your macOS laptop into a fully functional work development machine in a single command.
> A shell script to set up a new mac.

Omakos is inspired by Basecamp's [Omakub](https://github.com/basecamp/omakub) project. The name is a combination of "omakase" (お任せ, Japanese for "I leave it up to you") and "macOS", reflecting its purpose of providing a curated development environment setup for macOS.

It can be run multiple times on the same machine safely.
It installs, upgrades, or skips packages based on what is already installed on the machine.

<img src="./configs/images/screenshot_1.png" alt="screenshot" width="600"/>

## Install

You can install Omakos using one of these two methods:

### Option 1: Direct Install (Recommended)

Run this single command in your terminal:

```sh
curl -L https://raw.githubusercontent.com/mcrundo/omakos/main/install.sh | bash
```

### Option 2: Manual Install

If you prefer to review the code first:

1. Download the repo:

```sh
git clone https://github.com/mcrundo/omakos.git && cd omakos
```

2. Review the scripts (please don't run scripts you don't understand):

```sh
less setup.sh
```

3. Run the setup:

```sh
./setup.sh 2>&1 | tee ~/omakos.log
```

Just follow the prompts and you'll be fine. 👌

## User-specific values

At the start of setup, Omakos asks for a handful of values it uses across the
script (git config, SSH key, computer name). You can either answer the prompts
or set them ahead of time as environment variables to run non-interactively:

```sh
GIT_NAME="Jane Doe" \
GIT_EMAIL="jane@example.com" \
GITHUB_USER="janedoe" \
MAC_HOSTNAME="janes-work-mac" \
  ./setup.sh
```

| Variable       | Used by                                          |
|----------------|--------------------------------------------------|
| `GIT_NAME`     | `~/.gitconfig` `[user] name`                     |
| `GIT_EMAIL`    | `~/.gitconfig` `[user] email`, SSH key comment   |
| `GITHUB_USER`  | Printed alongside the SSH pubkey                 |
| `MAC_HOSTNAME` | `scutil --set ComputerName/HostName/LocalHostName` |

## What it sets up

The setup process installs and configures the following tools and applications.
All packages are managed through Homebrew and defined in
[`configs/Brewfile`](configs/Brewfile).

### Command Line Tools

- [XCode Command Line Tools](https://developer.apple.com/xcode/downloads/) for developer essentials
- [Git](https://git-scm.com/) for version control
- [Homebrew](http://brew.sh/) for managing operating system libraries
- [ZSH](https://www.zsh.org/) with [Oh My Zsh](https://ohmyz.sh/) for a better shell experience
- [coreutils](https://www.gnu.org/software/coreutils/) — GNU file, shell and text manipulation utilities
- [curl](https://curl.se/) and [wget](https://www.gnu.org/software/wget/) for downloading files
- [fzf](https://github.com/junegunn/fzf) for fuzzy finding
- [jq](https://stedolan.github.io/jq/) for JSON processing
- [bat](https://github.com/sharkdp/bat), [eza](https://github.com/eza-community/eza), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd) — modern replacements for `cat`/`ls`/`grep`/`find`
- [zoxide](https://github.com/ajeetdsouza/zoxide) for smart `cd`
- [direnv](https://direnv.net/) for per-directory environment variables
- [lazygit](https://github.com/jesseduffield/lazygit) — TUI git client
- [httpie](https://httpie.io/) — friendlier `curl`
- [btop](https://github.com/aristocratos/btop) for system resource monitoring
- [fastfetch](https://github.com/fastfetch-cli/fastfetch) for system information display
- [gh](https://cli.github.com/) — GitHub CLI
- [tmux](https://github.com/tmux/tmux) — terminal multiplexer
- [awscli](https://aws.amazon.com/cli/), [terraform](https://www.terraform.io/), [stripe](https://stripe.com/docs/stripe-cli) — work CLIs
- [libpq](https://www.postgresql.org/docs/current/libpq.html), [libyaml](https://pyyaml.org/wiki/LibYAML), [jemalloc](https://jemalloc.net/) — build-time libs

### Development Environment

- [Visual Studio Code](https://code.visualstudio.com/) with curated settings + extensions
- [iTerm2](https://iterm2.com/) for terminal emulation
- [Docker](https://www.docker.com/) for containerization
- [OrbStack](https://orbstack.dev/) for Docker and Linux VMs on macOS
- [PostgreSQL 18](https://www.postgresql.org/) with `libpq`
- [Redis](https://redis.io/) for in-memory data store
- [vips](https://www.libvips.org/) for image processing
- [Ollama](https://ollama.ai/) for local AI models
- [Overmind](https://github.com/DarthSim/overmind) for process management
- [Mise](https://mise.jdx.dev/) for runtime version management (Python, Ruby, Rust, Go, Node — see [`configs/mise.toml`](configs/mise.toml))
- [UV](https://github.com/astral-sh/uv) for Python packaging
- [pnpm](https://pnpm.io/) for Node.js package management
- [TablePlus](https://tableplus.com/) for database GUI
- [Bruno](https://www.usebruno.com/) for API testing
- [Proxyman](https://proxyman.io/) for HTTP debugging

### Productivity & Communication

- [Claude](https://claude.ai/), [ChatGPT](https://chat.openai.com/), [Codex](https://openai.com/codex/) for AI assistance
- [Linear](https://linear.app/) for issue tracking
- [Granola](https://www.granola.ai/) for AI meeting notes
- [Slack](https://slack.com/) for team communication
- [Zoom](https://zoom.us/) for video conferencing
- [Obsidian](https://obsidian.md/) for note-taking
- [Raycast](https://www.raycast.com/) for productivity launcher
- [Rectangle](https://rectangleapp.com/) for window management
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) for keyboard remapping
- [Ice](https://github.com/jordanbaird/Ice) for menu-bar management
- [Maccy](https://maccy.app/) for clipboard history
- [Boop](https://boop.okat.best/) for text transformations
- [Shottr](https://shottr.cc/) for screenshots
- [Cog](https://cog.losno.co/) for audio playback
- [SF Symbols](https://developer.apple.com/sf-symbols/) for Apple's symbol library

### Fonts

- Cascadia Code
- Fira Code
- Geist Mono
- Hack
- IBM Plex Mono

### Enhanced macOS Settings

The setup applies developer-optimized macOS configurations including:

- **Performance**: Near-instant window animations and faster Mission Control
- **Finder**: Opens to home directory, searches current folder by default, shows hidden files
- **Text Editing**: Key repeat enabled in all apps, faster cursor movement
- **Screenshots**: Organized in `~/Desktop/Screenshots/` folder without shadows
- **Trackpad**: Three-finger drag enabled for better window management
- **Keyboard**: Fastest repeat rates for efficient coding
- **System**: Disabled automatic corrections, expanded dialogs, local saves by default
- **Hostname**: ComputerName/HostName/LocalHostName set from your `MAC_HOSTNAME` answer

## Features

### Modular Scripts

Each script in the [`scripts/`](scripts/) directory can be run independently
(you'll need to export `GIT_NAME` / `GIT_EMAIL` / `GITHUB_USER` / `MAC_HOSTNAME`
first if a given script uses them):

```sh
# Run individual scripts
./scripts/mac.sh       # Only configure macOS settings
./scripts/git.sh       # Only setup Git configuration
./scripts/vscode.sh    # Only configure VS Code
./scripts/iterm2.sh    # Only configure iTerm2
./scripts/mise.sh      # Only setup mise and install configured runtimes
./scripts/rubocop.sh   # Only setup Rubocop configuration
./scripts/gemrc.sh     # Only setup Gem configuration
./scripts/irbrc.sh     # Only setup IRB configuration
./scripts/zshrc.sh     # Only setup Zsh configuration
./scripts/ssh.sh       # Only configure SSH (config + ed25519 key)
./scripts/login_items.sh # Register Rectangle, Raycast, Maccy, etc. as hidden login items
```

The scripts are designed to be:

- **Independent**: Each script can run on its own
- **Idempotent**: Safe to run multiple times
- **Configurable**: Easy to modify for your needs

## Code Structure

The project follows a modular structure where each component is responsible for
a specific setup task. You can run any script individually if you only want to
set up specific parts of your system.

```
omakos/
├── setup.sh                 # Main setup script
├── scripts/
│   ├── ascii.sh            # ASCII art for terminal output
│   ├── brew.sh             # Homebrew package installation
│   ├── gemrc.sh            # Gem configuration
│   ├── git.sh              # Git configuration
│   ├── irbrc.sh            # IRB configuration
│   ├── iterm2.sh           # iTerm2 configuration
│   ├── login_items.sh      # Register apps as hidden login items
│   ├── mac.sh              # macOS system preferences
│   ├── mise.sh             # Mise runtime manager setup
│   ├── rubocop.sh          # Rubocop configuration
│   ├── ssh.sh              # SSH configuration + ed25519 key generation
│   ├── utils.sh            # Utility functions (incl. prompt_or_env)
│   ├── vscode.sh           # VS Code settings + extensions
│   ├── zsh.sh              # ZSH shell setup
│   └── zshrc.sh            # Zshrc configuration
├── configs/
│   ├── Brewfile            # Homebrew packages list
│   ├── git/                # Git configuration template
│   ├── iterm2/             # iTerm2 preferences
│   ├── ssh/                # SSH configuration
│   ├── vscode/             # VS Code settings.json + extensions.txt
│   ├── gemrc              # Ruby gems configuration
│   ├── irbrc              # IRB (Interactive Ruby) configuration
│   ├── mise.toml          # Mise runtime versions
│   ├── rubocop.yml        # Ruby code style config
│   └── zshrc              # Zsh shell configuration
└── README.md
```

### Configuration Files

The [`configs/`](configs/) directory contains all config files. Files containing
`${VAR}` placeholders (e.g. `configs/git/gitconfig`) are rendered with
`envsubst` at install time using the user-specific values gathered at the start
of `setup.sh`.

## Customization

The script is designed to be customizable. You can:

- Modify the [`Brewfile`](configs/Brewfile) to add/remove packages
- Adjust macOS settings in [`scripts/mac.sh`](scripts/mac.sh)
- Modify the configuration files in [`configs/`](configs/) directory

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

Inspiration and code was taken from many sources, including:

- [Formation](https://github.com/minamarkham/formation) by Mina Markham
- [Omakub](https://github.com/basecamp/omakub)
- [yatish27/omakos](https://github.com/yatish27/omakos) — the original repo this is forked from
