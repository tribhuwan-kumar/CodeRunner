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
### Usage
- Use `:RunCode` for running code in Nvim `$TERM`
- `:VRunCode` For running code in vertical window
- & `:HRunCode` for horizontal window 

Example:
```vim
:set splitright " for right side vertically split
nnoremap <Leader>r :VRunCode<CR>
nnoremap <Leader>b :HRunCode<CR>
```

> [!NOTE]
> Currently, supports Python, Java, Go, Rust, Ruby, C/C++, Lua, Shell, JavaScript & Typescript

> Doesn't support windows or mac

> Supported shells are bash, zsh & fish
