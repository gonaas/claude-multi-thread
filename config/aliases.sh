#!/bin/bash
# Claude Code Multi-Thread Aliases
# Add to your ~/.zshrc or ~/.bashrc:
# source ~/dev/claude-multi-thread/config/aliases.sh

# Add bin directory to PATH
export PATH="$HOME/dev/claude-multi-thread/bin:$PATH"

# Main aliases
alias cmb='claude-multi-branch'
alias cmc='claude-multi-cleanup'

# Helper function to open multiple branches at once
claude-multi-open() {
    local repo_path="${2:-.}"

    if [ -z "$1" ]; then
        echo "Usage: claude-multi-open <branch1,branch2,branch3> [repo-path]"
        echo "Example: claude-multi-open 'main,develop,feature/new'"
        return 1
    fi

    IFS=',' read -ra BRANCHES <<< "$1"

    for branch in "${BRANCHES[@]}"; do
        branch=$(echo "$branch" | xargs)  # trim whitespace
        echo "Opening branch: $branch"
        claude-multi-branch "$branch" "$repo_path" &
        sleep 2  # Small pause between opens
    done

    wait
    echo "✓ All instances opened"
}

alias cmo='claude-multi-open'

# Help function
claude-multi-help() {
    cat << 'EOF'
🚀 Claude Code Multi-Thread Commands

MAIN COMMANDS:
  claude-multi-branch <branch> [repo]     Open branch in temporary instance
  cmb <branch> [repo]                     Short alias for above
  claude-multi-open <branch1,branch2>     Open multiple branches
  cmo <branch1,branch2>                   Short alias for above
  claude-multi-cleanup                    Cleanup temporary directories
  cmc                                     Short alias for cleanup

EXAMPLES:
  # Open feature branch in current directory
  cmb feature/new-feature

  # Open branch in specific repository
  cmb develop ~/projects/my-app

  # Open multiple branches in current project
  cmo "main,develop,feature/test"

  # Open multiple branches in specific repo
  cmo "main,develop" ~/projects/my-app

  # Cleanup temporary directories
  cmc

ADVANCED:
  # Compare branches side by side
  cmb main ~/projects/my-app &
  cmb develop ~/projects/my-app &

  # Work on multiple features simultaneously
  cmb feature/auth &
  cmb feature/ui &

  # Custom project aliases (add to your ~/.zshrc):
  alias cmb-myapp='f() { cmb "$1" "$HOME/projects/my-app"; }; f'

EOF
}

alias cmh='claude-multi-help'
