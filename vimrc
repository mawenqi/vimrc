""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MaWenqi's vimrc
" Note: Only for Unix/Linux and NO GUI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
filetype plugin indent on

set history=100		" keep 100 lines of command line history
set bs=2		" allow backspacing over everything in insert mode
set ruler		" show the cursor position all the time
set autoread    " auto read when a file is changed from the outside
set nu
set nobackup
set nowb
set showcmd
set shell=/bin/bash
set encoding=utf8
set ffs=unix
set modeline
set smartindent
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set wildmenu "Turn on Wild menu
set incsearch "Make search act like search in modern browsers
" set foldcolumn=4

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=

"colorscheme darkblue
"colorscheme delek
if &t_Co > 2                                                                    
    syntax on                                                                   
    set hlsearch                                                                
endif

if &diff
    hi DiffAdd term=reverse cterm=bold ctermbg=green  ctermfg=white
    hi DiffChange term=reverse cterm=bold ctermbg=cyan ctermfg=black
    hi DiffText term=reverse cterm=bold ctermbg=gray ctermfg=black
    hi DiffDelete term=reverse cterm=bold ctermbg=yellow ctermfg=black
endif

if v:version >= 703
    set cc=80
    hi ColorColumn ctermbg=lightgrey guibg=lightgrey
endif

map <C-Z> :shell<cr>
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

let mapleader = ";"
let g:mapleader = ";"

"Fast editing of .vimrc
map <silent> <leader>ee :tabe ~/.vimrc<cr>
"When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File explorer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let NERDTreeWinPos="right"
nmap <silent> <leader>f :NERDTreeToggle<cr> 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"tab mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
    endif
        let s .= '%' . (i + 1) . 'T'
        let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor
    let s .= '%#TabLineFill#%T'
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999Xclose'
    endif
    return s
endfunction

function! MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let label = bufname(buflist[winnr - 1])
    return fnamemodify(label,':p:t')
endfunction
set tabline=%!MyTabLine()
map <silent> <leader>tn :tabnew<CR>
map <silent> <leader>tw :tabclose<CR>
map <silent> <leader>tp :tabp<CR>
nnoremap <TAB> :tabnext<CR>
nnoremap <F1> 1gt
nnoremap <F2> 2gt
nnoremap <F3> 3gt
nnoremap <F4> 4gt
nnoremap <F5> 5gt

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
" find . -name "*.h" -o -name "*.H" \
"   -o -name "*.c" -o -name "*.cpp" -o -name "*.C" > cscope.files
" cscope -bkq -i cscope.files
" cat cscope.files | xargs ctags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" 0 or s: Find this C symbol
" 1 or g: Find this definition
" 2 or d: Find functions called by this function
" 3 or c: Find functions calling this function
" 4 or t: Find this text string
" 6 or e: Find this egrep pattern
" 7 or f: Find this file
" 8 or i: Find files #including this file
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>

""""""""""""""""""""""""""""""
" tagbar (ctags)
""""""""""""""""""""""""""""""
if filereadable("tags")
    set tags=tags
elseif $CTAGS != ""
    set tags=$CTAGS
endif

let g:tagbar_compact = 1
let g:tagbar_width = 30
let g:tagbar_left = 1
let g:tagbar_autofocus = 1
map <silent> <leader>tt :TagbarToggle<cr>

""""""""""""""""""""""""""""""
" BufExplorer
" To start exploring in the current window, use: >
"  ;be   or   :BufExplorer
" To start exploring in a newly split horizontal window, use: >
"  ;bs   or   :BufExplorerHorizontalSplit
" To start exploring in a newly split vertical window, use: >
"  ;bv   or   :BufExplorerVerticalSplit
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSplitBelow=1        " Split new window below current.
let g:bufExplorerSplitRight=1        " Split right.

""""""""""""""""""""""""""""""""""""
" => C/C++ Python Javascript HTML
""""""""""""""""""""""""""""""""""""
au FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr><cr>
au FileType c,cpp setlocal noet sw=8 ts=8
"Use :Man function-name or <leader>K to load manual in a split window
au FileType c,cpp source $VIMRUNTIME/ftplugin/man.vim

let python_highlight_all = 1
au FileType python set nocindent
au FileType python syn keyword pythonDecorator True None False self

au FileType javascript setl fen nocindent

au FileType html set ft=xml
au FileType html set syntax=htm

""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH

""""""""""""""""""""""""""""""
" => quickfix
""""""""""""""""""""""""""""""
nmap <leader>cn :cn<cr>
nmap <leader>cp :cp<cr>
nmap <leader>cw :cw 10<cr>
nmap <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ;ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>
"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>sl z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => neocomplcache
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

