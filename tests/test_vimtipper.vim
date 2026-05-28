set nocompatible
set runtimepath^=.

source autoload/vimtipper.vim

function! s:assert_equal(expected, actual, message) abort
  if a:expected !=# a:actual
    call add(v:errors, a:message . ': expected ' . string(a:expected) . ', got ' . string(a:actual))
  endif
endfunction

function! s:test_normal_prefix_filters_related_hints() abort
  let l:hints = vimtipper#GetHints('n', 'd')
  call s:assert_equal(1, len(filter(copy(l:hints), { _, item -> item.key ==# 'dd' })), 'normal d should include dd')
  call s:assert_equal(1, len(filter(copy(l:hints), { _, item -> item.key ==# 'dw' })), 'normal d should include dw')
  call s:assert_equal(0, len(filter(copy(l:hints), { _, item -> item.key ==# 'yy' })), 'normal d should exclude yy')
endfunction

function! s:test_insert_mode_shows_escape_hint() abort
  let l:hints = vimtipper#GetHints('i', '')
  call s:assert_equal(1, len(filter(copy(l:hints), { _, item -> item.key ==# '<Esc>' })), 'insert mode should include escape')
endfunction

function! s:test_unknown_prefix_returns_mode_overview() abort
  let l:hints = vimtipper#GetHints('n', 'zzzz')
  call s:assert_equal(1, len(filter(copy(l:hints), { _, item -> item.key ==# 'i' })), 'unknown normal prefix should fall back to overview')
endfunction

call s:test_normal_prefix_filters_related_hints()
call s:test_insert_mode_shows_escape_hint()
call s:test_unknown_prefix_returns_mode_overview()

if !empty(v:errors)
  cquit
endif

quit
