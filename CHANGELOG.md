# Changelog

All notable changes to Claude Multi-Thread will be documented in this file.

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
