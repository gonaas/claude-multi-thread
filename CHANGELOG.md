# Changelog

All notable changes to Claude Multi-Thread will be documented in this file.

## [2.1.0] - 2026-02-04

### Added - Native macOS UI 🎨
- **Native GUI Application**: New Tauri-based desktop app (`claude-multi-ui/`)
- **Modern React Interface**: Clean, dark-themed UI built with React 18 + TypeScript
- **Visual Stack Management**: Create and manage stacks with checkboxes and buttons
- **Real-time Stack Listing**: See all active stacks with instance numbers, ports, and repos
- **One-Click Actions**: Create, open, and kill stacks from the UI
- **Auto-Configuration**: Reads repository config from `repos.conf` or uses sensible defaults
- **Native Performance**: Lightweight Tauri app (~10MB) with native macOS integration

### Technical Details - UI
- **Frontend**: React 18 + TypeScript + TailwindCSS + Vite
- **Backend**: Rust + Tauri 2.0
- **Icons**: Lucide React
- **Components**: Modular UI with StackCreator, ActiveStacks, StackCard
- **IPC Bridge**: Rust commands call existing bash scripts
- **Documentation**: QUICKSTART.md, DEVELOPMENT.md, full README

### UI Features
- Repository selection with checkboxes
- Branch name input with validation
- Optional dependency installation toggle
- Active stacks refresh
- Port display for each repo
- Instance numbering
- Loading states and error handling

### Files Added
```
claude-multi-ui/
├── src/                  # React frontend
├── src-tauri/           # Rust backend
├── README.md            # Full documentation
├── QUICKSTART.md        # Quick start guide
└── DEVELOPMENT.md       # Developer guide
```

## [2.0.0] - 2026-02-03

### Added - Multi-Repository Mode 🚀
- **`claude-multi-start` (`cms`) command**: Open multiple related repositories together
- **Automatic Port Management**: Each instance increments ports automatically (base + 1000 * instance_num)
- **Smart .env Updates**: Automatically updates cross-service environment variables
- **Repository Configuration**: New `config/repos.conf` file for defining repositories and profiles
- **Predefined Profiles**: Define common repo combinations (e.g., "full-stack", "frontend-backend")
- **Interactive Selection**: Choose repos from a list when starting a stack
- **Stack Listing**: New `claude-multi-list-stacks` (`cmls`) command
- **Session Metadata**: Each stack saves instance info in `.session-info` file
- **Cross-Service Mapping**: Configure which env vars point to which services
- **✨ WORKSPACE_DIR Configuration**: Fully configurable workspace and symlink directories
- **✨ Portable Setup**: Works with any directory structure (~/dev, ~/projects, ~/code, etc.)
- **Configuration Examples**: New `repos.conf.examples` with 6 different setup scenarios

### Changed
- **⚠️ BREAKING**: Symlinks now use configured `SYMLINK_DIR` instead of hardcoded `~/dev`
- All scripts auto-detect installation location (no hardcoded paths)
- `claude-multi-cleanup` now handles both single repos and multi-repo stacks
- Enhanced help documentation with multi-repo examples
- Updated README with comprehensive installation and configuration guide
- Improved symlink naming: `{repo}-{branch}-i{instance}` for multi-repo stacks

### Technical Details
- New config: `config/repos.conf` with REPOS, PROFILES, ENV_MAPPINGS arrays
- New script: `bin/claude-multi-start` (multi-repo orchestrator)
- New script: `bin/claude-multi-list-stacks` (stack viewer)
- Session directories: `/tmp/claude-multi-stack-{instance}-{pid}/{repo}`
- Port formula: `base_port + (PORT_INCREMENT * instance_number)`
- Environment variable auto-update based on ENV_MAPPINGS configuration

### Use Cases
- Full-stack development with frontend + backend + services
- Microservices architecture with multiple repos
- Multiple feature branches across related repositories
- Team collaboration on connected codebases

## [1.1.0] - 2026-01-29

### Added
- Automatic symlink creation in `~/dev` for easy access to branch instances
- Symlinks are named `{repo}-{branch}` for easy identification
- Enhanced cleanup script to remove symlinks along with temporary directories
- Symlink path information displayed after branch creation

### Changed
- Updated cleanup script to detect and remove orphaned symlinks
- Improved cleanup output to show both directories and symlinks

### Benefits
- Easier navigation to branch instances from any terminal
- Better integration with IDEs and other development tools (VSCode, Cursor, etc.)
- Quick access via `cd ~/dev/{repo}-{branch}`

## [1.0.0] - 2026-01-18

### Added
- Initial release
- Core functionality to open Git branches in temporary Claude Code instances
- Automatic configuration file copying (`.env`, `.npmrc`, etc.)
- Optional dependency installation
- Cleanup utility for temporary directories
- Shell aliases for common operations
- Multi-branch opening support (`claude-multi-open`)
- Comprehensive documentation
- Installation and verification scripts
- Quick start guide
- Generic usage examples

### Features
- Shallow clone for faster setup
- Isolated temporary environments
- Support for all Git workflows
- Cross-platform compatibility (macOS, Linux)
- Shell integration (Zsh, Bash)

### Commands
- `claude-multi-branch` (alias: `cmb`) - Open branch in temporary instance
- `claude-multi-cleanup` (alias: `cmc`) - Cleanup temporary directories
- `claude-multi-open` (alias: `cmo`) - Open multiple branches
- `claude-multi-help` (alias: `cmh`) - Show help

## [Planned]

### Future Enhancements
- [ ] Auto-detect and copy more config files
- [ ] Support for custom hooks (pre-open, post-open)
- [ ] Branch comparison utilities
- [ ] Integration with Git workflow tools
- [ ] Performance metrics and optimization
- [ ] Support for more package managers (bun, etc.)
- [ ] Config file for user preferences
- [ ] Remote repository support
- [ ] Session management (save/restore instances)
