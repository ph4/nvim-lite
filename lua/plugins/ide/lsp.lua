return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      { 'williamboman/mason.nvim', config = true},
      { 'williamboman/mason-lspconfig.nvim', config = true },
    },
    config = function()
      -- Set signs for diagnostics
      vim.diagnostic.config({
        signs = { text = require('config.icons').diagnostics }
      })

      require('mason-lspconfig').setup_handlers {
        function(server_name) vim.lsp.enable(server_name) {} end,
      }
    end,
  },
}
