
return {
  {
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
      dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
      dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    config = true,
    opts = {
      handlers = {
        codelldb = function(config)
          local mason_registry = require('mason-registry')
          local codelldb_path = mason_registry.get_package('codelldb'):get_install_path()
            .. '/extension/adapter/codelldb'
          vim.notify(codelldb_path)

          config.adapters = {
            type = 'server',
            port = '${port}',
            executable = {
              command = codelldb_path,
              args = { '--port', '${port}' },
            },
          }
          require('mason-nvim-dap').default_setup(config) -- don't forget this!
        end,
      },
      ensure_installed = { 'codelldb' },
    },
    keys = {
      { '<leader>pb', '<cmd> DapToggleBreakpoint <CR>' },
      { '<leader>pr', '<cmd> DapContinue <CR>' },
    },
  },
}
