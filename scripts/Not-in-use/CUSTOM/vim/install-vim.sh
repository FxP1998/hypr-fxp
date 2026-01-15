#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

GREEN="\033[1;32m"
BLUE="\033[1;34m"
RESET="\033[0m"
VIMRC="$HOME/.vimrc"
MATUGEN_DIR="$HOME/.config/matugen"
VIM_COLORS_DIR="$HOME/.vim/colors"

echo -e "${BLUE}▶ STARTING VIM SETUP (By FxP)...${RESET}"

mkdir -p "$MATUGEN_DIR/templates/vim"
mkdir -p "$VIM_COLORS_DIR"

if [ -f "$VIMRC" ]; then
    mv "$VIMRC" "$VIMRC.backup.$(date +%s)"
fi

# 1. WRITE .VIMRC
cat << 'EOF' > "$VIMRC"
" AUTHOR: M. H. IMAM (FxP1998)
" GITHUB: https://github.com/FxP1998

set nocompatible
filetype plugin indent on
syntax on

" --- 1. CLIPBOARD & MOUSE (The Fixes) ---
set clipboard=unnamedplus
set mouse=a

if &term =~ '^xterm' || &term =~ '^screen' || &term =~ '^rxvt' || &term =~ 'kitty' || &term =~ 'alacritty'
  let &t_ti = "\<Esc>[?1049h"
  let &t_te = "\<Esc>[?1049l"
endif

set number
set relativenumber
set cursorline
set scrolloff=8
set termguicolors
set signcolumn=number
set nowrap
set noshowmode
set laststatus=2
set shortmess+=F
set shortmess+=I
set shortmess+=c

let s:matugen_theme = expand('~/.vim/colors/matugen.vim')
if filereadable(s:matugen_theme)
    execute 'source ' . s:matugen_theme
else
    colorscheme default
endif

function! SmartPath()
    let l:path = expand('%:p')
    if len(l:path) == 0
        return "[No Name]"
    endif
    return fnamemodify(l:path, ':~')
endfunction

set statusline=
set statusline+=%1*\ %{SmartPath()}\ %*
set statusline+=%3*%m%*
set statusline+=%r%h
set statusline+=%=
set statusline+=%4*\ VIM\ %*
set statusline+=%2*\ %l:%c\ %*
set statusline+=\ %P\

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set ignorecase
set smartcase
set hlsearch
set incsearch
nnoremap <Esc> :nohlsearch<CR>

set completeopt=menu,menuone,noselect
set wildmenu
set wildmode=full
if has("patch-8.2.4325")
    set wildoptions=pum
endif
set pumheight=15

function! AutoPathComplete()
    if pumvisible()
        return
    endif
    let l:col = col('.') - 1
    let l:line = getline('.')
    let l:context = l:line[0 : l:col - 1]
    if l:context =~# '/$'
        call feedkeys("\<C-x>\<C-f>", "n")
    endif
endfunction

augroup SmartPathPicker
    autocmd!
    autocmd TextChangedI * call AutoPathComplete()
augroup END

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"
EOF

# 2. SETUP MATUGEN TEMPLATE
cat << 'EOF' > "$MATUGEN_DIR/templates/vim/colors.vim"
" AUTHOR: M. H. IMAM (FxP1998)
" GITHUB: https://github.com/FxP1998

set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "matugen"

hi Normal       guifg={{colors.on_surface.default.hex}} guibg=NONE ctermbg=NONE
hi LineNr       guifg={{colors.outline_variant.default.hex}} guibg=NONE
hi SignColumn   guibg=NONE
hi CursorLineNr guifg={{colors.primary.default.hex}}     guibg=NONE gui=bold
hi CursorLine   guibg={{colors.surface_container.default.hex}}
hi Visual       guifg={{colors.on_primary_container.default.hex}} guibg={{colors.primary_container.default.hex}}
hi VertSplit    guifg={{colors.outline_variant.default.hex}} guibg=NONE gui=NONE
hi EndOfBuffer  guifg={{colors.background.default.hex}}      guibg=NONE

hi clear StatusLine
hi clear StatusLineNC
hi StatusLine   guifg={{colors.outline.default.hex}} guibg=NONE ctermbg=NONE gui=NONE
hi StatusLineNC guifg={{colors.outline_variant.default.hex}} guibg=NONE ctermbg=NONE gui=NONE

hi Pmenu        guifg={{colors.on_surface.default.hex}} guibg={{colors.surface_container.default.hex}}
hi PmenuSel     guifg={{colors.on_primary.default.hex}} guibg={{colors.primary.default.hex}} gui=bold

hi User1 guifg={{colors.primary.default.hex}} guibg=NONE ctermbg=NONE gui=bold
hi User2 guifg={{colors.secondary.default.hex}} guibg=NONE ctermbg=NONE gui=bold
hi User3 guifg={{colors.error.default.hex}} guibg=NONE ctermbg=NONE gui=bold
hi User4 guifg={{colors.tertiary.default.hex}} guibg=NONE ctermbg=NONE gui=bold

hi Comment      guifg={{colors.outline.default.hex}} gui=italic
hi Constant     guifg={{colors.tertiary.default.hex}}
hi String       guifg={{colors.primary.default.hex}}
hi Identifier   guifg={{colors.secondary.default.hex}}
hi Function     guifg={{colors.primary.default.hex}}
hi Statement    guifg={{colors.tertiary.default.hex}} gui=bold
hi Type         guifg={{colors.tertiary.default.hex}}
hi Special      guifg={{colors.primary.default.hex}}
EOF

# 3. MATUGEN CONFIG
if ! grep -q "\[templates.vim\]" "$MATUGEN_DIR/config.toml"; then
    cat << 'EOF' >> "$MATUGEN_DIR/config.toml"

[templates.vim]
input_path = "~/.config/matugen/templates/vim/colors.vim"
output_path = "~/.vim/colors/matugen.vim"
EOF
fi

echo -e "${GREEN}✔ VIM SETUP COMPLETE!${RESET}"
