local map = vim.keymap.set

local function nmap(...) map('n', ...) end

local function tmap(...) map('t', ...) end

nmap('<leader>c', '<cmd>nohl<CR>')

-- better idnenting
map('x', '>', '>gv')
map('x', '>', '>gv')

-- Move around splits using Ctrl + {h,j,k,l}
nmap('<C-h>', '<C-w>h')
nmap('<C-j>', '<C-w>j')
nmap('<C-k>', '<C-w>k')
nmap('<C-l>', '<C-w>l')

tmap('<Esc>', [[<C-\><C-n>]])
--tmap('jk', [[<C-\><C-n>]])
tmap('<C-h>', [[<cmd>wincmd h<CR>]])
tmap('<C-j>', [[<cmd>wincmd j<CR>]])
tmap('<C-k>', [[<cmd>wincmd k<CR>]])
tmap('<C-l>', [[<cmd>wincmd l<CR>]])

nmap('<leader>pb', '<cmd>DapToggleBreakpoint<CR>')
nmap('<leader>pr', '<cmd>DapContinue<CR>')
