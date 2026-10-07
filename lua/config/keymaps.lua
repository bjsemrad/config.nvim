-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local map = vim.keymap.set

-- Clear search highlight on <Esc>
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostics
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- NOTE: UI toggles live under <leader>u so that <leader>t is free for tests.
map('n', '<leader>ud', function()
  local enabled = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config { virtual_lines = not enabled, virtual_text = enabled and { source = 'if_many', spacing = 2 } or false }
end, { desc = 'Toggle [D]iagnostic virtual lines' })

-- Exit terminal mode with a shortcut that's easier to discover than <C-\><C-n>.
--  NOTE: This won't work in all terminal emulators/tmux.
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
map('n', '<CA-Left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<CA-Right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<CA-Down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<CA-Up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Commenting. Neovim 0.10+ has built-in `gc`/`gcc`, so these just wrap it.
map('n', '<leader>c/', 'gcc', { desc = 'Toggle Comment', remap = true })
map('x', '<leader>c/', 'gc', { desc = 'Toggle comment', remap = true })
map('n', '<C-/>', 'gcc', { desc = 'Toggle Comment', remap = true })
map('x', '<C-/>', 'gc', { desc = 'Toggle comment', remap = true })

-- Buffers
map({ 'n', 'x' }, '<C-b>x', '<cmd>bd<CR>', { desc = 'Close Buffer' })
map({ 'n', 'x' }, '<C-b>n', '<cmd>bn<CR>', { desc = 'Next Buffer' })
map({ 'n', 'x' }, '<C-b>p', '<cmd>bp<CR>', { desc = 'Previous Buffer' })

-- Move lines. In visual mode, reselect and re-indent after moving.
map('n', '<C-Up>', '<cmd>m -2<CR>==', { desc = 'Move Line Up' })
map('n', '<C-Down>', '<cmd>m +1<CR>==', { desc = 'Move Line Down' })
map('x', '<C-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move Selection Up' })
map('x', '<C-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move Selection Down' })

-- [[ Quickfix and location list ]]
--  Build output from overseer lands in the quickfix list.
map('n', ']q', '<cmd>cnext<CR>zz', { desc = 'Next quickfix item' })
map('n', '[q', '<cmd>cprev<CR>zz', { desc = 'Previous quickfix item' })
map('n', ']l', '<cmd>lnext<CR>zz', { desc = 'Next location list item' })
map('n', '[l', '<cmd>lprev<CR>zz', { desc = 'Previous location list item' })

map('n', '<leader>xq', function()
  local open = false
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 and win.loclist == 0 then
      open = true
    end
  end
  vim.cmd(open and 'cclose' or 'copen')
end, { desc = 'Toggle [Q]uickfix list' })

map('n', '<leader>xl', function()
  local ok = pcall(vim.cmd.lopen)
  if not ok then
    vim.notify('No location list', vim.log.levels.INFO)
  end
end, { desc = 'Toggle [L]ocation list' })
