local M = {}

-- Store terminal buffers by name
M.named_terminals = {}

function M.execute_command(name, command)
  local is_windows = vim.fn.has('win32') == 1

  local term_buf = M.named_terminals[name]

  -- Find the window of the terminal buffer
  local term_win
  if term_buf then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == term_buf then
        term_win = win
        break
      end
    end
  end

  -- Stop the current job if it's still running
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    local chan_id = vim.b[term_buf].terminal_job_id
    local job_still_running = chan_id and vim.fn.jobwait({ chan_id }, 0)[1] == -1
    if job_still_running then
      -- Send interrupt or terminate
      if is_windows then
        vim.fn.jobstop(chan_id) -- Best effort on Windows
      else
        vim.fn.chansend(chan_id, '\x03') -- Send Ctrl-C
        vim.fn.jobstop(chan_id) -- Force stop
      end
    end
  end

  if term_win then
    vim.cmd('enew')
    vim.api.nvim_buf_delete(term_buf, { force = true })
    term_buf = vim.api.nvim_get_current_buf()
  else
    vim.cmd('botright new')
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then vim.api.nvim_buf_delete(term_buf, { force = true }) end
    term_buf = vim.api.nvim_get_current_buf()
    term_win = vim.api.nvim_get_current_win()
  end

  vim.api.nvim_set_option_value('filetype', 'build_terminal', { buf = term_buf })

  M.named_terminals[name] = term_buf

  local job_id
  vim.api.nvim_buf_call(term_buf, function()
    job_id = vim.fn.jobstart(command, {
      term = true,
      height = vim.api.nvim_win_get_height(term_win),
      width = vim.api.nvim_win_get_width(term_win),
      on_exit = function(_, code, _)
        if code == 0 then
          vim.notify(name .. ' finished successfully', vim.log.levels.INFO)
        else
          vim.notify(name .. ' exited with code: ' .. code, vim.log.levels.ERROR)
        end
      end,
    })
  end)

  -- Set buffer name for easy identification
  vim.api.nvim_buf_set_name(term_buf, 'term://' .. name)
  return job_id, term_buf
end

local function get_stem(path)
  local parts
  if string.match(path, '\\') then
    parts = vim.split(path, '\\')
  else
    parts = vim.split(path, '/')
  end
  return parts[#parts]
end

M.titlestring = function() return string.format('[nvim] %s', get_stem(vim.fn.getcwd())) end

return M
