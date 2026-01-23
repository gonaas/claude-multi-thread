#!/bin/bash
# Claude Code Multi-Thread Aliases
# Add to your ~/.zshrc or ~/.bashrc:
# source ~/dev/claude-multi-thread/config/aliases.sh

# Add bin directory to PATH
export PATH="$HOME/dev/claude-multi-thread/bin:$PATH"

# Unset any previous alias to avoid conflicts
unalias cmb 2>/dev/null || true

# Main function that runs claude-multi-branch and changes to temp dir
cmb() {
    local output=$(claude-multi-branch "$@")
    echo "$output"

    # Extract TEMP_DIR from output
    local temp_dir=$(echo "$output" | grep "^TEMP_DIR=" | cut -d'=' -f2)

    # Change to temp directory if it exists
    if [ -n "$temp_dir" ] && [ -d "$temp_dir" ]; then
        cd "$temp_dir"
        echo ""
        echo "📂 Changed directory to: $temp_dir"
    fi
}

alias cmc='claude-multi-cleanup'
alias cml='claude-multi-list'

# Function to quickly navigate to a temporary branch directory
claude-multi-goto() {
    if [ -z "$1" ]; then
        # If no argument, show list and prompt for selection
        claude-multi-list
        return 0
    fi

    local index="$1"

    # Determine the actual temp directory (handles macOS symlink)
    local actual_tmp="/tmp"
    if [ -L "/tmp" ]; then
        actual_tmp=$(readlink -f /tmp 2>/dev/null || echo "/private/tmp")
    fi

    local temp_dirs=($actual_tmp/claude-multi-branch-*)

    # Check if any directories exist
    if [ ${#temp_dirs[@]} -eq 0 ] || [ ! -d "${temp_dirs[0]}" ]; then
        echo "❌ No temporary branch clones found"
        return 1
    fi

    # Validate index
    if ! [[ "$index" =~ ^[0-9]+$ ]]; then
        echo "❌ Invalid index. Please provide a number."
        return 1
    fi

    # Get the directory at the specified index (1-based)
    local dir="${temp_dirs[$((index - 1))]}"

    if [ ! -d "$dir" ]; then
        echo "❌ Instance #$index not found. Use 'cml' to see available instances."
        return 1
    fi

    # Change to the directory
    cd "$dir"

    # Get branch info
    local branch=$(git branch --show-current 2>/dev/null || echo "unknown")
    local repo=$(basename "$dir" | sed 's/claude-multi-branch-//' | sed 's/-[^-]*-[0-9]*$//')

    echo "✓ Changed to: $repo → $branch"
    echo "📂 $dir"
}

alias cmg='claude-multi-goto'

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
  claude-multi-list                       List all temporary instances
  cml                                     Short alias for above
  claude-multi-goto <number>              Go to instance by number
  cmg <number>                            Short alias for above
  claude-multi-cleanup                    Cleanup temporary directories
  cmc                                     Short alias for cleanup

EXAMPLES:
  # Open feature branch in current directory
  cmb feature/new-feature

  # Open branch in specific repository
  cmb develop ~/projects/my-app

  # Open multiple branches in current project
  cmo "main,develop,feature/test"

  # List all active instances
  cml

  # Navigate to instance #1
  cmg 1

  # Cleanup temporary directories
  cmc

WORKFLOW:
  # 1. Open multiple branches
  cmo "main,develop,feature/test"

  # 2. List them
  cml

  # 3. Navigate to instance #2
  cmg 2

  # 4. Do your work...

  # 5. Cleanup when done
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
