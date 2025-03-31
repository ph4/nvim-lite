return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'folke/which-key.nvim', -- to bind stuff
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-frecency.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
    },
    config = function()
      local tele = require('telescope')

      tele.setup {
        extensions = {
          ---@type FrecencyOpts
          frecency = {
            show_scores = true,
            show_unindexed = true,
          },
        },
      }
      tele.load_extension('fzy_native')
      tele.load_extension('frecency')

      local frecency = function ()
        tele.extensions.frecency.frecency {
            workspace = 'CWD',
        }
      end

      local builtins = require('telescope.builtin')
      local mappings = {
        { '<leader><space>', frecency, desc = 'Frecency' },
        { '<leader>/', builtins.live_grep, desc = 'Grep string' },

        { '<leader>f', group = 'Find (Telescope)' },
        { '<leader>fa', builtins.builtin, desc = 'All builtins' },
        { '<leader>ff', builtins.find_files, desc = 'Find files' },
        { '<leader>fw', builtins.grep_string, desc = 'Grep string under cursor' },
        { '<leader>fg', builtins.live_grep, desc = 'Grep string' },
        { '<leader>fh', builtins.help_tags, desc = 'Help tags' },
        { '<leader>fc', builtins.commands, desc = 'Commands' },
        { '<leader>fr', builtins.oldfiles, desc = 'Recent files' },
        { '<leader>fm', builtins.man_pages, desc = 'Man pages' },
        { '<leader>fq', builtins.quickfixhistory, desc = 'Quickfix history' },
        -- { '<leader>fp', [[<cmd>Telescope projects<CR>]], desc = 'Projects' },

        { '<leader>g', group = 'Git' },
        { '<leader>gf', builtins.git_files, desc = 'Files' },
        { '<leader>gb', builtins.git_branches, desc = 'Branches' },
        { '<leader>gc', builtins.git_commits, desc = 'Commits' },
        { '<leader>gC', builtins.git_bcommits, desc = 'Buffer commits' },
        { '<leader>gm', builtins.git_status, desc = 'Modified files' },
        { '<leader>gz', builtins.git_stash, desc = 'Stash' },

        { '<leader>bz', group = 'Buffer' },
        { '<leader>bb', builtins.buffers, desc = 'Buffers' },
        { '<leader>bw', builtins.current_buffer_fuzzy_find, desc = 'Grep string' },

        { '<leader>l', group = 'LSP' },
      }

      require('which-key').add(mappings, { mode = 'n' })
    end,
  },
}
