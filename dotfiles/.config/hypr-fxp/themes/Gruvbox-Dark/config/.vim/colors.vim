" Gruvbox Dark Color Scheme for Vim
set background=dark
set termguicolors

" Gruvbox Dark Base Colors
highlight Normal guibg=#282828 guifg=#ebdbb2
highlight NormalFloat guibg=#3c3836 guifg=#ebdbb2
highlight Comment guifg=#928374 gui=italic
highlight Constant guifg=#fb4934
highlight String guifg=#b8bb26
highlight Character guifg=#d3869b
highlight Number guifg=#d3869b
highlight Boolean guifg=#fb4934
highlight Float guifg=#d3869b

" Identifiers
highlight Identifier guifg=#83a598
highlight Function guifg=#8ec07c
highlight Variable guifg=#ebdbb2

" Statements
highlight Statement guifg=#fabd2f
highlight Conditional guifg=#fb4934
highlight Repeat guifg=#fb4934
highlight Label guifg=#fe8019
highlight Operator guifg=#ebdbb2
highlight Keyword guifg=#fb4934
highlight Exception guifg=#fb4934

" Preprocessor
highlight PreProc guifg=#8ec07c
highlight Include guifg=#8ec07c
highlight Define guifg=#8ec07c
highlight Macro guifg=#8ec07c
highlight PreCondit guifg=#8ec07c

" Types
highlight Type guifg=#d3869b
highlight StorageClass guifg=#fe8019
highlight Structure guifg=#8ec07c
highlight Typedef guifg=#8ec07c

" Special
highlight Special guifg=#fe8019
highlight SpecialChar guifg=#fb4934
highlight Tag guifg=#8ec07c
highlight Delimiter guifg=#ebdbb2
highlight SpecialComment guifg=#928374
highlight Debug guifg=#fb4934

" UI Elements
highlight LineNr guifg=#928374
highlight CursorLineNr guifg=#ebdbb2 gui=bold
highlight CursorLine guibg=#3c3836
highlight CursorColumn guibg=#3c3836
highlight ColorColumn guibg=#3c3836
highlight SignColumn guibg=#282828 guifg=#928374
highlight FoldColumn guibg=#282828 guifg=#928374
highlight Folded guibg=#3c3836 guifg=#928374

" Cursor settings
highlight Cursor guibg=#fb4934 guifg=#282828
highlight iCursor guibg=#fb4934 guifg=#282828
highlight CursorIM guibg=#fb4934 guifg=#282828

" Visual Mode
highlight Visual guibg=#458588
highlight VisualNOS guibg=#458588

" Search
highlight Search guibg=#fabd2f guifg=#282828
highlight IncSearch guibg=#fe8019 guifg=#282828
highlight MatchParen guibg=#458588 guifg=#ebdbb2 gui=bold

" Status Line
highlight StatusLine guibg=#3c3836 guifg=#ebdbb2
highlight StatusLineNC guibg=#282828 guifg=#928374
highlight WildMenu guibg=#fabd2f guifg=#282828

" Tab Line
highlight TabLine guibg=#3c3836 guifg=#928374
highlight TabLineSel guibg=#fabd2f guifg=#282828
highlight TabLineFill guibg=#282828 guifg=#928374

" Pmenu (Completion)
highlight Pmenu guibg=#3c3836 guifg=#ebdbb2
highlight PmenuSel guibg=#458588 guifg=#282828
highlight PmenuSbar guibg=#3c3836
highlight PmenuThumb guibg=#665c54

" Errors and Warnings
highlight Error guibg=#fb4934 guifg=#282828
highlight ErrorMsg guibg=#fb4934 guifg=#282828
highlight WarningMsg guibg=#fabd2f guifg=#282828
highlight MoreMsg guifg=#8ec07c
highlight ModeMsg guifg=#ebdbb2
highlight Question guifg=#fabd2f

" Diffs
highlight DiffAdd guibg=#32302f guifg=#8ec07c
highlight DiffChange guibg=#32302f guifg=#fabd2f
highlight DiffDelete guibg=#32302f guifg=#fb4934
highlight DiffText guibg=#32302f guifg=#d3869b

" Spelling
highlight SpellBad gui=undercurl guisp=#fb4934
highlight SpellCap gui=undercurl guisp=#fabd2f
highlight SpellRare gui=undercurl guisp=#d3869b
highlight SpellLocal gui=undercurl guisp=#8ec07c

" Special Syntax
highlight Title guifg=#83a598 gui=bold
highlight Todo guibg=#fabd2f guifg=#282828 gui=bold
highlight Underlined guifg=#d3869b gui=underline
highlight SpecialKey guifg=#928374
highlight NonText guifg=#928374
highlight Directory guifg=#83a598
highlight Conceal guifg=#928374
