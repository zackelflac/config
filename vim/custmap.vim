" Custom map
nnoremap Q <nop>
nnoremap x "_x
vnoremap x "_d
nnoremap X "_X
nnoremap , :
nnoremap ,, <nop>
inoremap ,, <esc>
inoremap jj <esc>j
inoremap kk <esc>k
inoremap JJ <esc>J
inoremap KK <esc>K
nnoremap // /\<<C-r><C-w>\><cr>
vnoremap // "sy/<C-R>"<cr>
nnoremap <leader>/ :nohlsearch<cr>
" search clipboard
nnoremap <S-Insert> q/p<cr>
" insert clipboard into command
cnoremap <S-Insert> <c-r>0

function! IsLeftMostWindow()
    let curNr = winnr()
    wincmd h
    if winnr() == curNr
        return 1
    endif
    wincmd p " Move back.
    return 0
endfunction

function IsCursorTop()
    let cursline = winline()
    let middleline = winheight(0) /2
    if cursline <= middleline
        return 1
    endif
    return 0
endfunction

function SmartSplit()
    if IsCursorTop()
        normal H
        execute ":split"
        normal <C-w>k``<C-w>j
    else
        normal L
        execute ":topleft split"
        normal <C-w>j``<C-w>k
    endif
endfunction

function FixedScroll()
    let curline   = line(".")
    let viewlines = winheight(0)
    let topviewline = line("w0")

    let pagenum = curline / viewlines
    let pagestartline = pagenum * viewlines
    if topviewline < pagestartline
        let offset = pagestartline - topviewline
        for i in range(1, offset)
            normal J
        endfor
    elseif topviewline > pagestartline
        let offset = topviewline - pagestartline
        for i in range(1, offset)
            normal K
        endfor
    endif
endfunction

command! AsyncCCL call asyncrun#quickfix_toggle(0, 0)

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-h> <S-Left>
cnoremap <C-l> <S-Right>
cnoremap <C-k> <C-w><C-w>

"noremap <leader>a :set scb<cr> " just use vimdiff or Linediff
"noremap <leader>A :set scb!<cr>
"noremap <leader>b :FufBuffer<cr>
noremap <leader>b :<c-u>Buffers<cr>
noremap <leader>c :<c-u>AsyncCCL<cr>:ccl\|lcl\|pcl<cr>
noremap <leader>C :AsyncStop<cr>
noremap <leader>d "_d
noremap <leader>e :silent<space>e<space>`pwd`<tab>
noremap <leader>ff :<c-u>Files<space>`pwd`<tab>
if executable('cquery') || executable('ccls')
    nnoremap <leader>fa :<c-u>call AutoAdjustQFWindow()<cr>
    nnoremap <leader>fd :<c-u>call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<cr>
    nnoremap <leader>fr :<c-u>call LanguageClient#textDocument_references()<cr>:call asyncrun#quickfix_toggle(0, 1)<cr>
    nnoremap <leader>fh :<c-u>call LanguageClient#textDocument_hover()<cr>
    nnoremap <leader>ft :<c-u>call LanguageClient#textDocument_signatureHelp()<cr>
    nnoremap <leader>fg :<c-u>call LanguageClient_contextMenu()<cr>
    nnoremap <leader>fc :<c-u>call LanguageClient#findLocations({'method':'$ccls/call'})<cr>
    nnoremap <leader>fC :<c-u>call LanguageClient#findLocations({'method':'$ccls/call','callee':v:true})<cr>
    nnoremap <leader>fx :<c-u>call LanguageClient#textDocument_codeAction()<cr>
else
    noremap <leader>f :botright pta <C-r><C-w><cr>
    noremap <leader>F "sy:botright pta /<C-R>"
    vnoremap <leader>f "sy:botright pta /<C-R>"<cr>
    vnoremap <leader>F "sy:botright pta /<C-R>"
