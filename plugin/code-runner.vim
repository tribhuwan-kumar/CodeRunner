function! RunCommand(command)
    let escaped_command = shellescape(a:command, 1) " Escape non-alpha numeric characters
    " Open integrated shell, In my case I'm using Bash shell 
    execute "term bash -c " . escaped_command . ";exec bash" 
endfunction


function! CodeRunner()
    let l:ext = expand("%:e") " Get current file extension
    let l:fullpath = expand("%:p") " Get current file path

    if l:ext == "py"
        call RunCommand("python -u " . shellescape(l:fullpath)) 
    elseif l:ext == "js"
        call RunCommand("node " . shellescape(l:fullpath)) 
  endif
endfunction

command! RunCode call CodeRunner()

