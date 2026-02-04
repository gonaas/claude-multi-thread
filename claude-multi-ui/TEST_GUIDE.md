# 🧪 Testing Guide

## Current Status
✅ App is running in development mode
✅ Vite dev server: http://localhost:1420/
✅ Hot reload enabled

## What You Should See

A native macOS window with:
- Title: "Claude Multi-Thread"
- Two panels side by side
- Left panel: "🚀 New Stack" with form
- Right panel: "📋 Active Stacks" (empty initially)

## How to Test

### 1. Check Repository Loading
Look at the left panel - you should see checkboxes for:
- nuela-next (port 3000)
- nuela-apiv2 (port 3003)
- nuela-ai (port 3001)

### 2. Create a Test Stack
1. Type a branch name: `feature/test-ui`
2. Check 2-3 repositories
3. Optionally check "Install dependencies"
4. Click "Create Stack"

This will execute:
```bash
~/dev/claude-multi-thread/bin/claude-multi-start feature/test-ui --repos repo1,repo2
```

### 3. View Active Stacks
- Click "Refresh" in right panel
- Should show your stack with:
  - Branch name
  - Instance number
  - Repository names with ports
  - [Open] and [Kill] buttons

### 4. Kill a Stack
- Click the red trash icon on any stack
- Confirms and runs cleanup script

## Development Features

### Hot Reload
- Edit files in `src/` - UI updates automatically
- Edit `src-tauri/src/lib.rs` - requires restart

### DevTools
- Right-click in app → "Inspect Element"
- Opens Chrome DevTools for debugging

### Logs
Terminal shows:
- Vite output (frontend)
- Rust output (backend)
- Any console.log from React
- Any println! from Rust

## Console Commands While Running

```bash
# View logs
tail -f /private/tmp/claude/-Users-gonzaloastudilloortega-dev-claude-multi-thread/tasks/b86851c.output

# Kill app
pkill -f "claude-multi-ui"

# Restart
npm run tauri dev
```

## Expected Behavior

✅ Form validates input (branch required, at least 1 repo)
✅ Loading spinner shows during stack creation
✅ Success/error messages display
✅ Stack list refreshes automatically after creation
✅ Ports increment by 1000 per instance

## Troubleshooting

### "Command failed" errors
- Check that scripts exist in `~/dev/claude-multi-thread/bin/`
- Verify scripts are executable: `chmod +x ~/dev/claude-multi-thread/bin/*`

### Empty repository list
- Check `~/dev/claude-multi-thread/config/repos.conf`
- App falls back to defaults if config missing

### App doesn't open
- Check terminal for errors
- Try: `npm run tauri dev`

## Next Steps

After testing basic functionality:
1. Try creating multiple stacks
2. Test with different branch names
3. Verify ports are correct (4000, 5000, etc.)
4. Test kill functionality
5. Check that symlinks are created in ~/dev/

Enjoy! 🚀
