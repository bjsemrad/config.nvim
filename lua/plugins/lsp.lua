-- [[ LSP ]]
--  Neovim 0.11+ configures language servers natively through `vim.lsp.config()`
--  and `vim.lsp.enable()`. `nvim-lspconfig` is now only a data package that
--  ships the per-server defaults (cmd, filetypes, root markers).

return {
  {
    -- `lazydev` configures the Lua LS for your Neovim config, runtime and plugins,
    -- giving completion and signatures for the `vim.*` API.
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load the luv types when the `vim.uv` word is found.
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- NOTE: the mason repos moved from `williamboman` to `mason-org` in v2.
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      -- This runs every time a language server attaches to a buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Navigation, backed by the snacks picker.
          map('gd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
          map('gr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
          map('gI', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
          map('<leader>D', function() Snacks.picker.lsp_type_definitions() end, 'Type [D]efinition')
          map('<leader>ds', function() Snacks.picker.lsp_symbols() end, '[D]ocument [S]ymbols')
          map('<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end, '[W]orkspace [S]ymbols')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<C-k>', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x', 'i' })

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- NOTE: `supports_method` is a *method* in Neovim 0.11+, so it must be
          -- called with `:` — calling it with `.` passes the method name as `self`.
          local function supports(method)
            return client and client:supports_method(method, event.buf)
          end

          -- Toggle inlay hints, where the server provides them.
          if supports(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>uh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle Inlay [H]ints')
          end
        end,
      })

      -- Extra capabilities advertised by blink.cmp (snippets, resolve support, ...).
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Per-server overrides. Anything not listed here uses nvim-lspconfig's
      -- defaults. Available keys: cmd, filetypes, capabilities, settings, ...
      local servers = {
        clangd = {
          cmd = { '/etc/profiles/per-user/brian/bin/clangd' },
        },
        qmlls = {
          cmd = { '/etc/profiles/per-user/brian/bin/qmlls' },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              -- Toggle below to ignore Lua LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        gopls = {},
        bashls = {},
        basedpyright = {
          settings = {
            basedpyright = {
              -- 'standard' is far less noisy than basedpyright's default 'all'.
              analysis = { typeCheckingMode = 'standard' },
            },
          },
        },
        vtsls = {}, -- TypeScript / JavaScript
        cmake = {},
        cssls = {},
        docker_compose_language_service = {},
        dockerls = {},
        gradle_ls = {},
        helm_ls = {},
        html = {},
        htmx = {},
        jdtls = {}, -- configured by nvim-java, see lua/plugins/lang.lua
        jsonls = {},
        kotlin_language_server = {},
        markdown_oxide = {},
        nil_ls = {},
        terraformls = {},
        yamlls = {},
        zls = {},
        regols = {},
      }

      -- Broadcast the completion capabilities to every server, then layer the
      -- per-server overrides on top.  See `:help vim.lsp.config()`.
      vim.lsp.config('*', { capabilities = capabilities })
      for name, config in pairs(servers) do
        if not vim.tbl_isempty(config) then
          vim.lsp.config(name, config)
        end
      end

      -- Standalone tools, by Mason *package* name.
      --
      -- NOTE: servers are NOT listed here. mason-tool-installer wants package
      -- names ("lua-language-server"), whereas these are lspconfig names
      -- ("lua_ls"). It only resolves the latter once mason-lspconfig has
      -- registered its aliases, which is a race — servers that happen to share
      -- both names installed, `bashls` never did. Servers go through
      -- mason-lspconfig's own `ensure_installed`, which does the mapping.
      require('mason-tool-installer').setup {
        ensure_installed = {
          'stylua', -- Lua formatter
        },
      }

      require('mason-lspconfig').setup {
        -- Takes lspconfig names and maps them to Mason packages itself.
        ensure_installed = vim.tbl_keys(servers),
        -- Installed servers are enabled automatically via `vim.lsp.enable()`.
        automatic_enable = {
          exclude = {
            -- `stylua` ships an lspconfig entry (`stylua --lsp`), which would
            -- attach it as a second formatter. We drive it via conform instead.
            'stylua',
            -- `jdtls` must not start until nvim-java has patched its config,
            -- so lua/plugins/lang.lua enables it on the `java` filetype.
            'jdtls',
          },
        },
      }

      -- Servers installed as system packages rather than through Mason.
      vim.lsp.enable { 'clangd', 'qmlls' }
    end,
  },
}
