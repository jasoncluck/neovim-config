-- Plugin specs for lazy.nvim (one file returning a list of plugins).
-- Adds:
--  - rachartier/tiny-inline-diagnostic.nvim (prettier inline diagnostics)
--  - rachartier/tiny-code-action.nvim (code action picker)
--
-- Behavior: keep tiny-inline-diagnostic for the nicer cursor inline display,
-- but enable Neovim builtin virtual_text only for ERROR severity so that
-- errors are always visible on every line (not only when the cursor is on the line).

return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'LspAttach',
    priority = 1000,
    opts = {
      -- Customize plugin options here; these keep the plugin's behavior but
      -- request that the plugin show all diagnostics on the cursor line.
      options = {
        show_all_diags_on_cursorline = true,
        throttle = 20,
      },
      -- You can further customize presets/hi/multilines/signs here if desired.
    },
    config = function(_, opts)
      -- Initialize tiny-inline-diagnostic with the provided opts
      require('tiny-inline-diagnostic').setup(opts or {})

      -- Enable builtin Neovim virtual text only for ERROR severity so errors
      -- are visible on all lines at all times.
      vim.diagnostic.config {
        virtual_text = {
          severity = { min = vim.diagnostic.severity.INFO },
          -- Optional: add a custom format function if you want to shorten messages:
          -- format = function(d)
          --   return d.message
          -- end,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
      }
    end,
  },

  {
    'rachartier/tiny-code-action.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- optional pickers; telescope is recommended if you use it:
      'nvim-telescope/telescope.nvim',
      -- optional: {"ibhagwan/fzf-lua"},
      -- optional: { "folke/snacks.nvim" },
    },
    event = 'LspAttach',
    opts = {
      -- default opts are fine; override as needed per README
    },
    config = function(_, opts)
      require('tiny-code-action').setup(opts or {})

      -- Keymap for invoking code actions (normal and visual)
      vim.keymap.set({ 'n', 'x' }, '<leader>ca', function()
        require('tiny-code-action').code_action()
      end, { noremap = true, silent = true })
    end,
  },
}
