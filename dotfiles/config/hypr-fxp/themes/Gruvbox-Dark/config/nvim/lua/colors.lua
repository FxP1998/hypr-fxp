-- Gruvbox Dark Enhanced - Full Color Scheme for Neovim
vim.cmd('set background=dark')
vim.cmd('set termguicolors')

-- Gruvbox Dark Base Colors
vim.api.nvim_set_hl(0, 'Normal', { bg = '#282828', fg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#3c3836', fg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'Comment', { fg = '#928374', italic = true })
vim.api.nvim_set_hl(0, 'Constant', { fg = '#fb4934' })
vim.api.nvim_set_hl(0, 'String', { fg = '#b8bb26' })
vim.api.nvim_set_hl(0, 'Character', { fg = '#d3869b' })
vim.api.nvim_set_hl(0, 'Number', { fg = '#d3869b' })
vim.api.nvim_set_hl(0, 'Boolean', { fg = '#fb4934' })
vim.api.nvim_set_hl(0, 'Float', { fg = '#d3869b' })

-- Identifiers
vim.api.nvim_set_hl(0, 'Identifier', { fg = '#83a598' })
vim.api.nvim_set_hl(0, 'Function', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, 'Variable', { fg = '#ebdbb2' })

-- Statements
vim.api.nvim_set_hl(0, 'Statement', { fg = '#fabd2f' })
vim.api.nvim_set_hl(0, 'Conditional', { fg = '#fb4934' })
vim.api.nvim_set_hl(0, 'Repeat', { fg = '#fb4934' })
vim.api.nvim_set_hl(0, 'Label', { fg = '#fe8019' })
vim.api.nvim_set_hl(0, 'Operator', { fg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'Keyword', { fg = '#fb4934' })
vim.api.nvim_set_hl(0, 'Exception', { fg = '#fb4934' })

-- Preprocessor
vim.api.nvim_set_hl(0, 'PreProc', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, 'Include', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, 'Define', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, 'Macro', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, 'PreCondit', { fg = '#8ec07c' })

-- Types
vim.api.nvim_set_hl(0, 'Type', { fg = '#d3869b' })
vim.api.nvim_set_hl(0, 'StorageClass', { fg = '#fe8019' })
vim.api.nvim_set_hl(0, 'Structure', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, 'Typedef', { fg = '#8ec07c' })

-- Special
vim.api.nvim_set_hl(0, 'Special', { fg = '#fe8019' })
vim.api.nvim_set_hl(0, 'SpecialChar', { fg = '#fb4934' })
vim.api.nvim_set_hl(0, 'Tag', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'SpecialComment', { fg = '#928374' })
vim.api.nvim_set_hl(0, 'Debug', { fg = '#fb4934' })

-- UI Elements
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#928374' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ebdbb2', bold = true })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#282828', fg = '#928374' })
vim.api.nvim_set_hl(0, 'FoldColumn', { bg = '#282828', fg = '#928374' })
vim.api.nvim_set_hl(0, 'Folded', { bg = '#3c3836', fg = '#928374' })

-- Visual Mode
vim.api.nvim_set_hl(0, 'Visual', { bg = '#458588' })
vim.api.nvim_set_hl(0, 'VisualNOS', { bg = '#458588' })

-- Search
vim.api.nvim_set_hl(0, 'Search', { bg = '#fabd2f', fg = '#282828' })
vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#fe8019', fg = '#282828' })
vim.api.nvim_set_hl(0, 'MatchParen', { bg = '#458588', fg = '#ebdbb2', bold = true })

-- Status Line
vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#3c3836', fg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#282828', fg = '#928374' })
vim.api.nvim_set_hl(0, 'WildMenu', { bg = '#fabd2f', fg = '#282828' })

-- Tab Line
vim.api.nvim_set_hl(0, 'TabLine', { bg = '#3c3836', fg = '#928374' })
vim.api.nvim_set_hl(0, 'TabLineSel', { bg = '#fabd2f', fg = '#282828' })
vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#282828', fg = '#928374' })

-- Pmenu (Completion)
vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#3c3836', fg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#458588', fg = '#282828' })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#665c54' })

-- Errors and Warnings
vim.api.nvim_set_hl(0, 'Error', { bg = '#fb4934', fg = '#282828' })
vim.api.nvim_set_hl(0, 'ErrorMsg', { bg = '#fb4934', fg = '#282828' })
vim.api.nvim_set_hl(0, 'WarningMsg', { bg = '#fabd2f', fg = '#282828' })
vim.api.nvim_set_hl(0, 'MoreMsg', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, 'ModeMsg', { fg = '#ebdbb2' })
vim.api.nvim_set_hl(0, 'Question', { fg = '#fabd2f' })

-- Diffs
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#32302f', fg = '#8ec07c' })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#32302f', fg = '#fabd2f' })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#32302f', fg = '#fb4934' })
vim.api.nvim_set_hl(0, 'DiffText', { bg = '#32302f', fg = '#d3869b' })

-- Spelling
vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true, sp = '#fb4934' })
vim.api.nvim_set_hl(0, 'SpellCap', { undercurl = true, sp = '#fabd2f' })
vim.api.nvim_set_hl(0, 'SpellRare', { undercurl = true, sp = '#d3869b' })
vim.api.nvim_set_hl(0, 'SpellLocal', { undercurl = true, sp = '#8ec07c' })

-- Special Syntax
vim.api.nvim_set_hl(0, 'Title', { fg = '#83a598', bold = true })
vim.api.nvim_set_hl(0, 'Todo', { bg = '#fabd2f', fg = '#282828', bold = true })
vim.api.nvim_set_hl(0, 'Underlined', { fg = '#d3869b', underline = true })
vim.api.nvim_set_hl(0, 'SpecialKey', { fg = '#928374' })
vim.api.nvim_set_hl(0, 'NonText', { fg = '#928374' })
vim.api.nvim_set_hl(0, 'Directory', { fg = '#83a598' })
vim.api.nvim_set_hl(0, 'Conceal', { fg = '#928374' })

-- LSP and Diagnostics
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#fb4934' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#fabd2f' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#83a598' })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#458588' })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#458588' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#458588' })

-- Treesitter
vim.api.nvim_set_hl(0, '@function', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, '@function.call', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, '@parameter', { fg = '#ebdbb2' })
vim.api.nvim_set_hl(0, '@field', { fg = '#fabd2f' })
vim.api.nvim_set_hl(0, '@property', { fg = '#fabd2f' })
vim.api.nvim_set_hl(0, '@constructor', { fg = '#d3869b' })
vim.api.nvim_set_hl(0, '@tag', { fg = '#8ec07c' })
vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = '#ebdbb2' })
