# Claude Multi-Thread

A command-line tool to open multiple instances of Claude Code on different Git branches without using git worktree. Each instance runs in an isolated temporary clone.

## 🎯 Features

### Single Repository Mode
- ✅ Open the same repository in multiple Claude Code instances
- ✅ Each instance on a different Git branch
- ✅ No worktree configuration needed
- ✅ Automatic configuration file copying (`.env`, `.npmrc`, etc.)
- ✅ Optional dependency installation
- ✅ Easy cleanup of temporary directories
- ✅ Shallow clones for faster setup
- ✅ Automatic symlinks in `~/dev` for easy access
- ✅ Works with any Git repository

### Multi-Repository Mode (NEW! 🚀)
- ✅ Open multiple related repositories together (e.g., frontend + backend + AI service)
- ✅ Automatic port management to avoid conflicts
- ✅ Smart `.env` updates - services point to correct ports
- ✅ Predefined profiles for common repo combinations
- ✅ Interactive repository selection
- ✅ All repos share the same branch and instance number
- ✅ Perfect for full-stack development workflows

## 📦 Installation

### 1. Clone the repository

You can install this anywhere. Common locations:

```bash
# Option 1: In ~/dev
cd ~/dev
git clone [url] claude-multi-thread

# Option 2: In ~/tools
cd ~/tools
git clone [url] claude-multi-thread

# Option 3: In ~/projects
cd ~/projects
git clone [url] claude-multi-thread
```

### 2. Add to your shell configuration

Add this line to your `~/.zshrc` or `~/.bashrc` (adjust path to where you installed):

```bash
# If installed in ~/dev
source ~/dev/claude-multi-thread/config/aliases.sh

# If installed in ~/tools
source ~/tools/claude-multi-thread/config/aliases.sh

# If installed elsewhere
source /path/to/claude-multi-thread/config/aliases.sh
```

### 3. Configure your workspace

Edit `config/repos.conf` to match YOUR directory structure:

```bash
nano ~/dev/claude-multi-thread/config/repos.conf
```

Change these variables to match your setup:

```bash
# If your repos are in ~/dev
WORKSPACE_DIR="$HOME/dev"

# If your repos are in ~/projects
WORKSPACE_DIR="$HOME/projects"

# If your repos are in ~/code
WORKSPACE_DIR="$HOME/code"

# Where to create symlinks (defaults to WORKSPACE_DIR)
SYMLINK_DIR="${SYMLINK_DIR:-$WORKSPACE_DIR}"
```

### 4. Reload your shell

```bash
source ~/.zshrc  # or ~/.bashrc
```

### 5. Verify installation

```bash
claude-multi-help
```

## 🚀 Usage

### Multi-Repository Mode (Recommended for Full-Stack)

The multi-repo mode allows you to work on multiple related repositories simultaneously with automatic port management.

#### First-Time Setup

Edit `~/dev/claude-multi-thread/config/repos.conf` to define your repositories:

```bash
# Define your repositories
declare -A REPOS=(
    ["nuela-next"]="$HOME/dev/nuela-next:3000"
    ["nuela-apiv2"]="$HOME/dev/nuela-apiv2:3003"
    ["nuela-ai"]="$HOME/dev/nuela-ai:3001"
)

# Create profiles
declare -A PROFILES=(
    ["full-stack"]="nuela-next,nuela-apiv2,nuela-ai"
    ["frontend-backend"]="nuela-next,nuela-apiv2"
)

# Define how services connect
ENV_MAPPINGS=(
    "nuela-next:NEXT_PUBLIC_SOCKET_URL:nuela-apiv2:0"
    "nuela-apiv2:NUELA_AI_URL:nuela-ai:0"
)
```

#### Multi-Repo Commands

```bash
# Interactive: select repos from a list
cms feature/auth

# Use a predefined profile
cms feature/payment --profile full-stack

# Manual selection
cms develop --repos nuela-next,nuela-apiv2

# With dependency installation
cms feature/test --profile frontend-backend --install-deps

# List all active stacks
cmls
```

#### How It Works

