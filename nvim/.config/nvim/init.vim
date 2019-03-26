" call vim-plug
call plug#begin('~/.nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
    " \ 'for': 'python'

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'lyuts/vim-rtags', { 'for': 'cpp' }
Plug 'rzaluska/deoplete-rtags', { 'for': 'cpp' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-scripts/a.vim'
Plug 't9md/vim-quickhl'
Plug 'scrooloose/nerdcommenter'
Plug 'zivyangll/git-blame.vim'
Plug 'neomake/neomake', {
    \ 'for': 'tex'
    \ }
Plug 'SailorCrane/vim-swap-string'
Plug 'tpope/vim-fugitive'

call plug#end()

" fzf config
nnoremap <leader>h :History<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>t :Files<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" lang server config
" Required for operations modifying multiple buffers like rename.
set hidden

" deoplete config
let g:deoplete#enable_at_startup = 1
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
call deoplete#custom#option('auto_complete_delay', 5)

" languageclient cfg
let g:LanguageClient_serverCommands = {
    \ 'cpp': ['cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory":".cquery-cache/"}'],
    \ 'c': ['cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory":".cquery-cache/"}'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['pyls'],
    \ }

    " \ 'cpp': ['ccls', '-log-file=/tmp/ccls.log'],
    " \ 'c': ['ccls'],
    " \ 'cpp': ['cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory":".cquery-cache/"}'],
    " \ 'c': ['cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory":".cquery-cache/"}'],
    " \ 'cpp': ['clangd'],
    " \ 'c': ['clangd'],

nnoremap <F4> :call LanguageClient_contextMenu()<CR>

" airline config
let g:airline_theme = "solarized"
let g:airline_powerline_fonts = 1

" YouCompleteMe config
"let g:ycm_global_ycm_extra_conf = '$HOME/.vim/.ycm_extra_conf.py'
"let g:ycm_confirm_extra_conf = 0

" snippets config
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<c-f>"
let g:UltiSnipsJumpForwardTrigger="<c-x>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" quickhl config
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)

" nerdcommenter config
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" a.vim config: alternate header / source file
:map <C-c> :A<CR>
:map <C-S-c> :AT<CR>
:imap <C-c> <ESC>:A<CR>

" remaining config
set mouse=a
set number
set relativenumber
set hlsearch
set tabstop=3
set sw=3
set expandtab
set cursorline
set autoread
syntax on

" filetype based configs
autocmd FileType tex setlocal shiftwidth=1 tabstop=1 expandtab
" consider : to be part of words for label autocomplete
autocmd FileType tex set iskeyword+=:
let g:tex_flavor = "latex"
autocmd FileType json setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType make setlocal noexpandtab
" hack: vim detects Make.{local,config} as conf file
autocmd FileType conf setlocal noexpandtab
" for cpp, always show signcolumn to avoid jumping horizontal layout if errors
autocmd FileType cpp setlocal signcolumn=yes syntax=cpp.doxygen
         \ cino=(3 fdm=syntax foldlevel=20
autocmd Filetype c,cpp set comments^=:///

" auto-refresh details
au CursorHold,CursorHoldI,FocusGained,BufEnter * checktime

" trailing whitespace handling
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun


" file types for which whitespace is preserved
let blacklist = ['rb', 'js', 'pl', 'diff']
autocmd BufWritePre * if index(blacklist, &ft) < 0 | :call <SID>StripTrailingWhitespaces()

" restore cursor at same position
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


" fourway merge: top is ancestor, left HEAD, center merge, right merged commit
command MergeTool :Gsdiff :1 | Gvdiff

" hotkeys
command SaveMake :wa <bar> :make
command SaveNeomake :wa <bar> :Neomake!
:map <F1> :nohls<CR>
:imap <F1> <ESC>:nohls<CR>
:map <F5> :SaveNeomake<CR>
:imap <F5> <ESC>:SaveNeomake<CR>
:map <F8> :SaveMake<CR>
:imap <F8> <ESC>:SaveMake<CR>

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" In visual mode, // searches for previous matches of the highlighted text
vnoremap // y/<C-R>"<CR>

" faster pane navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" tab navigation
map <C-n> :tabn<CR>
map <C-p> :tabp<CR>

" tab control
map <A-w> :tabclose<CR>

" mouse scrolling: scroll page instead of cursor
:map <ScrollWheelUp> <C-Y>
:map <S-ScrollWheelUp> <C-U>
:map <ScrollWheelDown> <C-E>
:map <S-ScrollWheelDown> <C-D>

" color profile
set background=light
colorscheme solarized
