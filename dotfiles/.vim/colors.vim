" Rosé Pine Main - Color Scheme for Vim
set background=dark
set termguicolors

" Rosé Pine Main Base Colors
highlight Normal guibg=#191724 guifg=#e0def4
highlight NormalFloat guibg=#1f1d2e guifg=#e0def4
highlight Comment guifg=#6e6a86 gui=italic
highlight Constant guifg=#eb6f92
highlight String guifg=#9ccfd8
highlight Character guifg=#c4a7e7
highlight Number guifg=#ebbcba
highlight Boolean guifg=#eb6f92
highlight Float guifg=#ebbcba

" Identifiers
highlight Identifier guifg=#31748f
highlight Function guifg=#c4a7e7
highlight Variable guifg=#e0def4

" Statements
highlight Statement guifg=#f6c177
highlight Conditional guifg=#eb6f92
highlight Repeat guifg=#eb6f92
highlight Label guifg=#ea9a97
highlight Operator guifg=#ebbcba
highlight Keyword guifg=#eb6f92
highlight Exception guifg=#eb6f92

" Preprocessor
highlight PreProc guifg=#c4a7e7
highlight Include guifg=#c4a7e7
highlight Define guifg=#c4a7e7
highlight Macro guifg=#c4a7e7
highlight PreCondit guifg=#c4a7e7

" Types
highlight Type guifg=#f6c177
highlight StorageClass guifg=#ea9a97
highlight Structure guifg=#c4a7e7
highlight Typedef guifg=#c4a7e7

" Special
highlight Special guifg=#ebbcba
highlight SpecialChar guifg=#eb6f92
highlight Tag guifg=#31748f
highlight Delimiter guifg=#908caa
highlight SpecialComment guifg=#6e6a86
highlight Debug guifg=#eb6f92

" UI Elements
highlight LineNr guifg=#6e6a86
highlight CursorLineNr guifg=#e0def4 gui=bold
highlight CursorLine guibg=#1f1d2e
highlight CursorColumn guibg=#1f1d2e
highlight ColorColumn guibg=#1f1d2e
highlight SignColumn guibg=#191724 guifg=#6e6a86
highlight FoldColumn guibg=#191724 guifg=#6e6a86
highlight Folded guibg=#1f1d2e guifg=#6e6a86

" Cursor settings - HIGH VISIBILITY
highlight Cursor guibg=#e0def4 guifg=#191724
highlight iCursor guibg=#e0def4 guifg=#191724
highlight CursorIM guibg=#e0def4 guifg=#191724

" Visual Mode
highlight Visual guibg=#403d52
highlight VisualNOS guibg=#403d52

" Search
highlight Search guibg=#f6c177 guifg=#191724
highlight IncSearch guibg=#ea9a97 guifg=#191724
highlight MatchParen guibg=#c4a7e7 guifg=#191724 gui=bold

" Status Line
highlight StatusLine guibg=#1f1d2e guifg=#e0def4
highlight StatusLineNC guibg=#191724 guifg=#6e6a86
highlight WildMenu guibg=#c4a7e7 guifg=#191724

" Tab Line
highlight TabLine guibg=#1f1d2e guifg=#6e6a86
highlight TabLineSel guibg=#c4a7e7 guifg=#191724
highlight TabLineFill guibg=#191724 guifg=#6e6a86

" Pmenu (Completion)
highlight Pmenu guibg=#1f1d2e guifg=#e0def4
highlight PmenuSel guibg=#c4a7e7 guifg=#191724
highlight PmenuSbar guibg=#1f1d2e
highlight PmenuThumb guibg=#26233a

" Errors and Warnings
highlight Error guibg=#eb6f92 guifg=#191724
highlight ErrorMsg guibg=#eb6f92 guifg=#191724
highlight WarningMsg guibg=#f6c177 guifg=#191724
highlight MoreMsg guifg=#9ccfd8
highlight ModeMsg guifg=#e0def4
highlight Question guifg=#f6c177

" Diffs
highlight DiffAdd guibg=#1f1d2e guifg=#9ccfd8
highlight DiffChange guibg=#1f1d2e guifg=#f6c177
highlight DiffDelete guibg=#1f1d2e guifg=#eb6f92
highlight DiffText guibg=#1f1d2e guifg=#ebbcba

" Spelling
highlight SpellBad gui=undercurl guisp=#eb6f92
highlight SpellCap gui=undercurl guisp=#f6c177
highlight SpellRare gui=undercurl guisp=#c4a7e7
highlight SpellLocal gui=undercurl guisp=#9ccfd8

" Special Syntax
highlight Title guifg=#31748f gui=bold
highlight Todo guibg=#f6c177 guifg=#191724 gui=bold
highlight Underlined guifg=#c4a7e7 gui=underline
highlight SpecialKey guifg=#6e6a86
highlight NonText guifg=#6e6a86
highlight Directory guifg=#31748f
highlight Conceal guifg=#6e6a86
