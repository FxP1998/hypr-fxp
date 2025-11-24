" Rosé Pine Dawn - Color Scheme for Vim
set background=light
set termguicolors

" Rosé Pine Dawn Base Colors
highlight Normal guibg=#faf4ed guifg=#575279
highlight NormalFloat guibg=#fffaf3 guifg=#575279
highlight Comment guifg=#9893a5 gui=italic
highlight Constant guifg=#b4637a
highlight String guifg=#56949f
highlight Character guifg=#907aa9
highlight Number guifg=#d7827e
highlight Boolean guifg=#b4637a
highlight Float guifg=#d7827e

" Identifiers
highlight Identifier guifg=#286983
highlight Function guifg=#907aa9
highlight Variable guifg=#575279

" Statements
highlight Statement guifg=#ea9d34
highlight Conditional guifg=#b4637a
highlight Repeat guifg=#b4637a
highlight Label guifg=#d7827e
highlight Operator guifg=#797593
highlight Keyword guifg=#b4637a
highlight Exception guifg=#b4637a

" Preprocessor
highlight PreProc guifg=#907aa9
highlight Include guifg=#907aa9
highlight Define guifg=#907aa9
highlight Macro guifg=#907aa9
highlight PreCondit guifg=#907aa9

" Types
highlight Type guifg=#ea9d34
highlight StorageClass guifg=#d7827e
highlight Structure guifg=#907aa9
highlight Typedef guifg=#907aa9

" Special
highlight Special guifg=#d7827e
highlight SpecialChar guifg=#b4637a
highlight Tag guifg=#286983
highlight Delimiter guifg=#797593
highlight SpecialComment guifg=#9893a5
highlight Debug guifg=#b4637a

" UI Elements
highlight LineNr guifg=#9893a5
highlight CursorLineNr guifg=#575279 gui=bold
highlight CursorLine guibg=#fffaf3
highlight CursorColumn guibg=#fffaf3
highlight ColorColumn guibg=#fffaf3
highlight SignColumn guibg=#faf4ed guifg=#9893a5
highlight FoldColumn guibg=#faf4ed guifg=#9893a5
highlight Folded guibg=#fffaf3 guifg=#9893a5

" Cursor settings - HIGH VISIBILITY
highlight Cursor guibg=#575279 guifg=#faf4ed
highlight iCursor guibg=#575279 guifg=#faf4ed
highlight CursorIM guibg=#575279 guifg=#faf4ed

" Visual Mode
highlight Visual guibg=#e4dfcf
highlight VisualNOS guibg=#e4dfcf

" Search
highlight Search guibg=#ea9d34 guifg=#faf4ed
highlight IncSearch guibg=#d7827e guifg=#faf4ed
highlight MatchParen guibg=#907aa9 guifg=#faf4ed gui=bold

" Status Line
highlight StatusLine guibg=#fffaf3 guifg=#575279
highlight StatusLineNC guibg=#faf4ed guifg=#9893a5
highlight WildMenu guibg=#907aa9 guifg=#faf4ed

" Tab Line
highlight TabLine guibg=#fffaf3 guifg=#9893a5
highlight TabLineSel guibg=#907aa9 guifg=#faf4ed
highlight TabLineFill guibg=#faf4ed guifg=#9893a5

" Pmenu (Completion)
highlight Pmenu guibg=#fffaf3 guifg=#575279
highlight PmenuSel guibg=#907aa9 guifg=#faf4ed
highlight PmenuSbar guibg=#fffaf3
highlight PmenuThumb guibg=#f2e9e1

" Errors and Warnings
highlight Error guibg=#b4637a guifg=#faf4ed
highlight ErrorMsg guibg=#b4637a guifg=#faf4ed
highlight WarningMsg guibg=#ea9d34 guifg=#faf4ed
highlight MoreMsg guifg=#56949f
highlight ModeMsg guifg=#575279
highlight Question guifg=#ea9d34

" Diffs
highlight DiffAdd guibg=#fffaf3 guifg=#56949f
highlight DiffChange guibg=#fffaf3 guifg=#ea9d34
highlight DiffDelete guibg=#fffaf3 guifg=#b4637a
highlight DiffText guibg=#fffaf3 guifg=#d7827e

" Spelling
highlight SpellBad gui=undercurl guisp=#b4637a
highlight SpellCap gui=undercurl guisp=#ea9d34
highlight SpellRare gui=undercurl guisp=#907aa9
highlight SpellLocal gui=undercurl guisp=#56949f

" Special Syntax
highlight Title guifg=#286983 gui=bold
highlight Todo guibg=#ea9d34 guifg=#faf4ed gui=bold
highlight Underlined guifg=#907aa9 gui=underline
highlight SpecialKey guifg=#9893a5
highlight NonText guifg=#9893a5
highlight Directory guifg=#286983
highlight Conceal guifg=#9893a5
