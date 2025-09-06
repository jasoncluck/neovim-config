-- Bootstrap configuration
require 'config.options'
require 'config.autocmds'
require 'config.lazy'
require 'keymaps'

-- ~/.config/nvim/init.lua (add or merge into your config)

-- sensible defaults for indentation
vim.o.tabstop = 4 -- how many columns a tab counts for
vim.o.shiftwidth = 4 -- size for autoindent and >>
vim.o.softtabstop = 4 -- number of spaces a <Tab> counts for while editing
vim.o.expandtab = true -- use spaces instead of actual tab characters
vim.o.autoindent = true
vim.o.smartindent = true

-- Makefile (and other filetypes that require real tabs) should keep tabs
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'make',
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 8
    vim.bo.shiftwidth = 8
    vim.bo.softtabstop = 0
  end,
})
