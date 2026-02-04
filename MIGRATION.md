# Migration Guide - v1.x to v2.0

## What Changed?

Version 2.0 adds powerful multi-repository support and makes the tool fully portable across different directory structures.

## Breaking Changes

### Symlinks Location

**Before (v1.x):**
- Symlinks were always created in `~/dev`
- Hardcoded, not configurable

**After (v2.0):**
- Symlinks use `SYMLINK_DIR` from `repos.conf`
- Fully configurable
- Defaults to `~/dev` for backward compatibility

## Migration Steps

### For Existing Users

If you're upgrading from v1.x, follow these steps:

#### 1. Pull Latest Changes

```bash
cd ~/dev/claude-multi-thread  # or wherever you installed it
git pull
```

#### 2. Configure Your Workspace (New!)

Edit `config/repos.conf`:

```bash
nano ~/dev/claude-multi-thread/config/repos.conf
```

Set your workspace directory:

```bash
# If you use ~/dev (default)
WORKSPACE_DIR="$HOME/dev"
SYMLINK_DIR="${SYMLINK_DIR:-$WORKSPACE_DIR}"

# If you use something else
WORKSPACE_DIR="$HOME/projects"  # Change this!
SYMLINK_DIR="${SYMLINK_DIR:-$WORKSPACE_DIR}"
```

#### 3. Reload Aliases

```bash
source ~/.zshrc  # or ~/.bashrc
```

#### 4. Cleanup Old Instances

Clean up any existing instances created with v1.x:

```bash
cmc
```

#### 5. Test

```bash
# Test single repo
cmb feature/test

# Test multi-repo (new!)
cms feature/test --profile full-stack
```

## New Features to Try

### 1. Multi-Repository Mode

Define your repos in `repos.conf`:

```bash
declare -A REPOS=(
    ["frontend"]="$WORKSPACE_DIR/frontend:3000"
    ["backend"]="$WORKSPACE_DIR/backend:3001"
)

declare -A PROFILES=(
    ["full-stack"]="frontend,backend"
)
```

Then use:

```bash
cms feature/auth --profile full-stack
```

### 2. Automatic Port Management

Each instance gets incremented ports:
- Instance 0: 3000, 3001
- Instance 1: 4000, 4001
- Instance 2: 5000, 5001

### 3. Smart .env Updates

Configure cross-service URLs:

```bash
ENV_MAPPINGS=(
    "frontend:API_URL:backend:0"
)
```

The tool automatically updates `frontend/.env` to point to the correct backend port!

## Common Issues

### Issue 1: Symlinks Still Going to ~/dev

**Problem:** You changed `WORKSPACE_DIR` but symlinks still go to `~/dev`

**Solution:** Make sure you also updated `SYMLINK_DIR`:

```bash
WORKSPACE_DIR="$HOME/projects"
SYMLINK_DIR="$HOME/projects"  # Add this line!
```

### Issue 2: repos.conf Not Found

**Problem:** `Error: Configuration file not found`

**Solution:** The file was added in v2.0. Create it:

```bash
cp ~/dev/claude-multi-thread/config/repos.conf.examples \
   ~/dev/claude-multi-thread/config/repos.conf

# Then edit it
nano ~/dev/claude-multi-thread/config/repos.conf
```

### Issue 3: Tool Installed in Different Location

**Problem:** You installed claude-multi-thread in `~/tools` instead of `~/dev`

**Solution:** The tool now auto-detects its location! Just make sure your shell config points to the right place:

```bash
# In ~/.zshrc or ~/.bashrc
source ~/tools/claude-multi-thread/config/aliases.sh  # Update path
```

## Backward Compatibility

All v1.x commands still work:

```bash
cmb feature/test              # ✅ Still works
cmo "main,develop"            # ✅ Still works
cml                           # ✅ Still works
cmg 1                         # ✅ Still works
cmc                           # ✅ Still works
```

Plus new commands:

```bash
cms feature/test              # ✨ New! Multi-repo
cmls                          # ✨ New! List stacks
```

## Questions?

- Check `README.md` for full documentation
- See `config/repos.conf.examples` for configuration examples
- See `docs/MULTI-REPO-SETUP.md` for detailed multi-repo guide

## Rollback to v1.x

If you need to rollback:

```bash
cd ~/dev/claude-multi-thread
git checkout v1.1.0  # or last v1.x tag
source ~/.zshrc
```
