function! CodeRunner()
  let l:ext = expand("%:e")
  let l:fullpath = expand("%:p")
  if l:ext == "py"
      execute "T python -u " . shellescape(l:fullpath)
  elseif l:ext == "js"
      execute "vsplit \| terminal"
      execute "send-keys node " . shellescape(l:fullpath)
  endif
endfunction

command! RunCode call CodeRunner()

