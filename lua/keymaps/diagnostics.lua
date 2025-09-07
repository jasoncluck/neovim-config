-- Diagnostic keymaps

-- Function to copy current diagnostic to clipboard
local function copy_diagnostic_to_clipboard()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  
  if #diagnostics == 0 then
    vim.notify("No diagnostic found on current line", vim.log.levels.WARN)
    return
  end
  
  local messages = {}
  for _, diagnostic in ipairs(diagnostics) do
    local severity = vim.diagnostic.severity[diagnostic.severity]
    local source = diagnostic.source and (" [" .. diagnostic.source .. "]") or ""
    table.insert(messages, string.format("[%s]%s %s", severity, source, diagnostic.message))
  end
  
  local full_message = table.concat(messages, "\n")
  
  -- Copy to clipboard
  vim.fn.setreg('+', full_message)
  vim.fn.setreg('*', full_message)
  
  -- Notification
  local preview = full_message:gsub("\n", " | "):sub(1, 80)
  vim.notify("Copied " .. #diagnostics .. " diagnostic(s) to clipboard: " .. preview .. 
            (full_message:len() > 80 and "..." or ""))
end

-- Function to copy all buffer diagnostics to clipboard
local function copy_all_diagnostics_to_clipboard()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics == 0 then
    vim.notify("No diagnostics found in current buffer", vim.log.levels.WARN)
    return
  end
  
  local messages = {}
  for _, diagnostic in ipairs(diagnostics) do
    local severity = vim.diagnostic.severity[diagnostic.severity]
    local line_info = string.format("L%d:%d", diagnostic.lnum + 1, diagnostic.col + 1)
    local source = diagnostic.source and (" [" .. diagnostic.source .. "]") or ""
    table.insert(messages, string.format("%s [%s]%s %s", line_info, severity, source, diagnostic.message))
  end
  
  local full_message = table.concat(messages, "\n")
  vim.fn.setreg('+', full_message)
  vim.fn.setreg('*', full_message)
  
  vim.notify("Copied " .. #diagnostics .. " buffer diagnostics to clipboard")
end

-- Diagnostic navigation and management
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Diagnostic clipboard operations
vim.keymap.set('n', 'cd', copy_diagnostic_to_clipboard, {
  desc = 'Copy current diagnostic to clipboard',
  silent = true,
})

vim.keymap.set('n', 'cD', copy_all_diagnostics_to_clipboard, {
  desc = 'Copy all buffer diagnostics to clipboard',
  silent = true,
})

-- Toggle diagnostics
vim.keymap.set('n', '<leader>ud', function()
  local is_enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not is_enabled)
  print('Diagnostics ' .. (not is_enabled and 'enabled' or 'disabled'))
end, { desc = 'Toggle Diagnostics' })