# Claude Multi-Thread UI

A native macOS application for managing Claude Multi-Thread stacks with a modern, clean interface.

## Features

- 🚀 Create multi-repository stacks with a single click
- 📋 View all active stacks in real-time
- 🎨 Modern, dark-themed UI built with React + TailwindCSS
- ⚡ Native performance with Tauri
- 🔧 Automatic port management
- 🗑️ Easy stack cleanup

## Screenshots

```
┌─────────────────────────────────────────────┐
│ Claude Multi-Thread                         │
├─────────────────────────────────────────────┤
│                                             │
│  🚀 New Stack          📋 Active Stacks    │
│  ┌──────────────┐      ┌──────────────┐    │
│  │ Branch:      │      │ feature/auth │    │
│  │ [input]      │      │ Instance #1  │    │
│  │              │      │ ✓ nuela-next │    │
│  │ Repos:       │      │ ✓ nuela-api  │    │
│  │ ☑ nuela-next │      │ Ports: 4000…│    │
│  │ ☑ nuela-api  │      │ [Open] [Kill]│    │
│  │ ☐ nuela-ai   │      └──────────────┘    │
│  │              │                           │
│  │ [Start]      │                           │
│  └──────────────┘                           │
└─────────────────────────────────────────────┘
```

## Prerequisites

- Rust toolchain (install with `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`)
- Node.js 18+ and npm
- Claude Multi-Thread CLI tools installed in `~/dev/claude-multi-thread`

## Development

```bash
# Install dependencies
npm install

# Run in development mode
npm run tauri dev
```

## Build

```bash
# Build for production
npm run tauri build

# The .dmg will be in src-tauri/target/release/bundle/dmg/
```

## How It Works

The app provides a graphical interface for the `claude-multi-start` and `claude-multi-cleanup` commands:

1. **Create Stack**: Calls `~/dev/claude-multi-thread/bin/claude-multi-start` with selected repos and branch
2. **List Stacks**: Calls `~/dev/claude-multi-thread/bin/claude-multi-list-stacks` to show active instances
3. **Kill Stack**: Calls `~/dev/claude-multi-thread/bin/claude-multi-cleanup` to remove temporary directories

## Configuration

The app reads repository configuration from `~/dev/claude-multi-thread/config/repos.conf`. If not found, it uses these defaults:

```
nuela-next (port 3000)
nuela-apiv2 (port 3003)
nuela-ai (port 3001)
```

## Tech Stack

- **Frontend**: React 18 + TypeScript + TailwindCSS
- **Icons**: Lucide React
- **Backend**: Rust + Tauri 2.0
- **Build Tool**: Vite

## Architecture

```
┌─────────────┐
│   React UI  │ ─── invoke() ───┐
└─────────────┘                 │
                                ▼
                        ┌───────────────┐
                        │  Rust Backend │
                        └───────────────┘
                                │
                                ├── get_repositories()
                                ├── create_stack()
                                ├── list_stacks()
                                ├── open_stack()
                                └── kill_stack()
                                        │
                                        ▼
                                ┌───────────────┐
                                │  Bash Scripts │
                                └───────────────┘
```

## Recommended IDE Setup

- [VS Code](https://code.visualstudio.com/) + [Tauri](https://marketplace.visualstudio.com/items?itemName=tauri-apps.tauri-vscode) + [rust-analyzer](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer)

## License

MIT
