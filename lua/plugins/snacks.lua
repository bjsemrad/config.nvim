-- snacks.nvim bundles a picker, file explorer, notifier, indent guides and
-- several startup-time optimisations that used to need separate plugins.
--  Replaces: telescope.nvim, neo-tree.nvim, fidget.nvim, indent-blankline.

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Skips treesitter/LSP on very large files so they open instantly.
    bigfile = { enabled = true },
    -- Renders the file before plugins load, so opening a file feels instant.
    quickfile = { enabled = true },
    -- Replaces fidget.nvim for LSP progress + general notifications.
    notifier = { enabled = true, timeout = 3000 },
    -- Replaces kickstart's indent_line module.
    indent = { enabled = true },
    -- Highlights the word under the cursor (LSP document highlight).
    words = { enabled = true },
    -- Buffer-local scope detection, used by indent guides.
    scope = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      layout = { preset = 'default' },
      sources = {
        explorer = {
          -- Close the explorer once you pick a file, instead of leaving the
          -- sidebar open alongside it. Snacks defaults this to `false`.
          jump = { close = true },
        },
      },
    },
    explorer = { enabled = true },
    styles = {
      notification = { wo = { wrap = true } },
    },
  },
  keys = {
    -- [[ Pickers ]] these mirror the old Telescope bindings one-for-one.
    { '<leader>sh', function() Snacks.picker.help() end, desc = '[S]earch [H]elp' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = '[S]earch [K]eymaps' },
    { '<leader>sf', function() Snacks.picker.files() end, desc = '[S]earch [F]iles' },
    { '<leader>ss', function() Snacks.picker.pickers() end, desc = '[S]earch [S]elect Picker' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = '[S]earch current [W]ord', mode = { 'n', 'x' } },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = '[S]earch by [G]rep' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = '[S]earch [R]esume' },
    { '<leader>s.', function() Snacks.picker.recent() end, desc = '[S]earch Recent Files ("." for repeat)' },
    { '<leader><leader>', function() Snacks.picker.buffers() end, desc = '[ ] Find existing buffers' },
    { '<leader>/', function() Snacks.picker.lines() end, desc = '[/] Fuzzily search in current buffer' },
    { '<leader>s/', function() Snacks.picker.grep_buffers() end, desc = '[S]earch [/] in Open Files' },
    {
      '<leader>sn',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    -- `:Telescope colorscheme` equivalent, for flipping between your themes.
    { '<leader>sc', function() Snacks.picker.colorschemes() end, desc = '[S]earch [C]olorschemes' },

    -- [[ Explorer ]] replaces the neo-tree `\` binding.
    { '\\', function() Snacks.explorer() end, desc = 'File Explorer' },

    -- [[ Misc ]]
    { '<leader>gg', function() Snacks.lazygit() end, desc = '[G]it: Lazy[g]it' },
    { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss [N]otifications' },
  },
}
