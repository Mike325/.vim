" ############################################################################
"
"                                YCM settings
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

if !exists('g:plugs["vim-session"]')
    finish
endif

" Session management
" Auto save on exit
let g:session_autosave = 'no'
" Don't ask for load last session
let g:session_autoload = 'no'

let g:session_directory = g:parent_dir.'sessions'

" Quick open session
nnoremap <leader>o :OpenSession
" Save current files in a session
nnoremap <leader>s :SaveSession
" Save the current session before close it, useful for neovim terminals
nnoremap <leader><leader>c :SaveSession<CR>:CloseSession!<CR>
" Quick save current session
nnoremap <leader><leader>s :SaveSession<CR>
" Quick delete session
nnoremap <leader><leader>d :DeleteSession<CR>

