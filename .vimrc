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

Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'tc50cal/vim-terminal'
Plug 'rust-lang/rust.vim'
Plug 'lifepillar/vim-gruvbox8'

call plug#end()

:command! Tree NERDTree
:set mouse=a
:set shortmess=a

let g:airline_theme= 'gruvbox8'
:set background=dark
autocmd vimenter * ++nested colorscheme gruvbox8


if v:version > 800
	:set termwinsize=20x0
	:command! Term belowright term
else
	:command! Term TerminalSplit zsh
endif

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



