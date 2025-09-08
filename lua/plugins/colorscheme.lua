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
  'EdenEast/nightfox.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'duskfox'
  end,
}
