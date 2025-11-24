-- Catppuccin Latte Enhanced - Color Scheme for Neovim
vim.cmd('set background=light')
vim.cmd('set termguicolors')

-- Catppuccin Latte Base Colors
vim.api.nvim_set_hl(0, 'Normal', { bg = '#eff1f5', fg = '#4c4f69' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#e6e9ef', fg = '#4c4f69' })
vim.api.nvim_set_hl(0, 'Comment', { fg = '#9ca0b0', italic = true })
vim.api.nvim_set_hl(0, 'Constant', { fg = '#d20f39' })
vim.api.nvim_set_hl(0, 'String', { fg = '#40a02b' })
vim.api.nvim_set_hl(0, 'Character', { fg = '#8839ef' })
vim.api.nvim_set_hl(0, 'Number', { fg = '#fe640b' })
vim.api.nvim_set_hl(0, 'Boolean', { fg = '#d20f39' })
vim.api.nvim_set_hl(0, 'Float', { fg = '#fe640b' })

-- Identifiers
vim.api.nvim_set_hl(0, 'Identifier', { fg = '#1e66f5' })
vim.api.nvim_set_hl(0, 'Function', { fg = '#8839ef' })
vim.api.nvim_set_hl(0, 'Variable', { fg = '#4c4f69' })

-- Statements
vim.api.nvim_set_hl(0, 'Statement', { fg = '#df8e1d' })
vim.api.nvim_set_hl(0, 'Conditional', { fg = '#d20f39' })
vim.api.nvim_set_hl(0, 'Repeat', { fg = '#d20f39' })
vim.api.nvim_set_hl(0, 'Label', { fg = '#fe640b' })
vim.api.nvim_set_hl(0, 'Operator', { fg = '#179299' })
vim.api.nvim_set_hl(0, 'Keyword', { fg = '#d20f39' })
vim.api.nvim_set_hl(0, 'Exception', { fg = '#d20f39' })

-- Preprocessor
vim.api.nvim_set_hl(0, 'PreProc', { fg = '#8839ef' })
vim.api.nvim_set_hl(0, 'Include', { fg = '#8839ef' })
vim.api.nvim_set_hl(0, 'Define', { fg = '#8839ef' })
vim.api.nvim_set_hl(0, 'Macro', { fg = '#8839ef' })
vim.api.nvim_set_hl(0, 'PreCondit', { fg = '#8839ef' })

-- Types
vim.api.nvim_set_hl(0, 'Type', { fg = '#df8e1d' })
vim.api.nvim_set_hl(0, 'StorageClass', { fg = '#fe640b' })
vim.api.nvim_set_hl(0, 'Structure', { fg = '#8839ef' })
vim.api.nvim_set_hl(0, 'Typedef', { fg = '#8839ef' })

-- Special
vim.api.nvim_set_hl(0, 'Special', { fg = '#ea76cb' })
vim.api.nvim_set_hl(0, 'SpecialChar', { fg = '#d20f39' })
vim.api.nvim_set_hl(0, 'Tag', { fg = '#1e66f5' })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#5c5f77' })
vim.api.nvim_set_hl(0, 'SpecialComment', { fg = '#9ca0b0' })
vim.api.nvim_set_hl(0, 'Debug', { fg = '#d20f39' })

-- UI Elements
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#9ca0b0' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#4c4f69', bold = true })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#e6e9ef' })
vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#e6e9ef' })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#e6e9ef' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#eff1f5', fg = '#9ca0b0' })
vim.api.nvim_set_hl(0, 'FoldColumn', { bg = '#eff1f5', fg = '#9ca0b0' })
vim.api.nvim_set_hl(0, 'Folded', { bg = '#e6e9ef', fg = '#9ca0b0' })

-- Cursor settings - HIGH VISIBILITY
vim.api.nvim_set_hl(0, 'Cursor', { bg = '#dc8a78', fg = '#eff1f5' })
vim.api.nvim_set_hl(0, 'iCursor', { bg = '#dc8a78', fg = '#eff1f5' })
vim.api.nvim_set_hl(0, 'CursorIM', { bg = '#dc8a78', fg = '#eff1f5' })

-- Visual Mode
vim.api.nvim_set_hl(0, 'Visual', { bg = '#bcc0cc' })
vim.api.nvim_set_hl(0, 'VisualNOS', { bg = '#bcc0cc' })

-- Search
vim.api.nvim_set_hl(0, 'Search', { bg = '#df8e1d', fg = '#eff1f5' })
vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#fe640b', fg = '#eff1f5' })
vim.api.nvim_set_hl(0, 'MatchParen', { bg = '#8839ef', fg = '#eff1f5', bold = true })

-- Status Line
vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#e6e9ef', fg = '#4c4f69' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#eff1f5', fg = '#9ca0b0' })
vim.api.nvim_set_hl(0, 'WildMenu', { bg = '#8839ef', fg = '#eff1f5' })

-- Tab Line
vim.api.nvim_set_hl(0, 'TabLine', { bg = '#e6e9ef', fg = '#9ca0b0' })
vim.api.nvim_set_hl(0, 'TabLineSel', { bg = '#8839ef', fg = '#eff1f5' })
vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#eff1f5', fg = '#9ca0b0' })

-- Pmenu (Completion)
vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#e6e9ef', fg = '#4c4f69' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#8839ef', fg = '#eff1f5' })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#e6e9ef' })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#ccd0da' })

-- Errors and Warnings
vim.api.nvim_set_hl(0, 'Error', { bg = '#d20f39', fg = '#eff1f5' })
vim.api.nvim_set_hl(0, 'ErrorMsg', { bg = '#d20f39', fg = '#eff1f5' })
vim.api.nvim_set_hl(0, 'WarningMsg', { bg = '#df8e1d', fg = '#eff1f5' })
vim.api.nvim_set_hl(0, 'MoreMsg', { fg = '#40a02b' })
vim.api.nvim_set_hl(0, 'ModeMsg', { fg = '#4c4f69' })
vim.api.nvim_set_hl(0, 'Question', { fg = '#df8e1d' })

-- Diffs
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#e6e9ef', fg = '#40a02b' })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#e6e9ef', fg = '#df8e1d' })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#e6e9ef', fg = '#d20f39' })
vim.api.nvim_set_hl(0, 'DiffText', { bg = '#e6e9ef', fg = '#fe640b' })

-- Spelling
vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true, sp = '#d20f39' })
vim.api.nvim_set_hl(0, 'SpellCap', { undercurl = true, sp = '#df8e1d' })
vim.api.nvim_set_hl(0, 'SpellRare', { undercurl = true, sp = '#8839ef' })
vim.api.nvim_set_hl(0, 'SpellLocal', { undercurl = true, sp = '#179299' })

