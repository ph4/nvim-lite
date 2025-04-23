local M = {}

-- Store terminal buffers by name
M.named_terminals = {}

function M.execute_command(name, command)
  local is_windows = vim.fn.has('win32') == 1
  local shell = vim.o.shell

  -- Ensure proper exit syntax based on shell
  if is_windows and shell:match('cmd.exe') then
    command = command .. ' && exit'
  else
    command = command .. ' ; exit'
  end

  local term_buf = M.named_terminals[name]

  -- Close old buffer if it exists but job is finished
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
    vim.api.nvim_buf_delete(term_buf, { force = true })
    M.named_terminals[name] = nil
    term_buf = nil
  end

  -- Reuse terminal buffer if valid, else create new one
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.cmd('botright split')
    vim.api.nvim_set_current_buf(term_buf)
  else
    vim.cmd('botright split | terminal')
    term_buf = vim.api.nvim_get_current_buf()
    M.named_terminals[name] = term_buf

    -- Optional: Set buffer name for easy identification
    vim.api.nvim_buf_set_name(term_buf, 'term://' .. name)
  end

  -- Send the command to the terminal
  local chan_id = vim.b.terminal_job_id
  local endline = is_windows and '\r\n' or '\n'
  vim.fn.chansend(chan_id, command .. endline)

  -- Start in insert mode for terminal interaction
  vim.cmd('startinsert')
end

return M