When you run `cms feature/auth`:
1. You select which repos to open (or use a profile)
2. All repos are cloned to the same branch (`feature/auth`)
3. Ports are automatically incremented:
   - Instance 0: nuela-next=3000, nuela-apiv2=3003, nuela-ai=3001
   - Instance 1: nuela-next=4000, nuela-apiv2=4003, nuela-ai=4001
   - Instance 2: nuela-next=5000, nuela-apiv2=5003, nuela-ai=5001
4. `.env` files are updated automatically:
   - `nuela-next/.env`: `NEXT_PUBLIC_SOCKET_URL=http://localhost:4003`
   - `nuela-apiv2/.env`: `NUELA_AI_URL=http://localhost:4001`
5. All instances open in Claude Code
6. Symlinks created: `~/dev/nuela-next-feature-auth-i1`, etc.

### Single Repository Mode

#### Basic Commands

```bash
# Open a branch in the current repository
claude-multi-branch feature/new-feature

# Short alias
cmb feature/new-feature

# Open a branch in a specific repository
cmb develop ~/projects/my-app

# Install dependencies automatically
cmb feature/new-feature --install-deps
# or
cmb feature/new-feature -i

# Combined: specific repo + install deps
cmb develop ~/projects/my-app --install-deps
```

### Open Multiple Branches

```bash
# Open multiple branches of the current project
claude-multi-open "main,develop,feature/test"

# Short alias
cmo "main,develop,feature/test"

# Multiple branches of a specific project
cmo "main,develop" ~/projects/my-app
```

### List Active Instances

```bash
# List all temporary branch instances
claude-multi-list

# Short alias
cml
```

### Navigate to Instance

```bash
# Go to instance by number
claude-multi-goto 1

# Short alias
cmg 1

# Or just list instances
cmg
```

### Cleanup

```bash
# Cleanup all temporary directories
claude-multi-cleanup

# Short alias
cmc
```

## 📖 Examples

### Typical Workflow
```bash
# 1. Open multiple branches
cmo "main,develop,feature/new-feature"

# 2. List all instances
cml

# 3. Navigate to specific instance
cmg 2

# 4. Work on the branch...

# 5. When done, cleanup
cmc
```

### Compare implementations between branches
```bash
cmb main ~/projects/my-app &
cmb develop ~/projects/my-app &

# List and navigate between them
cml
cmg 1  # Go to main
cmg 2  # Go to develop
```

### Work on multiple features simultaneously
```bash
cmb feature/auth &
cmb feature/ui &
cmb feature/api &
```

### PR review in isolated environment
```bash
cmb feature/pr-123 ~/projects/my-app
```

### Quick branch comparison
```bash
cmo "main,develop,feature/hotfix"
```

### Access via symlinks
```bash
# After creating a branch instance
cmb feature/new-feature

# Access from anywhere in your terminal
cd ~/dev/my-repo-feature-new-feature

# Use with other tools
code ~/dev/my-repo-feature-new-feature
cursor ~/dev/my-repo-feature-new-feature
```

## 🔧 How It Works

1. **Clone**: Creates a temporary clone in `/tmp/claude-multi-branch-{repo}-{branch}-{pid}`
2. **Checkout**: Checks out the specified branch
3. **Config**: Copies configuration files (`.env*`, `.npmrc`, etc.) from the original repository
4. **Symlink**: Creates a symlink in `~/dev/{repo}-{branch}` pointing to the temp directory
5. **Dependencies**: Installs dependencies if `--install-deps` flag is used
6. **Open**: Opens Claude Code in the temporary directory

Each instance is completely independent and isolated from your main repository.

**Symlinks**: You can access your branch clones from `~/dev/{repo}-{branch}` for easy navigation in your terminal or IDE.

## 🗂️ Project Structure

```
~/dev/claude-multi-thread/
├── bin/
│   ├── claude-multi-branch       # Main script
│   └── claude-multi-cleanup      # Cleanup script
├── config/
│   └── aliases.sh                # Shell aliases and functions
├── docs/
│   ├── QUICKSTART.md             # Quick start guide
│   └── EXAMPLES.md               # Usage examples
├── README.md                     # This file
├── CHANGELOG.md                  # Change history
├── install.sh                    # Installation script
├── verify.sh                     # Verification script
└── .gitignore
```

