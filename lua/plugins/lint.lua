return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

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

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        if vim.bo.modifiable then
          lint.try_lint()
        end
      end,
    })
  end,
}
