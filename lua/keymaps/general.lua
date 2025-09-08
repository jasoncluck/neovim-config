-- Core keymaps

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- better up/down (consolidated arrow keys with hjkl)
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

-- buffers (consolidated duplicate mappings)
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- Clear search with <esc> (combined version, removes redundancy)
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
  vim.lsp.buf.format()
end, { desc = 'Format' })

-- toggle options
vim.keymap.set('n', '<leader>uf', function()
  vim.g.format_on_save = not vim.g.format_on_save
  print('Format on save: ' .. tostring(vim.g.format_on_save))
end, { desc = 'Toggle format on save' })

vim.keymap.set('n', '<leader>us', function()
  vim.o.spell = not vim.o.spell
  print('Spell checking ' .. (vim.o.spell and 'enabled' or 'disabled'))
end, { desc = 'Toggle Spelling' })

vim.keymap.set('n', '<leader>uw', function()
  vim.o.wrap = not vim.o.wrap
  print('Line wrap ' .. (vim.o.wrap and 'enabled' or 'disabled'))
end, { desc = 'Toggle Line Wrap' })

vim.keymap.set('n', '<leader>ul', function()
  vim.o.relativenumber = not vim.o.relativenumber
  print('Relative line numbers ' .. (vim.o.relativenumber and 'enabled' or 'disabled'))
end, { desc = 'Toggle Relative Line Numbers' })

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
vim.keymap.set('n', '<leader>uc', function()
  vim.o.conceallevel = vim.o.conceallevel == 0 and conceallevel or 0
end, { desc = 'Toggle Conceal' })

-- Inlay hints toggle
local _inlay_hints_enabled = true
if vim.lsp and vim.lsp.buf and vim.lsp.buf.inlay_hint then
  vim.keymap.set('n', '<leader>uh', function()
    _inlay_hints_enabled = not _inlay_hints_enabled
    pcall(vim.lsp.buf.inlay_hint, 0, _inlay_hints_enabled)
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

-- LSP mappings (removed duplicates, kept most intuitive ones)
local function lsp_references()
  if pcall(require, 'telescope') then
    require('telescope.builtin').lsp_references()
  else
    vim.lsp.buf.references()
  end
end

local function lsp_definitions()
  if pcall(require, 'telescope') then
    require('telescope.builtin').lsp_definitions()
  else
    vim.lsp.buf.definition()
  end
end

-- Primary LSP mappings (using standard vim conventions)
vim.keymap.set('n', 'gd', lsp_definitions, { desc = 'LSP Definition' })
vim.keymap.set('n', 'gr', lsp_references, { desc = 'LSP References' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP Rename' })

-- Alternative mappings for those who prefer leader-based
vim.keymap.set('n', '<leader>gd', lsp_definitions, { desc = 'LSP Definition (leader)' })
vim.keymap.set('n', '<leader>gr', lsp_references, { desc = 'LSP References (leader)' })

-- Rename keymap with 'c' then 'r'
vim.keymap.set('n', 'cr', vim.lsp.buf.rename, { desc = 'LSP Rename' })
