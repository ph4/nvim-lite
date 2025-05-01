local function library()
  local ret = vim.api.nvim_get_runtime_file('', true)
  -- Hack to remove so dap has correct defintions
  -- because mason.nvim contains dap.lua
  for i = 1, #ret do
    if ret[i]:find('mason[.]nvim') then
      table.remove(ret, i)
      break
    end
  end
  return ret
end

local function runtime() end

return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = {
        unusedLocalExclude = { '_*' },
      },
      workspace = {
        checkThirdParty = false,
        library = library(),
        maxPreload = 10000,
        preloadFileSize = 50000,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
