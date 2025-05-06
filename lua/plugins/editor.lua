return {
  {
    'kylechui/nvim-surround',
    version = '^3.0.0', -- Use for stability; omit to use `main` branch for the latest features
    event = 'BufRead',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    'jbyuki/venn.nvim',
    dependencies = {
      'nvimtools/hydra.nvim',
    },
    event = 'VeryLazy',
    config = function()
      local Hydra = require('hydra')
      local venn_hint_utf = [[
Arrow^^^^^^  Select region with <C-v>^^^^^^
^ ^ _K_ ^ ^  _f_: Surround with box ^ ^ ^ ^
_H_ ^ ^ _L_  _<C-h>_: ◄, _<C-j>_: ▼
^ ^ _J_ ^ ^  _<C-k>_: ▲, _<C-l>_: ► _<C-c>_
]]
      Hydra {
        name = 'Draw Utf-8 Venn Diagram',
        hint = venn_hint_utf,
        config = {
          color = 'pink',
          invoke_on_body = true,
          on_enter = function() vim.wo.virtualedit = 'all' end,
          on_exit = function() vim.wo.virtualedit = 'block' end,
        },
        mode = 'n',
        body = '<leader>ve',
        heads = {
          { '<C-h>', 'xi<C-v>u25c4<Esc>' }, -- mode = 'v' somehow breaks
          { '<C-j>', 'xi<C-v>u25bc<Esc>' },
          { '<C-k>', 'xi<C-v>u25b2<Esc>' },
          { '<C-l>', 'xi<C-v>u25ba<Esc>' },
          { 'H', '<C-v>h:VBox<CR>' },
          { 'J', '<C-v>j:VBox<CR>' },
          { 'K', '<C-v>k:VBox<CR>' },
          { 'L', '<C-v>l:VBox<CR>' },
          { 'f', ':VBox<CR>', { mode = 'v' } },
          { '<C-c>', nil, { exit = true } },
        },
      }
    end,
  },
  {
    'echasnovski/mini.move',
    event = 'VeryLazy',
    opts = {
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<M-H>',
        right = '<M-L>',
        down = '<M-J>',
        up = '<M-K>',

        -- Move current line in Normal mode
        line_left = '<M-H>',
        line_right = '<M-L>',
        line_down = '<M-J>',
        line_up = '<M-K>',
      },
    },
  },
}
