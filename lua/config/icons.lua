local severity = vim.diagnostic.severity
return {
  modified = '●',
  diagnostics = {
    [severity.ERROR] = '󰅚',
    [severity.WARN] = '󰀪',
    [severity.INFO] = '󰋽',
    [severity.HINT] = '󰌶',
  },
  git = {
    actions = {
      --Actions
      stage = '',
      diff = '',
      unstage = '󰄱',
      blame = '',
      preview = '',
      reset = '󰜰',
    },
    status = {
      -- Change type
      added = '',
      deleted = '',
      modified = '',
      renamed = '',
      -- Status type
      untracked = '',
      ignored = '',
      unstaged = '󰄱',
      staged = '',
      conflict = '',
    },
  },
}
