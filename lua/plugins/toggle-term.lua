-- ToggleTerm config for Kickstart.nvim
-- Place this file at: lua/custom/plugins/toggleterm.lua
-- Behavior:
--  * Toggle terminal with Ctrl+/
--  * Persistent horizontal split terminal toggled with <leader>t|
--  * Terminals open in insert mode when they open
--  * From terminal insert mode, use Ctrl-h/j/k/l to move between windows (panes).
--    When moving into a terminal buffer, the mapping will re-enter insert mode there.
--    When moving into a normal buffer, no automatic insert is triggered.

return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      local ok, toggleterm = pcall(require, 'toggleterm')
      if not ok then
        vim.notify('toggleterm.nvim failed to load', vim.log.levels.WARN)
        return
      end

      local term_mod_ok, Terminal_mod = pcall(require, 'toggleterm.terminal')
      if not term_mod_ok or not Terminal_mod or not Terminal_mod.Terminal then
        vim.notify('toggleterm.terminal.Terminal failed to load', vim.log.levels.WARN)
        return
      end
      local Terminal = Terminal_mod.Terminal

      -- Global setup: rely on explicit mappings below
      toggleterm.setup {
        open_mapping = nil,
        start_in_insert = true,
        insert_mappings = true,
        size = 15,
        direction = 'horizontal',
        close_on_exit = true,
      }

      -- Helper: go to insert mode (scheduled)
      local function go_insert()
        vim.schedule(function()
          pcall(vim.cmd, 'startinsert')
        end)
      end

      -- Default terminal instance (horizontal)
      local default_term = Terminal:new {
        direction = 'horizontal',
        size = 15,
        close_on_exit = true,
        on_open = function(_term)
          go_insert()
        end,
      }

      -- Persistent horizontal terminal (separate instance)
      local horizontal_term = Terminal:new {
        direction = 'horizontal',
        size = 15,
        close_on_exit = false,
        on_open = function(_term)
          go_insert()
        end,
      }

      local function toggle_default_terminal()
        default_term:toggle()
      end

      local function toggle_horizontal_terminal()
        horizontal_term:toggle()
      end

      -- Clear conflicting mappings (safe)
      pcall(vim.keymap.del, 'n', '<C-_>')
      pcall(vim.keymap.del, 'n', '<C-/>')
      pcall(vim.keymap.del, 't', '<C-_>')
      pcall(vim.keymap.del, 't', '<C-/>')
      pcall(vim.keymap.del, 'n', '<leader>t|')
      pcall(vim.keymap.del, 't', '<leader>t|')

      -- Toggle default terminal with Ctrl+/
      vim.keymap.set('n', '<C-_>', toggle_default_terminal, {
        desc = 'Toggle terminal (Ctrl+/)',
        noremap = true,
        silent = true,
      })
      vim.keymap.set('t', '<C-_>', function()
        default_term:toggle()
      end, {
        desc = 'Toggle terminal (Ctrl+/) from terminal',
        noremap = true,
        silent = true,
      })
      pcall(function()
        vim.keymap.set('n', '<C-/>', toggle_default_terminal, {
          desc = 'Toggle terminal (Ctrl+/) fallback',
          noremap = true,
          silent = true,
        })
        vim.keymap.set('t', '<C-/>', function()
          default_term:toggle()
        end, {
          desc = 'Toggle terminal (Ctrl+/) fallback from terminal',
          noremap = true,
          silent = true,
        })
      end)

      -- Toggle persistent horizontal terminal with <leader>t|
      vim.keymap.set('n', '<leader>t|', toggle_horizontal_terminal, {
        desc = 'Toggle horizontal terminal (<leader>t|)',
        noremap = true,
        silent = true,
      })
      vim.keymap.set('t', '<leader>t|', function()
        horizontal_term:toggle()
      end, {
        desc = 'Toggle horizontal terminal from terminal',
        noremap = true,
        silent = true,
      })

      -- Window navigation helpers from terminal mode (insert mode in terminal)
      -- This lets you press Ctrl-h/j/k/l inside a terminal to move between windows.
      -- Implementation:
      --  1) Feed <C-\><C-n> to enter terminal-normal mode
      --  2) Feed a <C-w>{dir} command to move the window
      --  3) After movement, if the target buffer is a terminal, re-enter insert mode there
      --
      -- Note: Some terminals may capture specific Ctrl sequences. If a mapping doesn't trigger,
      -- use Ctrl+V then the key to see what sequence your terminal sends.

      local function term_move(direction_key)
        return function()
          -- exit terminal input mode to terminal-normal
          local esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true)
          -- window move sequence, e.g., <C-w>j
          local move = vim.api.nvim_replace_termcodes('<C-w>' .. direction_key, true, false, true)
          -- feed the sequences
          -- 't' means termcodes handled; use 'n' mode so movements apply
          vim.api.nvim_feedkeys(esc .. move, 'n', true)
          -- after moving, if we land on a terminal buffer, re-enter insert mode there
          vim.schedule(function()
            local bt = vim.bo[0].buftype
            if bt == 'terminal' then
              pcall(vim.cmd, 'startinsert')
            end
          end)
        end
      end

      -- Map ctrl-h/j/k/l in terminal mode to navigate windows
      -- these are common window navigation keys used in the rest of your config
      pcall(function()
        vim.keymap.set('t', '<C-h>', term_move 'h', { desc = 'Terminal: move to left window', noremap = true, silent = true })
        vim.keymap.set('t', '<C-j>', term_move 'j', { desc = 'Terminal: move to down window', noremap = true, silent = true })
        vim.keymap.set('t', '<C-k>', term_move 'k', { desc = 'Terminal: move to up window', noremap = true, silent = true })
        vim.keymap.set('t', '<C-l>', term_move 'l', { desc = 'Terminal: move to right window', noremap = true, silent = true })
      end)

      -- For completeness, also ensure normal-mode mappings for window movement exist (Kickstart already sets these,
      -- but adding safe sets here won't hurt)
      pcall(function()
        vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window', noremap = true, silent = true })
        vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window', noremap = true, silent = true })
        vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window', noremap = true, silent = true })
        vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window', noremap = true, silent = true })
      end)
    end,
  },
}
