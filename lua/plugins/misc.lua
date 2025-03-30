return {
  -- Sane buffer close
  {
    'mhinz/vim-sayonara',
    keys = {
      --{ '<leader>x', [[<cmd>x!<cr>]] },
      { '<leader>q', [[<cmd>Sayonara<cr>]], desc = 'Close buffer & window' },
      { '<leader>Q', [[<cmd>bufdo :Sayonara<cr>]], desc = 'Close all buffers and windows' },
      { '<leader>d', [[<cmd>Sayonara!<cr>]], desc = 'Close buffer' },
      { '<leader>D', [[<cmd>bufdo :Sayonara!<cr>]], desc = 'Close all buffers' },
    },
    config = function()
      --vim.g.sayonara_filetypes = { --['qf'] = '' }
      --vim.g.sayonara_confirm_quit = 1
    end,
  },
}
