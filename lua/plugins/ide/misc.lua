return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = {
        'lua',
        'vim',
        'vimdoc',
        'javascript',
        'typescript',
        'html',
        'css',
        'json',
        'yaml',
        'markdown',
        'markdown_inline',
        'toml',
        'python',
        'c',
        'cpp',
        'go'
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
    build = ':TSUpdate',

  },
  { 'rafcamlet/nvim-luapad' },
}
