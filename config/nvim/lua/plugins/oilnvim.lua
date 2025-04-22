return {
  'stevearc/oil.nvim',
  version = '*',
  opts = {
    columns = { 'icons' },
    keymaps = {
      ['<C-c>'] = false,
      ['q'] = 'actions.close',
      ['gp'] = function()
        local oil = require 'oil'

        local dir = GARBAGE_DIR
        vim.cmd { cmd = 'cd', args = { dir } }
        oil.open(dir)
        vim.notify(string.format 'INFO: i guess we are doing garbage now', vim.log.levels.INFO)
      end,
    },
  },
  keys = {
    { '-', '<CMD>Oil<CR>', desc = 'Oil reveal', silent = true },
  },
}
