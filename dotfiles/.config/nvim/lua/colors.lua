-- Rosé Pine Main - Color Scheme for Neovim
vim.cmd('set background=dark')
vim.cmd('set termguicolors')

-- Rosé Pine Main Base Colors
vim.api.nvim_set_hl(0, 'Normal', { bg = '#191724', fg = '#e0def4' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1f1d2e', fg = '#e0def4' })
vim.api.nvim_set_hl(0, 'Comment', { fg = '#6e6a86', italic = true })
vim.api.nvim_set_hl(0, 'Constant', { fg = '#eb6f92' })
vim.api.nvim_set_hl(0, 'String', { fg = '#9ccfd8' })
vim.api.nvim_set_hl(0, 'Character', { fg = '#c4a7e7' })
vim.api.nvim_set_hl(0, 'Number', { fg = '#ebbcba' })
vim.api.nvim_set_hl(0, 'Boolean', { fg = '#eb6f92' })
vim.api.nvim_set_hl(0, 'Float', { fg = '#ebbcba' })

-- Identifiers
vim.api.nvim_set_hl(0, 'Identifier', { fg = '#31748f' })
vim.api.nvim_set_hl(0, 'Function', { fg = '#c4a7e7' })
vim.api.nvim_set_hl(0, 'Variable', { fg = '#e0def4' })

-- Statements
vim.api.nvim_set_hl(0, 'Statement', { fg = '#f6c177' })
vim.api.nvim_set_hl(0, 'Conditional', { fg = '#eb6f92' })
vim.api.nvim_set_hl(0, 'Repeat', { fg = '#eb6f92' })
vim.api.nvim_set_hl(0, 'Label', { fg = '#ea9a97' })
vim.api.nvim_set_hl(0, 'Operator', { fg = '#ebbcba' })
vim.api.nvim_set_hl(0, 'Keyword', { fg = '#eb6f92' })
vim.api.nvim_set_hl(0, 'Exception', { fg = '#eb6f92' })

-- Preprocessor
vim.api.nvim_set_hl(0, 'PreProc', { fg = '#c4a7e7' })
vim.api.nvim_set_hl(0, 'Include', { fg = '#c4a7e7' })
vim.api.nvim_set_hl(0, 'Define', { fg = '#c4a7e7' })
vim.api.nvim_set_hl(0, 'Macro', { fg = '#c4a7e7' })
vim.api.nvim_set_hl(0, 'PreCondit', { fg = '#c4a7e7' })

-- Types
vim.api.nvim_set_hl(0, 'Type', { fg = '#f6c177' })
vim.api.nvim_set_hl(0, 'StorageClass', { fg = '#ea9a97' })
vim.api.nvim_set_hl(0, 'Structure', { fg = '#c4a7e7' })
vim.api.nvim_set_hl(0, 'Typedef', { fg = '#c4a7e7' })

-- Special
vim.api.nvim_set_hl(0, 'Special', { fg = '#ebbcba' })
vim.api.nvim_set_hl(0, 'SpecialChar', { fg = '#eb6f92' })
vim.api.nvim_set_hl(0, 'Tag', { fg = '#31748f' })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#908caa' })
vim.api.nvim_set_hl(0, 'SpecialComment', { fg = '#6e6a86' })
vim.api.nvim_set_hl(0, 'Debug', { fg = '#eb6f92' })

-- UI Elements
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#6e6a86' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e0def4', bold = true })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#1f1d2e' })
vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#1f1d2e' })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#1f1d2e' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#191724', fg = '#6e6a86' })
vim.api.nvim_set_hl(0, 'FoldColumn', { bg = '#191724', fg = '#6e6a86' })
vim.api.nvim_set_hl(0, 'Folded', { bg = '#1f1d2e', fg = '#6e6a86' })

-- Cursor settings - HIGH VISIBILITY
vim.api.nvim_set_hl(0, 'Cursor', { bg = '#e0def4', fg = '#191724' })
vim.api.nvim_set_hl(0, 'iCursor', { bg = '#e0def4', fg = '#191724' })
vim.api.nvim_set_hl(0, 'CursorIM', { bg = '#e0def4', fg = '#191724' })

-- Visual Mode
vim.api.nvim_set_hl(0, 'Visual', { bg = '#403d52' })
vim.api.nvim_set_hl(0, 'VisualNOS', { bg = '#403d52' })

-- Search
vim.api.nvim_set_hl(0, 'Search', { bg = '#f6c177', fg = '#191724' })
vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#ea9a97', fg = '#191724' })
vim.api.nvim_set_hl(0, 'MatchParen', { bg = '#c4a7e7', fg = '#191724', bold = true })

-- Status Line
vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#1f1d2e', fg = '#e0def4' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#191724', fg = '#6e6a86' })
vim.api.nvim_set_hl(0, 'WildMenu', { bg = '#c4a7e7', fg = '#191724' })

-- Tab Line
vim.api.nvim_set_hl(0, 'TabLine', { bg = '#1f1d2e', fg = '#6e6a86' })
vim.api.nvim_set_hl(0, 'TabLineSel', { bg = '#c4a7e7', fg = '#191724' })
vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#191724', fg = '#6e6a86' })

-- Pmenu (Completion)
vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#1f1d2e', fg = '#e0def4' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#c4a7e7', fg = '#191724' })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#1f1d2e' })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#26233a' })

-- Errors and Warnings
vim.api.nvim_set_hl(0, 'Error', { bg = '#eb6f92', fg = '#191724' })
vim.api.nvim_set_hl(0, 'ErrorMsg', { bg = '#eb6f92', fg = '#191724' })
vim.api.nvim_set_hl(0, 'WarningMsg', { bg = '#f6c177', fg = '#191724' })
vim.api.nvim_set_hl(0, 'MoreMsg', { fg = '#9ccfd8' })
vim.api.nvim_set_hl(0, 'ModeMsg', { fg = '#e0def4' })
vim.api.nvim_set_hl(0, 'Question', { fg = '#f6c177' })

-- Diffs
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#1f1d2e', fg = '#9ccfd8' })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#1f1d2e', fg = '#f6c177' })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#1f1d2e', fg = '#eb6f92' })
vim.api.nvim_set_hl(0, 'DiffText', { bg = '#1f1d2e', fg = '#ebbcba' })

-- Spelling
vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true, sp = '#eb6f92' })
vim.api.nvim_set_hl(0, 'SpellCap', { undercurl = true, sp = '#f6c177' })
vim.api.nvim_set_hl(0, 'SpellRare', { undercurl = true, sp = '#c4a7e7' })
vim.api.nvim_set_hl(0, 'SpellLocal', { undercurl = true, sp = '#9ccfd8' })

