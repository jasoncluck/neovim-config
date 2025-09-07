-- Window navigation (updated to match LazyVim conventions)
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Go to left window', remap = true })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Go to right window', remap = true })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Go to lower window', remap = true })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Go to upper window', remap = true })

-- Window splitting
vim.keymap.set('n', '<leader>|', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>_', '<C-w>s', { desc = 'Split window horizontally' })

-- Disable ctrl + arrow key bindings for Mac under keyboard shortcuts => mission control
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })
