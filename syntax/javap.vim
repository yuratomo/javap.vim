if version < 700
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

source $VIMRUNTIME/syntax/java.vim
syn keyword javapKeyword   class field method event 
syn keyword javapExtends   extends implements
syn match   javapKakko     "\[\a*\]"
syn match   javapClass     "^[A-Z][a-zA-Z0-9.]*"
syn match   javapFilePath  "- .*$"
syn match   javapMethod    " \w*("
syn match   javapMethodEnd ")"

hi default link javapIgnore    Ignore
hi default link javapKeyword   Type
hi default link javapModifier  Number
hi default link javapSpecial   Special
hi default link javapHide      Ignore
hi default link javapKakko     Comment
hi default link javapClass     Function
hi default link javapCurrent   Function
hi default link javapHeader    Underlined
hi default link javapExtends   WildMenu
hi default link javapFilePath  Comment
hi default link javapMethod    Special
hi default link javapMethodEnd Special

let b:current_syntax = 'javap'
