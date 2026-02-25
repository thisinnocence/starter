# Neovim 配置

基于 [LazyVim](https://www.lazyvim.org/) 的个人 Neovim 配置。

目标：尽量保留原有 Vim 编辑习惯，同时使用 LazyVim
提供的插件管理、LSP、诊断、会话和查找工作流。

## 概览

| 项目 | 说明 |
| --- | --- |
| 基线 | [LazyVim starter](https://github.com/LazyVim/starter) |
| 来源 | 从 [旧 Vim 配置](https://github.com/thisinnocence/vim) 迁移整理 |
| 风格 | 少量覆盖，尽量沿用 LazyVim 默认结构 |

## 安装

| 步骤 | 说明 |
| --- | --- |
| 放置目录 | 仓库路径为 `~/.config/nvim` |
| 首次启动 | `lazy.nvim` 会自动 bootstrap |
| 同步插件 | `:Lazy sync` |
| 查看状态 | `:Lazy` |

## 依赖与约定

| 项目 | 说明 |
| --- | --- |
| 依赖 | 建议安装 `git`、`rg`、`fd` |
| 缩进 | 默认 4 空格；`html/xhtml` 用 2 空格；`make` 保留 Tab |
| 行号 | 默认绝对行号 |
| 编码 | 保留中文编码回退 |
| tags | 使用 `./tags;,tags` |
| CPP 支持 | `clangd` 需自己安装，不交给 Mason 自动安装 |
| Rust 支持 | 已导入 LazyVim Rust extra |
| Rust 工具 | 自备 `rustup`、`cargo`、`rustc`、`rust-analyzer` |
| Rust 调试 | `codelldb` 由 Mason 安装 |
| Markdown | 保持原始文本视图，关闭 conceal |

## 对 LazyVim 的定制修改

| 配置项 | 说明 |
| --- | --- |
| `<leader>` 键 | 配置为 `,` |
| 文件查找 | 新增 `<C-p>`，等价于 `,<Space>` 的项目根目录找文件 |
| 函数与 tags | `,ff` 打开函数列表；`,ft` 打开 tags |
| 定义跳转 | `gd` 优先走 LSP；无结果时回退原生 `gd` |
| Flash | 恢复 `s` `S` `r` `R` 原生含义；Flash 改用 `,,*` (wbjk) |
| Git | `,gb` 直接执行 `:Git blame`；`,gD` 已禁用 |
| Explorer 目录 | `o` 在 Neovim 内打开；`<C-p>` 会同步标签页 cwd |
| Markdown 渲染 | 不启用内联渲染插件；缓冲区 `conceallevel=0` |

## 常用键位

### 文件与列表

| 键位 | 作用 | 来源 |
| --- | --- | --- |
| `<C-p>` | 从项目根目录查找文件 | 个人定制 |
| `,<Space>` | 从项目根目录查找文件 | LazyVim |
| `<F2>` | 打开文件树 | 个人定制 |
| `,e` | 打开文件树 | LazyVim |
| `<C-n>` | 下一个缓冲区 | 个人定制 |
| `,fb` | 缓冲区列表 | LazyVim |
| `,fr` | 最近文件 | LazyVim |
| `,fm` | 最近文件 | 个人定制 |
| `,fc` | 打开配置目录文件 | LazyVim |

### 搜索与符号

| 键位 | 作用 | 来源 |
| --- | --- | --- |
| `,/` / `,sg` | 全局搜索 | LazyVim |
| `,s`  | 搜索分组前缀，无独立动作 | LazyVim |
| `,sw` | 搜索当前词，项目根目录 | LazyVim |
| `,sW` | 搜索当前词，当前工作目录 | LazyVim |
| `,ss` | 当前缓冲区 LSP Symbols | LazyVim |
| `,sS` | LSP 工作区符号 | LazyVim |
| `,sk` | 查看键位 | LazyVim |
| `,sh` | 帮助页 | LazyVim |
| `,ff` | 函数列表 | 个人定制 |
| `,ft` | tags 列表，依赖项目 `tags` 文件 | 个人定制 |

### 跳转与诊断

| 键位 | 作用 | 备注 | 来源 |
| --- | --- | --- | --- |
| `gd` | 跳到定义 | 旧 Vim 只走原生 `gd`；这里改成先试 LSP，失败再回退 | 个人定制 |
| `[[` / `]]` | 上一处 / 下一处引用 | 旧 Vim 相邻函数跳转；现当前文件当前符号的引用跳转 | LazyVim |
| `[f` / `]f` | 上一函数 / 下一函数开头 | 这里用它来承接旧 Vim 的函数跳转习惯 | LazyVim |
| `[F` / `]F` | 上一函数 / 下一函数结尾 | 这里用它来承接旧 Vim 的函数跳转习惯 | LazyVim |
| `[g` / `]g` | 上一条 / 下一条诊断 | 旧 Vim 无诊断跳转 | 个人定制 |
| `<F8>` | 下一条诊断 | 在诊断跳转上额外补了一枚单键 | 个人定制 |
| `,cd` | 当前行诊断浮窗 | 旧 Vim 无对应 | LazyVim |
| `,xx` / `,xX` | Trouble 诊断面板 | 旧 Vim 无对应；这里改成用列表看诊断 | LazyVim |

### Git

| 键位 | 作用 | 来源 |
| --- | --- | --- |
| `,g` | LazyVim 默认 Git 前缀 | LazyVim |
| `,gb` | 当前文件 `git blame` | 个人定制 |
| `,gg` | `lazygit`，项目根目录 | LazyVim |
| `,gL` | 当前工作目录 `git log` | LazyVim |
| `,gf` | 当前文件历史 | LazyVim |
| `,gl` | Git 根目录日志 | LazyVim |

### 窗口、终端与会话

| 键位 | 作用 | 来源 |
| --- | --- | --- |
| `<C-h/j/k/l>` | 窗口切换 | LazyVim |
| `,t` | 定制的竖向分屏终端 | 个人定制 |
| `,-` / `,|` | 横向 / 竖向分屏 | LazyVim |
| `,bd` | 删除当前缓冲区 | LazyVim |
| `,wd` | 关闭当前窗口 | LazyVim |
| `<C-\><C-n>` | 退出终端插入模式 | Vim 原生 |
| `,q` | LazyVim 默认的退出与会话前缀 | LazyVim |

### 构建与开关

| 键位 | 作用 | 来源 |
| --- | --- | --- |
| `,uf` / `,uF` | 自动格式开关 | LazyVim |
| `,ud` | 诊断开关 | LazyVim |
| `,uw` | 换行开关 | LazyVim |
| `,ul` / `,uL` | 行号 / 相对行号开关 | LazyVim |
| `,:` | 命令历史 | LazyVim |
| `<F5>` | 定制的在 `./build` 目录执行 `make -j` | 个人定制 |

## 目录说明

| 路径 | 作用 |
| --- | --- |
| `init.lua` | 入口，设置 leader 并加载 LazyVim |
| `lua/config/options.lua` | 全局选项 |
| `lua/config/keymaps.lua` | 自定义键位 |
| `lua/config/actions.lua` | 自定义动作，如 `gd` |
| `lua/plugins/legacy.lua` | 对 LazyVim 默认插件的覆盖 |
| `ftplugin/` | 文件类型局部设置 |
