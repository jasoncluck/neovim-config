-- Core keymaps

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- better up/down
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move Lines
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- buffers
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- Clear search with <esc>
vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- save file
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- new file
vim.keymap.set('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

vim.keymap.set('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location List' })
vim.keymap.set('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix List' })

vim.keymap.set('n', '[q', vim.cmd.cprev, { desc = 'Previous quickfix' })
vim.keymap.set('n', ']q', vim.cmd.cnext, { desc = 'Next quickfix' })

-- formatting
vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
  vim.lsp.buf.format { async = true }
end, { desc = 'Format' })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
vim.keymap.set('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
vim.keymap.set('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
vim.keymap.set('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
vim.keymap.set('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
vim.keymap.set('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
vim.keymap.set('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- toggle options
vim.keymap.set('n', '<leader>uf', function()
  vim.g.format_on_save = not vim.g.format_on_save
  print('Format on save: ' .. tostring(vim.g.format_on_save))
end, { desc = 'Toggle format on save' })

vim.keymap.set('n', '<leader>us', function()
  if vim.o.spell then
    vim.o.spell = false
    print 'Spell checking disabled'
  else
    vim.o.spell = true
    print 'Spell checking enabled'
  end
end, { desc = 'Toggle Spelling' })

vim.keymap.set('n', '<leader>uw', function()
  if vim.o.wrap then
    vim.o.wrap = false
    print 'Line wrap disabled'
  else
    vim.o.wrap = true
    print 'Line wrap enabled'
  end
end, { desc = 'Toggle Line Wrap' })

vim.keymap.set('n', '<leader>ul', function()
  if vim.o.relativenumber then
    vim.o.relativenumber = false
    print 'Relative line numbers disabled'
  else
    vim.o.relativenumber = true
    print 'Relative line numbers enabled'
  end
end, { desc = 'Toggle Relative Line Numbers' })

vim.keymap.set('n', '<leader>ud', function()
  if not vim.diagnostic.is_enabled() then
    vim.diagnostic.enable()
    print 'Diagnostics enabled'
  else
    vim.diagnostic.enable(false)
    print 'Diagnostics disabled'
  end
end, { desc = 'Toggle Diagnostics' })

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
vim.keymap.set('n', '<leader>uc', function()
  if vim.o.conceallevel == 0 then
    vim.o.conceallevel = conceallevel
  else
    vim.o.conceallevel = 0
  end
end, { desc = 'Toggle Conceal' })

if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  vim.keymap.set('n', '<leader>uh', function()
    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
    else
      vim.lsp.buf.inlay_hint(0, nil)
    end
  end, { desc = 'Toggle Inlay Hints' })
end

-- quit
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- highlights under cursor
vim.keymap.set('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })

-- tabs
vim.keymap.set('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
vim.keymap.set('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
vim.keymap.set('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
vim.keymap.set('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- LSP mappings:
-- Keep 'cr' as rename, add 'gr' -> references and 'gd' -> definition.
-- Note: Mapping 'c' as a prefix (e.g., 'cr') will shadow the native 'c' operator.
-- If you want to avoid that, use the safer alternatives shown at the bottom.

-- Keep 'cr' for LSP rename
vim.keymap.set('n', 'cr', function()
  vim.lsp.buf.rename()
end, { noremap = true, silent = true, desc = 'LSP Rename (c then r)' })

-- 'gr' -> LSP references (prefers Telescope if available)
vim.keymap.set('n', 'gr', function()
  if pcall(require, 'telescope') then
    require('telescope.builtin').lsp_references()
  else
    vim.lsp.buf.references()
  end
end, { noremap = true, silent = true, desc = 'LSP References (g then r)' })

-- 'gd' -> LSP definition (prefers Telescope if available)
vim.keymap.set('n', 'gd', function()
  if pcall(require, 'telescope') then
    require('telescope.builtin').lsp_definitions()
  else
    vim.lsp.buf.definition()
  end
end, { noremap = true, silent = true, desc = 'LSP Definition (g then d)' })

vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP Rename (leader rn)' })
vim.keymap.set('n', '<leader>gr', function()
  if pcall(require, 'telescope') then
    require('telescope.builtin').lsp_references()
  else
    vim.lsp.buf.references()
  end
end, { desc = 'LSP References (leader gr)' })
vim.keymap.set('n', '<leader>gd', function()
  if pcall(require, 'telescope') then
    require('telescope.builtin').lsp_definitions()
  else
    vim.lsp.buf.definition()
  end
end, { desc = 'LSP Definition (leader gd)' })
vim.keymap.set('n', 'gR', vim.lsp.buf.references, { desc = 'LSP References (gR)' })
vim.keymap.set('n', 'gD', vim.lsp.buf.definition, { desc = 'LSP Definition (gD)' })
