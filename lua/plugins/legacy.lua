return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>,", false },
      { "<leader>gD", false },
    },
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = opts.picker.sources.explorer or {}
      opts.picker.sources.explorer.win = opts.picker.sources.explorer.win or {}
      opts.picker.sources.explorer.win.input = opts.picker.sources.explorer.win.input or {}
      opts.picker.sources.explorer.win.input.keys = opts.picker.sources.explorer.win.input.keys or {}
      opts.picker.sources.explorer.win.list = opts.picker.sources.explorer.win.list or {}
      opts.picker.sources.explorer.win.list.keys = opts.picker.sources.explorer.win.list.keys or {}

      opts.picker.sources.explorer.win.input.keys["<c-p>"] = { { "tcd", "picker_files" }, mode = { "n", "i" } }
      opts.picker.sources.explorer.win.list.keys["<c-p>"] = { "tcd", "picker_files" }
      opts.picker.sources.explorer.win.list.keys["o"] = "confirm"
    end,
  },
  {
    "xiyaowong/virtcolumn.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.virtcolumn_char = "▕"
      vim.g.virtcolumn_priority = 10
    end,
  },
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
      { "r", mode = "o", false },
      { "R", mode = { "o", "x" }, false },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    optional = true,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local actions = require("config.actions")

      opts.servers = opts.servers or {}
      opts.servers.clangd = vim.tbl_deep_extend("force", opts.servers.clangd or {}, {
        mason = false,
        cmd = { "clangd" },
      })

      local server = opts.servers["*"] or {}
      local keys = server.keys or {}
      local replaced = {
        gd = false,
      }

      for i, key in ipairs(keys) do
        if key[1] == "gd" then
          key = vim.deepcopy(key)
          key[2] = actions.goto_definition
          key.desc = "Goto Definition"
          key.has = "definition"
          keys[i] = key
          replaced.gd = true
        end
      end

      if not replaced.gd then
        table.insert(keys, { "gd", actions.goto_definition, desc = "Goto Definition", has = "definition" })
      end

      server.keys = keys
      opts.servers["*"] = server
    end,
  },
}
