# Claude Multi-Thread

## Project Overview

A generic command-line tool for opening multiple instances of Claude Code on different Git branches.

## Key Features

- Works with **any** Git repository
- No project-specific dependencies
- Fully customizable through aliases
- Clean, minimal design

## Files Structure

```
~/dev/claude-multi-thread/
├── bin/
│   ├── claude-multi-branch       # Main script
│   └── claude-multi-cleanup      # Cleanup utility
├── config/
│   └── aliases.sh                # Shell configuration
├── docs/
│   ├── QUICKSTART.md             # Quick start guide
│   └── EXAMPLES.md               # Generic examples
├── README.md                     # Full documentation
├── CHANGELOG.md                  # Version history
├── PROJECT_INFO.md               # This file
├── install.sh                    # Installation script
├── verify.sh                     # Verification script
└── .gitignore
```

## Quick Commands

```bash
cmb <branch>              # Open branch in current repo
cmb <branch> <repo-path>  # Open branch in specific repo
cmo "branch1,branch2"     # Open multiple branches
cmc                       # Cleanup temporary directories
cmh                       # Show help
```

## Customization

Users can create their own project aliases:

```bash
# Add to ~/.zshrc
alias cmb-myproject='f() { cmb "$1" "$HOME/projects/myproject"; }; f'
```

## No Hardcoded Projects

This tool is completely generic and contains no references to specific projects or technologies.
