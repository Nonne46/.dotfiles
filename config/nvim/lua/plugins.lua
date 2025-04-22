-- [[ Configure and install plugins ]]

require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  require 'plugins.gitsigns',

  require 'plugins.which-key',

  require 'plugins.telescope',

  require 'plugins.lspconfig',

  require 'plugins.conform',

  require 'plugins.cmp',

  -- require 'plugins.oxocarbon',
  -- require 'plugins.zenbones',
  require 'plugins.nightfox',
  -- require 'plugins.mellifluous',
  -- require 'plugins.kanagawa',

  require 'plugins.todo-comments',

  require 'plugins.mini',

  require 'plugins.treesitter',

  require 'plugins.oilnvim',

  require 'plugins.autopairs',

  require 'plugins.compile-mode',

  require 'plugins.toggelterm',

  require 'plugins.neogit',
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
