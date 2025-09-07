-- return {
--   'folke/tokyonight.nvim',
--   priority = 1000,
--   config = function()
--     require('tokyonight').setup {
--       styles = {
--         comments = { italic = false },
--       },
--     }
--     vim.cmd.colorscheme 'tokyonight-night'
--   end,
-- }

return {
  'darianmorat/gruvdark.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'gruvdark'
  end,
}
