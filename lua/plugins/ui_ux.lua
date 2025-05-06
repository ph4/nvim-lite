local icons = require('config.icons')
return {
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
      { '<Tab>',     [[<cmd>BufferLineCycleNext<CR>]] },
      { '<S-Tab>',   [[<cmd>BufferLineCyclePrev<CR>]] },
      { '<S-l>',     [[<cmd>BufferLineCycleNext<CR>]] },
      { '<S-h>',     [[<cmd>BufferLineCyclePrev<CR>]] },
      { '<]b>',      [[<cmd>BufferLineCycleNext<CR>]] },
      { '<[b>',      [[<cmd>BufferLineCyclePrev<CR>]] },
      { '<leader>`', '<cmd>e #<cr>',                  desc = 'Switch to Other Buffer' },
    },
  },
  {
    'vladdoster/remember.nvim',
    config = true,
  },
  {
    'coffebar/neovim-project',
    lazy = false,
    priority = 100,
    opts = {
      last_session_on_startup = false,
      projects = { -- define project roots
        '~/source/repos/*',
        '~/AppData/Local/nvim',
        '~/AppData/Local/nvim-data',
        -- "~/AppData/Local/nvim-data/lazy/*",
      },
      picker = { type = 'telescope' },
      session_manager_opts = {
        autosave_ignore_filetypes = { 'dap-view', 'dap-view-term', 'toggleterm' },
      },
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append('globals') -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
      require('which-key').add { '<leader>w', group = 'Projects' }
    end,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'Shatur/neovim-session-manager' },
    },
    keys = {
      { '<leader>ww', '<cmd>NeovimProjectDiscover<CR>',   desc = 'Select project from history' },
      { '<leader>wh', '<cmd>NeovimProjectHistory<CR>',    desc = 'Select project from history' },
      { '<leader>wl', '<cmd>NeovimProjectLoadRecent<CR>', desc = 'Load last project' },
      { '<leader>wc', '<cmd>NeovimProjectLoad .<CR>',     desc = 'Load session for cwd' },
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
      { '-', '<CMD>Neotree toggle<CR>', desc = 'NeoTree' },
    },
    config = {
      use_libuv_file_watcher = true,
      window = {
        width = 32,
      },
      default_component_configs = {
        diagnostics = {
          errors_only = true,
        },
        modified = {
          symbol = icons.modified,
        },
        git_status = {
          symbols = icons.git.status,
          align = 'right',
        },
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
          progress_icon = { 'dots_negative' },
        },
      },
      notification = {
        override_vim_notify = true,
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    lazy = false, -- The plugin is implementing its own lazy loading
    opts = {
      sign_priority = 100,
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

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
        local git = icons.git.actions
        wk.add {
          --stylua: ignore start
          { '<leader>gs', gs.stage_hunk,      desc = 'Stage Hunk',   icon = git.stage },
          { '<leader>gu', gs.undo_stage_hunk, desc = 'Unstage Hunk', icon = git.unstage },
          { '<leader>gr', gs.reset_hunk,      desc = 'Reset Hunk',   icon = git.reset },
          { '<leader>gp', gs.preview_hunk,    desc = 'Preview Hunk', icon = git.preview },
          { '<leader>gb', gs.blame_line,      desc = 'Git Blame',    icon = git.blame },
          { '<leader>gd', gs.diffthis,        desc = 'Diff This',    icon = git.diff },
          {
            '<leader>gD',
            function() gs.diffthis('~') end,
            desc = 'Diff This (cached)',
            icon = git.diff,
          },
          --stylua ignore end
          buffer = bufnr,
        }
      end,
    },
  },
  {
    'tzachar/highlight-undo.nvim',
    opts = {
      hlgroup = 'HighlightUndo',
      duration = 300,
      pattern = { '*' },
      ignored_filetypes = { 'neo-tree', 'fugitive', 'TelescopePrompt', 'mason', 'lazy' },
      -- ignore_cb is in comma as there is a default implementation. Setting
      -- to nil will mean no default os called.
      -- ignore_cb = nil,
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'diagnostics' },
        lualine_c = { 'filename', 'navic' },
        lualine_x = { 'branch', 'diff' },
        lualine_y = { 'encoding', 'fileformat', 'filetype' },
        lualine_z = { 'location' },
      },
    },
  },
  {
    -- Stolen from https://github.com/Saghen/nvim/blob/main/lua/core/ui.lua
    'b0o/incline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = 'VeryLazy',
    opts = {
      window = {
        zindex = 45, -- below the shade
        padding = 0,
        margin = { horizontal = 0 },
      },
      render = function(props)
        -- Modified icon
        local modified = vim.bo[props.buf].modified
        local modified_component = modified and { ' ●', group = 'BufferCurrentMod' } or ''

        -- Diagnostics
        local min_level = tonumber(vim.diagnostic.severity.WARN)
        local diagnostic_level = 999
        local diagnostic_count = 0
        for _, diagnostic in ipairs(vim.diagnostic.get(props.buf)) do
          local new = tonumber(diagnostic.severity)
          if new and new <= min_level then
            if new < diagnostic_level then
              diagnostic_count = 1
              diagnostic_level = new
            else
              diagnostic_count = diagnostic_count + 1
            end
          end
        end

        local diagnostic_icon = nil
        -- print('Total Count: ' .. diagnostic_count, 'Level: ' .. diagnostic_level)
        if diagnostic_count > 0 then
          local severity_name = vim.diagnostic.severity[diagnostic_level]
          severity_name = string.lower(severity_name)
          --make first letter uppercase
          severity_name = string.upper(string.sub(severity_name, 1, 1)) .. string.sub(severity_name, 2)
          diagnostic_icon = vim.fn.sign_getdefined('DiagnosticSign' .. severity_name)[1]
        end

        local diagnostic_component = diagnostic_icon
            and { ' ' .. diagnostic_icon.text .. diagnostic_count, group = diagnostic_icon.texthl }
            or ''

        -- Filename
        local buf_path = vim.api.nvim_buf_get_name(props.buf)
        local dirname = vim.fn.fnamemodify(buf_path, ':~:.:h')
        local dirname_component = { dirname, group = 'Comment' }

        local filename = vim.fn.fnamemodify(buf_path, ':t')
        if filename == '' then filename = '[No Name]' end
        local filename_component = { filename, group = 'Normal' }

        return {
          modified_component,
          diagnostic_component,
          ' ',
          filename_component,
          ' ',
          dirname_component,
          ' ',
        }
      end,
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      indent = {
        char = '▏',
        -- char = '│',
        -- char = '┊',
      },
    },
  },
  {
    'ph4/legendary.nvim',
    branch = 'extension-smart-splits',
    opts = {
      extensions = {
        smart_splits = {
          directions = { 'h', 'j', 'k', 'l' },
          mods = {
            move = '<C>',
            resize = {
              mod = '<M>',
            },
            swap = '<C-\\>',
          },
        },
      },
    },
  },
  {
    'mrjones2014/smart-splits.nvim',
    opts = {
      default_amount = 2,
    },
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>ta', '<cmd>AerialToggle! left<cr>', desc = 'Toggle aerial' },
    },
  },
}
