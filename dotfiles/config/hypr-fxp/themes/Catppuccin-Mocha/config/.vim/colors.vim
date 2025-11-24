" Catppuccin Mocha Color Scheme for Vim
set background=dark
set termguicolors

" Catppuccin Mocha Base Colors
highlight Normal guibg=#1e1e2e guifg=#cdd6f4
highlight NormalFloat guibg=#313244 guifg=#cdd6f4
highlight Comment guifg=#6c7086 gui=italic
highlight Constant guifg=#f38ba8
highlight String guifg=#a6e3a1
highlight Character guifg=#cba6f7
highlight Number guifg=#fab387
highlight Boolean guifg=#f38ba8
highlight Float guifg=#fab387

" Identifiers
highlight Identifier guifg=#89b4fa
highlight Function guifg=#cba6f7
highlight Variable guifg=#cdd6f4

" Statements
highlight Statement guifg=#f9e2af
highlight Conditional guifg=#f38ba8
highlight Repeat guifg=#f38ba8
highlight Label guifg=#fab387
highlight Operator guifg=#94e2d5
highlight Keyword guifg=#f38ba8
highlight Exception guifg=#f38ba8

" Preprocessor
highlight PreProc guifg=#cba6f7
highlight Include guifg=#cba6f7
highlight Define guifg=#cba6f7
highlight Macro guifg=#cba6f7
highlight PreCondit guifg=#cba6f7

" Types
highlight Type guifg=#f9e2af
highlight StorageClass guifg=#fab387
highlight Structure guifg=#cba6f7
highlight Typedef guifg=#cba6f7

" Special
highlight Special guifg=#f5c2e7
highlight SpecialChar guifg=#f38ba8
highlight Tag guifg=#89b4fa
highlight Delimiter guifg=#bac2de
highlight SpecialComment guifg=#6c7086
highlight Debug guifg=#f38ba8

" UI Elements
highlight LineNr guifg=#6c7086
highlight CursorLineNr guifg=#cdd6f4 gui=bold
highlight CursorLine guibg=#313244
highlight CursorColumn guibg=#313244
highlight ColorColumn guibg=#313244
highlight SignColumn guibg=#1e1e2e guifg=#6c7086
highlight FoldColumn guibg=#1e1e2e guifg=#6c7086
highlight Folded guibg=#313244 guifg=#6c7086

" Cursor settings - HIGH VISIBILITY
highlight Cursor guibg=#f5e0dc guifg=#1e1e2e
highlight iCursor guibg=#f5e0dc guifg=#1e1e2e
highlight CursorIM guibg=#f5e0dc guifg=#1e1e2e

" Visual Mode
highlight Visual guibg=#585b70
highlight VisualNOS guibg=#585b70

" Search
highlight Search guibg=#f9e2af guifg=#1e1e2e
highlight IncSearch guibg=#fab387 guifg=#1e1e2e
highlight MatchParen guibg=#cba6f7 guifg=#1e1e2e gui=bold

" Status Line
highlight StatusLine guibg=#313244 guifg=#cdd6f4
highlight StatusLineNC guibg=#1e1e2e guifg=#6c7086
highlight WildMenu guibg=#cba6f7 guifg=#1e1e2e

" Tab Line
highlight TabLine guibg=#313244 guifg=#6c7086
highlight TabLineSel guibg=#cba6f7 guifg=#1e1e2e
highlight TabLineFill guibg=#1e1e2e guifg=#6c7086

" Pmenu (Completion)
highlight Pmenu guibg=#313244 guifg=#cdd6f4
highlight PmenuSel guibg=#cba6f7 guifg=#1e1e2e
highlight PmenuSbar guibg=#313244
highlight PmenuThumb guibg=#45475a

" Errors and Warnings
highlight Error guibg=#f38ba8 guifg=#1e1e2e
highlight ErrorMsg guibg=#f38ba8 guifg=#1e1e2e
highlight WarningMsg guibg=#f9e2af guifg=#1e1e2e
highlight MoreMsg guifg=#a6e3a1
highlight ModeMsg guifg=#cdd6f4
highlight Question guifg=#f9e2af

" Diffs
highlight DiffAdd guibg=#313244 guifg=#a6e3a1
highlight DiffChange guibg=#313244 guifg=#f9e2af
highlight DiffDelete guibg=#313244 guifg=#f38ba8
highlight DiffText guibg=#313244 guifg=#fab387

" Spelling
highlight SpellBad gui=undercurl guisp=#f38ba8
highlight SpellCap gui=undercurl guisp=#f9e2af
highlight SpellRare gui=undercurl guisp=#cba6f7
highlight SpellLocal gui=undercurl guisp=#94e2d5

" Special Syntax
highlight Title guifg=#89b4fa gui=bold
highlight Todo guibg=#f9e2af guifg=#1e1e2e gui=bold
highlight Underlined guifg=#cba6f7 gui=underline
highlight SpecialKey guifg=#6c7086
highlight NonText guifg=#6c7086
highlight Directory guifg=#89b4fa
highlight Conceal guifg=#6c7086
