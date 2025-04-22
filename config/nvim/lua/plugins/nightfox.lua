return {
  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    init = function()
      vim.opt.background = 'dark'
      vim.cmd.colorscheme 'carbonfox'

      vim.cmd.hi 'Comment gui=none'
    end,
    opts = {
      palettes = {
        all = {
          yellow = '#c8c093',
          orange = '#957FB8',
        },
      },
      groups = {
        all = {
          MiniStatuslineModeNormal = { fg = 'bg0', bg = '#5aaed1', style = 'bold' },
        },
      },
    },
  },
}
