#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

GREEN="\033[1;32m"
BLUE="\033[1;34m"
RESET="\033[0m"
NVIM_CONFIG="$HOME/.config/nvim"
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
MATUGEN_DIR="$HOME/.config/matugen"

echo -e "${BLUE}▶ STARTING ROBUST NEOVIM INSTALLER (By FxP)...${RESET}"

# 1. CLEANUP & PREPARE
# We remove the old lazy install to force a fresh, correct download.
rm -rf "$HOME/.local/share/nvim/lazy"
rm -rf "$NVIM_CONFIG"
mkdir -p "$NVIM_CONFIG"
mkdir -p "$(dirname "$LAZY_PATH")"

# 2. WRITE INIT.LUA (With Fixes baked in)
echo -e "${BLUE}:: Writing init.lua...${RESET}"
cat << 'EOF' > "$NVIM_CONFIG/init.lua"
-- AUTHOR: M. H. IMAM (FxP1998)
-- GITHUB: https://github.com/FxP1998

-- 1. BOOTSTRAP LAZY (Self-Repairing)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. OPTIONS
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.pumheight = 15

-- CLIPBOARD FIX (For Wayland)
vim.opt.clipboard = "unnamedplus"

-- 3. SETUP PLUGINS
require("lazy").setup({
  { "RRethy/base16-nvim", priority = 1000 },
  { "typicode/bg.nvim", lazy = false },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-path", "hrsh7th/cmp-buffer", "hrsh7th/cmp-cmdline", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- BOX BORDER STYLE
      local border = { {"╭", "PmenuBorder"}, {"─", "PmenuBorder"}, {"╮", "PmenuBorder"}, {"│", "PmenuBorder"}, {"╯", "PmenuBorder"}, {"─", "PmenuBorder"}, {"╰", "PmenuBorder"}, {"│", "PmenuBorder"} }

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({ { name = 'path' }, { name = 'luasnip' }, { name = 'buffer' } }),
        window = {
          completion = { border = border, winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None" },
          documentation = { border = border, winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None" }
        }
      })
    end
  },
})

-- 4. THEME LOADER
local function load_matugen()
  local theme = vim.fn.stdpath("config") .. "/lua/matugen_theme.lua"
  if vim.fn.filereadable(theme) == 1 then pcall(dofile, theme) else vim.cmd("colorscheme default") end
end
vim.api.nvim_create_autocmd("Signal", { pattern = "SIGUSR1", callback = function() vim.schedule(load_matugen) end })
load_matugen()

-- 5. STATUS LINE
local function smart_path()
  local path = vim.fn.expand('%:p')
  return path == '' and '[No Name]' or vim.fn.fnamemodify(path, ':~')
end
function MyStatusLine()
  return table.concat({ "%#User1# " .. smart_path() .. " %*", "%#User3#%m%*", "%r%h", "%=", "%#User4# NVIM %*", "%#User2# %l:%c %*", " %P " })
end
vim.opt.statusline = "%!v:lua.MyStatusLine()"
EOF

# 4. WRITE MATUGEN TEMPLATE
echo -e "${BLUE}:: Configuring Matugen Template...${RESET}"
mkdir -p "$MATUGEN_DIR/templates/neovim"
cat << 'EOF' > "$MATUGEN_DIR/templates/neovim/template.lua"
-- AUTHOR: M. H. IMAM (FxP1998)
-- GITHUB: https://github.com/FxP1998

local colors = {
    base00 = '{{colors.background.default.hex}}',
    base01 = '{{colors.surface_container_low.default.hex}}',
    base02 = '{{colors.surface_container.default.hex}}',
    base03 = '{{colors.on_surface_variant.default.hex}}',
    base04 = '{{colors.outline.default.hex}}',
    base05 = '{{colors.on_surface.default.hex}}',
    base06 = '{{colors.on_surface.default.hex}}',
    base07 = '{{colors.inverse_on_surface.default.hex}}',
    base08 = '{{colors.error.default.hex}}',
    base09 = '{{colors.tertiary.default.hex}}',
    base0A = '{{colors.secondary.default.hex}}',
    base0B = '{{colors.primary.default.hex}}',
    base0C = '{{colors.on_secondary_container.default.hex}}',
    base0D = '{{colors.primary.default.hex}}',
    base0E = '{{colors.tertiary_container.default.hex}}',
    base0F = '{{colors.error_container.default.hex}}',
}
require('base16-colorscheme').setup(colors)

vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE', fg = '{{colors.outline.default.hex}}' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE', fg = '{{colors.outline_variant.default.hex}}' })
vim.api.nvim_set_hl(0, 'User1', { fg = '{{colors.primary.default.hex}}', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'User2', { fg = '{{colors.secondary.default.hex}}', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'User3', { fg = '{{colors.error.default.hex}}', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'User4', { fg = '{{colors.tertiary.default.hex}}', bg = 'NONE', bold = true })

-- Box Popup
vim.api.nvim_set_hl(0, 'Pmenu', { fg = '{{colors.on_surface.default.hex}}', bg = '{{colors.surface_container.default.hex}}' })
vim.api.nvim_set_hl(0, 'PmenuBorder', { fg = '{{colors.outline.default.hex}}', bg = '{{colors.surface_container.default.hex}}' })
vim.api.nvim_set_hl(0, 'PmenuSel', { fg = '{{colors.on_primary.default.hex}}', bg = '{{colors.primary.default.hex}}', bold = true })

-- Kinds (Blue Files, Yellow Folders)
vim.api.nvim_set_hl(0, 'CmpItemKindFile', { fg = '{{colors.primary.default.hex}}', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'CmpItemKindFolder', { fg = '{{colors.tertiary.default.hex}}', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { fg = '{{colors.on_surface.default.hex}}', bg = 'NONE' })

vim.api.nvim_set_hl(0, 'Comment', { fg = '{{colors.outline.default.hex}}', italic = true })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '{{colors.outline_variant.default.hex}}', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '{{colors.primary.default.hex}}', bold = true, bg = 'NONE' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '{{colors.surface_container.default.hex}}' })
EOF

# 5. MATUGEN CONFIG
if ! grep -q "\[templates.neovim\]" "$MATUGEN_DIR/config.toml"; then
    cat << 'EOF' >> "$MATUGEN_DIR/config.toml"

[templates.neovim]
input_path = "~/.config/matugen/templates/neovim/template.lua"
output_path = "~/.config/nvim/lua/matugen_theme.lua"
post_hook = "pkill -SIGUSR1 nvim"
EOF
fi

echo -e "${GREEN}✔ ROBUST INSTALL COMPLETE!${RESET}"
echo -e "${BLUE}▶ 1. Run 'matugen image /path/to/wall.jpg' NOW to generate colors.${RESET}"
echo -e "${BLUE}▶ 2. Open 'nvim'. You will see 'Lazy' installing plugins instantly.${RESET}"
