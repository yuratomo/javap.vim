let [ s:MODE_LIST, s:MODE_BODY ] = range(2)
let s:javap_title_prefix = 'javap-'
let s:javap_separator = '    - '
let s:javap_mode = s:MODE_LIST

function! s:usage()
  new
  let bufname = s:javap_title_prefix
  silent edit `=bufname`
  let help= [
    \ "[USAGE]",
    \ "1. Append your _vimrc following settings.",
    \ "",
    \ "let g:javap_jars = [",
    \ " \\ $JAVA_HOME . '/jre/lib/rt.jar',",
    \ " \\ ]",
    \ "",
    \ "2. Input command \":Javap<ENTER>\"",
    \ "",
    \ "",
    \ ]
  call setline(1,help)
  setl bt=nofile noswf nowrap hidden nolist nomodifiable ft=vim
endfunction

function! javap#start(mode)
  if !executable(g:javap_command)
    call s:message(g:javap_command . ' is not exists.')
    return
  endif
  if !executable(g:jar_command)
    call s:message(g:jar_command . ' is not exists.')
    return
  endif
  let ret = s:load()
  if ret == -1
    call s:usage()
    return
  endif

  call s:openWindow(a:mode)
  call s:list()

  if ret == 1
    try
      exe "write" fnameescape(g:javap_cache)
    catch /^Vim(write):/
      throw "EXCEPT:IO(" . getcwd() . ", " . a:file . "):WRITEERR"
    endtry
  endif
endfunction

function! javap#exit()
  bd
endfunction

function! javap#open()
  if s:javap_mode == s:MODE_LIST
    let b:javap_line = line('.')
    call s:show()
  elseif s:javap_mode == s:MODE_BODY
    let pos = col('.')
    let tline = getline(1)
    let cline = getline('.')
    let s = s:matchr(cline, '[^a-zA-Z0-9_.]', pos)
    let e = match(cline, '[^a-zA-Z0-9_.]', pos)
    if s == -1
      let s = 0
    else
      let s += 1
    endif
    if e == -1
      let e = len(cline) - 1
    else
      let e -= 1
    endif

    let word = cline[ s : e ]
    if stridx(word, '.') > 0
      let idx=1
      for mode in [0, 1]
        for jar in g:jar_list
          let path = jar.path
          if mode == 0
            " first same search in jar
            if path != tline
              continue
            endif
          else
            if path == tline
              continue
            endif
          endif
          for class in jar.classes
            if class == word
              let b:javap_line = idx
              call s:show([ class , path ])
              return
            endif
            let idx += 1
          endfor
        endfor
      endfor
    endif
    call s:message(word . ' not found')
  endif
endfunction

function! javap#back()
  if s:javap_mode == s:MODE_LIST
    bd!
  elseif s:javap_mode == s:MODE_BODY
    call s:list()
    call cursor(b:javap_line, 0)
  endif
endfunction

function! javap#help()
  if exists('g:loaded_w3m') && g:loaded_w3m == 1
    let pos = col('.')
    let cline = getline('.')
    let s = s:matchr(cline, '[^a-zA-Z0-9_.]', pos)
    let e = match(cline, '[^a-zA-Z0-9_.]', pos)
    if s == -1
      let s = 0
    else
      let s += 1
    endif
    if e == -1
      let e = len(cline) - 1
    else
      let e -= 1
    endif

    let word = cline[ s : e ]

    let id = 1
    while buflisted('w3m-' . id) != 0
      let id += 1
    endwhile
    let winnum = winnr('$')
    for winno in range(1, winnum)
      let bn = bufname(winbufnr(winno))
      if bn =~ 'w3m-*'
         exe winno . "wincmd w"
         exe ':W3m msdnl ' . word
         return
      endif
    endfor

    exe ':W3mSplit msdnl ' . word
  endif
endfunction

function! s:openWindow(mode)
  let id = 1
  while buflisted(s:javap_title_prefix . id)
    let id += 1
  endwhile
  let bufname = s:javap_title_prefix . id

  if a:mode == 1
    new
  endif
  silent edit `=bufname`
  setl bt=nofile noswf nowrap hidden nolist nomodifiable ft=javap
  let b:javap_line = 0
  augroup javap
    au!
    exe 'au BufDelete <buffer> call javap#exit()'
  augroup END
  nnoremap <buffer> <CR> :call javap#open()<CR>
  nnoremap <buffer> <BS> :call javap#back()<CR>
  nnoremap <buffer> <F1> :call javap#help()<CR>
endfunction

function! s:list()
  let s:javap_mode = s:MODE_LIST
  setl modifiable
  call clearmatches()
  % delete _
  let idx=1
  for jar in g:jar_list
    let path = jar.path
    for class in jar.classes
      call setline(idx, class . s:javap_separator . path)
      let idx += 1
    endfor
  endfor
  setl nomodifiable
endfunction

function! s:listFromCache()
  let s:javap_mode = s:MODE_LIST
  setl modifiable
  call clearmatches()
  % delete _
  exe "read" fnameescape(g:javap_cache)
  setl nomodifiable
endfunction

function! s:show(...)
  let idx = 1
  let s:javap_mode = s:MODE_BODY
  if len(a:000) > 0
    let part = a:1
    let idx = line('$') + 1
  else
    let part = split(getline('.'), s:javap_separator)
  endif
  if len(part) >= 2
    setl modifiable
    if idx == 1
      call clearmatches()
      % delete _
    endif
    call matchadd("javapHeader", '\%' . idx . 'l')
    exe 'syn match javapCurrent "' . part[0] . '"'
    call setline(idx, part[1])
    call setline(idx+1, javap#api#getClassInfo(part[1],part[0]))
    setl nomodifiable
    call cursor(idx+1,0)
  endif
endfunction

function! s:load()
  if !exists('g:javap_jars')
    return -1
  endif
  if exists('g:jar_list')
    return 0
  endif

  let g:jar_list = []
  let path = ''
  let classes = []
  if filereadable(g:javap_cache)
    let lines = readfile(g:javap_cache)
    for line in lines
      let part = split(line, s:javap_separator)
      if path != part[1]
        if path != ''
          call add(g:jar_list, { 'path' : path, 'classes' : classes })
        endif
        let classes = []
        let path = part[1]
      endif
      call add(classes, part[0])
    endfor
    if path != ''
      call add(g:jar_list, { 'path' : path, 'classes' : classes })
    endif
    call s:message( 'load from cache ( ' . g:javap_cache . ' )')
    return 2
  endif

  for path in g:javap_jars
    let classes = javap#api#getClassList(path)
    redraw
    call s:message( 'loading ' . substitute(path, ".*\\", '', 'g') . ' ... ')
    call add(g:jar_list, { 'path' : path, 'classes' : classes })
  endfor
  return 1
endfunction

function! javap#clearCache()
  if exists('g:jar_list')
    unlet g:jar_list
  endif
  call delete(g:javap_cache)
  call s:message('Cache cleared!!')
endfunction

function! s:message(msg)
  redraw
  echo 'javap: ' . a:msg
endfunction

function! s:matchr(line, pat, pos)
  let idx = a:pos
  if idx >= len(a:line)
    let idx = len(a:line) - 1
  endif
  while idx >= 0
    if a:line[idx] =~ a:pat
      return idx
    endif
    let idx = idx - 1
  endwhile
  return -1
endfunction

