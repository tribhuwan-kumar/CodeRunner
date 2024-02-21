let s:terminal_bufnr = -1
function! GetShell(command)
    let escaped_command = shellescape(a:command, 2)
    if has('unix')
        let shell = substitute(system('basename $SHELL'), '\n', '', '')

        if shell ==# "bash"
            if s:terminal_bufnr == -1
                execute "vsplit | term bash -c " . escaped_command . ";exec bash"
                let s:terminal_bufnr = bufnr('%')
            else
                let term_win_id = bufwinnr(s:terminal_bufnr)
                if term_win_id != -1
                    execute term_win_id . "wincmd w"
                else
                    execute "vsplit | term bash -c " . escaped_command . ";exec bash"
                    let s:terminal_bufnr = bufnr('%')
                endif
            endif
        endif
    else
        let g:os = "Not supported"
        echo g:os
    endif
endfunction

augroup TerminalWindow
    autocmd!
    autocmd TermClose * let s:terminal_bufnr = -1
augroup END

function! CodeRun()
    let l:ext = expand("%:e") 
    let l:fullpath = expand("%:p") 

    if l:ext == "py"
        call GetShell("python -u " . shellescape(l:fullpath)) 
    else
        call GetShell("echo 'Not supported filetype'")
    endif
endfunction

command! RunCode call CodeRun()



