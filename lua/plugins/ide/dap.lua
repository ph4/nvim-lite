---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input('Run with args: ', table.concat(args, ' ')) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], ' ')
  end
  return config
end

return {
  {
    'jay-babu/mason-nvim-dap.nvim',
    event = 'VeryLazy',
    dependencies = {
      {
        'igorlfs/nvim-dap-view',
        opts = {
          switchbuf = 'useopen,uselast',
          windows = {
            terminal = {
              position = 'right',
            },
          },
        }
      },
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
      'theHamsta/nvim-dap-virtual-text', -- help to find variable definitions in debug mode
      'nvimtools/hydra.nvim',
    },
    opts = {
      handlers = {
        function(config) require('mason-nvim-dap').default_setup(config) end,
        python = function(_)
          local debugpy_path = require('mason-registry').get_package('debugpy'):get_install_path()
          local python_path = debugpy_path .. '/venv/Scripts/python'
          require('dap-python').setup(python_path)
        end,
      },
      ensure_installed = { 'codelldb', 'debugpy' },
    },
    config = function(_, opts)
      local dap = require('dap')
      local dap_view = require('dap-view')
      dap.listeners.before.launch['dap-view-config'] = function() dap_view.open() end
      dap.listeners.before.attach['dap-view-config'] = function() dap_view.open() end

      require('mason-nvim-dap').setup(opts)
      require('nvim-dap-virtual-text').setup {}
      require('which-key').add { '<leader>e', group = 'Debug' }

      local mappings = {
        { '<leader>eq', function() dap_view.toggle(true) end },

        { '<leader>b', function() dap.toggle_breakpoint() end, desc = 'Breakpoint' },
        { '<leader>eb', function() dap.toggle_breakpoint() end, desc = 'Breakpoint' },
        {
          '<leader>eB',
          function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
          desc = 'Conditional breakpoint',
        },

        {
          '<leader>p',
          function()

            local on_build_done = function(job, code)
              if code ~= 0 then
                vim.notify('Build failed', vim.log.levels.ERROR)
                return
              end
              pcall(vim.api.nvim_buf_delete, job.term_buf, { force = true })
              if vim.g.debug_config ~= nil then
                dap.run(vim.g.debug_config)
              else
                dap.run_last()
              end
            end
            local on_done = function()
              if vim.g.build_function ~= nil then
                vim.g.build_function(on_build_done)
              end
            end

            if dap.session() ~= nil then
              dap.terminate(nil, nil, on_done) -- Will break if more than one session
            else
              on_done()
            end
          end,
          desc = 'DAP (Re)Run',
        },
        { '<leader>P', function() dap.continue { before = get_args } end, desc = 'DAP Run with Args' },
        -- stylua: ignore start
        { '<leader>ec', function() dap.continue()   end, desc = 'Continue' },
        { '<leader>er', function() dap.run_last()   end, desc = 'Run Last' },
        { '<leader>ep', function() dap.pause()      end, desc = 'Pause' },
        { '<leader>et', function() dap.terminate()  end, desc = 'Terminate' },
        { '<leader>ei', function() dap.step_into()  end, desc = 'Step Into' },
        { '<leader>eO', function() dap.step_out()   end, desc = 'Step Out' },
        { '<leader>eo', function() dap.step_over()  end, desc = 'Step Over' },

        { '<leader>eJ', function() dap.run_to_cursor() end, desc = 'Run to Cursor' },
        { '<leader>eg', function() dap.goto_() end, desc = 'Go to line (no execute)' },

        { '<leader>ej', function() dap.down() end, desc = 'Down' },
        { '<leader>ek', function() dap.up() end, desc = 'Up' },

        { '<leader>er', function() dap.repl.toggle() end, desc = 'Toggle REPL' },
        { '<leader>es', function() dap.session() end, desc = 'Session' },
        -- stylua: ignore end
      }
      require('which-key').add(mappings)

      local Hydra = require('hydra')
      Hydra {
        name = '',
        mode = 'n',
        body = '<leader>e',
        color = 'pink',
        heads = {
          { 'i', dap.step_into, { desc = 'Step Into' } },
          { 'o', dap.step_over, { desc = 'Step Over' } },
          { 'O', dap.step_out, { desc = 'Step Out' } },
        },
      }
    end,
  },
}
