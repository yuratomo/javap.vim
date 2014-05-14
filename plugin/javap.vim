" File: plugin/javap.vim
" Last Modified: 2014.03.06
" Author: yuratomo (twitter @yusetomo)
" Usage:
"
"   1.append _vimrc
"     let g:javap_jars = [
"       \ $JAVA_HOME . '/jre/lib/rt.jar',
"       \ ]
"
"   2.:Javap<ENTER>
"

if exists('g:loaded_javap') && g:loaded_javap == 1
  finish
endif

if !exists('g:javap_command')
  let g:javap_command = 'javap'
endif
if !exists('g:jar_command')
  let g:jar_command = 'jar'
endif

if !exists("g:javap_cache")
  let g:javap_cache = $home.'\\.vim_javap'
endif

command! -nargs=* Javap           :call javap#start(0)
command! -nargs=* JavapSplit      :call javap#start(1)
command! -nargs=* JavapClearCache :call javap#clearCache()
command! -nargs=* JavapReload     :call javap#reload()

let g:loaded_javap = 1

