-- AUTHOR: M. H. IMAM (FxP1998)
-- GITHUB: https://github.com/FxP1998

local colors = {
    base00 = '#101418', -- BG
    base01 = '#181c20', -- Lighter BG
    base02 = '#1c2024', -- Selection
    base03 = '#c2c7cf', -- Comments
    base04 = '#8c9199', -- Status Bar FG
    base05 = '#e0e2e8', -- Text
    base06 = '#e0e2e8',
    base07 = '#2d3135',
    base08 = '#ffb4ab', -- Red
    base09 = '#d4bee6', -- Orange/Peach
    base0A = '#b9c8da', -- Yellow
    base0B = '#9ccbfb', -- Green/String
    base0C = '#d5e4f7', -- Cyan
    base0D = '#9ccbfb', -- Blue/Function
    base0E = '#504061', -- Purple
    base0F = '#93000a', -- Brown
}

require('base16-colorscheme').setup(colors)
local hi = vim.api.nvim_set_hl

-- =========================================================
--  1. CORE UI & TRANSPARENCY (Fixes Black Bars)
-- =========================================================
-- Forces the main editor background to be transparent
hi(0, 'Normal', { bg = 'NONE', fg = colors.base05 })
hi(0, 'NormalNC', { bg = 'NONE', fg = colors.base05 })
hi(0, 'SignColumn', { bg = 'NONE' })
hi(0, 'VertSplit', { fg = colors.base02, bg = 'NONE' })
hi(0, 'WinSeparator', { fg = colors.base02, bg = 'NONE' })
hi(0, 'EndOfBuffer', { fg = colors.base00, bg = 'NONE' }) -- Hide tildes

-- STATUS LINE: Transparent Background (Removes the black bar)
hi(0, 'StatusLine', { bg = 'NONE', fg = colors.base04 })
hi(0, 'StatusLineNC', { bg = 'NONE', fg = colors.base03 })

-- =========================================================
--  2. PROFESSIONAL RICE (Sidebar, Finder, Dashboard)
-- =========================================================

-- NVIM TREE (Sidebar)
hi(0, 'NvimTreeNormal', { bg = 'NONE', fg = colors.base05 })
hi(0, 'NvimTreeEndOfBuffer', { fg = colors.base00 })
hi(0, 'NvimTreeFolderName', { fg = colors.base0D, bold = true })
hi(0, 'NvimTreeFolderIcon', { fg = colors.base0D })
hi(0, 'NvimTreeRootFolder', { fg = colors.base0E, bold = true })
hi(0, 'NvimTreeGitDirty', { fg = colors.base08 })

-- TELESCOPE (Fuzzy Finder)
-- Makes the popup transparent with colored borders
hi(0, 'TelescopeNormal', { bg = 'NONE' })
hi(0, 'TelescopeBorder', { fg = colors.base0D, bg = 'NONE' })
hi(0, 'TelescopePromptNormal', { bg = 'NONE' })
hi(0, 'TelescopePromptBorder', { fg = colors.base0B, bg = 'NONE' })
hi(0, 'TelescopeTitle', { fg = colors.base0B, bold = true })

-- DASHBOARD (Startup Screen)
hi(0, 'DashboardHeader', { fg = colors.base0D, bold = true })
hi(0, 'DashboardFooter', { fg = colors.base03, italic = true })
hi(0, 'DashboardIcon',   { fg = colors.base0E })
hi(0, 'DashboardKey',    { fg = colors.base08 })

-- =========================================================
--  3. POPUPS & AUTOCOMPLETE (The Box)
-- =========================================================
hi(0, 'Pmenu', { fg = colors.base05, bg = colors.base01 })
hi(0, 'PmenuBorder', { fg = colors.base04, bg = colors.base01 })
hi(0, 'PmenuSel', { fg = colors.base00, bg = colors.base0D, bold = true })

-- Completion Kinds (Icons)
hi(0, 'CmpItemKindFile', { fg = colors.base0B, bg = 'NONE', bold = true })
hi(0, 'CmpItemKindFolder', { fg = colors.base0A, bg = 'NONE', bold = true })
hi(0, 'CmpItemKindFunction', { fg = colors.base0D, bg = 'NONE', bold = true })

-- SYNTAX HIGHLIGHTS
hi(0, 'Comment', { fg = colors.base03, italic = true })
hi(0, 'LineNr', { fg = colors.base03, bg = 'NONE' })
hi(0, 'CursorLineNr', { fg = colors.base0D, bold = true, bg = 'NONE' })
hi(0, 'CursorLine', { bg = colors.base01 })
