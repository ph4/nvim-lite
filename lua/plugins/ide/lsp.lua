return {
  {
    "zk-org/zk-nvim",
    event = "VeryLazy",
    config = function ()
      require("zk").setup {
        picker = 'telescope',
        picker_options = {
          --file picker
          telescope = require('telescope.themes').get_dropdown {
            results_title = "Results",
            layout_strategy = 'horizontal',
            layout_config = {
              preview_width = 0.55,
              height=0.85,
              width = 0.85,
              prompt_position = 'bottom',
            },
          },
        },
      }
    end
  },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
              "github:ph4/mason-registry",
          },
        }
      },
      { 'williamboman/mason-lspconfig.nvim', config = true },
    },
    config = function()
      -- Set signs for diagnostics
      vim.diagnostic.config({
        signs = { text = require('config.icons').diagnostics }
      })

      require('mason-lspconfig').setup_handlers {
        function(server_name) vim.lsp.enable(server_name) end,
      }
    end,
  },
}
