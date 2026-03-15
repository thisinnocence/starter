-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.g.autoformat = false

local opt = vim.opt

-- Keep 4-space indentation as default
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Keep absolute line numbers by default
opt.relativenumber = false
opt.colorcolumn = "100"

-- Keep ctags lookup compatible with legacy project layout
opt.tags = "./tags;,tags"

-- Prefer Chinese encodings fallback when opening legacy files
opt.fileencodings = { "utf-8", "gb2312", "gb18030", "gbk", "ucs-bom", "cp936", "latin1" }
opt.fileformats = { "unix", "dos", "mac" }

opt.wildignore:append({
  "*.o",
  "*~",
  "*.pyc",
  "*.out",
  "*/.git/*",
  "*/.hg/*",
  "*/.svn/*",
  "*/.DS_Store",
})
