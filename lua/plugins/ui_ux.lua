return {
  icons = {
    diagnostics = {
      Error = '󰅚',
      Warn = '󰀪',
      Info = '󰋽',
      Hint = '󰌶',
    },
  },
  { 'Aliqyan-21/darkvoid.nvim' },
  {
    'zenbones-theme/zenbones.nvim',
    dependencies = 'rktjmp/lush.nvim',
    lazy = false,
    priority = 1000,
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
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    keys = { { '<leader><cr>', [[<Cmd>execute v:count . "ToggleTerm"<CR>]], mode = 'n', desc = 'Toggle terminal' } },
    opts = {
      shell = vim.fn.has('win32') == 1 and 'powershell' or nil,
      direction = 'horizontal',
    },
  },
  {
    'j-hui/fidget.nvim',
    -- use init so notifications from other plugins work
    init = function(_, opts)
      local fidget = require('fidget')
      fidget.setup(opts)
    end,

    opts = {
      progress = {
        display = {
          progress_icon = {'dots_negative'},
        },
      },
      notification = {
        override_vim_notify = true,
      }
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      sign_priority = 100,
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.nav_hunk('next') end)
          return '<Ignore>'
        end, 'Next Git hunk')

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.nav_hunk('prev') end)
          return '<Ignore>'
        end, 'Previous Git hunk')

        -- Actions
        require('which-key').add {}
        local wk = require('which-key')
        local icons = {
          git = {
            stage = '',
            diff = '',
            unstage = '',
            blame = '',
            preview = '',
            reset = '󰜰',
          }
        }
        wk.add {
          {'<leader>h', group = 'Git hunks'},
          { '<leader>hs', gs.stage_hunk, desc = 'Stage Hunk', icon = icons.git.stage },
          { '<leader>hu', gs.undo_stage_hunk, desc = 'Unstage Hunk', icon = icons.git.unstage },
          { '<leader>hr', gs.reset_hunk, desc = 'Reset Hunk', icon = icons.git.reset },
          { '<leader>hp', gs.preview_hunk, desc = 'Preview Hunk', icon = icons.git.preview },
          { '<leader>hb', gs.blame_line, desc = 'Git Blame', icon = icons.git.blame },
          { '<leader>hd', gs.diffthis, desc = 'Diff This', icon = icons.git.diff },
          { '<leader>hD', function() gs.diffthis('~') end, desc = 'Diff This (cached)', icon = icons.git.diff },
          bufnr = bufnr
        }
      end,
    }
  },

  {
    'tzachar/highlight-undo.nvim',
    opts = {
      hlgroup = "HighlightUndo",
      duration = 300,
      pattern = {"*"},
      ignored_filetypes = { "neo-tree", "fugitive", "TelescopePrompt", "mason", "lazy" },
      -- ignore_cb is in comma as there is a default implementation. Setting
      -- to nil will mean no default os called.
      -- ignore_cb = nil,
    },
  }
}
