scriptencoding utf-8
set encoding=utf-8

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[2 q"
let &t_EI = "\<Esc>[2 q"

" set cuc
set cul
set list
set listchars=nbsp:@,trail:-
set noeol
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,ColorScheme * :hi IndentGuidesOdd ctermbg=52
autocmd VimEnter,ColorScheme * :hi IndentGuidesEven ctermbg=17

" set shortmess-=S

function! StripTrailingWhitespace()
    if exists("b:noStripWhitespace") && b:noStripWhitespace == 1
        return
    endif
    %s/\s+\+$//e
endfunction

autocmd BufWritePre * call StripTrailingWhitespace()
autocmd FileType vim,ruby,perl let b:noStripWhitespace=1

let data = readfile('C:/local/cygwin32/home/jason/filetypes.txt')

if index(data, expand("%:e")) != -1 && getfsize(expand(@%)) < 10000 " 25 KB
    let g:rainbow_active = 1
    let g:rainbow_ctermfgs = [196, 208, 11, 46, 87, 39, 129, 199]
endif

let g:AutoPairsMultilineClose = 0
let g:AutoPairsMoveCharacter = ""

au FileType cpp,ada,java,cs,vb,pas let b:AutoPairs = AutoPairsDefine(
        \ {'\a\w\*\zs<' : '>'})
au FileType cpp let b:AutoPairs = AutoPairsDefine({'\^#include\s\+\zs<' : '>', 'MITER(' : ') MEND//m',
        \ 'STRUCT(' : ') ENDSTRUCT//m'})


set redrawtime=1000 "1 second
syntax on
colorscheme my_molokai

set encoding=utf-8
set guifont=Lucida_Console:h9:cANSI
set guifontwide=Lucida_Console:h12

set linespace=0

set showcmd
set number
set mouse=a


function ShowBuffer()
    let l:fullstring = @"
    let l:fullstring = substitute(l:fullstring, '^\_s\+', '', '')
    let l:fullstring = substitute(l:fullstring, '\_s\+$', '', '')
    if len(l:fullstring) > 23
        let l:fullstring = l:fullstring[ : 9] . '...' . l:fullstring[-10 : ]
    endif
    let l:fullstring = substitute(l:fullstring, '\_s', '_', 'g')
    return l:fullstring
endfunction

function BufferCurByte()
    let l:out = line2byte(line('.')) + col('.') - 1
    if l:out < 0
        return 0
    endif
    return l:out
endfunction

function BufferByteSize()
    let l:out = line2byte(line('$') + 1) - 1
    if l:out < 0
        return 0
    endif
    return l:out
endfunction

function BufferBytePercent()
    let l:bytesize = BufferByteSize()
    if l:bytesize == 0
        return 0
    endif
    return BufferCurByte() * 100 / l:bytesize
endfunction

function GetCurRows()
    return line('.') - (BufferByteSize() == 0)
endfunction
function GetCurCols()
    return col('.') - (BufferByteSize() == 0)
endfunction
function GetTotalRows()
    return line('$') - (BufferByteSize() == 0)
endfunction
function GetTotalCols()
    return col('$') - (mode() != 'i' || BufferByteSize() == 0)
endfunction

function CurrentLetter()
    if mode() == 'i'
        return '|'
    endif
    let l:out = strcharpart(getline('.'), virtcol('.') - 1, 1)
    if match(l:out, '\s') != -1
        return ""
    endif
    return l:out
endfunction

function StatusWordBeg()
    let l:insert = mode() == 'i'
    let l:currentletter = l:insert ? strcharpart(getline('.'), virtcol('.') - 2, 1) : CurrentLetter()
    if empty(l:currentletter)
        return ""
    endif
    if match(l:currentletter, '\k') != -1
        let l:bp = matchstr(getline('.'), '\k*\%' . virtcol('.') . 'v')
    else
        let l:bp = matchstr(getline('.'), '[^[:keyword:]]*\%' . virtcol('.') . 'v')
        let l:bp = matchstr(l:bp, '\_S*$')
    endif
    if len(l:bp) > 10
        if l:insert
            let l:bp = l:bp[ : 5] . '...' . l:bp[len(l:bp)-1]
        else
            let l:bp =  l:bp[ : 6] . '...'
        endif
    endif
    return l:bp
endfunction

function StatusWordEnd()
    let l:insert = mode() == 'i'
    let l:currentletter = l:insert ? strcharpart(getline('.'), virtcol('.') - 1, 1) : CurrentLetter()
    if empty(l:currentletter)
        return ""
    endif
    if match(l:currentletter, '\k') != -1
        let l:ep = matchstr(getline('.'), '\%' . (virtcol('.') + !l:insert) . 'v\k*')
    else
        let l:ep = matchstr(getline('.'), '\%' . (virtcol('.') + !l:insert) . 'v[^[:keyword:]]*')
        let l:ep = matchstr(l:ep, '^\_S*')
    endif
    if len(l:ep) > 10
        if l:insert
            let l:ep = l:ep[0] . '...' . l:ep[-6 : ]
        else
            let l:ep = '...' . l:ep[-7 : ]
        endif
    endif
    return l:ep
endfunction


" function StatusWord()
    " let line = getline('.')
    " let ci = col('.') - 1
    " let cc = line[ci]
    " if match(cc, '\s') != -1
        " return ""
    " endif
    " if match(cc, '\w') != -1
        " let bp = matchstr(getline('.'), '\w*\%' . (ci + 1) . 'c')
        " let ep = matchstr(getline('.'), '\%' . (ci + 2) . 'c\w*')
    " else
        " let bp = matchstr(getline('.'), '\W*\%' . (ci + 1) . 'c')
        " let ep = matchstr(getline('.'), '\%' . (ci + 2) . 'c\W*')
        " let bp = matchstr(bp, '\S*$')
        " let ep = matchstr(ep, '^\S*')
    " endif
    " if len(bp) > 8
        " let bp = bp[ : 7] . '...'
    " endif
    " if len(ep) > 8
        " let ep = '...' . ep[-7 : ]
    " endif
    " let out = ''
    " if !empty(bp)
        " if !empty(out)
            " let out = out . ' '
        " endif
        " let out = out . bp
    " endif
    " if !empty(out)
        " let out = out . ' '
    " endif
    " let out = out . cc
    " if !empty(ep)
        " if !empty(out)
            " let out = out . ' '
        " endif
        " let out = out . ep
    " endif
    " return out
" endfunction

set laststatus=2
set statusline=\ 
set statusline+=%<%f%(\ %y%)%(\ %H%M%R%)\ 

set statusline+=[
set statusline+=%#LineNr#%{GetCurRows()}
set statusline+=%#StatusLine#,
set statusline+=%#LineNr#%{GetCurCols()}
set statusline+=%#StatusLine#\/
set statusline+=%#LineNr#%{GetTotalRows()}
set statusline+=%#StatusLine#,
set statusline+=%#LineNr#%{GetTotalCols()}
set statusline+=%#StatusLine#]\ 
set statusline+=%(%#LineNr#%V%#StatusLine#\ %)

set statusline+=%#LineNr#%{BufferBytePercent()}
set statusline+=%#StatusLine#%%\ 
set statusline+=%#LineNr#%o
set statusline+=%#StatusLine#\/
set statusline+=%#LineNr#%{BufferByteSize()}
set statusline+=%#StatusLine#\ 

set statusline+=%=

set statusline+=%#StatusLine#
set statusline+=%{StatusWordBeg()}
set statusline+=%#LineNr#
set statusline+=%{CurrentLetter()}
set statusline+=%#StatusLine#
set statusline+=%{StatusWordEnd()}\ 

set statusline+=%#StatusLineNC#\ 

set statusline+=%#StatusLine#\ 
set statusline+=%{ShowBuffer()}\ 


set ignorecase
set smartcase

if has('reltime')
    set incsearch
endif

set belloff=all

set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set display=truncate

set scrolloff=5


" Only do this part when compiled with support for autocommands
if has("autocmd")
    augroup fedora
    autocmd!
    " In text files, always limit the width of text to 78 characters
    " autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
    " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
    autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
    " start with spec file template
    " 1724126 - do not open new file with .spec suffix with spec file template
    " apparently there are other file types with .spec suffix, so disable the
    " template
    " autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
    augroup END
endif

let c_comment_strings = 1
set hlsearch

if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
	        \ | wincmd p | diffthis
endif


" tabs

" set textwidth=100
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set autoindent
set smartindent

set backspace=indent,eol,start

set timeoutlen=1

nnoremap o o<Esc>a
nnoremap O O<Esc>a

" make Y consistent with C and D.
nnoremap Y y$


" make n always search forward and N backward
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" make ; always "find" forward and , backward
nnoremap <expr> ; getcharsearch().forward ? ';' : ','
nnoremap <expr> , getcharsearch().forward ? ',' : ';'
" move to the edge of a paragraph.

function! s:Move(isUp, isInVisual)
    if a:isInVisual
        normal! gv
    end
    let curpos = getcurpos()
    let firstline='\(^\s*\n\)\zs\s*\S\+'
    let lastline ='\s*\S\+\ze\n\s*$'
    let flags = 'Wn'. (a:isUp ? 'b' : '')
    " Move to first or last line of paragraph, or to the beginning/end of file
    let pat = '\('.firstline.'\|'.lastline.'\)\|\%^\|\%$'
    " make sure cursor moves and search does not get stuck on current line
    call cursor(line('.'), a:isUp ? 1 : col('$'))
    let target=search(pat, flags)
    if target > 0
        let curpos[1]=target
        let curpos[2]=curpos[4]
    end
    call setpos('.',curpos)
endfu


au BufEnter,BufReadPost * let @/=""
au FocusGained * redraw!


nnoremap d "_d
nnoremap x "_x
nnoremap D "_D
nnoremap X "_X
vnoremap d "_d
" x in Visual Mode will still put it in the register

vnoremap u ugv
vnoremap U Ugv
vnoremap ~ ~gv
vnoremap y ygv
vnoremap p pgv
vnoremap P Pgv
vnoremap > >gv
vnoremap < <gv
vnoremap J Jgv

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" K J for moving to paragraph edge
nnoremap <silent> J :<c-u>call <sid>Move(0, 0)<cr>
nnoremap <silent> K :<c-u>call <sid>Move(1, 0)<cr>
vnoremap <silent> J :<c-u>call <sid>Move(0, 1)<cr>
vnoremap <silent> K :<c-u>call <sid>Move(1, 1)<cr>
onoremap J V:call <sid>Move(0, 0)<cr>
onoremap K V:call <sid>Move(1, 0)<cr>
" make L and H move the cursor MORE.
nnoremap L g_
nnoremap H ^

" make <c-j>, <c-k>, <c-l>, and <c-h> scroll the screen.
nnoremap <c-j> <c-e>
nnoremap <c-k> <c-y>
nnoremap <c-l> zl
nnoremap <c-h> zh

" make <M-j>, <M-k>, <M-l>, and <M-h> move to window.
nnoremap <M-j> <c-w>j
nnoremap <M-k> <c-w>k
nnoremap <M-l> <c-w>l
nnoremap <M-h> <c-w>h

" make <M-J>, <M-K>, <M-L>, and <M-H> create windows.
nnoremap <M-J> <c-w>s<c-w>k
nnoremap <M-K> <c-w>s
nnoremap <M-H> <c-w>v
nnoremap <M-L> <c-w>v<c-w>h

" easy cursor navigation without leaving insert mode

nnoremap <silent> <c-_> :set hlsearch!<cr>

onoremap ge :execute "normal! " . v:count1 . "ge<space>"<cr>

nnoremap & :&&<cr>
xnoremap & :&&<cr>

noremap [H <Home>
noremap [5~ <PageUp>
noremap [6~ <PageDown>
noremap [F <End>
noremap [A <Up>
noremap [B <Down>
noremap [C <Right>
noremap [D <Left>

noremap! [H <Home>
noremap! [5~ <PageUp>
noremap! [6~ <PageDown>
noremap! [F <End>
noremap! [A <Up>
noremap! [B <Down>
noremap! [C <Right>
noremap! [D <Left>

inoremap <M-h> <Left>
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-l> <Right>

function MetaInsert()
    for l:i in [13] + range(33, 127)
        if empty(mapcheck('<M-char-' . l:i . '>', 'i'))
            execute 'inoremap <M-char-' . l:i . '> <C-o><char-' . l:i . '>'
        endif
        if empty(mapcheck('<M-char-' . l:i . '>', 'n'))
            execute 'noremap <M-char-' . l:i . '> <char-' . l:i . '>'
        endif
    endfor
endfunction

inoremap <M-char-60> <C-o><char-60>
inoremap <M-char-62> <C-o><char-62>

call MetaInsert()
