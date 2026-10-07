-- [[ Debugging ]]
--  NOTE: kickstart's version of this file used `keys = function() local dap =
--  require 'dap' ... end`, which lazy.nvim evaluates at startup — that pulled
--  nvim-dap, dap-ui, dap-go, nvim-nio and nui.nvim into the startup path.
--  Wrapping each action in its own closure keeps them genuinely lazy.

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  keys = {
    { '<F9>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<F7>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F8>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F6>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see the last session result. Without this you can't see session
    -- output in the case of an unhandled exception.
    { '<F5>', function() require('dapui').toggle() end, desc = 'Debug: See last session result.' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to set up the various debuggers with
      -- reasonable debug configurations.
      automatic_installation = true,
      handlers = {},
      -- `handlers = {}` above is truthy, so mason-nvim-dap runs its default
      -- handler for each of these and registers the adapter with nvim-dap.
      ensure_installed = {
        'delve', -- Go
        'codelldb', -- Rust / C / C++ / Zig
        'cppdbg', -- C / C++ (the cpptools package)
        'python', -- debugpy
        'js', -- js-debug-adapter, for Node and TypeScript
        'kotlin', -- kotlin-debug-adapter
      },
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    -- NOTE: upstream kickstart uses `dapui.close` for these two. Yours opens the
    -- UI when a session ends so the last result stays visible — kept as you had it.
    dap.listeners.before.event_terminated['dapui_config'] = dapui.open
    dap.listeners.before.event_exited['dapui_config'] = dapui.open

    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
