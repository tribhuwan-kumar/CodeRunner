function! CodeRunner()
      let l:ext = expand("%:e")
      execute "new | terminal"
      execute "cd %:p:h"
      if l:ext == "py"
            execute "python " . shellescape(expand("%"))
      elseif l:ext == "js"
            execute "node " . shellescape(expand("%"))
      endif
endfunction

command! RunCode call CodeRunner()

