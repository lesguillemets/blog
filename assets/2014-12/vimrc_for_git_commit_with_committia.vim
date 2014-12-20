scriptencoding utf-8
" NeoBundle {{{
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#begin(expand('$HOME/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'rhysd/committia.vim'
    let g:committia_hooks = {}
    let g:committia_min_window_width = 100
    function! g:committia_hooks.edit_open(e)
        setlocal spell
    endfunction
    function! g:committia_hooks.diff_open(e)
        setlocal nofoldenable
    endfunction
call neobundle#end()
" }}}

filetype plugin indent on  " ファイルタイプ毎の諸々
syntax on
set smarttab " indent/tab 周りを色々
set spelllang=en_gb,cjk " languages for spell checking
set timeout timeoutlen=1000 ttimeoutlen=100
set lazyredraw " don't redraw screen while executing macros etc.

set cursorline " highlight current line
set laststatus=2 " show statusline even when there's only one window
set list " \t, 行末などを可視化
set listchars=tab:>-,eol:$ " 可視化する文字の設定．お好みで
set number " show line number
set showmode  " tells us which mode we're in
set showcmd " show what command is being typed
set ruler " show current position

set t_Co=256 " for terminals that support 256 colours
colorscheme jellybeans
