# Quick Start Guide

## 🚀 First Time Setup

1. **Install Rust** (if not already installed):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source $HOME/.cargo/env
   ```

2. **Install Node dependencies**:
   ```bash
   npm install
   ```

3. **Verify CLI tools exist**:
   ```bash
   ls ~/dev/claude-multi-thread/bin/
   # Should show: claude-multi-start, claude-multi-cleanup, claude-multi-list-stacks
   ```

## 🎮 Running the App

### Development Mode
```bash
npm run tauri dev
```
This opens the app with hot-reload. Changes to React code will refresh automatically.

### Build for Production
```bash
npm run tauri build
```
The `.dmg` installer will be in `src-tauri/target/release/bundle/dmg/`

## 📖 Using the App

### Creating a Stack
1. Enter a branch name (e.g., `feature/auth`)
2. Select repositories to include
3. Optionally check "Install dependencies"
4. Click "Create Stack"

### Managing Stacks
- **Refresh**: Click refresh icon to update active stacks list
- **Open**: Opens all repos in Claude Code instances
- **Kill**: Removes the stack and cleans up temp directories

## 🔧 Configuration

Edit `~/dev/claude-multi-thread/config/repos.conf` to customize repositories:

```bash
declare -A REPOS=(
    ["my-frontend"]="$HOME/dev/my-frontend:3000"
    ["my-backend"]="$HOME/dev/my-backend:8000"
)
```

## 🐛 Troubleshooting

### "Command not found" errors
Make sure `~/dev/claude-multi-thread/config/aliases.sh` is sourced in your `~/.zshrc`:
```bash
source ~/dev/claude-multi-thread/config/aliases.sh
```

### Rust not found
Restart your terminal or run:
```bash
source $HOME/.cargo/env
```

### Ports already in use
The app automatically increments ports for each instance:
- Instance 0: base ports (3000, 3003, 3001)
- Instance 1: +1000 (4000, 4003, 4001)
- Instance 2: +1000 (5000, 5003, 5001)

## 🎨 Customization

### Change Theme Colors
Edit `src/index.css`:
```css
:root {
  --background: 222 47% 11%;  /* Dark blue-gray */
  --foreground: 210 40% 98%;  /* Almost white */
  --border: 217 33% 17%;      /* Border gray */
}
```

### Add More Repositories
Repositories are auto-loaded from `config/repos.conf` or you can modify the defaults in `src-tauri/src/lib.rs:48`

## 📦 Building Icons

To change the app icon, replace files in `src-tauri/icons/` with your custom icons.

## 🔥 Hot Tips

- Use **Cmd+R** to refresh the app during development
- The app remembers window size between sessions
- Native notifications coming soon!
