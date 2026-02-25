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

local group = api.nvim_create_augroup("user_colorcolumn", { clear = true })

api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = set_virtcolumn_highlight,
})

set_virtcolumn_highlight()
