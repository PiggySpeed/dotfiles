" ---------------------------------------------------------
" Useful References 
"
" ---------------------------------------------------------
" How to use augroup: https://vi.stackexchange.com/questions/9455/why-should-i-use-augroup
" maybe upgrade to lazygit later: https://github.com/jesseduffield/lazygit

" Setting up vim for go development: https://pmihaylov.com/vim-for-go-development


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
call plug#begin('~/.vim/autoload')
  Plug 'whatyouhide/vim-gotham'        " gotham color scheme
  Plug 'tmhedberg/SimpylFold'          " smart folding of python code
  Plug 'vim-scripts/indentpython.vim'  " for Python autoindentation
  Plug 'scrooloose/syntastic'          " python syntax checking
  Plug 'nvie/vim-flake8'               " python PEP-8 checking
  Plug 'leafgarland/typescript-vim'    " typescript syntax checking
  Plug 'scrooloose/nerdtree'           " tree explorer
  Plug 'jistr/vim-nerdtree-tabs'       " tabs
  Plug 'kien/ctrlp.vim'                " global search with CTRL-P
  Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'} " vim status bar
	Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " Go development
call plug#end()

" ---------------------------------------------------------
" Welcome Message 
"
" ---------------------------------------------------------
:echom '(>^.^<)'


" ---------------------------------------------------------
" GENERAL CONFIGURATIONS
"
" ---------------------------------------------------------
syntax on
set encoding=utf-8

set fillchars+=vert:\  " split windows border character 
set foldmethod=indent " enable folding
set foldlevel=99 " enable folding
set nu " set line numbers
set clipboard=unnamed " Allow access to clipboards from other applications
set whichwrap+=<,>,h,l,[,] " Move up/down lines when reaching the beginnin/end of a line

set tabstop=2
set softtabstop=2
set shiftwidth=2

set backspace=indent,eol,start
"set modifiable " makes the buffer modifiable in NERDTree

" remap window cycling to ctrl+hjkl
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

augroup User
  :echo '[autocmd] Python'
  au BufNewFile,BufRead *.py
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ match BadWhitespace /\s\+$/ " mark extra whitespace
  " :echo '[autocmd] Webdev'
  " au BufNewFile,BufRead *.js,*.html,*.css
  :echo '[autocmd] C/C++'
  au BufNewFile,BufRead *.h,*.c
    \ set exrc |
    \ set secure |
    \ set noexpandtab |
    \ set expandtab |
    \ set autoindent | 
    \ set smartindent |
    \ set filetype=c.doxygen |
    \ hi ColorColumn ctermbg=darkgrey

  :echo '[autocmd] statusline'
  " have different colors for entering/leaving insert mode
   au InsertEnter * call InsertStatuslineColor(v:insertmode)
   au InsertLeave * hi statusline guibg=NONE ctermfg=LightGrey guifg=White ctermbg=NONE
augroup END


" nerdtree config - no longer usings
"let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
"map <C-n> :NERDTreeToggle<CR> "let nerdtree open by default when entering vim
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"let NERDTreeAutoDeleteBuffer = 1 " delete buffer of files we delete
"let NERDTreeMinimalUI = 1 " UI
let NERDTreeDirArrows = 1 " UI

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" hi VertSplit guibg=NONE guifg=NONE " split windows border color
" hi VertSplit ctermbg=Black ctermfg=Black
" hi vertsplit guifg=Black guibg=Black
" Enable folding with the spacebar
nnoremap <space> za


" ---------------------------------------------------------
" PYTHON CONFIGURATIONS
"
" ---------------------------------------------------------
function Py2()
  let g:syntastic_python_python_exec = '/usr/local/bin/python2.7'
endfunction

function Py3()
  let g:syntastic_python_flake8_exec = 'python3'
  let g:syntastic_python_flake8_args = ['-m', 'flake8']
endfunction

let g:syntastic_python_checkers = ['python3']

"call Py3()   " default to Py3 because I try to use it when possible

" highlight BadWhitespace ctermbg=red guibg=red " set highlight color for BadWhitespace

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

" ---------------------------------------------------------
" Go DEV CONFIGURATIONS 
" based on https://pmihaylov.com/vim-for-go-development/
" ---------------------------------------------------------

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1

" disable all linters as that is taken care of by coc.nvim
let g:go_diagnostics_enabled = 0
let g:go_metalinter_enabled = []

" don't jump to errors after metalinter is invoked
let g:go_jump_to_error = 0

" run go imports on file save
let g:go_fmt_command = "goimports"

" automatically highlight variable your cursor is on
let g:go_auto_sameids = 0

" ---------------------------------------------------------
" C/C++ CONFIGURATIONS
"
" ---------------------------------------------------------
let &path.="src/include,/usr/include/AL,"
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py" " YCM Autocomplete


" ---------------------------------------------------------
" Markdown CONFIGURATIONS
"
" ---------------------------------------------------------
" https://github.com/jincheng9/markdown_supported_languages
let g:markdown_fenced_languages = ['html', 'js=javascript', 'css', 'go', 'bash', 'yaml', 'sql', 'python']


" ---------------------------------------------------------
" Status Line
" ref: https://shapeshed.com/vim-statuslines/
" ---------------------------------------------------------


" always show statusline
"set laststatus=2


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




set statusline+=\ %=                        " align left
set statusline+=Line:%l/%L[%p%%]            " line X of Y [percent of file]
set statusline+=\ Col:%c                    " current column
set statusline+=\ Buf:%n                    " Buffer number
set statusline+=\ [%b][0x%B]\               " ASCII and byte code under cursor


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


" set color of vertical split line
hi VertSplit ctermbg=NONE ctermfg=NONE 

" colorscheme configs
colorscheme gotham
highlight LineNr ctermbg=black


