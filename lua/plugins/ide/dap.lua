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
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    opts = {
      icons = { expanded = '', collapsed = '', current_frame = '▶' },
    },
    config = function(_, opts)
      local dap = require('dap')

      local dapui = require('dapui')
      dapui.setup(opts)

      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
      'theHamsta/nvim-dap-virtual-text', -- help to find variable definitions in debug mode
      'nvimtools/hydra.nvim',
    },
    opts = {
      handlers = {
        function (config)
          require('mason-nvim-dap').default_setup(config)
        end,
        python = function(_)
          local debugpy_path = require('mason-registry').get_package('debugpy'):get_install_path()
          local python_path = debugpy_path .. '/venv/Scripts/python'
          require('dap-python').setup(python_path)
        end
      },
      ensure_installed = { 'codelldb', 'debugpy' },
    },
    config = function(_, opts)
      require('mason-nvim-dap').setup(opts)
      require('nvim-dap-virtual-text').setup({})
      require('which-key').add { '<leader>e', group = 'Debug' }
      local Hydra = require('hydra')
      Hydra {
        name = '',
        mode = 'n',
        body = '<leader>e',
        color = 'pink',
        heads = {
          { 'i', '<cmd> DapStepInto <CR>', { desc = 'Step Into' } },
          { 'o', '<cmd> DapStepOver <CR>', { desc = 'Step Over' } },
          { 'O', '<cmd> DapStepOut <CR>', { desc = 'Step Out' } },
        },
      }
    end,
    keys = {
      { '<leader>eq', function() require('dapui').close() end },
      { '<leader>et', function() require('dapui').toggle() end },
      { '<leader>eo', function() require('dapui').open() end },

      { '<leader>eb', function() require('dap').toggle_breakpoint() end, desc = 'Breakpoint' },
      {
        '<leader>eB',
        function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
        desc = 'Conditional breakpoint',
      },

      { '<leader>p', function() require('dap').continue() end, desc = 'DAP Continue' },
      { '<leader>P', function() require('dap').continue { before = get_args } end, desc = 'DAP Run with Args' },
      { '<leader>er', function() require('dap').run_last() end, desc = 'Run Last' },
      { '<leader>ep', function() require('dap').pause() end, desc = 'Pause' },
      { '<leader>ec', function() require('dap').terminate() end, desc = 'Terminate' },

      { '<leader>ei', function() require('dap').step_into() end, desc = 'Step Into' },
      { '<leader>eO', function() require('dap').step_out() end, desc = 'Step Out' },
      { '<leader>eo', function() require('dap').step_over() end, desc = 'Step Over' },

      { '<leader>eJ', function() require('dap').run_to_cursor() end, desc = 'Run to Cursor' },
      { '<leader>eg', function() require('dap').goto_() end, desc = 'Go to line (no execute)' },

      { '<leader>ej', function() require('dap').down() end, desc = 'Down' },
      { '<leader>ek', function() require('dap').up() end, desc = 'Up' },

      { '<leader>er', function() require('dap').repl.toggle() end, desc = 'Toggle REPL' },
      { '<leader>es', function() require('dap').session() end, desc = 'Session' },
    },
  },
}
