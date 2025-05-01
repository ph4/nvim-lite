vim.api.nvim_create_augroup('close_with_q', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'qf',
    'help',
    'man',
    'notify',
    'lspinfo',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'PlenaryTestPopup',
    'toggleterm',
  },
  callback = function(event) vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true }) end,
})

vim.api.nvim_create_augroup('close_with_esc', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'toggleterm',
  },
  callback = function(event) vim.keymap.set('n', '<esc>', '<cmd>close<cr>', { buffer = event.buf, silent = true }) end,
})

-- Set commentstring for C/C++ files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'h', 'hpp' },
  callback = function() vim.bo.commentstring = '// %s' end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true -- Ensure spaces are used for indentation
  end,
})

vim.api.nvim_create_autocmd(
  'TextYankPost',
  { callback = function() vim.highlight.on_yank { higroup = 'IncSearch', timeout = 300 } end }
)

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function() vim.o.titlestring = require('util').titlestring() end,
})

vim.api.nvim_create_autocmd('DirChanged', {
  callback = function() vim.o.titlestring = require('util').titlestring() end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'dap-view', 'dap-view-terminal' }, -- or whatever you need
  callback = function()
    vim.wo.winfixheight = false
  end,
})


---Get window or windows directry above the given window
---Does not handle if has windows left or right in the same row
---Should not matter for now
---Also does not handle having a row of columns above
---@param layout any[]
---@param winid integer
---@return integer[]?
local function get_directry_above(layout, winid)
  if layout == nil or #layout == 0 then
    return nil
  end
  if layout[1] == 'leaf' then
    return nil
  elseif layout[1] == 'col' then
    local above = nil
    for _, v in ipairs(layout[2]) do
      if v[1] == 'leaf' and v[2] == winid then
        if above ~= nil then
          if above[1] == 'leaf' then
            return { above[2] }
            elseif above[1] == 'row' then
              return vim.iter(above[2])
              :filter(function(i) return i[1] == 'leaf' end)
              :map(function(i) return i[2] end)
              :totable()
            elseif above[1] == 'col' then
              error('unreachable')
            end
        end
        return above
      end
      if v[1] == 'col' or v[1] == 'row' then
        local res = get_directry_above(v, winid)
        if res ~= nil then
          return res
        end
      end
      above = v
    end
  elseif layout[1] == 'row' then
    return get_directry_above(layout[2], winid)
  end
end

vim.api.nvim_create_autocmd('WinClosed', {
  callback = function()
    local winid = vim.fn.win_getid()
    local above = get_directry_above(vim.fn.winlayout(), winid)
    if above ~= nil then
      local heights = {}
      for _, w in ipairs(above) do
        if vim.wo[w].winfixheight then
          heights[w] = vim.api.nvim_win_get_height(w)
        end
      end
      vim.schedule(function()
        for w, h in pairs(heights) do
          vim.api.nvim_win_set_height(w, h)
        end
      end)
    end
  end,
})

