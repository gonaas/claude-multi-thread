#!/bin/bash

# Claude Multi-Thread Installation Script

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

INSTALL_DIR="$HOME/dev/claude-multi-thread"

echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    Claude Multi-Thread Installation${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

# Make scripts executable
echo -e "${BLUE}1. Making scripts executable...${NC}"
chmod +x "$INSTALL_DIR/bin/claude-multi-branch"
chmod +x "$INSTALL_DIR/bin/claude-multi-cleanup"
chmod +x "$INSTALL_DIR/config/aliases.sh"
echo -e "   ${GREEN}✓${NC} Scripts are now executable\n"

# Detect shell
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
    SHELL_NAME="zsh"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
    SHELL_NAME="bash"
else
    echo -e "${RED}✗ No .zshrc or .bashrc found${NC}"
    exit 1
fi

echo -e "${BLUE}2. Detected shell: ${NC}$SHELL_NAME"

# Check if already installed
if grep -q "claude-multi-thread/config/aliases.sh" "$SHELL_CONFIG" 2>/dev/null; then
    echo -e "   ${YELLOW}⚠${NC}  Already installed in $SHELL_CONFIG"
    echo -e "   ${BLUE}Skipping configuration...${NC}\n"
else
    echo -e "${BLUE}3. Adding configuration to $SHELL_CONFIG...${NC}"

    # Backup existing config
    cp "$SHELL_CONFIG" "$SHELL_CONFIG.backup.$(date +%Y%m%d-%H%M%S)"
    echo -e "   ${GREEN}✓${NC} Backup created"

    # Add configuration
    cat >> "$SHELL_CONFIG" << 'EOF'

# Claude Multi-Thread
source ~/dev/claude-multi-thread/config/aliases.sh
EOF

    echo -e "   ${GREEN}✓${NC} Configuration added\n"
fi

# Verify Claude CLI
echo -e "${BLUE}4. Verifying Claude CLI...${NC}"
if command -v claude &> /dev/null; then
    echo -e "   ${GREEN}✓${NC} Claude CLI found: $(claude --version)"
else
    echo -e "   ${RED}✗${NC} Claude CLI not found"
    echo -e "   ${YELLOW}Please install Claude CLI first${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}    Installation completed successfully!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}\n"

echo -e "${BLUE}📖 Next steps:${NC}\n"
echo -e "   ${YELLOW}1.${NC} Reload your shell:"
echo -e "      ${GREEN}source $SHELL_CONFIG${NC}\n"
echo -e "   ${YELLOW}2.${NC} View help:"
echo -e "      ${GREEN}claude-multi-help${NC}\n"
echo -e "   ${YELLOW}3.${NC} Try it out:"
echo -e "      ${GREEN}cmb develop${NC}\n"

echo -e "${BLUE}📚 Documentation:${NC}"
echo -e "   ${GREEN}cat ~/dev/claude-multi-thread/README.md${NC}\n"
