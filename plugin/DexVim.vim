" Check os and shell
function! GetShell(command)
    let escaped_command = shellescape(a:command, 2)

    if has('unix')
        let shell = substitute(system('basename $SHELL'), '\n', '', '')

        if shell ==# "bash"
            call RunTerminal(escaped_command, 'bash')
        elseif shell ==# "zsh"
            call RunTerminal(escaped_command, 'zsh')
        elseif shell ==# "fish"
            call RunTerminal(escaped_command, 'fish')
        elseif shell ==# "sh"
            call RunTerminal(escaped_command, 'sh')
        else
            let g:shell = "Not supported shell"
            echo g:shell
        endif
    else
        let g:os = "Not supported"
        echo g:os
    endif
endfunction

" Run terminal command based on shell
let s:terminal_bufnr = -1

function! RunTerminal(command, shell)
    if s:terminal_bufnr == -1
        execute "term " . a:shell . " -c " . a:command . ";exec " . a:shell
        let s:terminal_bufnr = bufnr('%')
    else
        let term_win_id = bufwinnr(s:terminal_bufnr)
        if term_win_id != -1
            execute term_win_id . "wincmd w"
        else
            execute "term " . a:shell . " -c " . a:command . ";exec " . a:shell
            let s:terminal_bufnr = bufnr('%')
        endif
    endif
endfunction

" Handle terminal window closure
augroup TerminalWindow
    autocmd!
    autocmd TermClose * let s:terminal_bufnr = -1
augroup END


" Pass run command
function! CodeRun()
    let l:ext = expand("%:e") 
    let l:fullpath = expand("%:p") 
    let l:filename = expand("%:t:r")

    if l:ext == "py"
        call GetShell("python3 -u " . shellescape(l:fullpath)) 
    elseif l:ext == "js"
        call GetShell("node " . shellescape(l:fullpath))
    elseif l:ext == "ts"
        call GetShell("ts-node " . shellescape(l:fullpath))
    elseif l:ext == "tsx"
        call GetShell("ts-node " . shellescape(l:fullpath))
    elseif l:ext == "c" || l:ext == "cpp"
        let compile_command = l:ext == "c" ? 'gcc' : 'g++'
        let compile_command .= ' ' . shellescape(l:fullpath)
        let compile_command .= ' -o ' . shellescape('./' . l:filename)
        let run_command = './' . shellescape(l:filename)
        call GetShell(compile_command . " && " . run_command)
    elseif l:ext == "java"
        let compile_command = "javac " . shellescape(l:fullpath)
        let run_command = "java " . shellescape(l:filename)
        call GetShell(compile_command . " && " . run_command)
        " call GetShell("javac " . shellescape(l:fullpath) . " && java " . shellescape(l:filename))
    elseif l:ext == "go"
        call GetShell("go run " . shellescape(l:fullpath))
    elseif l:ext == "rs"
        call GetShell("rustc " . shellescape(l:fullpath) . " && " . shellescape('./' . l:filename))
    elseif l:ext == "php"
        call GetShell("php " . shellescape(l:fullpath))
    elseif l:ext == "lua"
        call GetShell("lua " . shellescape(l:fullpath))
    elseif l:ext == "sh"
        call GetShell("bash " . shellescape(l:fullpath))    
    elseif l:ext == "rb"
        call GetShell("ruby " . shellescape(l:fullpath))
    else
        call GetShell("echo 'Not supported filetype'")
    endif
endfunction

command! RunCode call CodeRun()


