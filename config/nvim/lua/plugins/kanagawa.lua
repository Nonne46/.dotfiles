return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    init = function()
      vim.opt.background = 'dark'
      vim.cmd.colorscheme 'kanagawa-dragon'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
