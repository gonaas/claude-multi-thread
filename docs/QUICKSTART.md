# Quick Start Guide

## Installation

```bash
cd ~/dev/claude-multi-thread
./install.sh
source ~/.zshrc
```

## Verify Installation

```bash
./verify.sh
```

## Basic Usage

### Open a single branch

```bash
# In any git repository
cmb feature/my-feature

# Specific repository
cmb develop ~/projects/my-app
```

### Multiple Branches

```bash
# Compare branches
cmb main &
cmb develop &

# Or use the multi-open command
cmo "main,develop,feature/test"
```

## Common Workflows

### PR Review

```bash
# Open the PR branch in isolation
cmb feature/pr-123

# Compare with main
cmb main &
cmb feature/pr-123 &
```

### Feature Development

```bash
# Work on multiple features
cmb feature/auth &
cmb feature/payments &
cmb feature/notifications &
```

### Bug Investigation

```bash
# Compare working vs broken
cmb main &              # Working version
cmb hotfix/bug &        # Broken version
```

### Experimentation

```bash
# Test different approaches
cmb feature/approach-a &
cmb feature/approach-b &
cmb feature/approach-c &
```

## Custom Project Aliases

Add to your `~/.zshrc`:

```bash
# Your main projects
alias cmb-frontend='f() { cmb "$1" "$HOME/projects/frontend"; }; f'
alias cmb-backend='f() { cmb "$1" "$HOME/projects/backend"; }; f'
alias cmb-api='f() { cmb "$1" "$HOME/projects/api"; }; f'

# Usage
cmb-frontend feature/new-ui
cmb-backend hotfix/auth-bug
cmb-api develop
```

## Cleanup

```bash
# List and remove temporary directories
cmc
```

## Help

```bash
# Show all commands
cmh

# Or
claude-multi-help
```

## Tips

1. Each instance is completely isolated
2. You can commit and push from temporary instances
3. Configuration files (`.env`) are automatically copied
4. Dependencies are NOT installed by default (you can opt-in)
5. Use `pwd` in each instance to see the temporary path
6. Temporary directories are in `/tmp/` and auto-cleaned on macOS restart

## Troubleshooting

### Commands not found?

```bash
source ~/.zshrc
```

### Want to add custom config files?

Edit `~/dev/claude-multi-thread/bin/claude-multi-branch` line 57.

### Want different project paths?

Create custom aliases in your `~/.zshrc` as shown above.
