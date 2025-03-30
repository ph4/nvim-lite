return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('mason').setup()
      require('mason-registry')
      require('mason-lspconfig').setup()
      local lspconfig = require('lspconfig')
      local default_on_attach = function(_client, bufnr)
        local mappings = {
          { '[d', vim.diagnostic.goto_prev, desc = 'Previous diagnostic' },
          { ']d', vim.diagnostic.goto_next, desc = 'Next diagnostic' },
          { '[e', vim.diagnostic.goto_prev, desc = 'Previous diagnostic' },
          { ']e', vim.diagnostic.goto_next, desc = 'Next diagnostic' },
          { 'gD', vim.lsp.buf.declaration, desc = 'Go to declaration' },
          { 'gd', vim.lsp.buf.definition, desc = 'Go to definition' },
          { 'gr', vim.lsp.buf.references, desc = 'Go to references' },
          { 'gi', vim.lsp.buf.implementation, desc = 'Go to implementation' },
          { 'gt', vim.lsp.buf.type_definition, desc = 'Go to type definition' },
          { 'K', vim.lsp.buf.hover, desc = 'Document hover' },

          { '<leader>r', vim.lsp.buf.rename, desc = 'Rename symbol' },
          { '<leader>a', vim.lsp.buf.code_action, desc = 'Code action' },

          { '<leader>ld', vim.diagnostic.setloclist, desc = 'Document diagnostics' },
          { '<leader>lc', vim.lsp.codelens.run, desc = 'Run code lens' },
          { '<leader>lt', vim.lsp.buf.type_definition, desc = 'Go to type definition' },
          { '<leader>lr', vim.lsp.buf.rename, desc = 'Rename symbol' },
          { '<leader>lf', function() vim.lsp.buf.format { async = true } end, desc = 'Format file' },
          { '<leader>ll', vim.diagnostic.open_float, desc = 'Line diagnostics' },
          { '<leader>ls', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]], desc = 'Document symbols' },
          {
            '<leader>lp',
            function()
              local params = vim.lsp.util.make_position_params()
              local cb = function(_, result)
                if result == nil or vim.tbl_isempty(result) then return nil end
                vim.lsp.util.preview_location(result[1], { border = as.lsp.borders })
              end
              return vim.lsp.buf_request(0, 'textDocument/definition', params, cb)
            end,
            desc = 'Peek definition',
          },

          { '<leader>lw', name = 'Workspace' },
          { '<leader>lwa', vim.lsp.buf.add_workspace_folder, desc = 'Add folder to workspace' },
          { '<leader>lwr', vim.lsp.buf.remove_workspace_folder, desc = 'Remove folder from workspace' },
          { '<leader>lwd', vim.lsp.diagnostic.set_qflist, desc = 'Workspace diagnostics' },
          {
            '<leader>lwl',
            function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            desc = 'List workspace folders',
          },
        }
        require('which-key').add(mappings, { mode = 'n', buffer = bufnr })
      end
      require('mason-lspconfig').setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            on_attach = default_on_attach,
          }
        end,
        -- ['clangd'] = function()
        --   require('lspconfig').clangd.setup {
        --     -- cmd = {'clangd', '--experimental-modules-support'}
        --   }
        -- end,
        ['lua_ls'] = function()
          lspconfig.lua_ls.setup {
            on_attach = default_on_attach,
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

  {
    'hrsh7th/nvim-cmp',
    version = false, --last release is old
    dependencies = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'onsails/lspkind.nvim',
    },
    opts = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')
      return {
        sources = cmp.config.sources {
          { name = 'codeium' },
          { name = 'nvim_lua' },
          { name = 'nvim_lsp' },
          { name = 'luasnip', keyword_length = 2, priority = 50 },
          {
            {
              name = 'buffer',
              option = {
                get_bufnrs = function() return vim.api.nvim_list_bufs() end,
              },
            },
            { name = 'path' },
          },
        },
        formatting = {
          format = lspkind.cmp_format { with_text = true, maxwidth = 50 },
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = {
          ['<down>'] = cmp.mapping.select_next_item(),
          ['<up>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
              }
            elseif luasnip.expandable() then
              luasnip.expand {}
            else
              fallback()
            end
          end),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
              }
            elseif luasnip.expandable() then
              luasnip.expand {}
            else
              fallback()
            end
          end),
        },
      }
    end,
  },
  {
    'Exafunction/codeium.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function() require('codeium').setup {} end,
  },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
}
