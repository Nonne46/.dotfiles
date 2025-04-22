return {
  {
    'zenbones-theme/zenbones.nvim',
    dependencies = 'rktjmp/lush.nvim',
    priority = 1000,
    init = function()
      vim.opt.background = 'dark'
      vim.cmd.colorscheme 'zenwritten'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
