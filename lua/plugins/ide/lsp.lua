return {
  {
    'zk-org/zk-nvim',
    event = 'VeryLazy',
    config = function()
      local commands = require('zk.commands')
      require('zk').setup {
        picker = 'telescope',
        picker_options = {
          --file picker
          telescope = require('telescope.themes').get_dropdown {
            results_title = 'Results',
            layout_strategy = 'horizontal',
            layout_config = {
              preview_width = 0.55,
              height = 0.85,
              width = 0.85,
              prompt_position = 'bottom',
            },
          },
        },
      }
      local wk = require('which-key')
      local normal = {
        { '<leader>z', group = 'zk' },
        { '<leader>zno', commands.get('ZkNotes'), desc = 'Notes' },
        { '<leader>zne', commands.get('ZkNew'), desc = 'New note' },
        { '<leader>zl', commands.get('ZkLinks'), desc = 'Links' },
        { '<leader>zbl', commands.get('ZkBacklinks'), desc = 'Backlinks' },
        { '<leader>zbb', commands.get('ZkBuffers'), desc = 'Buffers' },
        { '<leader>zt', commands.get('ZkTags'), desc = 'Tags' },
        { '<leader>zi', commands.get('ZkInsertLink'), desc = 'Insert link' },
        mode = 'n',
      }
      local visual = {
        { '<leader>z', group = 'zk' },
        { '<leader>zc', commands.get('ZkNewFromContentSelection'), desc = 'New note from content selection' },
        { '<leader>zt', commands.get('ZkNewFromTitleSelection'), desc = 'New note from title selection' },
        { '<leader>zi', commands.get('ZkInsertLinkAtSelection'), desc = 'Insert link at selection' },
        { '<leader>zm', commands.get('ZkMatch'), desc = 'Match note (from selection)' },
        mode = 'v',
      }
      wk.add(normal)
      wk.add(visual)
    end,
  },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
            'github:ph4/mason-registry',
          },
        },
      },
      { 'williamboman/mason-lspconfig.nvim', config = true },
    },
    config = function()
      -- Set signs for diagnostics
      vim.diagnostic.config {
        signs = { text = require('config.icons').diagnostics },
      }

      require('mason-lspconfig').setup_handlers {
        function(server_name) vim.lsp.enable(server_name) end,
      }
    end,
  },
}
