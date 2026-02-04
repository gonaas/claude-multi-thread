# Multi-Repository Setup Guide

This guide shows you how to configure `claude-multi-start` for your multi-repo projects.

## Quick Start

### 1. Configure Your Repositories

Edit `~/dev/claude-multi-thread/config/repos.conf`:

```bash
nano ~/dev/claude-multi-thread/config/repos.conf
```

### 2. Define Your Repos

Add your repositories with their paths and base ports:

```bash
declare -A REPOS=(
    # Your frontend
    ["my-frontend"]="$HOME/dev/my-frontend:3000"

    # Your backend
    ["my-backend"]="$HOME/dev/my-backend:3001"

    # Your AI service
    ["my-ai"]="$HOME/dev/my-ai:3002"
)
```

### 3. Create Profiles

Define common combinations:

```bash
declare -A PROFILES=(
    # All services together
    ["full-stack"]="my-frontend,my-backend,my-ai"

    # Just frontend and backend
    ["web"]="my-frontend,my-backend"

    # Backend services only
    ["backend"]="my-backend,my-ai"
)
```

### 4. Map Environment Variables

Tell the system which services need to connect to each other:

```bash
ENV_MAPPINGS=(
    # Frontend needs to know backend URL
    "my-frontend:REACT_APP_API_URL:my-backend:0"

    # Backend needs to know AI service URL
    "my-backend:AI_SERVICE_URL:my-ai:0"
)
```

**Format**: `"source_repo:ENV_VAR_NAME:target_repo:port_offset"`

## Example: Nuela Ecosystem

Here's a complete example for the Nuela AI ecosystem:

```bash
#!/bin/bash

# ============================================================================
# NUELA ECOSYSTEM CONFIGURATION
# ============================================================================

declare -A REPOS=(
    ["nuela-next"]="$HOME/dev/nuela-next:3000"
    ["nuela-apiv2"]="$HOME/dev/nuela-apiv2:3003"
    ["nuela-ai"]="$HOME/dev/nuela-ai:3001"
)

declare -A PROFILES=(
    ["full-stack"]="nuela-next,nuela-apiv2,nuela-ai"
    ["frontend-backend"]="nuela-next,nuela-apiv2"
    ["api-only"]="nuela-apiv2,nuela-ai"
)

ENV_MAPPINGS=(
    "nuela-next:NEXT_PUBLIC_SOCKET_URL:nuela-apiv2:0"
    "nuela-apiv2:NUELA_AI_URL:nuela-ai:0"
)

PORT_INCREMENT=1000

AUTO_INSTALL_DEPS=()
```

## Usage Examples

### Interactive Selection

```bash
cms feature/auth
```

Output:
```
📦 Available repositories:
  1) nuela-next ($HOME/dev/nuela-next - port 3000)
  2) nuela-apiv2 ($HOME/dev/nuela-apiv2 - port 3003)
  3) nuela-ai ($HOME/dev/nuela-ai - port 3001)

Enter repository numbers (comma-separated, e.g., 1,2,3):
1,2,3
```

### Use a Profile

```bash
cms feature/payment --profile full-stack
```

This will:
1. Clone all 3 repos to `feature/payment` branch
2. Assign ports: next=4000, api=4003, ai=4001 (instance 1)
3. Update `.env` files automatically
4. Open all 3 in Claude Code

### Manual Selection

```bash
cms develop --repos nuela-next,nuela-apiv2
```

### With Dependencies

```bash
cms feature/test --profile full-stack --install-deps
```

## Port Management

### How Ports Work

Each instance increments by `PORT_INCREMENT` (default: 1000):

| Instance | nuela-next | nuela-apiv2 | nuela-ai |
|----------|------------|-------------|----------|
| 0 (normal) | 3000 | 3003 | 3001 |
| 1 (cms #1) | 4000 | 4003 | 4001 |
| 2 (cms #2) | 5000 | 5003 | 5001 |
| 3 (cms #3) | 6000 | 6003 | 6001 |

### Custom Port Increment

Change in `repos.conf`:

```bash
PORT_INCREMENT=2000  # Larger gaps
```

## Environment Variable Mapping

### Understanding the Format

```bash
"source_repo:ENV_VAR_NAME:target_repo:port_offset"
```

- **source_repo**: The repo that has the env var
- **ENV_VAR_NAME**: The variable to update
- **target_repo**: The repo this var should point to
- **port_offset**: Additional offset (usually 0)

### Example Mapping

```bash
ENV_MAPPINGS=(
    "nuela-next:NEXT_PUBLIC_SOCKET_URL:nuela-apiv2:0"
)
```

This means:
- In `nuela-next/.env`
- Find `NEXT_PUBLIC_SOCKET_URL`
- Set it to `http://localhost:{nuela-apiv2-port}`

If instance 1:
- `nuela-apiv2` is on port 4003
- So `NEXT_PUBLIC_SOCKET_URL=http://localhost:4003`

## Advanced Configuration

### Auto-Install Dependencies

```bash
AUTO_INSTALL_DEPS=(
    "nuela-next"
    "nuela-apiv2"
)
```

Now `--install-deps` is not needed for these repos.

### Multiple Environment Files

The system updates these files automatically:
- `.env`
- `.env.local`
- `.env.development`
- `.env.production`

### Complex Mappings

```bash
ENV_MAPPINGS=(
    # Frontend to Backend
    "frontend:API_URL:backend:0"

    # Frontend to Auth Service
    "frontend:AUTH_URL:auth-service:0"

    # Backend to Database (if needed)
    "backend:DB_URL:postgres:0"

    # Backend to AI
    "backend:AI_URL:ai-service:0"
)
```

## Workflow Examples

### Full-Stack Feature Development

```bash
# Start full stack
cms feature/user-profile --profile full-stack

# Check what's running
cmls

# Work on the feature...

# When done
cmc
```

### Bug Investigation

```bash
# Compare working vs broken
cms main --profile full-stack &
cms hotfix/bug-123 --profile full-stack &

cmls
```

### Microservices Development

```bash
# Open only backend services
cms feature/api-refactor --profile api-only

# Add frontend later if needed
cmb feature/api-refactor ~/dev/nuela-next
```

## Tips

1. **Always use profiles** for common combinations
2. **Port conflicts**: Use `lsof -i :3000` to check if ports are in use
3. **Symlinks**: Access via `~/dev/{repo}-{branch}-i{instance}`
4. **Cleanup regularly**: Use `cmc` to free up disk space
5. **Check logs**: Each repo has its own git branch and changes

## Troubleshooting

### Port Already in Use

If you get "port already in use":
1. Check existing instances: `cmls` and `cml`
2. Cleanup old ones: `cmc`
3. Or use different branch to get new instance number

### Environment Not Updated

Make sure:
1. Both repos are in the same stack (selected together)
2. ENV_MAPPINGS has the correct format
3. The env var exists in the source `.env` file

### Repo Path Not Found

Update the path in `repos.conf`:
```bash
["my-repo"]="$HOME/projects/my-repo:3000"  # Full absolute path
```

## Next Steps

1. Configure your repos in `repos.conf`
2. Test with: `cms test-branch --profile your-profile`
3. Check the result: `cmls`
4. Create custom aliases in `~/.zshrc` for your workflows

Happy coding! 🚀
