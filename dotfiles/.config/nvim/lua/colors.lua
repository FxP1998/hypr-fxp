-- Catppuccin Mocha Enhanced - Color Scheme for Neovim
vim.cmd('set background=dark')
vim.cmd('set termguicolors')

-- Catppuccin Mocha Base Colors
vim.api.nvim_set_hl(0, 'Normal', { bg = '#1e1e2e', fg = '#cdd6f4' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#313244', fg = '#cdd6f4' })
vim.api.nvim_set_hl(0, 'Comment', { fg = '#6c7086', italic = true })
vim.api.nvim_set_hl(0, 'Constant', { fg = '#f38ba8' })
vim.api.nvim_set_hl(0, 'String', { fg = '#a6e3a1' })
vim.api.nvim_set_hl(0, 'Character', { fg = '#cba6f7' })
vim.api.nvim_set_hl(0, 'Number', { fg = '#fab387' })
vim.api.nvim_set_hl(0, 'Boolean', { fg = '#f38ba8' })
vim.api.nvim_set_hl(0, 'Float', { fg = '#fab387' })

-- Identifiers
vim.api.nvim_set_hl(0, 'Identifier', { fg = '#89b4fa' })
vim.api.nvim_set_hl(0, 'Function', { fg = '#cba6f7' })
vim.api.nvim_set_hl(0, 'Variable', { fg = '#cdd6f4' })

-- Statements
vim.api.nvim_set_hl(0, 'Statement', { fg = '#f9e2af' })
vim.api.nvim_set_hl(0, 'Conditional', { fg = '#f38ba8' })
vim.api.nvim_set_hl(0, 'Repeat', { fg = '#f38ba8' })
vim.api.nvim_set_hl(0, 'Label', { fg = '#fab387' })
vim.api.nvim_set_hl(0, 'Operator', { fg = '#94e2d5' })
vim.api.nvim_set_hl(0, 'Keyword', { fg = '#f38ba8' })
vim.api.nvim_set_hl(0, 'Exception', { fg = '#f38ba8' })

-- Preprocessor
vim.api.nvim_set_hl(0, 'PreProc', { fg = '#cba6f7' })
vim.api.nvim_set_hl(0, 'Include', { fg = '#cba6f7' })
vim.api.nvim_set_hl(0, 'Define', { fg = '#cba6f7' })
vim.api.nvim_set_hl(0, 'Macro', { fg = '#cba6f7' })
vim.api.nvim_set_hl(0, 'PreCondit', { fg = '#cba6f7' })

-- Types
vim.api.nvim_set_hl(0, 'Type', { fg = '#f9e2af' })
vim.api.nvim_set_hl(0, 'StorageClass', { fg = '#fab387' })
vim.api.nvim_set_hl(0, 'Structure', { fg = '#cba6f7' })
vim.api.nvim_set_hl(0, 'Typedef', { fg = '#cba6f7' })

-- Special
vim.api.nvim_set_hl(0, 'Special', { fg = '#f5c2e7' })
vim.api.nvim_set_hl(0, 'SpecialChar', { fg = '#f38ba8' })
vim.api.nvim_set_hl(0, 'Tag', { fg = '#89b4fa' })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#bac2de' })
vim.api.nvim_set_hl(0, 'SpecialComment', { fg = '#6c7086' })
vim.api.nvim_set_hl(0, 'Debug', { fg = '#f38ba8' })

-- UI Elements
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#6c7086' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#cdd6f4', bold = true })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#313244' })
vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#313244' })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#313244' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#1e1e2e', fg = '#6c7086' })
vim.api.nvim_set_hl(0, 'FoldColumn', { bg = '#1e1e2e', fg = '#6c7086' })
vim.api.nvim_set_hl(0, 'Folded', { bg = '#313244', fg = '#6c7086' })

-- Cursor settings - HIGH VISIBILITY
vim.api.nvim_set_hl(0, 'Cursor', { bg = '#f5e0dc', fg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'iCursor', { bg = '#f5e0dc', fg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'CursorIM', { bg = '#f5e0dc', fg = '#1e1e2e' })

-- Visual Mode
vim.api.nvim_set_hl(0, 'Visual', { bg = '#585b70' })
vim.api.nvim_set_hl(0, 'VisualNOS', { bg = '#585b70' })

-- Search
vim.api.nvim_set_hl(0, 'Search', { bg = '#f9e2af', fg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#fab387', fg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'MatchParen', { bg = '#cba6f7', fg = '#1e1e2e', bold = true })

-- Status Line
vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#313244', fg = '#cdd6f4' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#1e1e2e', fg = '#6c7086' })
vim.api.nvim_set_hl(0, 'WildMenu', { bg = '#cba6f7', fg = '#1e1e2e' })

-- Tab Line
vim.api.nvim_set_hl(0, 'TabLine', { bg = '#313244', fg = '#6c7086' })
vim.api.nvim_set_hl(0, 'TabLineSel', { bg = '#cba6f7', fg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#1e1e2e', fg = '#6c7086' })

-- Pmenu (Completion)
vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#313244', fg = '#cdd6f4' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#cba6f7', fg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#313244' })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#45475a' })

-- Errors and Warnings
vim.api.nvim_set_hl(0, 'Error', { bg = '#f38ba8', fg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'ErrorMsg', { bg = '#f38ba8', fg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'WarningMsg', { bg = '#f9e2af', fg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'MoreMsg', { fg = '#a6e3a1' })
vim.api.nvim_set_hl(0, 'ModeMsg', { fg = '#cdd6f4' })
vim.api.nvim_set_hl(0, 'Question', { fg = '#f9e2af' })

-- Diffs
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#313244', fg = '#a6e3a1' })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#313244', fg = '#f9e2af' })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#313244', fg = '#f38ba8' })
vim.api.nvim_set_hl(0, 'DiffText', { bg = '#313244', fg = '#fab387' })

-- Spelling
vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true, sp = '#f38ba8' })
vim.api.nvim_set_hl(0, 'SpellCap', { undercurl = true, sp = '#f9e2af' })
vim.api.nvim_set_hl(0, 'SpellRare', { undercurl = true, sp = '#cba6f7' })
vim.api.nvim_set_hl(0, 'SpellLocal', { undercurl = true, sp = '#94e2d5' })

-- Special Syntax
vim.api.nvim_set_hl(0, 'Title', { fg = '#89b4fa', bold = true })
vim.api.nvim_set_hl(0, 'Todo', { bg = '#f9e2af', fg = '#1e1e2e', bold = true })
vim.api.nvim_set_hl(0, 'Underlined', { fg = '#cba6f7', underline = true })
vim.api.nvim_set_hl(0, 'SpecialKey', { fg = '#6c7086' })
vim.api.nvim_set_hl(0, 'NonText', { fg = '#6c7086' })
vim.api.nvim_set_hl(0, 'Directory', { fg = '#89b4fa' })
vim.api.nvim_set_hl(0, 'Conceal', { fg = '#6c7086' })

-- LSP and Diagnostics
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#f38ba8' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#f9e2af' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#89b4fa' })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#94e2d5' })
vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#585b70' })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#585b70' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#585b70' })

-- Treesitter
vim.api.nvim_set_hl(0, '@function', { fg = '#cba6f7' })
vim.api.nvim_set_hl(0, '@function.call', { fg = '#cba6f7' })
vim.api.nvim_set_hl(0, '@parameter', { fg = '#cdd6f4' })
vim.api.nvim_set_hl(0, '@field', { fg = '#f9e2af' })
vim.api.nvim_set_hl(0, '@property', { fg = '#f9e2af' })
vim.api.nvim_set_hl(0, '@constructor', { fg = '#fab387' })
vim.api.nvim_set_hl(0, '@tag', { fg = '#cba6f7' })
vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = '#bac2de' })

-- Additional Catppuccin Mocha colors available:
-- Rosewater: #f5e0dc, Flamingo: #f2cdcd, Pink: #f5c2e7,
-- Mauve: #cba6f7, Maroon: #eba0ac, Peach: #fab387,
-- Green: #a6e3a1, Teal: #94e2d5, Sky: #89dceb,
-- Sapphire: #74c7ec, Blue: #89b4fa, Lavender: #b4befe,
-- Surface0: #45475a, Surface1: #585b70, Surface2: #6c7086