endif
"Add --cpp or --type:
noremap <leader>g :AsyncRun -program=grep "<C-r><C-w>" `pwd`<tab>
vnoremap <leader>g "sy:AsyncRun -program=grep "<C-R>"" `pwd`<tab>
nnoremap <leader>G :lcd<space>`pwd`<tab><space>\|<space>Ag<left><left><left><left><left><tab>
vnoremap <leader>G "sy:lcd<space>`pwd`<tab><space>\|<space>Ag<space><C-R>"<C-f>F\|<left><C-c><tab>
noremap <leader>h :<c-u>call File_flip()<cr>zz
nnoremap <c-h> :<c-u>History<cr>
"noremap <leader>H :0r ~/.vim/.header_template<cr>
noremap <leader>j :<c-u>tj <C-r><C-w><cr>
noremap <leader>J :<c-u>tj /<C-r><C-w><C-b><right><right><right><right>
vnoremap <leader>j "sy:tj /<C-R>"<cr>
vnoremap <leader>J "sy:tj /<C-R>"
" Use surfraw to search on the web
noremap <leader>l :<c-u>let g:tagbar_left=IsLeftMostWindow()<cr>:TagbarOpen j<cr>
"noremap <leader>mk :mksession ~/mysession.vim
nnoremap <leader>m :Marks<cr>
noremap <leader>mm <esc>:SlimeSend1 cppman <C-r><C-w>
noremap <leader>o <c-w>w
noremap <leader>O <esc>:only<cr>:vsp<cr>
vnoremap <leader>p "_dP
noremap <leader>q :<c-u>q<cr>
noremap <leader>r /\<<C-r><C-w>\><cr>:%s//<C-r><C-w>/g<left><left>
vnoremap <leader>r "sy/<C-R>"<cr>:%s//<C-R>"/g<left><left>
noremap <leader>s vi
noremap <leader>s, vi,
noremap <leader>S :<c-u>SemanticHighlightToggle<cr>
nnoremap <leader>t :<c-u>vsp<cr>
nnoremap _ :<c-u>call SmartSplit()<cr>``zz
noremap <leader>u :<c-u>UndotreeToggle<cr>:UndotreeFocus<cr>
noremap <leader>v <C-v>
noremap <leader>w :<c-u>up<cr>
noremap <leader>x :<c-u>bp\|bd #<cr>
noremap <leader>X :<c-u>bp\|bd! #<cr>
noremap <leader>y "+y
nnoremap <leader>z :<c-u>call FixedScroll()<cr>
"noremap <leader>z zR
"noremap <leader>Z zM

