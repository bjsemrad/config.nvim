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
      style = 'darker',
    },
    config = function(_, opts)
      require('onedark').setup(opts)
      --vim.cmd.colorscheme 'onedark'
    end,
  },
  {
    'bjsemrad/kanso.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      foreground = { dark = 'saturated', light = 'default' },
      overrides = function(colors)
        local s = colors.theme.syn
        local BOOST = 0.08 -- 0 = stock kanso, 0.12 ≈ soft's level, 0.20 = One Dark darker-ish

        local function lift(hex)
          local r = tonumber(hex:sub(2, 3), 16)
          local g = tonumber(hex:sub(4, 5), 16)
          local b = tonumber(hex:sub(6, 7), 16)
          local f = function(x)
            return math.floor(x + (255 - x) * BOOST + 0.5)
          end
          return string.format('#%02x%02x%02x', f(r), f(g), f(b))
        end

        local hl = {}
        local function paint(groups, spec)
          for _, g in ipairs(groups) do
            hl[g] = spec
          end
        end

        -- keywords: kanso violet, lifted, bold so they stand apart
        paint({
          '@keyword',
          '@keyword.function',
          '@keyword.return',
          '@keyword.conditional',
          '@keyword.repeat',
          '@keyword.import',
          '@keyword.operator',
          '@keyword.exception',
        }, { fg = lift(s.keyword), bold = false })

        -- functions, types, strings, numbers, constants: lifted versions of kanso's own colors
        paint({ '@function', '@function.call', '@function.method', '@function.method.call' }, { fg = lift(s.fun) })
        paint({ '@type', '@type.builtin', '@type.definition' }, { fg = lift(s.type) })
        paint({ '@string', '@string.escape' }, { fg = lift(s.string) })
        paint({ '@number', '@number.float' }, { fg = lift(s.number) })
        paint({ '@constant', '@constant.builtin', '@boolean' }, { fg = lift(s.constant) })

        -- members: warm sand so they no longer share the keyword color
        paint({ '@variable.member', '@property', '@lsp.type.property' }, { fg = lift '#c4a68a' })

        return hl
      end,
    },
    config = function(_, opts)
      require('kanso').setup(opts)
      vim.cmd.colorscheme 'kanso-ink'
    end,
  },

  { 'bjsemrad/matteblack.nvim', lazy = true },
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
