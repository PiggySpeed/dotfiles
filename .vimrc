" Vim Plug (https://github.com/junegunn/vim-plug)


" ---------------------------------------------------------
" AUTO-INSTALL VIM PLUG 
"
" ---------------------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ---------------------------------------------------------
" START CONFIG 
"
" ---------------------------------------------------------
call plug#begin('~/.vim/bundle')

syntax on
set encoding=utf-8

Plug 'whatyouhide/vim-gotham'
Plug 'ryanss/vim-hackernews'
Plug 'tmhedberg/SimpylFold'          " smart folding of python code
Plug 'vim-scripts/indentpython.vim'  " for Python autoindentation
"Plug 'Valloric/YouCompleteMe'        " code autocompletion
Plug 'scrooloose/syntastic'          " python syntax checking
Plug 'nvie/vim-flake8'               " python PEP-8 checking
Plug 'leafgarland/typescript-vim'    " typescript syntax checking
Plug 'scrooloose/nerdtree'           " tree explorer
Plug 'jistr/vim-nerdtree-tabs'       " tabs
Plug 'kien/ctrlp.vim'                " global search with CTRL-P
Plug 'tpope/vim-fugitive'            " git integration
Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'} " vim status bar

" ---------------------------------------------------------
" GENERAL CONFIGURATIONS
"
" ---------------------------------------------------------

" nerdtree configs
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
map <C-n> :NERDTreeToggle<CR>

"          let nerdtree open by default when entering \"vim\"
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

let NERDTreeAutoDeleteBuffer = 1 " delete buffer of files we delete
let NERDTreeMinimalUI = 1 " UI
let NERDTreeDirArrows = 1 " UI

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow " split new windows to bottom
set fillchars+=vert:\  " split windows border character 

" hi VertSplit guibg=NONE guifg=NONE " split windows border color
" hi VertSplit ctermbg=Black ctermfg=Black
" hi vertsplit guifg=Black guibg=Black

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable line numbers
set nu

" Allow access to clipboards from other applications
set clipboard=unnamed

" Move up/down lines when reaching the beginnin/end of a line
set whichwrap+=<,>,h,l,[,]

" Enable folding with the spacebar
nnoremap <space> za


" ---------------------------------------------------------
" PYTHON CONFIGURATIONS
"
" ---------------------------------------------------------
au BufNewFile,BufRead *.py
	\ set tabstop=2 | 
	\ set softtabstop=2 |
	\ set shiftwidth=2 |
	\ set textwidth=79 |
  \ set expandtab |
	\ set autoindent |
	\ set fileformat=unix |
 	\ match BadWhitespace /\s\+$/ " mark extra whitespace

function Py2()
  let g:syntastic_python_python_exec = '/usr/local/bin/python2.7'
endfunction

function Py3()
  let g:syntastic_python_flake8_exec = 'python3'
  let g:syntastic_python_flake8_args = ['-m', 'flake8']
endfunction

let g:syntastic_python_checkers = ['python3']

"call Py3()   " default to Py3 because I try to use it when possible

"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h
"	\ match BadWhitespace /\s\+$/ " mark extra whitespace

highlight BadWhitespace ctermbg=red guibg=red " set highlight color for BadWhitespace

" let g:ycm_autoclose_preview_window_after_completion=1 " autoclose autocomplete window
" map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"python with virtualenv support
" NOT WORKING 22/05/18 AFTER UPGRADING VIM
"py << EOF
"import os
"import sys
"if 'VIRTUAL_ENV' in os.environ:
"  project_base_dir = os.environ['VIRTUAL_ENV']
"  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"  execfile(activate_this, dict(__file__=activate_this))
"EOF

" warning for column lengths over 80
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" make python pretty
let python_highlight_all=1
syntax on

" ---------------------------------------------------------
" WEB DEV CONFIGURATIONS 
"
" ---------------------------------------------------------
au BufNewFile,BufRead *.js,*.html,*.css set tabstop=2 softtabstop=2 shiftwidth=2


" ---------------------------------------------------------
" C/C++ CONFIGURATIONS
"
" ---------------------------------------------------------
set exrc
set secure
set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab
set expandtab
set autoindent
set smartindent
set backspace=indent,eol,start

hi ColorColumn ctermbg=darkgrey
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END 
let &path.="src/include,/usr/include/AL," 

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py" " YCM Autocomplete


" ---------------------------------------------------------
" Color Scheme
"
" ---------------------------------------------------------
hi LineNr 
  \ term=bold 
  \ cterm=NONE 
  \ ctermfg=DarkGrey 
  \ ctermbg=black 
  \ gui=NONE 
  \ guifg=NONE 
  \ guibg=NONE


" ---------------------------------------------------------
" Status Line
"
" ---------------------------------------------------------

" have different status line colors depending on current mode
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=Green ctermfg=Green guifg=Black ctermbg=0
  elseif a:mode == 'r'
    hi statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
  else
    hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
  endif
endfunction

" have different colors for entering/leaving insert mode
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=NONE ctermfg=LightGrey guifg=White ctermbg=NONE

" default statusline colors
hi StatusLine guibg=NONE ctermfg=LightGrey guifg=White ctermbg=NONE
hi StatusLineNC guibg=NONE ctermfg=8 guifg=White ctermbg=NONE

" Formats the statusline
set statusline=%f                           " file name
set statusline+=\                           " blank space 
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%y      "filetype
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%{fugitive#statusline()} " Puts in the current git status

"if count(g:pathogen_disabled, 'Fugitive') < 1   
"  set statusline+=%{fugitive#statusline()}
"endif

" Puts in syntastic warnings
"    if count(g:pathogen_disabled, 'Syntastic') < 1  
"        set statusline+=%#warningmsg#
"        set statusline+=%{SyntasticStatuslineFlag()}
"        set statusline+=%*
"    endif

set statusline+=\ %=                        " align left
set statusline+=Line:%l/%L[%p%%]            " line X of Y [percent of file]
set statusline+=\ Col:%c                    " current column
set statusline+=\ Buf:%n                    " Buffer number
set statusline+=\ [%b][0x%B]\               " ASCII and byte code under cursor

" set color of vertical split line
hi VertSplit ctermbg=NONE ctermfg=NONE 

call plug#end()

" colorscheme configs
colorscheme gotham
highlight LineNr ctermbg=black


