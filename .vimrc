" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Put all the plugins you need between these begin and end blocks
call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'tc50cal/vim-terminal'
Plug 'rust-lang/rust.vim'
Plug 'lifepillar/vim-gruvbox8'

call plug#end()

:command! Tree NERDTree
:set mouse=a
:set shortmess=a
:set autoread
:set shiftwidth=2
:set expandtab


let g:airline_theme= 'gruvbox8'
:set background=dark
autocmd vimenter * colorscheme gruvbox8

if v:version > 800
	:set termwinsize=20x0
	:command! Term belowright term
else
	:command! Term TerminalSplit zsh
endif


" Strim trailing whitespace in YAML, Python and Javascript documents where it
" might be semantically meaningful.
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    %s#\($\n\s*\)\+\%$##e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

autocmd BufWritePre *.py,*.js,*.sh,*.yml,*.yaml :call <SID>StripTrailingWhitespaces()

" keep NERDTree open on each new tab
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" automatically reload the state of the file on disk while cursor is still
:set autoread
au CursorHold,CursorHoldI * checktime