-- Special Syntax
vim.api.nvim_set_hl(0, 'Title', { fg = '#1e66f5', bold = true })
vim.api.nvim_set_hl(0, 'Todo', { bg = '#df8e1d', fg = '#eff1f5', bold = true })
vim.api.nvim_set_hl(0, 'Underlined', { fg = '#8839ef', underline = true })
vim.api.nvim_set_hl(0, 'SpecialKey', { fg = '#9ca0b0' })
vim.api.nvim_set_hl(0, 'NonText', { fg = '#9ca0b0' })
vim.api.nvim_set_hl(0, 'Directory', { fg = '#1e66f5' })
vim.api.nvim_set_hl(0, 'Conceal', { fg = '#9ca0b0' })

-- LSP and Diagnostics
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#d20f39' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#df8e1d' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#1e66f5' })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#179299' })
vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#bcc0cc' })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#bcc0cc' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#bcc0cc' })

-- Treesitter
vim.api.nvim_set_hl(0, '@function', { fg = '#8839ef' })
vim.api.nvim_set_hl(0, '@function.call', { fg = '#8839ef' })
vim.api.nvim_set_hl(0, '@parameter', { fg = '#4c4f69' })
vim.api.nvim_set_hl(0, '@field', { fg = '#df8e1d' })
vim.api.nvim_set_hl(0, '@property', { fg = '#df8e1d' })
vim.api.nvim_set_hl(0, '@constructor', { fg = '#fe640b' })
vim.api.nvim_set_hl(0, '@tag', { fg = '#8839ef' })
vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = '#5c5f77' })

-- Additional Catppuccin Latte colors available:
-- Rosewater: #dc8a78, Flamingo: #dd7878, Pink: #ea76cb, 
-- Maroon: #e64553, Green: #40a02b, Teal: #179299,
-- Sky: #04a5e5, Sapphire: #209fb5, Blue: #1e66f5, 
-- Lavender: #7287fd, Surface0: #ccd0da, Surface1: #bcc0cc
