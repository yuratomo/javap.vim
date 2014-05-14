
function! javap#api#getClassList(path)
  let cmd = join( [ 
    \ g:jar_command, 
    \ '-tf', 
    \ '"' . a:path . '"', 
    \ ],  ' ')
  let list = map(map(split(s:system(cmd), '\n'), 'substitute(v:val, "\.class.*", "", "")'), 'substitute(v:val, "/", ".", "g")')
  return filter(filter(list, 'v:val !~ ".*$.*"'), 'v:val !~ ".*META.*"')
endfunction

function! javap#api#getClassInfo(path, class)
  let cmd = join( [
    \ g:javap_command,
    \ '-public',
    \ '-classpath',
    \ shellescape(a:path),
    \ a:class
    \ ],  ' ')
    "\ '-constants',

  return split(s:system(cmd), '\n')[1:]
endfunction

function! s:system(string)
" if exists('g:loaded_vimproc')
"   return vimproc#system(a:string)
" else
    return system(a:string)
" endif
endfunction
