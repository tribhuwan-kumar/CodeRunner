"+--Code Runner for NVIM---+
" Aurthor: @tribhuwan-kumar

" NVIM 'term' with default shell
function! s:TermCmd(command, shell)
    call s:deleteTermBuffers()
    execute "term " . a:shell . " -c " . a:command . ";exec " . a:shell
endfunction

" Manage 'term' Bufs
function! s:deleteTermBuffers() abort
    for l:termBuf in filter(range(1, bufnr('$')), 'bufname(v:val) =~ "^term://"')
        execute 'bdelete! ' . l:termBuf
    endfor
endfunction

" Get shell
function! s:GetShell(command)
    let l:escaped_command = shellescape(a:command, 2)
    if has('unix')
        let l:shell = substitute(system('basename $SHELL'), '\n', '', '')
        if l:shell ==# "bash"
            call s:TermCmd(l:escaped_command, 'bash')
        elseif l:shell ==# "zsh"
            call s:TermCmd(l:escaped_command, 'zsh')
        elseif l:shell ==# "fish"
            call s:TermCmd(l:escaped_command, 'fish')
        else
            let l:shell = "Not supported shell"
            echo l:shell
        endif
    else
        echo "Not supported"
    endif
endfunction

" Pass code run command
function! CodeRun()
    let l:cwd = getcwd()
    let l:ext = expand("%:e")
    let l:fullPath = expand("%:p")
    let l:relPath = strpart(l:fullPath, strlen(l:cwd))
    if  l:relPath[0] ==# "/"
        let l:relPath = strpart(l:relPath, 1)
    endif
    if l:ext == "py"
        call s:GetShell("python3 -u " . shellescape(l:relPath)) 
    elseif l:ext == "js"
        call s:GetShell("node " . shellescape(l:relPath))
    elseif l:ext == "ts"
        call s:GetShell("ts-node " . shellescape(l:relPath))
    elseif l:ext == "tsx"
        call s:GetShell("ts-node " . shellescape(l:relPath))
    elseif l:ext == "c" || l:ext == "cpp"
        let l:exeRelPath = fnamemodify(l:relPath, ':r')
        let l:compileCommand = l:ext == "c" ? 'gcc' : 'g++'
        let l:compileCommand .= ' ' . shellescape(l:relPath)
        let l:compileCommand .= ' -o ' . shellescape(l:exeRelPath)
        let l:runCommand = './' . shellescape(l:exeRelPath)
        call s:GetShell(l:compileCommand . " && " . l:runCommand) 
    elseif l:ext == "java"
        call s:GetShell("java " . shellescape(l:relPath))
    elseif l:ext == "go"
        call s:GetShell("go run " . shellescape(l:relPath))
    elseif l:ext == "rs"
        let l:exeRelPath = fnamemodify(l:relPath, ':r')
        call s:GetShell("rustc " . shellescape(l:relPath) . " -o " . shellescape(l:exeRelPath) . " && " . shellescape('./' . l:exeRelPath))
    elseif l:ext == "php"
        call s:GetShell("php " . shellescape(l:relPath))
    elseif l:ext == "lua"
        call s:GetShell("lua " . shellescape(l:relPath))
    elseif l:ext == "sh"
        call s:GetShell("bash " . shellescape(l:relPath))    
    elseif l:ext == "rb"
        call s:GetShell("ruby " . shellescape(l:relPath))
    else
        call s:GetShell("echo 'Not supported filetype'")
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

