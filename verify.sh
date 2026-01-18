#!/bin/bash

# Verification script for Claude Multi-Thread installation

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔍 Verifying Claude Multi-Thread installation...${NC}\n"

# Check scripts exist
echo -e "${BLUE}1. Checking scripts:${NC}"
if [ -f ~/dev/claude-multi-thread/bin/claude-multi-branch ]; then
    if [ -x ~/dev/claude-multi-thread/bin/claude-multi-branch ]; then
        echo -e "   ${GREEN}✓${NC} claude-multi-branch (executable)"
    else
        echo -e "   ${YELLOW}⚠${NC}  claude-multi-branch (not executable)"
    fi
else
    echo -e "   ${RED}✗${NC} claude-multi-branch not found"
fi

if [ -f ~/dev/claude-multi-thread/bin/claude-multi-cleanup ]; then
    if [ -x ~/dev/claude-multi-thread/bin/claude-multi-cleanup ]; then
        echo -e "   ${GREEN}✓${NC} claude-multi-cleanup (executable)"
    else
        echo -e "   ${YELLOW}⚠${NC}  claude-multi-cleanup (not executable)"
    fi
else
    echo -e "   ${RED}✗${NC} claude-multi-cleanup not found"
fi

# Check configuration
echo -e "\n${BLUE}2. Checking shell configuration:${NC}"
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CONFIG" ]; then
    if grep -q "claude-multi-thread/config/aliases.sh" "$SHELL_CONFIG" 2>/dev/null; then
        echo -e "   ${GREEN}✓${NC} Configuration found in $SHELL_CONFIG"
    else
        echo -e "   ${YELLOW}⚠${NC}  Configuration not found in $SHELL_CONFIG"
        echo -e "   ${BLUE}Run: ~/dev/claude-multi-thread/install.sh${NC}"
    fi
else
    echo -e "   ${RED}✗${NC} No shell config found"
fi

# Check PATH
echo -e "\n${BLUE}3. Checking PATH:${NC}"
if echo $PATH | grep -q "claude-multi-thread/bin"; then
    echo -e "   ${GREEN}✓${NC} claude-multi-thread/bin in PATH"
else
    echo -e "   ${YELLOW}⚠${NC}  claude-multi-thread/bin NOT in PATH"
    echo -e "   ${BLUE}Reload your shell: source $SHELL_CONFIG${NC}"
fi

# Check commands available
echo -e "\n${BLUE}4. Checking commands:${NC}"
if command -v claude-multi-branch &> /dev/null; then
    echo -e "   ${GREEN}✓${NC} claude-multi-branch available"
else
    echo -e "   ${RED}✗${NC} claude-multi-branch not available"
fi

if command -v claude &> /dev/null; then
    echo -e "   ${GREEN}✓${NC} Claude CLI available ($(claude --version))"
else
    echo -e "   ${RED}✗${NC} Claude CLI not found"
fi

# Check aliases
echo -e "\n${BLUE}5. Checking aliases:${NC}"
if type cmb &> /dev/null; then
    echo -e "   ${GREEN}✓${NC} cmb alias available"
else
    echo -e "   ${YELLOW}⚠${NC}  cmb alias not available (reload shell)"
fi

if type claude-multi-help &> /dev/null; then
    echo -e "   ${GREEN}✓${NC} claude-multi-help available"
else
    echo -e "   ${YELLOW}⚠${NC}  claude-multi-help not available (reload shell)"
fi

# Summary
echo -e "\n${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Verification complete!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

echo -e "${BLUE}💡 Quick start:${NC}"
echo -e "   ${GREEN}claude-multi-help${NC}     # Show help"
echo -e "   ${GREEN}cmb develop${NC}           # Open develop branch"
echo -e "   ${GREEN}cmb main ~/projects/app${NC}     # Open main in specific project"
echo -e "   ${GREEN}cmc${NC}                   # Cleanup temp directories\n"
