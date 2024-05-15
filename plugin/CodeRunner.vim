"+--Code Runner for NVIM---+
" Aurthor: @tribhuwan-kumar

" NVIM 'term' with default shell
function! TermCmd(command, shell)
    call s:deleteTermBuffers()
    execute "term " . a:shell . " -c " . a:command . ";exec " . a:shell
endfunction

" Manage 'term' Bufs
function! s:deleteTermBuffers() abort
    for termBuf in filter(range(1, bufnr('$')), 'bufname(v:val) =~ "^term://"')
        execute 'bdelete! ' . termBuf
    endfor
endfunction

" Get shell
function! GetShell(command)
    let escaped_command = shellescape(a:command, 2)
    if has('unix')
        let shell = substitute(system('basename $SHELL'), '\n', '', '')
        if shell ==# "bash"
            call TermCmd(escaped_command, 'bash')
        elseif shell ==# "zsh"
            call TermCmd(escaped_command, 'zsh')
        elseif shell ==# "fish"
            call TermCmd(escaped_command, 'fish')
        elseif shell ==# "sh"
            call TermCmd(escaped_command, 'sh')
        else
            let g:shell = "Not supported shell"
            echo g:shell
        endif
    else
        echo "Not supported"
    endif
endfunction

" Pass code run command
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
        call GetShell("java " . shellescape(l:fullpath))
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

" Vertical window
function! VRunCode()
    execute 'vsplit' | call CodeRun()
endfunction

" Horizontal window
function! HRunCode()
    execute 'botright split' | call CodeRun()
endfunction

" Commands
command! RunCode call CodeRun()
command! VRunCode call VRunCode()
command! HRunCode call HRunCode()
