return {
  -- {
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  --   ---@module 'render-markdown'
  --   ---@type render.md.UserConfig
  --   opts = {},
  -- },
  {
    'stevearc/conform.nvim',
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        json = { 'jq', '--indent', '2' },
        typescript = { 'prettierd' },
        vue = { 'prettierd' },
        lua = { 'stylua' },
        html = { 'prettierd' },
        go = { 'gofmt' },
        rust = { 'rustfmt' },
      },
    },
  },
  {
    'pearofducks/ansible-vim',
  }
}
