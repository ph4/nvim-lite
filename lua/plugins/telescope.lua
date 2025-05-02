return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
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
        defaults = {
          borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
        },
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

      --set highlights
      vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { link = 'TelescopeSelection' })
      vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { link = 'TelescopeSelection' })
      vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { link = 'DiagnosticVirtualTextOk' })
      vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { link = 'DiagnosticVirtualTextError' })
      vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { link = 'DiagnosticVirtualTextWarn' })

      local frecency = function()
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
        { '<leader>fF', builtins.find_files, desc = 'Find files' },
        { '<leader>fw', builtins.grep_string, desc = 'Grep string under cursor' },
        { '<leader>fg', builtins.live_grep, desc = 'Grep string' },
        { '<leader>fh', builtins.help_tags, desc = 'Help tags' },
        { '<leader>fc', builtins.commands, desc = 'Commands' },
        { '<leader>fr', builtins.oldfiles, desc = 'Recent files' },
        { '<leader>fm', builtins.man_pages, desc = 'Man pages' },
        { '<leader>fq', builtins.quickfixhistory, desc = 'Quickfix history' },

        { '<leader>fb', builtins.buffers, desc = 'Buffers' },
        { '<leader>ff', builtins.current_buffer_fuzzy_find, desc = 'Grep string' },
        -- { '<leader>fp', [[<cmd>Telescope projects<CR>]], desc = 'Projects' },

        { '<leader>g', group = 'Git' },
        { '<leader>gf', builtins.git_files, desc = 'Files' },
        { '<leader>gb', builtins.git_branches, desc = 'Branches' },
        { '<leader>gc', builtins.git_commits, desc = 'Commits' },
        { '<leader>gC', builtins.git_bcommits, desc = 'Buffer commits' },
        { '<leader>gm', builtins.git_status, desc = 'Modified files' },
        { '<leader>gz', builtins.git_stash, desc = 'Stash' },
      }

      require('which-key').add(mappings, { mode = 'n' })

      -- From https://github.com/nvim-telescope/telescope.nvim/issues/3020#issuecomment-2439446111
      local blend = 50
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'TelescopePrompt',
        callback = function(ctx)
          local backdropName = 'TelescopeBackdrop'
          local telescopeBufnr = ctx.buf

          -- `Telescope` does not set a zindex, so it uses the default value
          -- of `nvim_open_win`, which is 50: https://neovim.io/doc/user/api.html#nvim_open_win()
          local telescopeZindex = 50

          local backdropBufnr = vim.api.nvim_create_buf(false, true)
          local winnr = vim.api.nvim_open_win(backdropBufnr, false, {
            relative = 'editor',
            border = 'none',
            row = 0,
            col = 0,
            width = vim.o.columns,
            height = vim.o.lines,
            focusable = false,
            style = 'minimal',
            zindex = telescopeZindex - 1, -- ensure it's below the reference window
          })

          vim.api.nvim_set_hl(0, backdropName, { bg = '#000000', default = true })
          vim.wo[winnr].winhighlight = 'Normal:' .. backdropName
          vim.wo[winnr].winblend = blend
          vim.bo[backdropBufnr].buftype = 'nofile'

          -- close backdrop when the reference buffer is closed
          vim.api.nvim_create_autocmd({ 'WinClosed', 'BufLeave' }, {
            once = true,
            buffer = telescopeBufnr,
            callback = function()
              if vim.api.nvim_win_is_valid(winnr) then vim.api.nvim_win_close(winnr, true) end
              if vim.api.nvim_buf_is_valid(backdropBufnr) then
                vim.api.nvim_buf_delete(backdropBufnr, { force = true })
              end
            end,
          })
        end,
      })
    end,
    keys = {
      { '<leader>f' },
      { '<leader>/' },
      { '<leader><leader>' },
    },
  },
}