-- Special Syntax
vim.api.nvim_set_hl(0, 'Title', { fg = '#31748f', bold = true })
vim.api.nvim_set_hl(0, 'Todo', { bg = '#f6c177', fg = '#191724', bold = true })
vim.api.nvim_set_hl(0, 'Underlined', { fg = '#c4a7e7', underline = true })
vim.api.nvim_set_hl(0, 'SpecialKey', { fg = '#6e6a86' })
vim.api.nvim_set_hl(0, 'NonText', { fg = '#6e6a86' })
vim.api.nvim_set_hl(0, 'Directory', { fg = '#31748f' })
vim.api.nvim_set_hl(0, 'Conceal', { fg = '#6e6a86' })

-- LSP and Diagnostics
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#eb6f92' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#f6c177' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#31748f' })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#9ccfd8' })
vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#403d52' })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#403d52' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#403d52' })

-- Treesitter
vim.api.nvim_set_hl(0, '@function', { fg = '#c4a7e7' })
vim.api.nvim_set_hl(0, '@function.call', { fg = '#c4a7e7' })
vim.api.nvim_set_hl(0, '@parameter', { fg = '#e0def4' })
vim.api.nvim_set_hl(0, '@field', { fg = '#f6c177' })
vim.api.nvim_set_hl(0, '@property', { fg = '#f6c177' })
vim.api.nvim_set_hl(0, '@constructor', { fg = '#ea9a97' })
vim.api.nvim_set_hl(0, '@tag', { fg = '#c4a7e7' })
vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = '#908caa' })
