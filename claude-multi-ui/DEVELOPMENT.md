# Development Guide

## 📁 Project Structure

```
claude-multi-ui/
├── src/                      # React frontend
│   ├── components/
│   │   ├── ui/              # Reusable UI components
│   │   │   ├── Button.tsx
│   │   │   ├── Card.tsx
│   │   │   ├── Checkbox.tsx
│   │   │   └── Input.tsx
│   │   ├── ActiveStacks.tsx # Active stacks list
│   │   ├── StackCard.tsx    # Individual stack display
│   │   └── StackCreator.tsx # Stack creation form
│   ├── lib/
│   │   └── utils.ts         # Utility functions
│   ├── types.ts             # TypeScript interfaces
│   ├── App.tsx              # Main application
│   ├── main.tsx             # React entry point
│   └── index.css            # Global styles + Tailwind
│
├── src-tauri/               # Rust backend
│   ├── src/
│   │   ├── main.rs          # Entry point
│   │   └── lib.rs           # Tauri commands
│   ├── Cargo.toml           # Rust dependencies
│   └── tauri.conf.json      # Tauri configuration
│
├── package.json             # Node dependencies
├── tailwind.config.js       # Tailwind CSS config
├── vite.config.ts           # Vite bundler config
├── README.md                # Main documentation
├── QUICKSTART.md            # Quick start guide
└── DEVELOPMENT.md           # This file
```

## 🔄 Data Flow

```
User Action (UI)
      ↓
React Component
      ↓
invoke("command", { args })
      ↓
Tauri IPC Bridge
      ↓
Rust Command Handler
      ↓
Shell Script Execution
      ↓
Return Result
      ↓
Update UI State
```

## 🛠️ Available Commands

### Tauri Commands (Rust → Bash)

#### `get_repositories()`
Returns list of configured repositories from `repos.conf`

**Returns:**
```typescript
Repository[] = [
  { name: "nuela-next", path: "/path/to/repo", basePort: 3000 },
  ...
]
```

#### `create_stack(branch, repos, installDeps)`
Creates a new multi-repo stack

**Parameters:**
- `branch: string` - Git branch name
- `repos: string[]` - Array of repo names
- `installDeps: boolean` - Whether to run npm install

**Calls:** `~/dev/claude-multi-thread/bin/claude-multi-start`

#### `list_stacks()`
Returns all active stack instances

**Returns:**
```typescript
StackInstance[] = [
  {
    id: "stack-1-feature/auth",
    branch: "feature/auth",
    instanceNumber: 1,
    repositories: [
      { name: "nuela-next", port: 4000, path: "...", symlink: "..." }
    ],
    createdAt: "2026-02-03T...",
    tempDir: "/tmp/..."
  }
]
```

**Calls:** `~/dev/claude-multi-thread/bin/claude-multi-list-stacks`

#### `open_stack(stackId)`
Opens Claude Code instances for stack (not yet implemented)

#### `kill_stack(stackId)`
Removes a stack and cleans up temp directories

**Calls:** `~/dev/claude-multi-thread/bin/claude-multi-cleanup`

## 🎨 UI Components

### StackCreator
Form for creating new stacks
- Branch name input
- Repository checkboxes
- Install dependencies toggle
- Submit button with loading state

### ActiveStacks
List of running stacks
- Refresh button
- Empty state message
- Scrollable list of StackCards

### StackCard
Individual stack display
- Branch name with icon
- Instance number badge
- Repository list with ports
- Open and Kill action buttons

## 🧪 Testing

### Manual Testing Checklist
- [ ] App launches without errors
- [ ] Repositories load from config
- [ ] Can create a new stack
- [ ] Active stacks display correctly
- [ ] Can refresh stack list
- [ ] Can kill a stack
- [ ] Error messages display for failures
- [ ] Loading states work properly

### Testing Commands
```bash
# Check Rust compilation
cd src-tauri && cargo check

# Check TypeScript types
npm run check

# Build app
npm run tauri build

# Run in dev mode
npm run tauri dev
```

## 🐛 Common Issues

### Rust compilation errors
```bash
# Clean and rebuild
cd src-tauri
cargo clean
cargo build
```

### React/TypeScript errors
```bash
# Clear node_modules
rm -rf node_modules package-lock.json
npm install
```

### Tauri IPC issues
Check that:
1. Command is registered in `tauri::generate_handler![]`
2. Command has `#[tauri::command]` attribute
3. serde serialization is correct

### Shell script not found
Verify paths in `lib.rs:132` and ensure scripts are executable:
```bash
chmod +x ~/dev/claude-multi-thread/bin/*
```

## 📝 Adding New Features

### Adding a New Command

1. **Define Rust command** (`src-tauri/src/lib.rs`):
```rust
#[tauri::command]
fn my_new_command(arg: String) -> Result<String, String> {
    // Implementation
    Ok("result".to_string())
}

// Register in run()
.invoke_handler(tauri::generate_handler![
    get_repositories,
    my_new_command  // Add here
])
```

2. **Call from React** (`src/App.tsx`):
```typescript
import { invoke } from "@tauri-apps/api/core"

const result = await invoke<string>("my_new_command", { arg: "value" })
```

3. **Update types** (`src/types.ts`):
```typescript
export interface MyNewType {
  field: string
}
```

### Adding a New UI Component

1. Create component in `src/components/`
2. Import and use in `App.tsx`
3. Add types to `src/types.ts`
4. Style with Tailwind classes

## 🔧 Configuration

### Window Size
Edit `src-tauri/tauri.conf.json`:
```json
{
  "windows": [{
    "width": 1200,
    "height": 800
  }]
}
```

### App Icon
Replace files in `src-tauri/icons/` with your custom icons

### Theme
Edit CSS variables in `src/index.css`:
```css
:root {
  --background: 222 47% 11%;
  --foreground: 210 40% 98%;
}
```

## 📚 Useful Resources

- [Tauri Docs](https://tauri.app)
- [React TypeScript](https://react-typescript-cheatsheet.netlify.app/)
- [TailwindCSS](https://tailwindcss.com/docs)
- [Lucide Icons](https://lucide.dev/)

## 🚀 Deployment

### macOS
```bash
npm run tauri build
# .dmg in src-tauri/target/release/bundle/dmg/
```

### Code Signing (for distribution)
1. Get Apple Developer account
2. Create certificates
3. Configure in `tauri.conf.json`
4. Build with signing

## 💡 Tips

- Use React DevTools for debugging UI
- Use `console.log` in Rust (goes to terminal)
- Hot reload works for React, not for Rust
- Test bash scripts independently first
- Keep UI components small and focused
