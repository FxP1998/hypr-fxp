#!/usr/bin/env bash

# Simple script to reload Vim and Neovim after theme changes

echo "󰑓 Reloading editors..."

# Reload Vim in running instances (if using client-server)
if command -v vim &> /dev/null; then
    # Try to reload Vim if running with server
    vim --servername VIM --remote-send ':source ~/.vim/colors.vim<CR>' 2>/dev/null && echo " Vim colors reloaded" || echo "  Vim not running with server"
fi

# Reload Neovim in running instances
if command -v nvim &> /dev/null; then
    # For Neovim, we can try multiple methods
    
    # Method 1: If using nvim-remote
    if command -v nvr &> /dev/null; then
        nvr --remote-send ':source $MYVIMRC<CR>' 2>/dev/null && echo " Neovim colors reloaded via nvr"
    fi
    
    # Method 2: Send signal to all nvim processes (basic reload)
    echo "󰋼 Neovim: Run ':source \$MYVIMRC' in each instance"
    
    # Method 3: If you want to automatically reload, you can use this:
    # pkill -USR1 nvim  # This requires special handling in your init.lua
fi

echo " Editor reload commands sent!"
