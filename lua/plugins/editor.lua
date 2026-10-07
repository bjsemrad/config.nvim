-- [[ Editing & general UI ]]

return {
  -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth' },

  -- Git signs in the gutter
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Shows pending keybinds
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
        },
      },
      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>g', group = '[G]it' },
        { '<leader>r', group = '[R]un / [R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]est' },
        { '<leader>u', group = '[U]I toggles' },
        { '<leader>x', group = 'Quickfi[x]' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- Highlight TODO, NOTE, FIX, etc. in comments
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- Collection of small, independent editing plugins
  {
    'nvim-mini/mini.nvim',
    version = '*',
    event = 'VeryLazy',
    config = function()
      -- Better Around/Inside textobjects:
      --  va)  - [V]isually select [A]round [)]paren
      --  yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings:
      --  saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      --  sd'   - [S]urround [D]elete [']quotes
      --  sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      require('mini.pairs').setup()

      -- Icon provider. Replaces nvim-web-devicons, and registers itself as a
      -- drop-in so plugins that ask for devicons get mini.icons instead.
      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Inline colour swatches
  {
    'Bishop-Fox/colorblocks.nvim',
    ft = { 'lua', 'css', 'qml', 'json' },
    opts = {
      symbol = '󱡕',
      virt_text_pos = 'eol',
      mode = 'fg',
      section = { 'S', '  ', 'The color is: ', 'H' },
      filetypes = { 'lua', 'css', 'qml', 'json' },
    },
    config = function(_, opts)
      require('colorblocks').setup(opts)
    end,
  },
}
