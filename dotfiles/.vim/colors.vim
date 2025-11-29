" Catppuccin Latte Color Scheme for Vim
set background=light
set termguicolors

" Catppuccin Latte Base Colors
highlight Normal guibg=#eff1f5 guifg=#4c4f69
highlight NormalFloat guibg=#e6e9ef guifg=#4c4f69
highlight Comment guifg=#9ca0b0 gui=italic
highlight Constant guifg=#d20f39
highlight String guifg=#40a02b
highlight Character guifg=#8839ef
highlight Number guifg=#fe640b
highlight Boolean guifg=#d20f39
highlight Float guifg=#fe640b

" Identifiers
highlight Identifier guifg=#1e66f5
highlight Function guifg=#8839ef
highlight Variable guifg=#4c4f69

" Statements
highlight Statement guifg=#df8e1d
highlight Conditional guifg=#d20f39
highlight Repeat guifg=#d20f39
highlight Label guifg=#fe640b
highlight Operator guifg=#179299
highlight Keyword guifg=#d20f39
highlight Exception guifg=#d20f39

" Preprocessor
highlight PreProc guifg=#8839ef
highlight Include guifg=#8839ef
highlight Define guifg=#8839ef
highlight Macro guifg=#8839ef
highlight PreCondit guifg=#8839ef

" Types
highlight Type guifg=#df8e1d
highlight StorageClass guifg=#fe640b
highlight Structure guifg=#8839ef
highlight Typedef guifg=#8839ef

" Special
highlight Special guifg=#ea76cb
highlight SpecialChar guifg=#d20f39
highlight Tag guifg=#1e66f5
highlight Delimiter guifg=#5c5f77
highlight SpecialComment guifg=#9ca0b0
highlight Debug guifg=#d20f39

" UI Elements
highlight LineNr guifg=#9ca0b0
highlight CursorLineNr guifg=#4c4f69 gui=bold
highlight CursorLine guibg=#e6e9ef
highlight CursorColumn guibg=#e6e9ef
highlight ColorColumn guibg=#e6e9ef
highlight SignColumn guibg=#eff1f5 guifg=#9ca0b0
highlight FoldColumn guibg=#eff1f5 guifg=#9ca0b0
highlight Folded guibg=#e6e9ef guifg=#9ca0b0

" Cursor settings - HIGH VISIBILITY
highlight Cursor guibg=#dc8a78 guifg=#eff1f5
highlight iCursor guibg=#dc8a78 guifg=#eff1f5
highlight CursorIM guibg=#dc8a78 guifg=#eff1f5

" Visual Mode
highlight Visual guibg=#bcc0cc
highlight VisualNOS guibg=#bcc0cc

" Search
highlight Search guibg=#df8e1d guifg=#eff1f5
highlight IncSearch guibg=#fe640b guifg=#eff1f5
highlight MatchParen guibg=#8839ef guifg=#eff1f5 gui=bold

" Status Line
highlight StatusLine guibg=#e6e9ef guifg=#4c4f69
highlight StatusLineNC guibg=#eff1f5 guifg=#9ca0b0
highlight WildMenu guibg=#8839ef guifg=#eff1f5

" Tab Line
highlight TabLine guibg=#e6e9ef guifg=#9ca0b0
highlight TabLineSel guibg=#8839ef guifg=#eff1f5
highlight TabLineFill guibg=#eff1f5 guifg=#9ca0b0

" Pmenu (Completion)
highlight Pmenu guibg=#e6e9ef guifg=#4c4f69
highlight PmenuSel guibg=#8839ef guifg=#eff1f5
highlight PmenuSbar guibg=#e6e9ef
highlight PmenuThumb guibg=#ccd0da

" Errors and Warnings
highlight Error guibg=#d20f39 guifg=#eff1f5
highlight ErrorMsg guibg=#d20f39 guifg=#eff1f5
highlight WarningMsg guibg=#df8e1d guifg=#eff1f5
highlight MoreMsg guifg=#40a02b
highlight ModeMsg guifg=#4c4f69
highlight Question guifg=#df8e1d

" Diffs
highlight DiffAdd guibg=#e6e9ef guifg=#40a02b
highlight DiffChange guibg=#e6e9ef guifg=#df8e1d
highlight DiffDelete guibg=#e6e9ef guifg=#d20f39
highlight DiffText guibg=#e6e9ef guifg=#fe640b

" Spelling
highlight SpellBad gui=undercurl guisp=#d20f39
highlight SpellCap gui=undercurl guisp=#df8e1d
highlight SpellRare gui=undercurl guisp=#8839ef
highlight SpellLocal gui=undercurl guisp=#179299

" Special Syntax
highlight Title guifg=#1e66f5 gui=bold
highlight Todo guibg=#df8e1d guifg=#eff1f5 gui=bold
highlight Underlined guifg=#8839ef gui=underline
highlight SpecialKey guifg=#9ca0b0
highlight NonText guifg=#9ca0b0
highlight Directory guifg=#1e66f5
highlight Conceal guifg=#9ca0b0
