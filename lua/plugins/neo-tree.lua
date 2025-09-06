return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    close_if_last_window = false,
    filesystem = {
      -- keep the mappings you already had and enable follow_current_file
      follow_current_file = true, -- auto-reveal the current file in the tree
      use_libuv_file_watcher = true, -- keep the tree in sync when files change
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_by_name = {},
        hide_by_pattern = {},
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
