return {
  {
    'williamboman/mason.nvim',
    config = true,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = true,
  },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      -- Set signs for diagnostics
      for name, icon in pairs(require('plugins.ui_ux').icons.diagnostics) do
        name = 'DiagnosticSign' .. name
        print(name, icon)
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
      end

      local lspconfig = require('lspconfig')
      require('mason-lspconfig').setup_handlers {
        function(server_name) lspconfig[server_name].setup {} end,
        -- ['clangd'] = function()
        --   require('lspconfig').clangd.setup {
        --     -- cmd = {'clangd', '--experimental-modules-support'}
        --   }
        -- end,
        ['lua_ls'] = function()
          lspconfig.lua_ls.setup {
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = {
                  globals = { 'vim', 'as' },
                  unusedLocalExclude = { '_*' },
                },
                workspace = {
                  checkThirdParty = false,
                  library = vim.api.nvim_get_runtime_file('', true),
                  maxPreload = 10000,
                  preloadFileSize = 50000,
                },
                telemetry = {
                  enable = false,
                },
              },
            },
          }
        end,
        -- ["rust_analyzer"] = function ()
        --     require("rust-tools").setup {}
        -- end
      }
    end,
  },
}