vnoremap <leader>=, :Tab /,\zs/l1r0<cr>gv=
vnoremap <leader>== :Tab /=<cr>gv=
vnoremap <leader>=<space> :Tab /\s\zs/l1r0<cr>gv=
vnoremap <leader>=; :Tabularize /\S\+;$/l1<cr>gv=
vnoremap <leader>=( :Tabularize /\S\+($/l1<cr>gv=

noremap <leader>1 "1
noremap <leader>2 "2
noremap <leader>3 "3
noremap <leader><cr> a<cr><esc>
noremap <leader>> x<esc>wP
noremap <leader>< x<esc>bep

nnoremap <bs> <C-O>
nnoremap <leader><bs> <C-I>

" Custom hard remap
inoremap        [  []<Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

inoremap <c-f> <c-x><c-f>
inoremap <c-l> <c-x><c-l>
inoremap <c-k> <c-o>:call LanguageClient#textDocument_signatureHelp()<cr>
nnoremap <silent> <c-k> <Esc>:Man <cword><CR>
vnoremap <silent> <c-k> "sy:Man <C-R>"<CR>

" scroll remap
nnoremap <c-j> J
nnoremap K <c-y>
nnoremap J <c-e>
nnoremap <PageUp> :<c-u>call FixedScroll()<cr><c-b><c-y><c-y>M
nnoremap <PageDown> :<c-u>call FixedScroll()<cr><c-f><c-e><c-e>M
nnoremap - <PageUp>
nnoremap + <PageDown>
nmap <S-ScrollWheelUp> <PageUp>
nmap <S-ScrollWheelDown> <PageDown>

" Simulate <down> after CTRL-N
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
            \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
inoremap <expr> <tab>      pumvisible() ? "\<lt>Down>" : "\<c-r>=Smart_TabComplete()\<CR>"
inoremap <expr> <s-tab>    pumvisible() ? "\<lt>Up>" : "\<s-tab>"

function! CaptureExtOutputInNewBuffer(cmd)
    let out = system(a:cmd)
    ene
    silent put=out
    set nomodified
endfunction
command! -nargs=+ -complete=command CaptureExtOutputInNewBuffer call CaptureExtOutputInNewBuffer(<q-args>)

noremap <F1> :<c-u>!git add %<cr>
noremap <F2> :<c-u>set modifiable\|set noro\|set write<cr>

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    nnoremap <F3> :<c-u>let g:neoterm_size=winheight(0)/3 \| topleft Ttoggle<cr>
    tnoremap <F3> <C-\><C-n>: Ttoggle<cr>

    " mappings for putting
    nmap p <Plug>(extract-put)
    nmap P <Plug>(extract-Put)
    " mappings for visual
    vmap p <Plug>(extract-put)
    vmap P <Plug>(extract-Put)

    nmap <leader>p :ExtractPin<cr>

    " mappings for cycling
    nmap <leader>n <Plug>(extract-sycle)
    nmap <leader>N <Plug>(extract-Sycle)

    " mappings for insert
    imap <m-v> <Plug>(extract-completeReg)
    imap <c-v> <Plug>(extract-completeList)
endif

function! SetMan()
    let choice = confirm("Which provider?", "&Google\n&Duckduckgo\n&Cppman\n&man", 2)
    if choice == 0
        echom "none"
    elseif choice == 1
        command! -nargs=+ Man exe "silent !tmux ".g:man_tmux_command." ".man_focus." '".man_sr_command." google \"" . expand(<q-args>) . "\"'"
    elseif choice == 2
        command! -nargs=+ Man exe "silent !tmux ".g:man_tmux_command." ".man_focus."'".man_sr_command." duckduckgo \"" . expand(<q-args>) . "\"'"
    elseif choice == 3
        command! -nargs=+ Man exe man_silent."!tmux ".g:man_tmux_command." 'cppman " . expand(<q-args>) . "'"
    elseif choice == 4
        command! -nargs=+ Man exe man_silent."!tmux ".g:man_tmux_command." 'man " . expand(<q-args>) . "'"
    endif
endfunction
if has("gui_running")
    let g:man_tmux_command="new-window"
    let g:man_sr_command='sr'
    let g:man_focus="-d"
    let g:man_silent="silent"
else
    let g:man_tmux_command="split-window"
    let g:man_sr_command='sr -browser=w3m'
    let g:man_focus=""
    let g:man_silent=""
endif
command! -nargs=+ Man exe "silent !tmux ".g:man_tmux_command." ".man_focus."'".man_sr_command." duckduckgo \"" . expand(<q-args>) . "\"'"

" Need to manually call copen first so that directories are correctly set
" (issue with asyncrun?)

noremap <expr> <F4> exists('g:debug') ? ":<c-u>AsyncRun -program=make @ -j4 DEBUG=1 -C `pwd`/<tab><tab>" : ":<c-u>AsyncRun -program=make @ -j4 -C `pwd`/<tab><tab>"
nnoremap <F5> :<c-u>AsyncCCL<cr>:up<cr>:AsyncRun -program=make<Up><cr>
inoremap <F5> <esc>:<c-u>AsyncCCL<cr>:up<cr>:AsyncRun -program=make<Up><cr>

fun IsQFOrLocOrTagOpen()
    silent exec 'redir @a | ls | redir END'
    if match(@a,'\[Location List\]') >= 0
        return 2
    elseif match(@a,'\[Quickfix List\]') >= 0
        return 1
    else
        return 3
    endif
endfun

fun NextWinOrQFError()
    try
        let l:res = IsQFOrLocOrTagOpen()
        if l:res == 1
            :cn
            :foldopen
            return 0
        elseif l:res == 2
            :ln
        elseif l:res == 3
            ":ptn
        endif
        return 0
    catch /.*/
        echohl WarningMsg | echon v:exception | echohl None
    endtry
endfun

fun PrevWinOrQFError()
    try
        let l:res = IsQFOrLocOrTagOpen()
        if l:res == 1
            :cp
            :foldopen
            return 0
        elseif l:res == 2
            :lp
        elseif l:res == 3
            ":ptp
        endif
        return 0
    catch /.*/
        echohl WarningMsg | echon v:exception | echohl None
    endtry
endfun

fun CurrWinOrQFError()
    try
        let l:res = IsQFOrLocOrTagOpen()
        if l:res == 1
            if exists('g:jumpfirst')
                :cfirst
                :cn
                if g:asyncrun_status != 'running'
                    unlet g:jumpfirst
                endif
            else
                :cc
            endif
            :cp
            return 0
        elseif l:res == 2
            :ll
        elseif l:res == 3
            ":ptr
        endif
        :foldopen
        return 0
    catch /.*/
        echohl WarningMsg | echon v:exception | echohl None
    endtry
endfun

noremap <expr> <F6> bufwinnr('!gdb') != -1 ? ":<c-u>Finish<cr>" : ":<c-u>call PrevWinOrQFError()<cr>"
noremap <expr> <F7> bufwinnr('!gdb') != -1 ? ":<c-u>Over<cr>"   : ":<c-u>call NextWinOrQFError()<cr>"
noremap <expr> <F8> bufwinnr('!gdb') != -1 ? ":<c-u>Step<cr>"   : ":<c-u>call CurrWinOrQFError()<cr>"

function SetDebug()
    let choice = confirm("Debug mode", "&Yes\n&No", 2)
    if choice == 0
    elseif choice == 1
        let g:debug=1
    elseif choice == 2
        let g:debug=1
        unlet g:debug
    endif
endfunction

noremap <expr> <F9> "<esc>:<c-u>call SetDebug()<cr>"

function ToggleSpell()
    if &spell
        set nospell
    else
        set spell
    endif
endfunction

noremap <F10> :<c-u>call ToggleSpell()<cr>
inoremap <F10> <Esc>:call ToggleSpell()<cr>
noremap <F11> :<c-u>call SetMan()<cr>

function Smart_TabComplete()
    let line = getline('.')                         " current line

    let substr = strpart(line, -1, col('.'))      " from the start of the current
    " line to one character right
    " of the cursor
    let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
    if (strlen(substr)==0)                          " nothing to match on empty string
        return "\<tab>"
    endif
    let has_period = match(substr, '\.') != -1      " position of period, if any
    let has_slash = match(substr, '\/') != -1       " position of slash, if any
    let has_colon = match(substr, '::') != -1     " position of ::, if any
    "if (!has_period && !has_slash && !has_colon)
    "    return "\<C-X>\<C-O>"                         " existing text matching
    if ( has_slash )
        return "\<C-X>\<C-F>"                         " file matching
    elseif &omnifunc != ""
        return "\<C-X>\<C-O>"                         " plugin matching
    else
        return "\<C-n>"
    endif
endfunction

"command! -nargs=? Gdiff diffthis |
"      \ let gdiffpath=fnamemodify(resolve(expand('%:p')),':h') |
"      \ vnew |
"      \ set buftype=nofile |
"      \ set bufhidden=wipe |
"      \ set noswapfile |
"      \ execute "cd ".gdiffpath." | r!git show ".(!"<args>"?'HEAD~0':"<args>").":./".expand('#') |
"      \ 1d_ |
"      \ let &filetype=getbufvar('#', '&filetype') |
"      \ execute 'autocmd BufWipeout <buffer> diffoff!' |
"      \ diffthis

if &diff
endif
