-- AUTHOR: M. H. IMAM (FxP1998)
-- GITHUB: https://github.com/FxP1998

-- --- 1. BOOTSTRAP LAZY (PRESERVED) ---
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- --- 2. OPTIONS (PRESERVED) ---
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3 -- Global Statusline (Pro Rice Look)
vim.opt.showmode = false
vim.opt.pumheight = 15
vim.opt.clipboard = "unnamedplus" -- Wayland Fix
vim.opt.mouse = "a"

-- --- 3. SETUP PLUGINS ---
require("lazy").setup({
  -- >> EXISTING THEME & CMP (PRESERVED)
  { "RRethy/base16-nvim", priority = 1000 },
  { "typicode/bg.nvim", lazy = false },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-path", "hrsh7th/cmp-buffer", "hrsh7th/cmp-cmdline", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "onsails/lspkind.nvim" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      -- YOUR CUSTOM BORDER LOGIC
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

  -- >> NEW RICE FEATURES (ADDED) <<

  -- 1. ICONS (Essential for Rice)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- 2. FILE EXPLORER (Sidebar like NERDTree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30, side = "left" },
        renderer = { indent_markers = { enable = true } },
        actions = { open_file = { quit_on_open = true } }
      })
    end
  },

  -- 3. FUZZY FINDER (Search like FZF)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- 4. DASHBOARD (Your Startup Screen)
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('dashboard').setup {
        theme = 'doom',
        config = {
          header = {
            [[  ______    _____  __  ___   ___   ___   ]],
            [[ |  ____|  |  __ \/_ |/ _ \ / _ \ / _ \  ]],
            [[ | |____  _| |__) || | (_) | (_) | (_) | ]],
            [[ |  __\ \/ /  ___/ | |\__, |\__, |> _ <  ]],
            [[ | |   >  <| |     | |  / /   / /| (_) | ]],
            [[ |_|  /_/\_\_|     |_| /_/   /_/  \___/  ]],
            [[  ]],
          },
          center = {
            { icon = '  ', desc = 'Find File          ', action = 'Telescope find_files', key = 'f' },
            { icon = '  ', desc = 'File Explorer      ', action = 'NvimTreeToggle',       key = 'e' },
            { icon = '  ', desc = 'Find Text          ', action = 'Telescope live_grep',  key = 'g' },
            { icon = '  ', desc = 'Configuration      ', action = 'edit $MYVIMRC',        key = 'c' },
            -- ADDED: Quit Option
            { icon = '  ', desc = 'Quit Neovim        ', action = 'qa',                   key = 'q' },
          },
        }
      }
    end
  },

  -- 5. BETTER SYNTAX (Treesitter)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- 6. STATUS BAR (Professional Lualine)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup {
        options = { theme = 'auto', globalstatus = true, component_separators = '|', section_separators = '' },
      }
    end
  },

  -- 7. EXTRAS (Comments & Autopairs)
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "numToStr/Comment.nvim", opts = {} },
})

-- --- 4. KEY MAPPINGS (ADDED) ---
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>', { silent = true })
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true })

-- --- 5. THEME LOADER (PRESERVED) ---
local function load_matugen()
  local theme = vim.fn.stdpath("config") .. "/lua/matugen_theme.lua"
  if vim.fn.filereadable(theme) == 1 then pcall(dofile, theme) else vim.cmd("colorscheme default") end
end
vim.api.nvim_create_autocmd("Signal", { pattern = "SIGUSR1", callback = function() vim.schedule(load_matugen) end })
load_matugen()

-- --- 6. LEGACY STATUS LINE (PRESERVED BUT OVERRIDDEN BY LUALINE) ---
function MyStatusLine()
  return table.concat({ "%#User1# %f %*", "%#User3#%m%*", "%=", "%#User4# NVIM %*", "%#User2# %l:%c %*" })
end
