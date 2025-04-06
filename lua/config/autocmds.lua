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

vim.api.nvim_create_autocmd('User', {
  pattern = 'PersistedSavePre',
  callback = function()
      require('neo-tree').close_all()
      local ui = require('toggleterm.ui')
      local has_open, windows = ui.find_open_windows()
      if has_open then
          ui.close_and_save_terminal_view(windows)
      end
  end,
})


-- Set commentstring for C/C++ files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'h', 'hpp' },
  callback = function() vim.bo.commentstring = '// %s' end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true  -- Ensure spaces are used for indentation
  end,
})
