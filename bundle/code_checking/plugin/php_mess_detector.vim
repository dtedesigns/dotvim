"/home/kgustavson/workspace/symfony2/src/celltrak/2_0/AppBundle/Controller/ActivityController.php:371	Avoid excessively long variable names like $exportPreventedAlertIds
"/home/kgustavson/workspace/symfony2/src/celltrak/2_0/AppBundle/Controller/ActivityController.php:377	Avoid excessively long variable names like $lockedPendingAlertCount

" PHP Mess Detector
function! RunPhpmd()
    let l:quote_token="'"
    let l:filename=@%
    let l:phpcs_output=system('phpmd '.l:filename.' text codesize,design,naming,unusedcode')
    let l:phpcs_output=substitute(l:phpcs_output, '\\"', l:quote_token, 'g')
    let l:phpcs_list=split(l:phpcs_output, "\n")
    "unlet l:phpcs_list[0]
    cexpr l:phpcs_list
    cwindow
endfunction
command! Phpmd execute RunPhpmd()

"set errorformat+=\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"\\,%*[a-zA-Z0-9_.-]\\,%*[0-9]
set errorformat+=%f\\:%l\\\\t%m

