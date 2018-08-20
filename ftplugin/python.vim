" ############################################################################
"
"                               python Setttings
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


if exists('+formatprg')
    if executable('yapf')
        setlocal formatprg=yapf\ --style\ pep8
    elseif executable('autopep8')
        setlocal formatprg=autopep8\ --experimental\ --aggressive\ --max-line-length\ 120
    endif
endif

if executable('flake8')
    setlocal makeprg=flake8\ --max-line-length=120\ --ignore=E121,E123,E126,E226,E24,E704,W503,W504,H233,E228,E701,E226,E251,E501,E221,E203\ %
    let &efm='%f:%l:%c: %t%n %m'
elseif executable('pycodestyle')
    setlocal makeprg=pycodestyle\ --max-line-length=120\ --ignore=E121,E123,E126,E226,E24,E704,W503,W504,H233,E228,E701,E226,E251,E501,E221,E203\ %
    let &efm='%f:%l:%c: %t%n %m'
else
    setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
endif

function! s:PythonFix()
    silent! execute '%s/==\(\s\+\)\(None\|True\|False\)/is\1\2/g'
    call histdel('search', -1)
    silent! execute '%s/!=\(\s\+\)\(None\|True\|False\)/is not\1\2/g'
    call histdel('search', -1)
    silent! execute '%s/\(if\s\+\)\(not\s\+\)\{0,1}\(.*\)\.has_key(\(.*\))/\1\4 \2in \3'
    call histdel('search', -1)
    silent! execute '%s/\s\+$//e'
    call histdel('search', -1)
    silent! execute '%s/^\(\s\+\)\?#\([^ #!]\)/\1# \2/e'
    call histdel('search', -1)
    silent! execute '%s/\(except\):/\1 Exception:/e'
    call histdel('search', -1)
endfunction

command! -buffer PythonFix call s:PythonFix()
