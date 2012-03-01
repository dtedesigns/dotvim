" PHP Code Sniffer
function! RunPhpcs()
    let l:quote_token="'"
    let l:filename=@%
    let l:phpcs_output=system('phpcs --report=csv --standard=Symfony2 '.l:filename)
    let l:phpcs_output=substitute(l:phpcs_output, '\\"', l:quote_token, 'g')
    let l:phpcs_list=split(l:phpcs_output, "\n")
    unlet l:phpcs_list[0]
    cexpr l:phpcs_list
    cwindow
    " copen
endfunction
command! Phpcs execute RunPhpcs()

set errorformat+=\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"\\,%*[a-zA-Z0-9_.-]\\,%*[0-9]

