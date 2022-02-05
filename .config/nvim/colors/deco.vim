set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "deco"

hi Normal guifg=#CCCCCC guibg=#000000
hi NonText guifg=#56C2D6

"line numbers
hi LineNr       ctermfg=3    ctermbg=NONE cterm=NONE guifg=#FF9820

"current line
hi CursorLine   ctermfg=NONE ctermbg=234  cterm=NONE gui=NONE guifg=NONE    guibg=#333333
hi CursorLineNr ctermfg=3    ctermbg=234  cterm=NONE gui=NONE guifg=#FF9820 guibg=#333333

"comments, #!/bin/bang
hi Comment      ctermfg=99   ctermbg=NONE cterm=NONE

"stdin, <stdio.h>, "string", 10, NULL, etc
hi Constant     ctermfg=161  ctermbg=NONE cterm=NONE

"if, return, for, #include, def, in, etc
hi Statement    ctermfg=12   ctermbg=NONE cterm=NONE

"typedef, struct, char, int, etc
hi Type         ctermfg=11   ctermbg=NONE cterm=NONE




"hi Identifier   ctermfg=5    ctermbg=NONE cterm=NONE
"hi Folded ctermfg=32 ctermbg=NONE cterm=NONE
"hi PreProc ctermfg=32 ctermbg=NONE cterm=NONE
"hi Special ctermfg=35 ctermbg=NONE cterm=NONE
"hi Underlined ctermfg=244 ctermbg=NONE cterm=underline
"hi Ignore ctermfg=bg ctermbg=NONE cterm=NONE
"hi Error ctermfg=15 ctermbg=196 cterm=NONE
"hi Todo ctermfg=fg ctermbg=bg cterm=NONE
