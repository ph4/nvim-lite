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

local dont_save_filetypes = { 'neo-tree', 'toggleterm' }

vim.api.nvim_create_autocmd('User', {
  pattern = 'PersistedSavePre',
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      for _, ft in ipairs(dont_save_filetypes) do
        if vim.bo[buf].filetype == ft then vim.api.nvim_buf_delete(buf, { force = true }) end
      end
    end
  end,
})

-- Set commentstring for C/C++ files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'h', 'hpp' },
  callback = function() vim.bo.commentstring = '// %s' end,
})
