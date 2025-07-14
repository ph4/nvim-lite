local function mappings()
  local wk = require('which-key')
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then return end
      local bufnr = ev.buf
      local server_name = client.name


      local devicons = require('nvim-web-devicons')

      local py = devicons.get_icon('python', nil, { default = true })

      if server_name == "basedpyright" then
        wk.add({
          --stylua: ignore start
          { '<leader>loi',  '<cmd>LspPyrightOrganizeImports<cr>', desc = 'Organize imports', icon = py },
          { '<leader>lspp', '<cmd>LspPyrightSetPythonPath<cr>',   desc = 'Set python path',  icon = py },
          --stylua: ignore end
        }, { buffer = bufnr })
      else
        if server_name == "clangd" then
          local c = devicons.get_icon('c', nil, { default = true })
          wk.add({
            --stylua: ignore start
            { '<leader>h',  '<cmd>ClangdSwitchSourceHeader<cr>', desc = 'Switch source header', icon = c },
            { '<leader>ls', '<cmd>ClangdSymbolInfo<cr>>',        desc = 'Show symbol info',     icon = c },
            { '<leader>lt', '<cmd>ClangdTypeHierarchy<cr>',      desc = 'Show type hierarchy',  icon = c },
            --stylua: ignore end
          }, { buffer = bufnr })
        end
      end
    end
  })
end


local function get_config_by_ft(filetype)
  local matching_configs = {}
  for name, val in pairs(vim.lsp._enabled_configs) do
    local config = val.resolved_config
    if not config then config = vim.lsp.config[name] end
    if config then
      local filetypes = config.filetypes or {}
      for _, ft in pairs(filetypes) do
        if ft == filetype then table.insert(matching_configs, config) end
      end
    end
  end
  return matching_configs
end

local function attach_lsp_servers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == '' then
      local ft = vim.bo[bufnr].filetype
      local clients = get_config_by_ft(ft)
      if clients then
        for _, client in pairs(clients) do
          vim.lsp.start(client)
        end
      end
    end
  end
end

local function setup_signature_help()
  local sig_opts = {
    -- hint_prefix = " ",
    -- hint_scheme = "String",
    focusable = false,
    close_events = { 'CursorMoved', 'BufLeave', 'InsertLeave' },
    anchor_bias = 'above',
  }

  vim.keymap.set('i', '(', function()
    vim.api.nvim_feedkeys('(', 'n', false)
    vim.defer_fn(function() vim.lsp.buf.signature_help(sig_opts) end, 10)
  end, { silent = true })

  vim.keymap.set('i', ',', function()
    vim.api.nvim_feedkeys(',', 'n', false)
    vim.defer_fn(function() vim.lsp.buf.signature_help(sig_opts) end, 10)
  end, { silent = true })

  vim.keymap.set('n', '<C-K>, ', function() vim.lsp.buf.signature_help(sig_opts) end, { silent = true })
  vim.keymap.set('i', '<C-K>, ', function() vim.lsp.buf.signature_help(sig_opts) end, { silent = true })
end

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
        --stylua: ignore start
        { '<leader>z',   group = 'zk' },
        { '<leader>zno', commands.get('ZkNotes'),      desc = 'Notes' },
        { '<leader>zne', commands.get('ZkNew'),        desc = 'New note' },
        { '<leader>zl',  commands.get('ZkLinks'),      desc = 'Links' },
        { '<leader>zbl', commands.get('ZkBacklinks'),  desc = 'Backlinks' },
        { '<leader>zbb', commands.get('ZkBuffers'),    desc = 'Buffers' },
        { '<leader>zt',  commands.get('ZkTags'),       desc = 'Tags' },
        { '<leader>zi',  commands.get('ZkInsertLink'), desc = 'Insert link' },
        --stylua: ignore end
        mode = 'n',
      }
      local visual = {
        --stylua: ignore start
        { '<leader>z',  group = 'zk' },
        { '<leader>zc', commands.get('ZkNewFromContentSelection'), desc = 'New note from content selection' },
        { '<leader>zt', commands.get('ZkNewFromTitleSelection'),   desc = 'New note from title selection' },
        { '<leader>zi', commands.get('ZkInsertLinkAtSelection'),   desc = 'Insert link at selection' },
        { '<leader>zm', commands.get('ZkMatch'),                   desc = 'Match note (from selection)' },
        --stylua: ignore end
        mode = 'v',
      }
      wk.add(normal)
      wk.add(visual)
    end,
  },
  {
    'neovim/mason-lspconfig.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      { 'https://git.sr.ht/~p00f/clangd_extensions.nvim' },
      { 'SmiteshP/nvim-navic' },
      {
        'williamboman/mason.nvim',
        init = function(_, opts) require('mason').setup(opts) end,
      },
    },
    config = function()
      -- Set signs for diagnostics
      vim.diagnostic.config {
        signs = { text = require('config.icons').diagnostics },
      }

      local default_on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then require('nvim-navic').attach(client, bufnr) end
      end

      vim.lsp.config('*', { on_attach = default_on_attach })

      mappings()
      require('mason-lspconfig').setup {
        automatic_enable = true,
        ensure_installed = {},
      }
      setup_signature_help()

      -- Manually attach LSP to existing buffers after lazy load
      vim.defer_fn(function() attach_lsp_servers() end, 200)
    end,
  },
}
