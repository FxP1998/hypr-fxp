" Gruvbox Light Color Scheme for Vim
set background=light
set termguicolors

" Gruvbox Light Base Colors
highlight Normal guibg=#fbf1c7 guifg=#3c3836
highlight NormalFloat guibg=#ebdbb2 guifg=#3c3836
highlight Comment guifg=#928374 gui=italic
highlight Constant guifg=#cc241d
highlight String guifg=#98971a
highlight Character guifg=#b16286
highlight Number guifg=#b16286
highlight Boolean guifg=#cc241d
highlight Float guifg=#b16286

" Identifiers
highlight Identifier guifg=#458588
highlight Function guifg=#689d6a
highlight Variable guifg=#3c3836

" Statements
highlight Statement guifg=#d79921
highlight Conditional guifg=#cc241d
highlight Repeat guifg=#cc241d
highlight Label guifg=#d65d0e
highlight Operator guifg=#3c3836
highlight Keyword guifg=#cc241d
highlight Exception guifg=#cc241d

" Preprocessor
highlight PreProc guifg=#689d6a
highlight Include guifg=#689d6a
highlight Define guifg=#689d6a
highlight Macro guifg=#689d6a
highlight PreCondit guifg=#689d6a

" Types
highlight Type guifg=#b16286
highlight StorageClass guifg=#d65d0e
highlight Structure guifg=#689d6a
highlight Typedef guifg=#689d6a

" Special
highlight Special guifg=#d65d0e
highlight SpecialChar guifg=#cc241d
highlight Tag guifg=#689d6a
highlight Delimiter guifg=#3c3836
highlight SpecialComment guifg=#928374
highlight Debug guifg=#cc241d

" UI Elements
highlight LineNr guifg=#a89984
highlight CursorLineNr guifg=#3c3836 gui=bold
highlight CursorLine guibg=#ebdbb2
highlight CursorColumn guibg=#ebdbb2
highlight ColorColumn guibg=#ebdbb2
highlight SignColumn guibg=#fbf1c7 guifg=#a89984
highlight FoldColumn guibg=#fbf1c7 guifg=#a89984
highlight Folded guibg=#ebdbb2 guifg=#a89984

" Cursor settings - HIGH VISIBILITY
highlight Cursor guibg=#000000 guifg=#fbf1c7
highlight iCursor guibg=#000000 guifg=#fbf1c7
highlight CursorIM guibg=#000000 guifg=#fbf1c7

" Visual Mode
highlight Visual guibg=#83a598
highlight VisualNOS guibg=#83a598

" Search
highlight Search guibg=#d79921 guifg=#fbf1c7
highlight IncSearch guibg=#d65d0e guifg=#fbf1c7
highlight MatchParen guibg=#83a598 guifg=#fbf1c7 gui=bold

" Status Line
highlight StatusLine guibg=#ebdbb2 guifg=#3c3836
highlight StatusLineNC guibg=#fbf1c7 guifg=#a89984
highlight WildMenu guibg=#d79921 guifg=#fbf1c7

" Tab Line
highlight TabLine guibg=#ebdbb2 guifg=#a89984
highlight TabLineSel guibg=#d79921 guifg=#fbf1c7
highlight TabLineFill guibg=#fbf1c7 guifg=#a89984

" Pmenu (Completion)
highlight Pmenu guibg=#ebdbb2 guifg=#3c3836
highlight PmenuSel guibg=#458588 guifg=#fbf1c7
highlight PmenuSbar guibg=#ebdbb2
highlight PmenuThumb guibg=#d5c4a1

" Errors and Warnings
highlight Error guibg=#cc241d guifg=#fbf1c7
highlight ErrorMsg guibg=#cc241d guifg=#fbf1c7
highlight WarningMsg guibg=#d79921 guifg=#fbf1c7
highlight MoreMsg guifg=#689d6a
highlight ModeMsg guifg=#3c3836
highlight Question guifg=#d79921

" Diffs
highlight DiffAdd guibg=#d5c4a1 guifg=#689d6a
highlight DiffChange guibg=#d5c4a1 guifg=#d79921
highlight DiffDelete guibg=#d5c4a1 guifg=#cc241d
highlight DiffText guibg=#d5c4a1 guifg=#b16286

" Spelling
highlight SpellBad gui=undercurl guisp=#cc241d
highlight SpellCap gui=undercurl guisp=#d79921
highlight SpellRare gui=undercurl guisp=#b16286
highlight SpellLocal gui=undercurl guisp=#689d6a

" Special Syntax
highlight Title guifg=#458588 gui=bold
highlight Todo guibg=#d79921 guifg=#fbf1c7 gui=bold
highlight Underlined guifg=#b16286 gui=underline
highlight SpecialKey guifg=#a89984
highlight NonText guifg=#a89984
highlight Directory guifg=#458588
highlight Conceal guifg=#a89984
