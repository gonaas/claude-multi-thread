# Claude Multi-Thread

A command-line tool to open multiple instances of Claude Code on different Git branches without using git worktree. Each instance runs in an isolated temporary clone.

## 🎯 Features

- ✅ Open the same repository in multiple Claude Code instances
- ✅ Each instance on a different Git branch
- ✅ No worktree configuration needed
- ✅ Automatic configuration file copying (`.env`, `.npmrc`, etc.)
- ✅ Optional dependency installation
- ✅ Easy cleanup of temporary directories
- ✅ Shallow clones for faster setup
- ✅ Works with any Git repository

## 📦 Installation

### 1. Add to your shell configuration

Add this line to your `~/.zshrc` or `~/.bashrc`:

```bash
source ~/dev/claude-multi-thread/config/aliases.sh
```

### 2. Reload your shell

```bash
source ~/.zshrc  # or ~/.bashrc
```

### 3. Verify installation

```bash
claude-multi-help
```

## 🚀 Usage

### Basic Commands

```bash
# Open a branch in the current repository
claude-multi-branch feature/new-feature

# Short alias
cmb feature/new-feature

# Open a branch in a specific repository
cmb develop ~/projects/my-app
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

### Cleanup

```bash
# Cleanup all temporary directories
claude-multi-cleanup

# Short alias
cmc
```

## 📖 Examples

### Compare implementations between branches
```bash
cmb main ~/projects/my-app &
cmb develop ~/projects/my-app &
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

## 🔧 How It Works

1. **Clone**: Creates a temporary clone in `/tmp/claude-multi-branch-{repo}-{branch}-{pid}`
2. **Checkout**: Checks out the specified branch
3. **Config**: Copies configuration files (`.env*`, `.npmrc`, etc.)
4. **Dependencies**: Optionally installs dependencies
5. **Open**: Opens Claude Code in the temporary directory

Each instance is completely independent and isolated from your main repository.

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
| `claude-multi-branch` | `cmb` | Open branch in temporary instance |
| `claude-multi-open` | `cmo` | Open multiple branches |
| `claude-multi-cleanup` | `cmc` | Cleanup temporary directories |
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
- On macOS, `/tmp` is automatically cleaned on restart
- Clones use shallow clone (`--depth 1`) for speed
- Dependencies are NOT installed by default (you can opt-in)
- Each instance is completely isolated
- You can commit and push from temporary instances

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
