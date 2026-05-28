# VimTipper

VimTipper 是一个轻量 Vim 操作提示器，会在你编辑时显示和当前模式相关的操作提示。
它的目标不是接管 Vim，而是在你犹豫下一步按什么时给一点及时提醒。

## 功能

- 根据普通、插入、可视、操作符等待、命令行模式显示不同提示。
- 输入 `d`、`y`、`g`、`z` 等普通模式前缀后，只显示相关后续操作。
- Vim 支持 popup 时使用浮窗显示，旧版本会退回到 `echo`。
- 提供手动显示、开启、关闭和切换命令。

## 安装

把这个目录复制到 Vim 的包路径：

```text
vimfiles/pack/plugins/start/vimtipper
```

也可以用你常用的插件管理器加载这个仓库路径：

```vim
Plug 'rockets-cn/vimtippershow'
```

## 使用

插件加载后会自动启用。

命令：

```vim
:VimTipperShow
:VimTipperToggle
:VimTipperEnable
:VimTipperDisable
```

配置：

```vim
let g:vimtipper_enabled = 1
let g:vimtipper_max_hints = 7
let g:vimtipper_popup_time = 2500
let g:vimtipper_map_prefixes = 1
```

如果只想要模式提示，不想让 VimTipper 监听普通模式前缀键，可以在加载插件前设置：

```vim
let g:vimtipper_map_prefixes = 0
```

## 开发

运行测试：

```powershell
vim -Nu NONE -n -es -S tests/test_vimtipper.vim
```
