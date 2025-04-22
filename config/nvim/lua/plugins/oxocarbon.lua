return {
  {
    'nyoom-engineering/oxocarbon.nvim',
    priority = 1000,
    init = function()
      vim.opt.background = 'dark'
      vim.cmd.colorscheme 'oxocarbon'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
