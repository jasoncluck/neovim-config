-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Window resize
vim.keymap.set('n', '<M-h>', '<C-w><', { desc = 'Decrease window width' })
vim.keymap.set('n', '<M-l>', '<C-w>>', { desc = 'Increase window width' })
vim.keymap.set('n', '<M-j>', '<C-w>-', { desc = 'Decrease window height' })
vim.keymap.set('n', '<M-k>', '<C-w>+', { desc = 'Increase window height' })
