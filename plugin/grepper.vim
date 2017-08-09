" ############################################################################
"
"                                Grepper settings
"
"                                     -`
"                     ...            .o+`
"                  .+++s+   .h`.    `ooo/
"                 `+++%++  .h+++   `+oooo:
"                 +++o+++ .hhs++. `+oooooo:
"                 +s%%so%.hohhoo'  'oooooo+:
"                 `+ooohs+h+sh++`/:  ++oooo+:
"                  hh+o+hoso+h+`/++++.+++++++:
"                   `+h+++h.+ `/++++++++++++++:
"                            `/+++ooooooooooooo/`
"                           ./ooosssso++osssssso+`
"                          .oossssso-````/osssss::`
"                         -osssssso.      :ssss``to.
"                        :osssssss/  Mike  osssl   +
"                       /ossssssss/   8a   +sssslb
"                     `/ossssso+/:-        -:/+ossss'.-
"                    `+sso+:-`                 `.-/+oso:
"                   `++:.  github.com/mike325/.vim  `-/+/
"                   .`                                 `/
"
" ############################################################################

if !exists('g:plugs["vim-grepper"]')
    finish
endif

let g:grepper       = {}    " initialize g:grepper with empty dictionary
let g:grepper.jump  = 0
let g:grepper.open  = 1
let g:grepper.tools = ['git', 'ag', 'ack', 'grep', 'findstr']
let g:grepper.dir   = 'repo,cwd'

" let g:grepper.highlight = 1
" let g:grepper.rg.grepprg .= ' --smart-case'

" I like to keep Ag and grep as a ignore case searchers (smart case for Ag)
" and git as a case sensitive project searcher
let g:grepper.ag = {
    \ 'grepprg':    'ag -S -U --hidden --ignore .ropeproject --ignore .git --ignore .svn --ignore .hg --vimgrep',
    \ 'grepformat': '%f:%l:%c:%m,%f:%l:%m',
    \ 'escape':     '\^$.*+?()[]{}|',
    \ }

let g:grepper.grep = {
    \ 'grepprg':    'grep --exclude-dir .svn --exclude-dir .git --exclude-dir .ropeproject -RIni $*',
    \ 'grepprgbuf': 'grep -HIn -- $* $.',
    \ 'grepformat': '%f:%l:%m',
    \ 'escape':     '\^$.*[]',
    \ }

let g:grepper.git = {
    \ 'grepprg':    'git grep -nI',
    \ 'grepformat': '%f:%l:%m',
    \ 'escape':     '\^$.*[]',
    \ }

let g:grepper.findstr = {
    \ 'grepprg': 'findstr -rspnc:$* *',
    \ 'grepprgbuf': 'findstr -rpnc:$* $.',
    \ 'grepformat': '%f:%l:%m',
    \ 'wordanchors': ['\<', '\>'],
    \ }

" You can use <TAB> to change the current grep tool
nnoremap <C-g> :Grepper<CR>

command! Todo :Grepper -query '\(TODO\|FIXME\)'

" Motions for grepper command
nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)
