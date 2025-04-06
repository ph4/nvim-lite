return {
  { 'Aliqyan-21/darkvoid.nvim' },
  {
    'zenbones-theme/zenbones.nvim',
    dependencies = 'rktjmp/lush.nvim',
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = true,
    event = 'VeryLazy',
    keys = {
      { '<Tab>', [[<cmd>BufferLineCycleNext<CR>]] },
      { '<S-Tab>', [[<cmd>BufferLineCyclePrev<CR>]] },
      { '<S-l>', [[<cmd>BufferLineCycleNext<CR>]] },
      { '<S-h>', [[<cmd>BufferLineCyclePrev<CR>]] },
      { '<]b>', [[<cmd>BufferLineCycleNext<CR>]] },
      { '<[b>', [[<cmd>BufferLineCyclePrev<CR>]] },
      { '<leader>bb', '<cmd>e #<cr>', desc = 'Switch to Other Buffer' },
      { '<leader>`', '<cmd>e #<cr>', desc = 'Switch to Other Buffer' },
    },
  },
  {
    'vladdoster/remember.nvim',
    config = true,
  },
  {
    'olimorris/persisted.nvim',
    ignored_dirs = {
      { '~', exact = true },
      '/tmp/',
      '/var/tmp',
    },
    lazy = false,
    init = function() require('which-key').add { '<leader>s', group = 'Sessions' } end,
    keys = {

      { '<leader>sl', '<cmd>SessionLoadLast<CR>', desc = 'Load last session' },
      { '<leader>ss', '<cmd>Telescope persisted<CR>', desc = 'Search saved sessions' },
      { '<leader>sc', '<cmd>SessionLoad<CR>', desc = 'Load session for cwd' },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      {
        's1n7ax/nvim-window-picker',
        version = '2.*',
        config = function()
          require('window-picker').setup {
            hint = 'floating-big-letter',
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal', 'quickfix' },
              },
            },
          }
        end,
      },
    },
    keys = {
      { '<leader>e', '<CMD>Neotree toggle<CR>', desc = 'NeoTree' },
    },
    config = {
      use_libuv_file_watcher = true,
      window = {
        width = 32,
      },
    },
  },
  {
    'rcarriga/nvim-notify',
    init = function()
      -- Hack otherwise notify complains when I open telescope
      local notify = require('notify')
      local hl = vim.api.nvim_get_hl(0, { name = 'Normal' })
      notify.setup { background_colour = string.format('#%06x', hl.bg) } ---@diagnostic disable-line: undefined-field
      vim.notify = notify
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    keys = { { '<leader><cr>', [[<Cmd>execute v:count . "ToggleTerm"<CR>]], mode = 'n', desc = 'Toggle terminal' } },
    opts = {
      shell = vim.fn.has('win32') == 1 and 'powershell' or nil,
      direction = 'horizontal',
    },
  },
}
