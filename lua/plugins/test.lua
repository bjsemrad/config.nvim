-- [[ Testing ]]
--  neotest runs individual tests from the cursor and shows pass/fail inline.
--  Each language needs its own adapter; the ones here match the toolchains
--  installed on this machine.

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- Adapters
    'fredrikaverpil/neotest-golang',
    'rcasia/neotest-java',
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-jest',
    'mrcjkb/rustaceanvim', -- ships its own neotest adapter
  },
  keys = {
    {
      '<leader>tn',
      function()
        require('neotest').run.run()
      end,
      desc = '[T]est [N]earest',
    },
    {
      '<leader>tf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = '[T]est [F]ile',
    },
    {
      '<leader>ta',
      function()
        require('neotest').run.run(vim.uv.cwd())
      end,
      desc = '[T]est [A]ll',
    },
    {
      '<leader>tl',
      function()
        require('neotest').run.run_last()
      end,
      desc = '[T]est [L]ast',
    },
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = '[T]est [S]ummary',
    },
    {
      '<leader>to',
      function()
        require('neotest').output.open { enter = true, auto_close = true }
      end,
      desc = '[T]est [O]utput',
    },
    {
      '<leader>tp',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = '[T]est output [P]anel',
    },
    {
      '<leader>tS',
      function()
        require('neotest').run.stop()
      end,
      desc = '[T]est [S]top' ,
    },
    {
      '<leader>td',
      function()
        require('neotest').run.run { strategy = 'dap' }
      end,
      desc = '[T]est [D]ebug nearest',
    },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-golang',
        require 'neotest-java',
        require 'neotest-python',
        require 'neotest-jest',
        require 'rustaceanvim.neotest',
      },
      status = { virtual_text = true },
      output = { open_on_run = false },
    }
  end,
}
