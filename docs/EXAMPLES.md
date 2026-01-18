# Usage Examples

Real-world examples of using Claude Multi-Thread for various development workflows.

## Table of Contents

1. [Basic Workflows](#basic-workflows)
2. [Feature Development](#feature-development)
3. [Code Review](#code-review)
4. [Bug Investigation](#bug-investigation)
5. [Experimentation](#experimentation)
6. [Multi-Project Development](#multi-project-development)
7. [Custom Aliases](#custom-aliases)

---

## Basic Workflows

### Open a single branch

```bash
cd ~/projects/my-app
cmb feature/new-feature
```

### Compare two branches

```bash
cmb main ~/projects/my-app &
cmb develop ~/projects/my-app &
```

### Open multiple branches at once

```bash
cd ~/projects/my-app
cmo "main,develop,feature/test"
```

---

## Feature Development

### Work on multiple features simultaneously

```bash
# Each feature in its own instance
cmb feature/authentication &
cmb feature/payment-gateway &
cmb feature/user-dashboard &
```

### Parallel feature branches

```bash
# Frontend features
cmb feature/ui-redesign ~/projects/frontend &
cmb feature/dark-mode ~/projects/frontend &

# Backend features
cmb feature/api-v2 ~/projects/backend &
cmb feature/webhooks ~/projects/backend &
```

### Feature comparison

```bash
# Test different implementations
cmb feature/approach-a &
cmb feature/approach-b &
cmb feature/approach-c &
```

---

## Code Review

### PR review workflow

```bash
# Open base branch
cmb main ~/projects/my-app &

# Open PR branch
cmb feature/pr-456 ~/projects/my-app &

# Review changes side-by-side in Claude Code
```

### Review multiple PRs

```bash
cmb feature/pr-123 &
cmb feature/pr-456 &
cmb feature/pr-789 &
```

### Pre-merge verification

```bash
# Current production
cmb main ~/projects/api &

# About to merge
cmb feature/breaking-changes ~/projects/api &
```

---

## Bug Investigation

### Compare working vs broken

```bash
# Known good version
cmb v1.2.0 ~/projects/app &

# Broken version
cmb develop ~/projects/app &
```

### Bisect debugging

```bash
# Open multiple commits
cmb abc123 &  # Working
cmb def456 &  # Broken
cmb ghi789 &  # Testing
```

### Hotfix development

```bash
# Production branch
cmb production &

# Hotfix branch
cmb hotfix/critical-bug &
```

---

## Experimentation

### Test different approaches

```bash
# Algorithm A
cmb experiment/algorithm-a &

# Algorithm B
cmb experiment/algorithm-b &

# Hybrid approach
cmb experiment/hybrid &
```

### Performance comparison

```bash
# Before optimization
cmb main ~/projects/api &
# Run benchmarks

# After optimization
cmb optimize/database-queries ~/projects/api &
# Run same benchmarks, compare results
```

### Architecture refactoring

```bash
# Current architecture
cmb main ~/projects/backend &

# New architecture
cmb refactor/microservices ~/projects/backend &
```

---

## Multi-Project Development

### Full-stack development

```bash
# Frontend
cmb feature/new-ui ~/projects/frontend &

# Backend
cmb feature/new-api ~/projects/backend &

# Mobile
cmb feature/mobile-support ~/projects/mobile &
```

### Monorepo with multiple services

```bash
# Service A
cmb feature/service-a ~/projects/monorepo &

# Service B
cmb feature/service-b ~/projects/monorepo &

# Shared library
cmb feature/shared-lib ~/projects/monorepo &
```

### Microservices development

```bash
# Auth service
cmb develop ~/projects/auth-service &

# API Gateway
cmb develop ~/projects/api-gateway &

# Payment service
cmb develop ~/projects/payment-service &
```

---

## Custom Aliases

### Create project-specific shortcuts

Add to your `~/.zshrc`:

```bash
# Main projects
alias cmb-web='f() { cmb "$1" "$HOME/projects/website"; }; f'
alias cmb-api='f() { cmb "$1" "$HOME/projects/api"; }; f'
alias cmb-mobile='f() { cmb "$1" "$HOME/projects/mobile-app"; }; f'

# Work projects
alias cmb-work='f() { cmb "$1" "$HOME/work/main-project"; }; f'

# Client projects
alias cmb-client-a='f() { cmb "$1" "$HOME/clients/client-a"; }; f'
alias cmb-client-b='f() { cmb "$1" "$HOME/clients/client-b"; }; f'
```

### Use your custom aliases

```bash
# Web development
cmb-web feature/redesign

# API work
cmb-api hotfix/auth-bug

# Mobile features
cmb-mobile feature/push-notifications
```

### Multi-project function

```bash
# Add to ~/.zshrc
open-stack() {
    local branch="${1:-develop}"
    cmb-web "$branch" &
    cmb-api "$branch" &
    cmb-mobile "$branch" &
    echo "Opening full stack on branch: $branch"
}

# Usage
open-stack feature/new-feature
```

---

## Advanced Workflows

### Integration testing

```bash
# Open all services on test branches
cmb feature/integration-test ~/projects/service-a &
cmb feature/integration-test ~/projects/service-b &
cmb feature/integration-test ~/projects/service-c &

# Start each service in its temporary directory
# Test integration between services
```

### Migration testing

```bash
# Before migration
cmb v1.0 ~/projects/app &

# After migration
cmb v2.0 ~/projects/app &

# Compare database schemas, API responses, etc.
```

### Documentation writing

```bash
# Code to document
cmb main ~/projects/app &

# Docs branch
cmb docs/api-reference ~/projects/app &

# Write docs while viewing actual code
```

### Training new developers

```bash
# Show different stages of a feature
cmb tutorial/step-1 ~/projects/app &
cmb tutorial/step-2 ~/projects/app &
cmb tutorial/step-3 ~/projects/app &
```

---

## Tips for Different Project Types

### Node.js / JavaScript

```bash
# Open branch
cmb feature/new-api ~/projects/node-app

# In the temporary directory
cd /tmp/claude-multi-branch-node-app-feature-new-api-*
npm install
npm run dev
```

### Python

```bash
# Open branch
cmb feature/ml-model ~/projects/python-app

# In the temporary directory
cd /tmp/claude-multi-branch-python-app-feature-ml-model-*
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

### Go

```bash
# Open branch
cmb feature/grpc-service ~/projects/go-app

# In the temporary directory
cd /tmp/claude-multi-branch-go-app-feature-grpc-service-*
go mod download
go run main.go
```

### Rust

```bash
# Open branch
cmb feature/optimization ~/projects/rust-app

# In the temporary directory
cd /tmp/claude-multi-branch-rust-app-feature-optimization-*
cargo build
cargo run
```

---

## Cleanup

### Manual cleanup

```bash
# After finishing work
cmc
```

### Automatic cleanup

Add to your `~/.zshrc`:

```bash
# Auto-cleanup on shell exit
trap 'cmc 2>/dev/null' EXIT
```

### Selective cleanup

```bash
# List temporary directories
find /tmp -maxdepth 1 -name "claude-multi-branch-*"

# Remove specific ones
rm -rf /tmp/claude-multi-branch-myapp-feature-test-12345
```

---

## Best Practices

1. **Use descriptive branch names** for easier identification
2. **Clean up regularly** to free disk space
3. **Create custom aliases** for frequently used projects
4. **Use `&` to open multiple instances** for comparison
5. **Keep the main repo** for commits, use temps for exploration
6. **Copy .env files** are automatic, but verify sensitive data
7. **Don't install dependencies** unless needed (saves time)
8. **Use shallow clones** (default) for speed
9. **Commit directly** from temp instances if needed
10. **Document your workflow** with custom scripts

---

## Common Patterns

### The Comparison Pattern

```bash
# Pattern: Compare A vs B
cmb version-a ~/projects/app &
cmb version-b ~/projects/app &
```

### The Exploration Pattern

```bash
# Pattern: Try multiple approaches
cmb idea-1 &
cmb idea-2 &
cmb idea-3 &
```

### The Review Pattern

```bash
# Pattern: Base + Changes
cmb main ~/projects/app &
cmb feature/changes ~/projects/app &
```

### The Stack Pattern

```bash
# Pattern: Full stack on same branch
cmb feature/full-stack ~/projects/frontend &
cmb feature/full-stack ~/projects/backend &
cmb feature/full-stack ~/projects/database &
```

---

## Need Help?

```bash
# Show help
claude-multi-help

# Verify installation
~/dev/claude-multi-thread/verify.sh

# Read documentation
cat ~/dev/claude-multi-thread/README.md
```
