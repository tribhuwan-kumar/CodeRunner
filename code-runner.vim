function! CodeRunner()
      let l:ext = expand("%:e")
      execute "new | terminal"
      execute "cd %:p:h"
      if l:ext == "py"
          execute "python %"
      elseif l:ext == "js"
          execute "node %"
      endif
endfunction

command! RunCode call CodeRunner()

