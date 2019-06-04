" Install plugin manager if it does not exist
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy file finder binary
Plug 'junegunn/fzf.vim'                   " Fuzzy file finder plugin
Plug 'junegunn/vim-plug'                  " Manage self

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'gruvbox-community/gruvbox'          " Gruvbox colorscheme
Plug 'sheerun/vim-polyglot'               " Collection of language plugins
Plug 'tpope/vim-commentary'               " Commenting made easy
Plug 'tpope/vim-dispatch'                 " Dispatch commands asynchronously!
Plug 'tpope/vim-fugitive'                 " Git in vim
Plug 'tpope/vim-sensible'                 " Sensible defaults
Plug 'vim-airline/vim-airline'            " Statusline
Plug 'vim-airline/vim-airline-themes'     " Statusline themes
Plug 'vimwiki/vimwiki'                    " Wiki management in vim
Plug 'w0rp/ale'                           " Asynchronous Linter
Plug 'Yggdroot/indentLine'                " Indentation guides

call plug#end()

" Leader
let mapleader="\<space>"

" Smart searching
set ignorecase
set smartcase
set hlsearch

" Cursor line
set cursorline

" Set the background
set background=dark
colorscheme gruvbox

" Store swapfiles in a single location
set dir=$HOME/.vim/tmp

" Fuzzy file finder
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :FZF<cr>

" Airline
"let g:airline_powerline_fonts = 1

" IndentLine
let g:indentLine_concealcursor='c'

" Spell settings
highlight SpellBad cterm=underline

" Wiki
let g:vimwiki_list =[{'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_url_maxsave=0
let g:vimwiki_global_ext=0

" ALE
let g:ale_linters = {'rust': ['rls']}
let g:ale_rust_rls_toolchain = 'stable'

" Deoplete
let g:deoplete#enable_at_startup = 1

" For guake terminal artifacts with neovim https://github.com/neovim/neovim/issues/7049
set guicursor=

" Style Guidelines
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
autocmd BufNewFile,BufRead {*.m,*.mi,*.mhtml} setlocal filetype=mason
autocmd FileType {mail,markdown,taskedit,text,vimwiki} setlocal spell concealcursor=c
autocmd FileType {mail} setlocal formatoptions+=w textwidth=80
autocmd FileType {crontab} setlocal nobackup | set nowritebackup
autocmd FileType {java,jsp} setlocal shiftwidth=4 tabstop=4 textwidth=150 cc=+1

