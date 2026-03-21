" ==============================================================================
"  FILE: .vimrc
"  AUTHOR: M. H. IMAM (FxP1998)
"  GITHUB: https://github.com/FxP1998
"  DESCRIPTION: Ultimate Riced Vim (Fixed Search & Highlighting)
" ==============================================================================

" --- 0. PLUGINS (VIM-PLUG) ---
call plug#begin('~/.vim/plugged')
    " AESTHETICS
    Plug 'vim-airline/vim-airline'           " Pro Status Bar
    Plug 'vim-airline/vim-airline-themes'    " Themes
    Plug 'ryanoasis/vim-devicons'            " Icons (Nerd Fonts)
    Plug 'mhinz/vim-startify'                " Dashboard / Home Page
    Plug 'ap/vim-css-color'                  " Color Highlighting (#ff0000)

    " FILE EXPLORER
    Plug 'preservim/nerdtree'                " Sidebar File Tree
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Icons for Sidebar

    " FUNCTIONALITY
    Plug 'tpope/vim-surround'                " Quote handling (cs"')
    Plug 'tpope/vim-commentary'              " Commenting (gcc)
    Plug 'sheerun/vim-polyglot'              " Syntax Highlighting
    
    " FZF (Using System Binary)
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
call plug#end()

" --- 1. GENERAL SETTINGS ---
set nocompatible
filetype plugin indent on
syntax on
set clipboard=unnamedplus
if has('persistent_undo')
    set undofile
    set undodir=~/.vim/undo
endif

" --- 2. UI & VISUALS ---
set number
set relativenumber
set cursorline
set scrolloff=8
set termguicolors          " Required for Matugen Hex Colors
set signcolumn=yes
set nowrap
set noshowmode
set laststatus=2
set splitbelow
set splitright
set list
set listchars=tab:\│\ ,trail:·,extends:›,precedes:‹,nbsp:␣

" --- 3. MOUSE & PERFORMANCE ---
set mouse=a
if !has('nvim')
    set ttymouse=sgr       " Fix for Kitty/Alacritty mouse clicks
endif
set ttyfast                " Faster scrolling
set lazyredraw             " Faster macros
set updatetime=300         " Faster updates
set timeoutlen=1000
set ttimeoutlen=10         " No delay on ESC

" FIX: Prevent Clipboard Freezes on Wayland
if has('unnamedplus')
    set clipboard=unnamedplus
endif

let NERDTreeShowHidden=1

" --- 4. SEARCHING (ADDED) ---
set hlsearch      " Highlight all matches
set incsearch     " Highlight matches AS YOU TYPE
set ignorecase    " Case insensitive search
set smartcase     " Ignore case unless capital letter is typed

" --- 5. FIX: HYPRLAND RESIZE & RENDERING LAG ---
autocmd VimResized * redraw!
autocmd VimResized * wincmd =
autocmd VimEnter * call timer_start(10, {-> execute('redraw!')})

" --- 6. DASHBOARD (STARTIFY) CONFIG ---
let g:startify_padding_left = 3
let g:startify_fortune_use_unicode = 1

" Custom ASCII Header (FxP1998 - Terrace Style)
let g:startify_custom_header = [
    \ ' ______    _____  __  ___   ___   ___ ',
    \ '|  ____|  |  __ \/_ |/ _ \ / _ \ / _ \ ',
    \ '| |____  _| |__) || | (_) | (_) | (_) |',
    \ '|  __\ \/ /  ___/ | |\__, |\__, |> _ < ',
    \ '| |   >  <| |     | |  / /   / /| (_) |',
    \ '|_|  /_/\_\_|     |_| /_/   /_/  \___/ ',
    \ ]

let g:startify_lists = [
    \ { 'type': 'commands',  'header': ['   COMMANDS']       },
    \ { 'type': 'files',     'header': ['   RECENT FILES']   },
    \ { 'type': 'dir',       'header': ['   CURRENT DIR ' . getcwd()] },
    \ ]

let g:startify_commands = [
    \ { 'c': ['View Cheatsheet', 'call ShowCheatsheet()'] },
    \ { 'u': ['Update Plugins', ':PlugUpdate'] },
    \ { 'f': ['Find Files (FZF)', ':Files'] },
    \ ]

" Function to display Cheatsheet in a popup buffer
function! ShowCheatsheet()
    new
    setlocal buftype=nofile bufhidden=wipe noswapfile
    call append(0, '=== VIM RICE CHEATSHEET ===')
    call append(1, '')
    call append(2, '  <Ctrl> + n      :: Toggle File Explorer (NERDTree)')
    call append(3, '  <Ctrl> + p      :: Find Files (FZF)')
    call append(4, '  <Ctrl> + ww     :: Switch Windows')
    call append(5, '  gcc             :: Comment/Uncomment Line')
    call append(6, '  :Startify       :: Go back to Dashboard')
    call append(7, '')
    call append(8, '=== EDITING ===')
    call append(9,  '  cs"''            :: Change "Hello" to ''Hello''')
    call append(10, '  ds"             :: Delete quotes surrounding text')
    call append(11, '  <Tab>           :: Autocomplete Path/Box')
    normal! gg
endfunction

" --- 7. KEY MAPPINGS ---
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-p> :Files<CR>
" Clear search highlights with Esc
nnoremap <Esc> :nohlsearch<CR>

" --- 8. THEME & AIRLINE ---
let g:airline_powerline_fonts = 1
let g:airline_theme = 'deus'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Load Matugen if available
let s:matugen_theme = expand('~/.vim/colors/matugen.vim')
if filereadable(s:matugen_theme)
    execute 'source ' . s:matugen_theme
else
    colorscheme default
endif

" --- 9. SMART AUTOCOMPLETE (Your Box Logic) ---
set completeopt=menu,menuone,noselect
set wildmenu
set wildmode=full
if has("patch-8.2.4325")
  set wildoptions=pum
endif
set pumheight=15
if exists('&pumblend')
    set pumblend=10 
endif

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
