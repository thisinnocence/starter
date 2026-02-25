local M = {}

local function native_gd()
  vim.cmd("normal! gd")
end

local function find_request_win(api, win, bufnr, tabpage)
  if api.nvim_win_is_valid(win) and api.nvim_win_get_buf(win) == bufnr then
    return win
  end

  if not api.nvim_tabpage_is_valid(tabpage) then
    return
  end

  for _, candidate in ipairs(api.nvim_tabpage_list_wins(tabpage)) do
    if api.nvim_win_is_valid(candidate) and api.nvim_win_get_buf(candidate) == bufnr then
      return candidate
    end
  end
end

local function with_request_context(api, win, bufnr, tabpage, cursor, fn)
  local target_win = find_request_win(api, win, bufnr, tabpage)

  if not target_win then
    return false
  end

  api.nvim_win_call(target_win, function()
    if api.nvim_win_get_buf(target_win) ~= bufnr then
      return
    end

    pcall(api.nvim_win_set_cursor, target_win, cursor)
    fn(target_win)
  end)

  return true
end

function M.goto_definition()
  local api = vim.api
  local lsp = vim.lsp
  local method = lsp.protocol.Methods.textDocument_definition
  local bufnr = api.nvim_get_current_buf()
  local clients = lsp.get_clients({ bufnr = bufnr, method = method })

  if vim.tbl_isempty(clients) then
    native_gd()
    return
  end

  local win = api.nvim_get_current_win()
  local tabpage = api.nvim_win_get_tabpage(win)
  local cursor = api.nvim_win_get_cursor(win)
  local from = vim.fn.getpos(".")
  from[1] = bufnr
  local tagname = vim.fn.expand("<cword>")
  local remaining = #clients
  local all_items = {}
  local finished = false

  local function finish()
    if finished then
      return
    end

    finished = true

    if vim.tbl_isempty(all_items) then
      with_request_context(api, win, bufnr, tabpage, cursor, function()
        native_gd()
      end)
      return
    end

    if #all_items == 1 then
      local item = all_items[1]
      local target_buf = item.bufnr or vim.fn.bufadd(item.filename)

      with_request_context(api, win, bufnr, tabpage, cursor, function(target_win)
        vim.cmd("normal! m'")
        vim.fn.settagstack(vim.fn.win_getid(target_win), { items = { { tagname = tagname, from = from } } }, "t")

        vim.bo[target_buf].buflisted = true
        api.nvim_win_set_buf(target_win, target_buf)
        api.nvim_win_set_cursor(target_win, { item.lnum, item.col - 1 })
        vim.cmd("normal! zv")
      end)
      return
    end

    with_request_context(api, win, bufnr, tabpage, cursor, function()
      vim.fn.setqflist({}, " ", { title = "LSP locations", items = all_items })
      vim.cmd("botright copen")
    end)
  end

  local function complete(items)
    if items then
      vim.list_extend(all_items, items)
    end

    remaining = remaining - 1

    if remaining == 0 then
      finish()
    end
  end

  for _, client in ipairs(clients) do
    local params = lsp.util.make_position_params(win, client.offset_encoding)
    local sent = client:request(method, params, function(_, result)
      local locations = {}

      if result then
        locations = vim.islist(result) and result or { result }
      end

      local items = lsp.util.locations_to_items(locations, client.offset_encoding)
      complete(items)
    end, bufnr)

    if not sent then
      complete()
    end
  end
end

return M
