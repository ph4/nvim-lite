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
