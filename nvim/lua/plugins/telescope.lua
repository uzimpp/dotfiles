return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  -- branch = '0.1.x',
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'ahmedkhalf/project.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      defaults = {
        sorting_strategy = 'ascending',  -- First result at bottom
        layout_strategy = 'flex',
        layout_config = {
            prompt_position = 'top',  -- This moves prompt to top
        },
        mappings = {
          i = {
            ['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
            ['<C-j>'] = require('telescope.actions').move_selection_next,     -- move to next result
            ['<C-l>'] = require('telescope.actions').select_default,          -- open file
          },
        },
      },
      pickers = {
        find_files = {
          file_ignore_patterns = { 'node_modules', '%.git', '%.venv' },
          hidden = true,
        },
        live_grep = {
          file_ignore_patterns = { 'node_modules', '%.git', '%.venv' },
          additional_args = function(_)
            return { '--hidden' }
          end,
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- Project.nvim setup (uses fd if available, falls back to find)
    require('project_nvim').setup {
      detection_methods = { 'pattern', 'lsp' },
      patterns = { '.git', 'Makefile', 'package.json', 'Cargo.toml', 'pyproject.toml', '.project' },
      show_hidden = true,
    }
    pcall(require('telescope').load_extension, 'projects')

    local builtin = require 'telescope.builtin'

    -- ═══════════════════════════════════════════════════════════════════════
    -- PRIMARY (single key - most used actions)
    -- ═══════════════════════════════════════════════════════════════════════
    vim.keymap.set('n', '<leader>f', builtin.live_grep, { desc = 'Find text (grep)' })
    vim.keymap.set('n', '<leader>F', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>r', builtin.oldfiles, { desc = 'Recent files' })
    vim.keymap.set('n', '<leader>p', ':Telescope projects<CR>', { desc = 'Projects' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 0, previewer = false,
      })
    end, { desc = 'Search in buffer' })

    -- ═══════════════════════════════════════════════════════════════════════
    -- SEARCH PREFIX (s + key - less frequent but useful)
    -- ═══════════════════════════════════════════════════════════════════════
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search word under cursor' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search keymaps' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search diagnostics' })
    vim.keymap.set('n', '<leader>sc', builtin.git_commits, { desc = 'Search commits' })
    vim.keymap.set('n', '<leader>ss', builtin.git_status, { desc = 'Search git status' })
    vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = 'Search telescope pickers' })
    vim.keymap.set('n', '<leader>sR', builtin.resume, { desc = 'Search resume (last)' })
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep { grep_open_files = true, prompt_title = 'Grep in Open Files' }
    end, { desc = 'Search in open files' })
  end,
}
