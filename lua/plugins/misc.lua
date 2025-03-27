return {
  -- Sane buffer close
  {
    'mhinz/vim-sayonara',
    keys = {
      --{ '<leader>x', [[<cmd>x!<cr>]] },
      { '<leader>q', [[<cmd>Sayonara<cr>]], desc = 'Sayonara! close buffer' },
      { '<leader>Q', [[<cmd>bufdo :Sayonara<cr>]], desc = 'Sayonara! close buffer' },
      { '<leader>d', [[<cmd>Sayonara!<cr>]], desc = 'Sayonara close all' },
      { '<leader>D', [[<cmd>bufdo :Sayonara!<cr>]], desc = 'Sayonara close all' },
    },
    config = function()
      --vim.g.sayonara_filetypes = { --['qf'] = '' }
      --vim.g.sayonara_confirm_quit = 1
    end,
  },
}
