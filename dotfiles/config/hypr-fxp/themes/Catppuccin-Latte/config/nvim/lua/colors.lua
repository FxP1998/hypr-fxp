-- Gruvbox Light Enhanced - Full Color Scheme for Neovim
vim.cmd('set background=light')
vim.cmd('set termguicolors')

-- Gruvbox Light Base Colors
vim.api.nvim_set_hl(0, 'Normal', { bg = '#fbf1c7', fg = '#3c3836' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#ebdbb2', fg = '#3c3836' })
vim.api.nvim_set_hl(0, 'Comment', { fg = '#928374', italic = true })
vim.api.nvim_set_hl(0, 'Constant', { fg = '#cc241d' })
vim.api.nvim_set_hl(0, 'String', { fg = '#98971a' })
vim.api.nvim_set_hl(0, 'Character', { fg = '#b16286' })
vim.api.nvim_set_hl(0, 'Number', { fg = '#b16286' })
vim.api.nvim_set_hl(0, 'Boolean', { fg = '#cc241d' })
vim.api.nvim_set_hl(0, 'Float', { fg = '#b16286' })

-- Identifiers
vim.api.nvim_set_hl(0, 'Identifier', { fg = '#458588' })
vim.api.nvim_set_hl(0, 'Function', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, 'Variable', { fg = '#3c3836' })

-- Statements
vim.api.nvim_set_hl(0, 'Statement', { fg = '#d79921' })
vim.api.nvim_set_hl(0, 'Conditional', { fg = '#cc241d' })
vim.api.nvim_set_hl(0, 'Repeat', { fg = '#cc241d' })
vim.api.nvim_set_hl(0, 'Label', { fg = '#d65d0e' })
vim.api.nvim_set_hl(0, 'Operator', { fg = '#3c3836' })
vim.api.nvim_set_hl(0, 'Keyword', { fg = '#cc241d' })
vim.api.nvim_set_hl(0, 'Exception', { fg = '#cc241d' })

-- Preprocessor
vim.api.nvim_set_hl(0, 'PreProc', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, 'Include', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, 'Define', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, 'Macro', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, 'PreCondit', { fg = '#689d6a' })

-- Types
vim.api.nvim_set_hl(0, 'Type', { fg = '#b16286' })
vim.api.nvim_set_hl(0, 'StorageClass', { fg = '#d65d0e' })
vim.api.nvim_set_hl(0, 'Structure', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, 'Typedef', { fg = '#689d6a' })

-- Special
vim.api.nvim_set_hl(0, 'Special', { fg = '#d65d0e' })
vim.api.nvim_set_hl(0, 'SpecialChar', { fg = '#cc241d' })
vim.api.nvim_set_hl(0, 'Tag', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#3c3836' })
vim.api.nvim_set_hl(0, 'SpecialComment', { fg = '#928374' })
vim.api.nvim_set_hl(0, 'Debug', { fg = '#cc241d' })

-- UI Elements
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#a89984' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#3c3836', bold = true })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#fbf1c7', fg = '#a89984' })
vim.api.nvim_set_hl(0, 'FoldColumn', { bg = '#fbf1c7', fg = '#a89984' })
vim.api.nvim_set_hl(0, 'Folded', { bg = '#ebdbb2', fg = '#a89984' })

-- Visual Mode
vim.api.nvim_set_hl(0, 'Visual', { bg = '#83a598' })
vim.api.nvim_set_hl(0, 'VisualNOS', { bg = '#83a598' })

-- Search
vim.api.nvim_set_hl(0, 'Search', { bg = '#d79921', fg = '#fbf1c7' })
vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#d65d0e', fg = '#fbf1c7' })
vim.api.nvim_set_hl(0, 'MatchParen', { bg = '#83a598', fg = '#fbf1c7', bold = true })

-- Status Line
vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#ebdbb2', fg = '#3c3836' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#fbf1c7', fg = '#a89984' })
vim.api.nvim_set_hl(0, 'WildMenu', { bg = '#d79921', fg = '#fbf1c7' })

-- Tab Line
vim.api.nvim_set_hl(0, 'TabLine', { bg = '#ebdbb2', fg = '#a89984' })
vim.api.nvim_set_hl(0, 'TabLineSel', { bg = '#d79921', fg = '#fbf1c7' })
vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#fbf1c7', fg = '#a89984' })

-- Pmenu (Completion)
vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#ebdbb2', fg = '#3c3836' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#458588', fg = '#fbf1c7' })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#d5c4a1' })

-- Errors and Warnings
vim.api.nvim_set_hl(0, 'Error', { bg = '#cc241d', fg = '#fbf1c7' })
vim.api.nvim_set_hl(0, 'ErrorMsg', { bg = '#cc241d', fg = '#fbf1c7' })
vim.api.nvim_set_hl(0, 'WarningMsg', { bg = '#d79921', fg = '#fbf1c7' })
vim.api.nvim_set_hl(0, 'MoreMsg', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, 'ModeMsg', { fg = '#3c3836' })
vim.api.nvim_set_hl(0, 'Question', { fg = '#d79921' })

-- Diffs
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#d5c4a1', fg = '#689d6a' })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#d5c4a1', fg = '#d79921' })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#d5c4a1', fg = '#cc241d' })
vim.api.nvim_set_hl(0, 'DiffText', { bg = '#d5c4a1', fg = '#b16286' })

-- Spelling
vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true, sp = '#cc241d' })
vim.api.nvim_set_hl(0, 'SpellCap', { undercurl = true, sp = '#d79921' })
vim.api.nvim_set_hl(0, 'SpellRare', { undercurl = true, sp = '#b16286' })
vim.api.nvim_set_hl(0, 'SpellLocal', { undercurl = true, sp = '#689d6a' })

-- Special Syntax
vim.api.nvim_set_hl(0, 'Title', { fg = '#458588', bold = true })
vim.api.nvim_set_hl(0, 'Todo', { bg = '#d79921', fg = '#fbf1c7', bold = true })
vim.api.nvim_set_hl(0, 'Underlined', { fg = '#b16286', underline = true })
vim.api.nvim_set_hl(0, 'SpecialKey', { fg = '#a89984' })
vim.api.nvim_set_hl(0, 'NonText', { fg = '#a89984' })
vim.api.nvim_set_hl(0, 'Directory', { fg = '#458588' })
vim.api.nvim_set_hl(0, 'Conceal', { fg = '#a89984' })

-- LSP and Diagnostics
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#cc241d' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#d79921' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#458588' })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#83a598' })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#83a598' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#83a598' })

-- Treesitter
vim.api.nvim_set_hl(0, '@function', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, '@function.call', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, '@parameter', { fg = '#3c3836' })
vim.api.nvim_set_hl(0, '@field', { fg = '#d79921' })
vim.api.nvim_set_hl(0, '@property', { fg = '#d79921' })
vim.api.nvim_set_hl(0, '@constructor', { fg = '#b16286' })
vim.api.nvim_set_hl(0, '@tag', { fg = '#689d6a' })
vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = '#3c3836' })
