-- [[ Colorschemes ]]
--  Only the active theme loads at startup; the rest are lazy and load on demand
--  when you pick them (`<leader>sc`). Previously all five loaded eagerly.

return {
  {
    'bjsemrad/onedark.nvim',
    lazy = false,
    priority = 1000, -- load before everything else
    opts = {
      -- Main options --
      style = 'soft',
      colors = {
        black = '#08090b',
        bg_d = '#0e1013', -- sidebars, floats, statusline
        bg0 = '#121418', -- main editor background
        bg1 = '#1a1d22', -- cursorline, popups
        bg2 = '#22252b', -- selection, pmenu
        bg3 = '#262a31', -- borders, inactive bits
      },
    },
    config = function(_, opts)
      require('onedark').setup(opts)
      vim.cmd.colorscheme 'onedark'
    end,
  },

  { 'bjsemrad/matteblack.nvim', lazy = true },
  { 'vague-theme/vague.nvim', lazy = true },
  { 'bjsemrad/pastel.nvim', lazy = true },
  { 'folke/tokyonight.nvim', lazy = true },
  {
    'webhooked/kanso.nvim',
    opts = {
      foreground = { dark = 'saturated', light = 'default' }, -- the "pop"
      overrides = function(colors)
        local member = { fg = '#C4A68A' } -- warm sand, from kanso's yellow3/orange family
        return {
          ['@variable.member'] = member,
          ['@property'] = member,
          ['@lsp.type.property'] = member,
          ['@keyword'] = { fg = colors.theme.syn.keyword, bold = true },
        }
      end,
    },
    lazy = true,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
    opts = {
      variant = 'moon', -- auto, main, moon, or dawn
      dark_variant = 'moon',
      dim_inactive_windows = false,
      extend_background_behind_borders = true,

      enable = {
        terminal = true,
        legacy_highlights = true,
        migrations = true,
      },

      styles = {
        bold = true,
        italic = true,
        transparency = true,
      },

      groups = {
        border = 'muted',
        link = 'iris',
        panel = 'surface',

        error = 'love',
        hint = 'iris',
        info = 'foam',
        note = 'pine',
        todo = 'rose',
        warn = 'gold',

        git_add = 'foam',
        git_change = 'rose',
        git_delete = 'love',
        git_dirty = 'rose',
        git_ignore = 'muted',
        git_merge = 'iris',
        git_rename = 'pine',
        git_stage = 'iris',
        git_text = 'rose',
        git_untracked = 'subtle',

        h1 = 'iris',
        h2 = 'foam',
        h3 = 'rose',
        h4 = 'gold',
        h5 = 'pine',
        h6 = 'foam',
      },

      palette = {
        main = {
          pine = '#3E8FB0',
        },
      },
    },
    config = function(_, opts)
      require('rose-pine').setup(opts)
    end,
  },
}
