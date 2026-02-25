-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local actions = require("config.actions")
local function flash_jump(opts)
  return function()
    require("flash").jump(opts)
  end
end

map("n", "<leader><cr>", "<cmd>nohlsearch<cr>", { desc = "Clear Search Highlight" })
map("n", "<C-n>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("x", "p", "pgvy", { desc = "Paste Without Overwrite Register" })
map("i", "<C-a>", "<Home>", { desc = "Line Start" })
map("i", "<C-e>", "<End>", { desc = "Line End" })
map("n", "<leader>t", function()
  vim.cmd("vsplit")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal Vertical Split" })
map("n", "<F2>", "<leader>e", { remap = true, desc = "Explorer (Root Dir)" })
map("n", "<C-p>", LazyVim.pick("files"), { desc = "Find Files (Root Dir)" })
map("n", "<leader><leader>w", flash_jump({
  search = {
    forward = true,
    wrap = false,
    multi_window = false,
    mode = function(str)
      return "\\<" .. str
    end,
  },
}), { desc = "Flash Word Forward" })
map("n", "<leader><leader>b", flash_jump({
  search = {
    forward = false,
    wrap = false,
    multi_window = false,
    mode = function(str)
      return "\\<" .. str
    end,
  },
}), { desc = "Flash Word Backward" })
map("n", "<leader><leader>j", flash_jump({
  pattern = "^",
  search = { forward = true, wrap = false, multi_window = false, mode = "search", max_length = 0 },
  label = { after = { 0, 0 } },
}), { desc = "Flash Line Down" })
map("n", "<leader><leader>k", flash_jump({
  pattern = "^",
  search = { forward = false, wrap = false, multi_window = false, mode = "search", max_length = 0 },
  label = { after = { 0, 0 } },
}), { desc = "Flash Line Up" })
map({ "n", "x", "o" }, "<leader><leader>s", function()
  require("flash").jump()
end, { desc = "Flash Jump" })
map({ "n", "x", "o" }, "<leader><leader>S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })
map("n", "gd", actions.goto_definition, { desc = "Goto Definition" })

map("n", "<leader>ff", function()
  Snacks.picker.treesitter({
    filter = {
      default = { "Function", "Method" },
    },
  })
end, { desc = "Function List" })

map("n", "<leader>ft", function()
  Snacks.picker.tags()
end, { desc = "Tags" })

map("n", "<leader>fm", function()
  Snacks.picker.recent()
end, { desc = "Recent Files" })

map("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Git Blame" })

map("n", "<F5>", function()
  if vim.fn.isdirectory("build") == 1 then
    vim.cmd("botright vsplit")
    vim.cmd("terminal make -C build -j")
    vim.cmd("startinsert")
  else
    vim.notify("build directory not found", vim.log.levels.WARN)
  end
end, { desc = "Build in ./build" })

map("n", "[g", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
map("n", "]g", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
map("n", "<F8>", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
