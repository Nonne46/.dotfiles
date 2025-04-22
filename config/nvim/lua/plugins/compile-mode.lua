return {
  'ej-shafran/compile-mode.nvim',
  branch = 'latest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'm00qek/baleia.nvim', tag = 'v1.3.0' },
  },
  keys = {
    {
      '<C-x>',
      function()
        require('compile-mode').compile { count = 10 }
      end,
      'n',
      { desc = '[C]ode [C]ompile' },
    },
  },
  config = function()
    vim.g.compile_mode = {
      buffer_name = 'compilation',
      baleia_setup = true,
      default_command = '',
    }
  end,
}
