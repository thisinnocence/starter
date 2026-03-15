-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local api = vim.api

local function rgb(color)
  local r = math.floor(color / 0x10000)
  local g = math.floor((color / 0x100) % 0x100)
  local b = color % 0x100

  return r, g, b
end

local function blend(fg, bg, alpha)
  local fr, fg_g, fb = rgb(fg)
  local br, bg_g, bb = rgb(bg)
  local r = math.floor(fr * alpha + br * (1 - alpha) + 0.5)
  local g = math.floor(fg_g * alpha + bg_g * (1 - alpha) + 0.5)
  local b = math.floor(fb * alpha + bb * (1 - alpha) + 0.5)

  return string.format("#%02x%02x%02x", r, g, b)
end

local function set_virtcolumn_highlight()
  local nontext = api.nvim_get_hl(0, { name = "NonText", link = false })
  local normal = api.nvim_get_hl(0, { name = "Normal", link = false })

  if nontext.fg and normal.bg then
    api.nvim_set_hl(0, "VirtColumn", { fg = blend(nontext.fg, normal.bg, 0.45), nocombine = true })
  elseif nontext.fg then
    api.nvim_set_hl(0, "VirtColumn", { fg = string.format("#%06x", nontext.fg), nocombine = true })
  else
    api.nvim_set_hl(0, "VirtColumn", { link = "NonText" })
  end

  api.nvim_set_hl(0, "ColorColumn", { bg = "NONE" })
end

local function set_diff_highlights()
  api.nvim_set_hl(0, "DiffAdd", { bg = "#e6ffec" })
  api.nvim_set_hl(0, "DiffChange", { bg = "#ddf4ff" })
  api.nvim_set_hl(0, "DiffDelete", { fg = "#d0d7de", bg = "#fff8f8" })
  api.nvim_set_hl(0, "DiffText", { bg = "#b6e3ff" })
end

local function has_diff_windows()
  for _, win in ipairs(api.nvim_list_wins()) do
    if api.nvim_get_option_value("diff", { scope = "local", win = win }) then
      return true
    end
  end

  return false
end

local function set_diff_colorscheme()
  if not has_diff_windows() then
    return
  end

  if vim.g.colors_name == "github_light_default" then
    vim.o.background = "light"
    vim.opt.fillchars:append({ diff = " " })
    set_diff_highlights()
    return
  end

  local ok, err = pcall(vim.cmd.colorscheme, "github_light_default")
  if not ok then
    vim.notify("failed to load github_light_default: " .. err, vim.log.levels.WARN)
    return
  end

  vim.o.background = "light"
  vim.opt.fillchars:append({ diff = " " })
  set_diff_highlights()
end

local group = api.nvim_create_augroup("user_colorcolumn", { clear = true })

api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    set_virtcolumn_highlight()

    if has_diff_windows() then
      set_diff_highlights()
    end
  end,
})

set_virtcolumn_highlight()
api.nvim_create_autocmd({ "VimEnter", "BufWinEnter", "WinEnter" }, {
  group = group,
  callback = function()
    vim.schedule(set_diff_colorscheme)
  end,
})
