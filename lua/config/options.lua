local opt = vim.opt
opt.termguicolors = true

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 4
opt.shiftwidth = 4

opt.swapfile = true
opt.undofile = true
opt.backup = false
opt.writebackup = false

opt.signcolumn = 'auto:1-2'
opt.clipboard = 'unnamedplus'

opt.wrap = false
opt.showbreak = [[↳]] -- Options include -> '…', '↳ ', '→','↪ '

opt.list = true
opt.listchars = {
  trail = '•',
  -- eol = "↴",
  tab = '» ',
  extends = '❯',
  precedes = '❮',
  nbsp = '_',
  space = ' ',
}

opt.scrolloff = 5
opt.cursorline = true

opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
