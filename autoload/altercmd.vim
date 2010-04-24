" altercmd - Alter built-in Ex commands by your own ones
" Version: 0.0.0
" Copyright (C) 2009 kana <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Interface  "{{{1
function! altercmd#define(...)  "{{{2
  try
    let [options, lhs_list, alternate_name] = s:parse_args(a:000)
  catch /^parse error$/
    return
  endtry

  for lhs in lhs_list
    execute
    \ options.mode . 'noreabbrev <expr>' . (options.buffer ? '<buffer>' : '')
    \ lhs
    \ '(getcmdtype() == "' . options.cmdtype . '" && getcmdline() ==# "' . lhs  . '")'
    \ '?' ('"' . alternate_name . '"')
    \ ':' ('"' . lhs . '"')
  endfor
endfunction



function! s:parse_args(args)  "{{{2
  let args = a:args
  let parse_error = 'parse error'

  if len(args) < 2
    throw parse_error
  endif

  let options = {
  \ 'cmdtype': ':',
  \ 'mode': 'c',
  \}
  let lhs_list = []

  let options.buffer = (args[0] ==? '<buffer>')
  if options.buffer
    call remove(args, 0)
  endif
  let [original_name, alternate_name] = args[0:1]
  if len(args) >= 3 && type(args[2]) == type({})
    call extend(options, args[2])
  endif

  if original_name =~ '\['
    let [original_name_head, original_name_tail] = split(original_name, '[')
    let original_name_tail = substitute(original_name_tail, '\]', '', '')
  else
    let original_name_head = original_name
    let original_name_tail = ''
  endif

  let original_name_tail = ' ' . original_name_tail
  for i in range(len(original_name_tail))
    let lhs = original_name_head . original_name_tail[1:i]
    call add(lhs_list, lhs)
  endfor

  return [options, lhs_list, alternate_name]
endfunction




function! altercmd#load()  "{{{2
  runtime! plugin/altercmd.vim
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
