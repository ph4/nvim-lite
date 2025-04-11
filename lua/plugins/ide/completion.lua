return {
  {
    'hrsh7th/nvim-cmp',
    version = false, --last release is old
    event = 'InsertEnter',
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
        },
      }
    end,
  },
  {
    'supermaven-inc/supermaven-nvim',
    event = 'InsertEnter',
    config = function(_, opts)
      local function set_highlights(...) ---@diagnostic disable-line: unused-vararg
        -- NvimLightCyan darkened & desaturated https://hslpicker.com/#4d7372
        -- vim.api.nvim_set_hl(0, 'SupermavenSuggestion', { fg='#4d7372', italic = true })
        vim.api.nvim_set_hl(0, 'SupermavenSuggestion', { fg = '#3d6b6a', italic = true })
      end

      vim.api.nvim_create_autocmd('ColorScheme', { pattern = '*', callback = set_highlights })
      set_highlights()
      local supermaven = require('supermaven-nvim')
      local preview = require('supermaven-nvim.completion_preview')
      supermaven.setup(opts)
      preview.suggestion_group = 'SupermavenSuggestion' -- Works with zenbones
    end,
    opts = {
      keymaps = {
        accept_suggestion = '<Tab>',
        clear_suggestion = '<C-]>',
        accept_word = '<S-Tab>',
      },
    },
  },
}
