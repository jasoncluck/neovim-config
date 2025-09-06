-- Plugin spec for nvim-lint with sqlfluff configured to use the "postgres" dialect.
-- Save as e.g. lua/plugins/lint.lua (or drop into your existing plugin specs).
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    local api = vim.api

    -- Override / extend the sqlfluff linter so we can pass --dialect postgres
    -- and parse the JSON output into nvim diagnostics.
    lint.linters.sqlfluff = {
      -- call sqlfluff in lint (json) mode for the current file
      cmd = 'sqlfluff',
      -- Use the 'lint' subcommand and request JSON output. We pass the file name
      -- as the last argument (the linter runner will substitute the filename).
      args = { 'lint', '--dialect', 'postgres', '--format', 'json' },
      -- sqlfluff prints json to stdout, and we want to parse it from stdout:
      stdin = false,
      -- parser: translate sqlfluff JSON into nvim-lint diagnostics
      parser = function(output, bufnr)
        if not output or output == '' then
          return {}
        end

        local ok, data = pcall(vim.fn.json_decode, output)
        if not ok or type(data) ~= 'table' then
          -- If parsing fails, return no diagnostics instead of erroring
          vim.schedule(function()
            vim.notify('sqlfluff: failed to parse JSON output', vim.log.levels.WARN)
          end)
          return {}
        end

        local diagnostics = {}
        -- sqlfluff json is typically a list of file results. Each entry has:
        -- { filepath = "...", violations = [ { line_no = N, line_pos = P, code = "L001", description = "...", ... } ] }
        for _, file_result in ipairs(data) do
          if file_result and file_result.violations and type(file_result.violations) == 'table' then
            for _, v in ipairs(file_result.violations) do
              local lnum = tonumber(v.line_no) or 1
              local col = tonumber(v.line_pos) or 1
              local code = v.code or ''
              local msg = v.description or ''

              local diag = {
                lnum = lnum - 1,
                col = col - 1,
                end_lnum = lnum - 1,
                end_col = col, -- end column is non-inclusive, keep as start+1-ish
                text = (code ~= '' and ('[' .. code .. '] ') or '') .. msg,
                severity = vim.diagnostic.severity.WARN,
                source = 'sqlfluff',
              }

              table.insert(diagnostics, diag)
            end
          end
        end

        return diagnostics
      end,
    }

    -- filetype to linter mapping
    lint.linters_by_ft = {
      markdown = { 'markdownlint' },
      javascript = { 'eslint_d' },
      sql = { 'sqlfluff' },
    }

    if vim.fn.executable 'sqlfluff' == 0 then
      vim.schedule(function()
        vim.notify('sqlfluff executable not found in PATH. Install with: pip install sqlfluff', vim.log.levels.WARN)
      end)
    end

    local lint_augroup = api.nvim_create_augroup('lint', { clear = true })
    api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        if vim.bo.modifiable then
          lint.try_lint()
        end
      end,
    })
  end,
}
