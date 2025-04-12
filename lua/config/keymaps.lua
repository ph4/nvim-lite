local function map(mode, lhs, rhs, opts)
  if opts == nil then
    opts = {}
  elseif type(opts) == 'string' then
    opts = { desc = opts }
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function nmap(...) map('n', ...) end

local function tmap(...) map('t', ...) end

local function xmap(...) map('x', ...) end

local wk, whichkey = pcall(require, 'which-key')

nmap('<leader>c', '<cmd>nohl<CR>')

-- better idnenting
xmap('>', '>gv', 'Indent right')
xmap('<', '<gv', 'Indent left')

-- Move around splits using Ctrl + {h,j,k,l}
nmap('<C-h>', '<C-w>h', 'Move to the left split')
nmap('<C-j>', '<C-w>j', 'Move to the split below')
nmap('<C-k>', '<C-w>k', 'Move to the split above')
nmap('<C-l>', '<C-w>l', 'Move to the right split')

-- Toggle Esc to exit terminal mode
tmap('<Esc>', [[<C-\><C-n>]], 'Exit terminal mode')
local esc_mapped = true
local function toggle_esc()
  if esc_mapped then
    vim.api.nvim_del_keymap('t', '<Esc>')
    esc_mapped = false
    print('ESC umapped')
  else
    tmap('<Esc>', [[<C-\><C-n>]], 'Exit terminal mode')
    esc_mapped = true
    print('ESC mapped')
  end
end
tmap([[<C-\><C-t>]], toggle_esc, 'Toggle esc to exit terminal mode')
nmap([[<C-\><C-t>]], toggle_esc, 'Toggle esc to exit terminal mode')

--tmap('jk', [[<C-\><C-n>]])
tmap('<C-h>', [[<cmd>wincmd h<CR>]], 'Move to the left split')
tmap('<C-j>', [[<cmd>wincmd j<CR>]], 'Move to the split below')
tmap('<C-k>', [[<cmd>wincmd k<CR>]], 'Move to the split above')
tmap('<C-l>', [[<cmd>wincmd l<CR>]], 'Move to the right split')

nmap('<leader>pb', '<cmd>DapToggleBreakpoint<CR>')
nmap('<leader>pr', '<cmd>DapContinue<CR>')

-- LSP
nmap('gD', vim.lsp.buf.declaration, 'Go to declaration')
nmap('gd', vim.lsp.buf.definition, 'Go to definition')
nmap('gr', vim.lsp.buf.references, 'Go to references')
nmap('gi', vim.lsp.buf.implementation, 'Go to implementation')
nmap('gt', vim.lsp.buf.type_definition, 'Go to type definition')

local hover = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo.filetype == 'help' then
    vim.cmd(':help ' .. vim.fn.fnameescape(vim.fn.expand('<cword>')) .. '\n')
  elseif vim.lsp.get_clients { bufnr = bufnr } then
    vim.lsp.buf.hover()
  else
    vim.cmd(':Man ' .. vim.fn.fnameescape(vim.fn.expand('<cword>')) .. '\n')
  end
end
nmap('K', hover, 'Document hover')

nmap('<leader>r', vim.lsp.buf.rename, 'Rename symbol')
nmap('<leader>a', vim.lsp.buf.code_action, 'Code action')

if wk then whichkey.add { '<leader>l', group = '+LSP' } end
nmap('<leader>ld', vim.diagnostic.setloclist, 'Document diagnostics')
nmap('<leader>lc', vim.lsp.codelens.run, 'Run code lens')
nmap('<leader>la', vim.lsp.buf.code_action, 'Code action')
nmap('<leader>lt', vim.lsp.buf.type_definition, 'Go to type definition')
nmap('<leader>lr', vim.lsp.buf.rename, 'Rename symbol')
nmap('<leader>lf', function() vim.lsp.buf.format { async = true } end, 'Format file')
nmap('<leader>ll', vim.diagnostic.open_float, 'Line diagnostics')
nmap('<leader>ls', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]], 'Document symbols')
local peek_definition = function()
  local params = vim.lsp.util.make_position_params(0, 'utf-8')
  local cb = function(_, result)
    if result == nil or vim.tbl_isempty(result) then return nil end
    vim.lsp.util.preview_location(result[1])
  end
  return vim.lsp.buf_request(0, 'textDocument/definition', params, cb)
end
nmap('<leader>lp', peek_definition, 'Peek definition')

if wk then whichkey.add { '<leader>lw', group = 'Workspace' } end
nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Add folder to workspace')
nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove folder from workspace')
nmap('<leader>lwd', vim.diagnostic.setqflist, 'Workspace diagnostics')
nmap('<leader>lwl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, 'List workspace folders')
