-- Source colors
require('colors')

-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.numberwidth = 5
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.cursorline = true
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:list,full'

-- Mouse Support
vim.opt.mouse = 'a'

-- Key mappings
vim.g.mapleader = ' '

-- Better navigation
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- File explorer
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Quick save and quit
vim.keymap.set('n', '<leader>w', vim.cmd.w)
vim.keymap.set('n', '<leader>q', vim.cmd.q)
vim.keymap.set('n', '<leader>wq', vim.cmd.wq)

-- Buffer navigation
vim.keymap.set('n', '<leader>bn', vim.cmd.bnext)
vim.keymap.set('n', '<leader>bp', vim.cmd.bprevious)
vim.keymap.set('n', '<leader>bd', vim.cmd.bdelete)

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Search
vim.opt.hlsearch = true
vim.keymap.set('n', '<leader>h', vim.cmd.nohlsearch)

-- wl-clipboard integration
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('v', '<leader>p', '"+p')