## ⌨️ Command Reference

| Command | Alias | Description |
|---------|-------|-------------|
| `claude-multi-start` | `cms` | **Start multi-repo stack (recommended)** |
| `claude-multi-list-stacks` | `cmls` | List all active multi-repo stacks |
| `claude-multi-branch` | `cmb` | Open single branch in temporary instance |
| `claude-multi-open` | `cmo` | Open multiple branches (same repo) |
| `claude-multi-list` | `cml` | List all active single instances |
| `claude-multi-goto` | `cmg` | Navigate to instance by number |
| `claude-multi-cleanup` | `cmc` | Cleanup all temporary directories |
| `claude-multi-help` | `cmh` | Show help |

## 🛠️ Advanced Configuration

### Create Custom Project Aliases

Add to your `~/.zshrc`:

```bash
# Alias for your main project
alias cmb-myapp='f() { cmb "$1" "$HOME/projects/my-app"; }; f'

# Alias for work projects
alias cmb-work='f() { cmb "$1" "$HOME/work/main-project"; }; f'

# Alias for frontend
alias cmb-frontend='f() { cmb "$1" "$HOME/projects/frontend"; }; f'

# Alias for backend
alias cmb-backend='f() { cmb "$1" "$HOME/projects/backend"; }; f'
```

Then use them:

```bash
cmb-myapp feature/new-feature
cmb-work hotfix/bug-123
```

### Auto-cleanup on Shell Exit

Add to your `~/.zshrc`:

```bash
trap 'claude-multi-cleanup 2>/dev/null' EXIT
```

### Custom Configuration Files

Edit `~/dev/claude-multi-thread/bin/claude-multi-branch` line 57 to add more config files:

```bash
for config_file in .env .env.local .env.development .env.production .npmrc .yarnrc .prettierrc .eslintrc; do
```

## 🔍 Troubleshooting

### "Branch not found"
The script will clone the full repository and create/checkout the branch locally.

### "Not a git repository"
Make sure you're in a directory with `.git` or specify the full path:
```bash
cmb feature/test ~/projects/my-app
```

### Commands not available
Reload your shell:
```bash
source ~/.zshrc
```

### Want different temporary directory
Edit the `TEMP_DIR` variable in the main script (line 41).

## 💡 Tips

- Temporary directories are created in `/tmp/`
- Symlinks are created in `~/dev/{repo}-{branch}` for easy access
- On macOS, `/tmp` is automatically cleaned on restart (but symlinks in `~/dev` remain until cleanup)
- Clones use shallow clone (`--depth 1`) for speed
- Configuration files (`.env`, `.npmrc`, etc.) are automatically copied
- Dependencies are NOT installed by default (use `--install-deps` or `-i` to install)
- Each instance is completely isolated
- You can commit and push from temporary instances
- Access your branches via `cd ~/dev/{repo}-{branch}` in any terminal

## 📝 Use Cases

### 1. Feature Development
Work on multiple features without switching branches:
```bash
cmb feature/auth &
cmb feature/payments &
cmb feature/notifications &
```

### 2. Bug Investigation
Compare working vs broken state:
```bash
cmb main ~/projects/app &          # Working
cmb hotfix/bug ~/projects/app &    # Broken
```

### 3. PR Review
Review changes in isolation:
```bash
cmb main ~/projects/app &
cmb feature/pr-456 ~/projects/app &
```

### 4. Experimentation
Test different approaches:
```bash
cmb feature/approach-a &
cmb feature/approach-b &
cmb feature/approach-c &
```

### 5. Refactoring
Keep reference while refactoring:
```bash
cmb main ~/projects/app &              # Reference
cmb feature/refactor ~/projects/app &  # Work in progress
```

## 🤝 Contributing

Feel free to modify and improve the scripts for your needs. Fork the project and make it your own!

## 📄 License

MIT

## 🔗 Links

- [Quick Start Guide](docs/QUICKSTART.md)
- [Examples](docs/EXAMPLES.md)
- [Changelog](CHANGELOG.md)
