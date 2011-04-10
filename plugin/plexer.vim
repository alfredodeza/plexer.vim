" File:        plexer.vim
" Description: Edit multiple lines at the same time
" Maintainer:  Alfredo Deza <alfredodeza AT gmail.com>
" Url:         https://github.com/alfredodeza/plexer.vim
" License:     MIT
"============================================================================

if exists("g:loaded_plexer") || &cp 
  finish
endif

" Set some global vars
let g:plexer_from_line   = 0
let g:plexer_marks       = []
let g:plexer_start       = 0
let g:plexer_total_lines = line('$')


" In certain situations, it allows you to echo something without 
" having to hit Return again to do exec the command.
" It looks if the global message variable is set or set to 0 or set to 1
function! s:Echo(msg, ...)
    redraw!
    let x=&ruler | let y=&showcmd
    set noruler noshowcmd
    if (a:0 == 1)
        echo a:msg
    else
        echohl WarningMsg | echo a:msg | echohl None
    endif

    let &ruler=x | let &showcmd=y
endfunction


function! s:Relative()
    if (g:plexer_total_lines == 0)
        let g:plexer_total_lines = line('$')
    endif
    let current_line = line('.')
    let difference = current_line - g:plexer_start 
    return difference
    call s:Echo("difference is ".difference", 1)
endfunction


function! s:AppendNewLine(number)
    let _count = 0
    while _count < a:number
        call append(line('$'), '')
        let _count = _count + 1
    endwhile
endfunction


function! s:ApplyChange()
    " if this is the start of an editing wrath
    " save the line number
    let current_mode = mode()
     
    if (g:plexer_start == 0)
        let g:plexer_start = line('.')
    endif

    let relative_line = s:Relative()

    if exists("g:plexer_marks") == 0
        call s:Echo("No Plexer marks set yet", 0)
        return
    endif
    let line   = line('.')
    let column = col('.')
    let current_lines = line('$') - g:plexer_total_lines

    " Yank the line from start to end
    exe 'normal 0'
    exe 'normal y$'

    for position in g:plexer_marks
        if line > position
            let relative_pos = position + relative_line 
        else
            let relative_pos = position + relative_line + current_lines
        endif
        if relative_pos > line('$')
            let more_lines = relative_pos - line('$')
            call s:AppendNewLine(more_lines)
        endif
        exe relative_pos
        exe "normal 0"
        exe "normal D"
        exe 'normal "0P'
    endfor
    exe line
    exe "normal " . column . "|"
endfunction


function! s:AddMark()
    let g:plexer_total_lines = line('$')
    if exists("g:plexer_marks") == 0
        let g:plexer_marks = []
    endif
    let line = line('.')
    call add(g:plexer_marks, line)
    call s:Echo("Added mark for Plexer", 1)
    call s:Highlight()
endfunction


function! s:ClearMarks()
    let g:plexer_from_line = 0
    let g:plexer_marks     = []
    let g:plexer_start     = 0
    let g:plexer_total_lines = line('$')
    sign unplace *
    call s:Echo("Cleared all marks for Plexer", 1)
endfunction!


function! s:Start()
    if (&modified == 1)
        call s:ApplyChange()
    endif
    call s:Echo("Plexer mode ON", 0)
endfunction


function! s:Completion(ArgLead, CmdLine, CursorPos)
    let m_options      = "add\napply\nclear\n"
    let m_version      = "version\n"
    let m_visuals      = "show\nhide\n"
    return m_options . m_version . m_visuals
endfunction


function! s:Version()
    call s:Echo("plexer.vim version 0.0.1", 1)
endfunction


function! s:Proxy(action, ...)
    if (a:action == "add")
        call s:AddMark()
    elseif (a:action == "apply")
        call s:ApplyChange()
    elseif (a:action == "clear")
        call s:ClearMarks()
    elseif (a:action == "version")
        call s:Version()
    elseif (a:action == "show")
        call s:Highlight()
    elseif (a:action == "hide")
        sign unplace *
    endif
endfunction


function s:Highlight()
    sign define Plexer text=* linehl=Todo texthl=Error
    for position in g:plexer_marks
        execute(":sign place ". position ." line=". position ." name=Plexer file=".expand("%:p"))
    endfor
endfunction

command! -nargs=+ -complete=custom,s:Completion Plexer call s:Proxy(<f-args>)


