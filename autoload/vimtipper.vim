if exists('g:loaded_vimtipper_autoload')
  finish
endif
let g:loaded_vimtipper_autoload = 1

let s:enabled = get(g:, 'vimtipper_enabled', 1)
let s:last_prefix = ''
let s:last_popup = -1

let s:hints = {
      \ 'n': [
      \   {'key': 'i', 'label': '在光标前进入插入模式'},
      \   {'key': 'a', 'label': '在光标后进入插入模式'},
      \   {'key': 'dd', 'label': '删除当前行'},
      \   {'key': 'dw', 'label': '删除一个单词'},
      \   {'key': 'yy', 'label': '复制当前行'},
      \   {'key': 'p', 'label': '在光标后粘贴'},
      \   {'key': 'u', 'label': '撤销'},
      \   {'key': '<C-r>', 'label': '重做'},
      \   {'key': '/ ', 'label': '向前搜索'},
      \   {'key': ':w', 'label': '保存文件'},
      \   {'key': ':q', 'label': '退出窗口'},
      \   {'key': 'gg', 'label': '跳到第一行'},
      \   {'key': 'G', 'label': '跳到最后一行'},
      \ ],
      \ 'i': [
      \   {'key': '<Esc>', 'label': '返回普通模式'},
      \   {'key': '<C-n>', 'label': '下一个补全项'},
      \   {'key': '<C-p>', 'label': '上一个补全项'},
      \   {'key': '<C-o>', 'label': '临时执行一个普通模式命令'},
      \ ],
      \ 'v': [
      \   {'key': 'y', 'label': '复制选区'},
      \   {'key': 'd', 'label': '删除选区'},
      \   {'key': '>', 'label': '增加缩进'},
      \   {'key': '<', 'label': '减少缩进'},
      \   {'key': 'gc', 'label': '切换注释，需要 commentary 等插件'},
      \ ],
      \ 'o': [
      \   {'key': 'w', 'label': '直到下一个单词开头'},
      \   {'key': 'e', 'label': '直到单词结尾'},
      \   {'key': '$', 'label': '直到行尾'},
      \   {'key': '}', 'label': '直到下一段'},
      \ ],
      \ 'c': [
      \   {'key': '<Tab>', 'label': '补全命令或路径'},
      \   {'key': '<C-f>', 'label': '打开命令行窗口'},
      \   {'key': '<C-r>"', 'label': '插入默认寄存器内容'},
      \ ],
      \ }

function! s:ModeKey(mode) abort
  if a:mode =~# '^[vV]'
    return 'v'
  endif
  if a:mode =~# '^i'
    return 'i'
  endif
  if a:mode =~# '^o'
    return 'o'
  endif
  if a:mode =~# '^c'
    return 'c'
  endif
  return 'n'
endfunction

function! vimtipper#GetHints(mode, prefix) abort
  let l:mode = s:ModeKey(a:mode)
  let l:all = get(s:hints, l:mode, s:hints.n)
  let l:prefix = a:prefix

  if empty(l:prefix)
    return l:all[:min([len(l:all), get(g:, 'vimtipper_max_hints', 7)]) - 1]
  endif

  let l:matched = filter(copy(l:all), { _, item -> stridx(item.key, l:prefix) == 0 })
  if empty(l:matched)
    return vimtipper#GetHints(l:mode, '')
  endif
  return l:matched
endfunction

function! vimtipper#RecordPrefix(prefix) abort
  let s:last_prefix = a:prefix
  call vimtipper#Show()
  return a:prefix
endfunction

function! vimtipper#ClearPrefix() abort
  let s:last_prefix = ''
endfunction

function! vimtipper#Enable() abort
  let s:enabled = 1
  let g:vimtipper_enabled = 1
  call vimtipper#Show()
endfunction

function! vimtipper#Disable() abort
  let s:enabled = 0
  let g:vimtipper_enabled = 0
  call s:ClosePopup()
endfunction

function! vimtipper#Toggle() abort
  if s:enabled
    call vimtipper#Disable()
    echo 'VimTipper disabled'
  else
    call vimtipper#Enable()
    echo 'VimTipper enabled'
  endif
endfunction

function! s:ClosePopup() abort
  if exists('*popup_close') && s:last_popup > 0
    silent! call popup_close(s:last_popup)
  endif
  let s:last_popup = -1
endfunction

function! s:Format(hints) abort
  return map(copy(a:hints), { _, item -> printf('%-7s %s', item.key, item.label) })
endfunction

function! vimtipper#Show(...) abort
  if !s:enabled
    return
  endif

  let l:prefix = a:0 ? a:1 : s:last_prefix
  let l:hints = vimtipper#GetHints(mode(), l:prefix)
  let l:lines = s:Format(l:hints)

  if exists('*popup_create')
    call s:ClosePopup()
    let s:last_popup = popup_create(l:lines, {
          \ 'line': 'cursor+1',
          \ 'col': 'cursor',
          \ 'moved': 'word',
          \ 'time': get(g:, 'vimtipper_popup_time', 2500),
          \ 'padding': [0, 1, 0, 1],
          \ 'border': [],
          \ 'highlight': 'Pmenu',
          \ })
  else
    echo join(l:lines, ' | ')
  endif
endfunction
