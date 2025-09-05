return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    -- format_on_save kept as your original logic
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,

    -- Add explicit formatter definitions here so we call the exact CLI we expect.
    -- Conform will look up formatters_by_ft entries and resolve these names.
    -- Use "command" (Conform's expected field) rather than "exe".
    formatters = (function()
      -- Resolve sql-formatter path using NVM_DIR if available; fallback to a hard-coded path you provided.
      local nvm_bin = nil
      if vim.env.NVM_DIR then
        -- Keep the node version in sync with your environment if you change Node versions.
        nvm_bin = vim.env.NVM_DIR .. '/versions/node/v22.16.0/bin'
      else
        nvm_bin = '/Users/jasoncluck/.nvm/versions/node/v22.16.0/bin'
      end
      local sql_formatter_path = nvm_bin .. '/sql-formatter'

      return {
        -- keep stylua available as before
        stylua = {
          command = 'stylua',
          stdin = true,
        },

        -- Explicit sql-formatter wrapper:
        -- This calls the sql-formatter executable and sends the buffer on stdin.
        -- We pass a dialect via "-l". By default this uses "sql" (generic),
        -- but you can customize per-buffer by setting `vim.b.sql_dialect = "postgresql"`
        -- (or change the default below).
        ['sql-formatter'] = {
          command = sql_formatter_path,
          stdin = true,
          -- args can be a table or a function that returns a table.
          args = function(ctx)
            local buf = ctx and ctx.buf or 0
            local default_dialect = 'sql'
            local dialect = vim.b[buf].sql_dialect or default_dialect
            return { '-l', dialect }
          end,
        },

        -- Optional: keep sqlfluff available if you want a python-based fallback
        -- (install with `pip install sqlfluff`). Example args: use stdin via '-'
        sqlfluff = {
          command = 'sqlfluff',
          stdin = true,
          args = function()
            -- Use 'fix -' to read from stdin and print fixed SQL to stdout
            return { 'fix', '-' }
          end,
        },
      }
    end)(),

    -- Map filetypes to the formatter names above. Prefer sql-formatter and fall back to sqlfluff.
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },

      -- prefer js sql-formatter binary, fall back to sqlfluff if desired:
      sql = { 'sql-formatter', 'sqlfluff', stop_after_first = true },
    },
  },
}
