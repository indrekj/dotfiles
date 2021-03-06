let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

hi link railsMethod         PreProc
hi link rubyDefine          Keyword
hi link rubySymbol          Constant
hi link rubyAccess          rubyMethod
hi link rubyAttribute       rubyMethod
hi link rubyEval            rubyMethod
hi link rubyException       rubyMethod
hi link rubyInclude         rubyMethod
hi link rubyStringDelimiter rubyString
hi link rubyRegexp          Regexp
hi link rubyRegexpDelimiter rubyRegexp
"hi link rubyConstant        Variable
"hi link rubyGlobalVariable  Variable
"hi link rubyClassVariable   Variable
"hi link rubyInstanceVariable Variable
hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant
highlight link diffAdded        String
highlight link diffRemoved      Statement
highlight link diffLine         PreProc
highlight link diffSubname      Comment

highlight Normal        guifg=#EEEEEE
highlight StatusLine    guifg=Black   guibg=#aabbee gui=bold
highlight StatusLineNC  guifg=#444444 guibg=#aaaaaa gui=none
"highlight StatusLine    ctermbg=117

highlight WildMenu      guifg=Black guibg=#ffff00 gui=bold
highlight Cursor        guifg=Black guibg=White
highlight CursorLine    guibg=#333333 guifg=NONE
highlight CursorColumn  guibg=#333333 guifg=NONE
highlight NonText       guifg=#404040
highlight SpecialKey    guifg=#404040
highlight Directory     none
high link Directory     Identifier
highlight ErrorMsg      guibg=Red guifg=NONE
highlight Search        guifg=NONE gui=none guibg=#555555
highlight IncSearch     guifg=White guibg=Black
highlight MoreMsg       guifg=#00AA00
highlight LineNr        guifg=#DDEEFF guibg=#222222
highlight Question      none
high link Question      MoreMsg
highlight Title         guifg=Magenta
highlight VisualNOS     gui=none guibg=#444444
highlight Visual        guibg=#555577
highlight MatchParen    guibg=#1100AA
highlight WarningMsg    guifg=Red

highlight Folded        guibg=#110077 guifg=#AADDEE
highlight FoldColumn    none
high link FoldColumn    Folded
highlight DiffAdd       guibg=DarkBlue
highlight DiffChange    guibg=DarkMagenta
highlight DiffDelete    gui=bold guifg=Blue guibg=DarkCyan
highlight DiffText      gui=bold guibg=Red

highlight Pmenu         guifg=White gui=bold guibg=#000099
highlight PmenuSel      guifg=White gui=bold guibg=#5555FF
highlight PmenuSbar     guibg=Grey
highlight PmenuThumb    guibg=White
highlight TabLine       gui=underline guifg=#BBBBBB guibg=#333333
highlight TabLineSel    guifg=White guibg=Black
highlight TabLineFill   gui=underline guifg=#BBBBBB guibg=#808080

highlight Type            gui=none
highlight Statement       gui=none
"highlight Identifier      cterm=none
highlight PreProc         guifg=#EDF8F9
highlight Comment         guifg=#9933CC
highlight Constant        guifg=#339999
highlight rubyNumber      guifg=#CCFF33
highlight String          guifg=#66FF00
highlight Identifier      guifg=#FFCC00
highlight Statement       guifg=#FF7614 " module/class keyword
highlight PreProc         guifg=#AAFFFF
highlight railsUserMethod guifg=#AACCFF
highlight Type            guifg=#DBDB84 " Orange-yellow (class name)
highlight railsUserClass  guifg=#AAAAAA
highlight Special         guifg=#33AA00
highlight Regexp          guifg=#44B4CC
highlight rubyMethod      guifg=#DDE93D
highlight ColorColumn     guibg=#ed2939
