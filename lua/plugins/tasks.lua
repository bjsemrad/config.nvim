-- [[ Build / run ]]
--  overseer detects build systems from the project itself (cargo, go, make,
--  npm, gradle, zig, cmake), so there is nothing to define per project.
--  Task output lands in the quickfix list, so `]q` / `[q` walk the errors.

return {
  'stevearc/overseer.nvim',
  cmd = {
    'OverseerRun',
    'OverseerToggle',
    'OverseerBuild',
    'OverseerQuickAction',
    'OverseerRestartLast',
  },
  keys = {
    { '<leader>rr', '<cmd>OverseerRun<cr>', desc = '[R]un task' },
    { '<leader>rw', '<cmd>OverseerToggle<cr>', desc = '[R]un: toggle task list' },
    { '<leader>ra', '<cmd>OverseerRestartLast<cr>', desc = '[R]un: [A]gain (restart last)' },
    { '<leader>rq', '<cmd>OverseerQuickAction<cr>', desc = '[R]un: [Q]uick action' },
    { '<leader>rc', '<cmd>OverseerBuild<cr>', desc = '[R]un: [C]ompose a task' },
    {
      '<leader>rb',
      function()
        require('overseer').run_task { tags = { 'BUILD' } }
      end,
      desc = '[R]un: [B]uild',
    },
    {
      '<leader>rt',
      function()
        require('overseer').run_task { tags = { 'TEST' } }
      end,
      desc = '[R]un: [T]est',
    },
    {
      '<leader>rx',
      function()
        require('overseer').run_task { tags = { 'RUN' } }
      end,
      desc = '[R]un: e[X]ecute',
    },
  },
  opts = {
    templates = { 'builtin' },
    task_list = {
      direction = 'bottom',
      min_height = 12,
      bindings = {
        ['<C-h>'] = false,
        ['<C-j>'] = false,
        ['<C-k>'] = false,
        ['<C-l>'] = false,
      },
    },
    -- Send task output to the quickfix list on failure so you can jump to errors.
    component_aliases = {
      default = {
        { 'display_duration', detail_level = 2 },
        'on_output_summarize',
        'on_exit_set_status',
        'on_complete_notify',
        { 'on_complete_dispose', require_view = { 'SUCCESS', 'FAILURE' } },
      },
      default_neotest = {
        'on_output_summarize',
        'on_exit_set_status',
        { 'on_complete_notify', system = 'unfocused' },
      },
    },
  },
  config = function(_, opts)
    local overseer = require 'overseer'
    overseer.setup(opts)

    -- overseer ships builtin templates for cargo, make, npm, deno, just, mise
    -- and others, but NOT for go, zig, gradle or cmake. These providers fill
    -- that gap so <leader>rb / <leader>rt / <leader>rx work there too.
    --
    -- NOTE: a template's `condition` only supports `filetype` and `dir` in this
    -- version of overseer — there is no `callback`. Gating on a marker file has
    -- to happen inside a provider's `generator`, which is what cargo.lua does.
    local TAG = require('overseer.constants').TAG

    ---@param name string provider name
    ---@param marker string|string[] file(s) identifying the project
    ---@param commands table<integer, {args: string[], tags: string[]}>
    ---@param exe string executable to run
    local function provider(name, marker, exe, commands)
      overseer.register_template {
        name = name,
        generator = function(search, cb)
          local found = vim.fs.find(marker, { upward = true, type = 'file', path = search.dir })[1]
          if not found then
            return cb {}
          end
          local root = vim.fs.dirname(found)
          local ret = {}
          for _, command in ipairs(commands) do
            table.insert(ret, {
              name = ('%s %s'):format(name, table.concat(command.args, ' ')),
              tags = command.tags,
              builder = function()
                return {
                  cmd = vim.list_extend({ exe }, vim.deepcopy(command.args)),
                  cwd = root,
                  components = {
                    { 'on_output_quickfix', open_on_exit = 'failure', open_height = 12 },
                    'default',
                  },
                }
              end,
            })
          end
          cb(ret)
        end,
      }
    end

    provider('go', 'go.mod', 'go', {
      { args = { 'build', './...' }, tags = { TAG.BUILD } },
      { args = { 'run', '.' }, tags = { TAG.RUN } },
      { args = { 'test', './...' }, tags = { TAG.TEST } },
      { args = { 'vet', './...' }, tags = {} },
      { args = { 'clean' }, tags = { TAG.CLEAN } },
    })

    provider('zig', 'build.zig', 'zig', {
      { args = { 'build' }, tags = { TAG.BUILD } },
      { args = { 'build', 'run' }, tags = { TAG.RUN } },
      { args = { 'build', 'test' }, tags = { TAG.TEST } },
    })

    provider('gradle', { 'build.gradle', 'build.gradle.kts' }, './gradlew', {
      { args = { 'build' }, tags = { TAG.BUILD } },
      { args = { 'test' }, tags = { TAG.TEST } },
      { args = { 'clean' }, tags = { TAG.CLEAN } },
    })

    provider('cmake', 'CMakeLists.txt', 'cmake', {
      { args = { '-S', '.', '-B', 'build' }, tags = {} },
      { args = { '--build', 'build' }, tags = { TAG.BUILD } },
    })

    -- Make `:make` and friends route through overseer.
    vim.api.nvim_create_user_command('Make', function(params)
      local task = require('overseer').new_task {
        cmd = vim.fn.expandcmd(('%s %s'):format(vim.o.makeprg, params.args)),
        components = {
          { 'on_output_quickfix', open = not params.bang, open_height = 12 },
          'default',
        },
      }
      task:start()
    end, { desc = 'Run makeprg as an overseer task', nargs = '*', bang = true })
  end,
}
