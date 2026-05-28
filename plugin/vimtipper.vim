if exists('g:loaded_vimtipper')
  finish
endif
let g:loaded_vimtipper = 1

command! VimTipperShow call vimtipper#Show('')
command! VimTipperToggle call vimtipper#Toggle()
command! VimTipperEnable call vimtipper#Enable()
command! VimTipperDisable call vimtipper#Disable()

augroup vimtipper
  autocmd!
  autocmd VimEnter,ModeChanged,CursorHold * call vimtipper#ClearPrefix() | call vimtipper#Show('')
  autocmd InsertEnter,CmdlineEnter * call vimtipper#ClearPrefix() | call vimtipper#Show('')
augroup END

if get(g:, 'vimtipper_map_prefixes', 1)
  nnoremap <expr> d vimtipper#RecordPrefix('d')
  nnoremap <expr> y vimtipper#RecordPrefix('y')
  nnoremap <expr> g vimtipper#RecordPrefix('g')
  nnoremap <expr> z vimtipper#RecordPrefix('z')
endif
