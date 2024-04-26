# CodeRunner
## A simple plugin for code running in Nvim

### Keyfeatures
- No dependencies
- Uses Nvim intergrated terminal like VS code
- Opens Vertically or horizontally window, As you wish!!

### Installation
Use vim-plug or any plugin installer
```bash
Plug 'tribhuwan-kumar/CodeRunner'
```
### Configuration
- Use `:RunCode` for running code in Nvim
- Bind `RunCode` with your leader
- Use `vsplit` for vertical window & `botright split` for horizontal

Example:
```vim
:set splitright " for right side vsplit
nnoremap <Leader>r :vsplit \| RunCode<CR>
nnoremap <Leader>b :botright split \| RunCode<CR>
```

> [!NOTE]
> Currently, supports Python, Java, Go, Rust, Ruby C/C++, Lua, Shell, JavaScript & Typescript

> Doesn't support windows or mac

> Supported shells are bash, zsh, fish, shell, sh, csh, ksh, dash, tcsh & busybox
