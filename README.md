# nvim

My personal Neovim configuration. It started life as
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and has since been
restructured into a modular layout and modernised for Neovim 0.11+ APIs.

- Native LSP configuration (`vim.lsp.config` / `vim.lsp.enable`) — no lspconfig `setup()` calls
- [blink.cmp](https://github.com/Saghen/blink.cmp) for completion
- [snacks.nvim](https://github.com/folke/snacks.nvim) for the picker, file explorer and notifications
- nvim-treesitter `main` branch (the rewrite, not the old module system)
- ~44ms startup, 6 plugins loaded eagerly out of 31

## Requirements

**Neovim 0.11 or newer.** Developed and tested on 0.12.5. The config uses
`vim.lsp.config()`, `vim.lsp.enable()`, `vim.hl.on_yank()`, `opt.winborder` and
diagnostic `virtual_lines`, none of which exist before 0.11.

| Tool | Needed for |
| :--- | :--- |
| `git`, `make`, C compiler | plugin installation and LuaSnip's jsregexp build |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep) | `snacks.picker` grep |
| [`fd`](https://github.com/sharkdp/fd) | faster file finding (optional, falls back to `find`) |
| Clipboard tool (`xclip`, `xsel`, `wl-clipboard`, …) | `unnamedplus` clipboard sync |
| A [Nerd Font](https://www.nerdfonts.com/) | icons — set `vim.g.have_nerd_font` in `init.lua` if you don't have one |
| [`lazygit`](https://github.com/jesseduffield/lazygit) | `<leader>gg` (optional) |
| [`cargo-watch`](https://github.com/watchexec/cargo-watch) | background Rust builds (optional) |

Language toolchains (`go`, `javac`, `cargo`, `node`, …) are needed only for the
servers you actually use. Mason installs the servers themselves.

## Layout

```
init.lua                 leader keys, then bootstrap — nothing else
lua/config/
  options.lua            vim options + diagnostic configuration
  keymaps.lua            global keymaps
  autocmds.lua           autocommands
  lazy.lua               plugin-manager bootstrap and settings
lua/plugins/             one file per concern, imported automatically
  colorscheme.lua        themes (only the active one loads at startup)
  completion.lua         blink.cmp + LuaSnip
  dap.lua                debugging
  editor.lua             mini.nvim, which-key, gitsigns, todo-comments
  format.lua             conform.nvim
  lang.lua               Java and Rust specific tooling
  lsp.lua                LSP servers, Mason, keymaps
  snacks.lua             picker, explorer, notifier
  treesitter.lua         parsers and highlighting
```

Every file under `lua/plugins/` is picked up automatically by
`{ import = 'plugins' }`, so adding a plugin means adding a file — no central
list to update.

## Keymaps

Leader is `<Space>`. Press it and wait to see the available chains via
which-key. `<leader>sk` searches every keymap interactively.

### Search and navigation

| Key | Action |
| :-- | :--- |
| `<leader>sf` | Search files |
| `<leader>sg` | Search by grep |
| `<leader>sw` | Search current word |
| `<leader>sd` | Search diagnostics |
| `<leader>sh` | Search help |
| `<leader>sk` | Search keymaps |
| `<leader>ss` | Search available pickers |
| `<leader>sr` | Resume last picker |
| `<leader>s.` | Recent files |
| `<leader>sn` | Search Neovim config files |
| `<leader>sc` | Switch colorscheme |
| `<leader>s/` | Grep in open files |
| `<leader>/` | Fuzzy-find in current buffer |
| `<leader><leader>` | Find existing buffers |
| `\` | Toggle file explorer |

### LSP

Active only in buffers with a language server attached.

| Key | Action |
| :-- | :--- |
| `gd` | Goto definition |
| `gr` | Goto references |
| `gI` | Goto implementation |
| `gD` | Goto declaration |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `<leader>rn` | Rename |
| `<C-k>` | Code action (normal, visual and insert mode) |
| `<leader>th` | Toggle inlay hints |
| `K` | Hover — in Rust buffers this is rustaceanvim's hover actions |
| `<leader>ca` | Grouped code actions (Rust only) |

### Diagnostics and formatting

| Key | Action |
| :-- | :--- |
| `<leader>q` | Open diagnostic quickfix list |
| `<leader>tD` | Toggle inline `virtual_lines` diagnostics |
| `<leader>f` | Format buffer |

### Completion (insert mode)

| Key | Action |
| :-- | :--- |
| `<A-CR>` | Accept completion |
| `<A-Space>` | Open menu / toggle documentation |
| `<C-n>` / `<C-p>` | Next / previous item |
| `<C-b>` / `<C-f>` | Scroll documentation |
| `<C-e>` | Dismiss |
| `<C-l>` / `<C-h>` | Jump forward / backward in a snippet |

`<C-k>` is deliberately unbound in blink so the LSP code-action mapping works in
insert mode. Signature help appears automatically instead.

### Editing

| Key | Action |
| :-- | :--- |
| `<Esc>` | Clear search highlight |
| `<C-/>` or `<leader>c/` | Toggle comment (normal and visual) |
| `<C-Up>` / `<C-Down>` | Move line or selection up / down |
| `<C-b>x` | Close buffer |
| `<C-b>n` / `<C-b>p` | Next / previous buffer |
| `<C-A-Left/Right/Up/Down>` | Move focus between windows |
| `<Esc><Esc>` | Exit terminal mode |

### Debugging

| Key | Action |
| :-- | :--- |
| `<F5>` | Toggle debug UI |
| `<F9>` | Start / continue |
| `<F6>` | Step out |
| `<F7>` | Step into |
| `<F8>` | Step over |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Set conditional breakpoint |

### Misc

| Key | Action |
| :-- | :--- |
| `<leader>gg` | Lazygit |
| `<leader>un` | Dismiss notifications |

## Language servers

Servers are declared in the `servers` table in `lua/plugins/lsp.lua` and
installed by Mason. Currently configured:

`clangd`, `cmake`, `cssls`, `docker_compose_language_service`, `dockerls`,
`gopls`, `gradle_ls`, `helm_ls`, `html`, `htmx`, `jdtls`, `jsonls`,
`kotlin_language_server`, `lua_ls`, `markdown_oxide`, `nil_ls`, `qmlls`,
`regols`, `terraformls`, `yamlls`, `zls`

Rust is handled separately by [rustaceanvim](https://github.com/mrcjkb/rustaceanvim),
which configures `rust_analyzer` itself — do **not** add it to the `servers`
table.

### Adding a server

Add an entry to `servers` in `lua/plugins/lsp.lua`. An empty table means
"use nvim-lspconfig's defaults":

```lua
local servers = {
  pyright = {},
  ts_ls = {
    settings = { ... },
  },
}
```

Mason installs it on next start and `mason-lspconfig` enables it automatically.

### Two servers are excluded from auto-enable

- **`stylua`** ships an lspconfig entry (`stylua --lsp`) which would attach it as
  a second formatter. It is driven through conform instead.
- **`jdtls`** must not start until `nvim-java` has patched its configuration, so
  `lua/plugins/lang.lua` enables it on the `java` filetype.

## Plugins

| Plugin | Role |
| :--- | :--- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Picker, explorer, notifier, indent guides, big-file handling |
| [blink.cmp](https://github.com/Saghen/blink.cmp) | Completion |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Parsing, highlighting, indentation (`main` branch) |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Server definitions consumed by `vim.lsp.config` |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | Installs servers, formatters and debug adapters |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting, with format-on-save |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Debugging, with dap-ui and dap-go |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | `ai`, `surround`, `pairs`, `icons`, `statusline` |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keymap discovery |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git gutter signs |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Lua LS types for the Neovim API |
| [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) | Rust tooling |
| [nvim-java](https://github.com/nvim-java/nvim-java) | Java tooling (lazy, `ft = 'java'`) |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlights TODO/FIX/NOTE |
| [colorblocks.nvim](https://github.com/Bishop-Fox/colorblocks.nvim) | Inline colour swatches |

### Adding a plugin

Create a file under `lua/plugins/`:

```lua
-- lua/plugins/my-plugin.lua
return {
  'owner/repo',
  event = 'VeryLazy',
  opts = {},
}
```

Prefer `event`, `ft`, `cmd` or `keys` over `lazy = false`. When using `keys`,
wrap each action in its own closure rather than requiring the plugin in a
`keys = function()` block — the latter is evaluated at startup and defeats lazy
loading entirely.

## Themes

`onedark` loads at startup; `matteblack`, `tokyonight` and `rose-pine` are lazy
and load when selected. Switch with `<leader>sc`.

To change the default, edit the `config` function in
`lua/plugins/colorscheme.lua` and move `vim.cmd.colorscheme` to the theme you
want, giving it `lazy = false` and `priority = 1000`.

## NixOS notes

`clangd` and `qmlls` are pinned to absolute Nix profile paths in
`lua/plugins/lsp.lua` because they come from the system rather than Mason:

```lua
clangd = { cmd = { '/etc/profiles/per-user/brian/bin/clangd' } },
qmlls  = { cmd = { '/etc/profiles/per-user/brian/bin/qmlls' } },
```

Update these if the username or profile path changes.

blink.cmp is configured with `fuzzy = { implementation = 'lua' }`. Its optional
Rust matcher downloads a prebuilt binary that will not dynamically link on NixOS.

## Maintenance

| Command | Purpose |
| :--- | :--- |
| `:Lazy` | Plugin status; `U` updates, `S` syncs, `X` cleans |
| `:Mason` | Manage servers, formatters and debug adapters |
| `:checkhealth` | Diagnose problems |
| `:checkhealth vim.deprecated` | Find deprecated API usage after a Neovim upgrade |

`lazy-lock.json` is tracked in git — commit it after updating so the plugin set
is reproducible.

## Troubleshooting

**Something broke after `:Lazy update`.** Restore the previous plugin versions
with `git checkout lazy-lock.json` followed by `:Lazy restore`.

**A plugin calls a function that no longer exists.** Usually a plugin pinned to
an old branch against a newer Neovim or dependency. Check for a `branch` or
`version` pin in the relevant spec.

**Startup feels slow.** `nvim --startuptime /tmp/start.log` shows where the time
goes. To find plugins loading eagerly that shouldn't be:

```
nvim --headless -c 'lua local l=require("lazy.core.config").plugins; local e={}; for n,p in pairs(l) do if p._.loaded then e[#e+1]=n end end; table.sort(e); print(#e.." eager: "..table.concat(e,", "))' -c qa
```

## Credit

Originally derived from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
