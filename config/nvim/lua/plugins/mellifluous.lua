return {
  {
    'ramojus/mellifluous.nvim',
    priority = 1000,
    init = function()
      vim.opt.background = 'dark'
      vim.cmd.colorscheme 'mellifluous'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
