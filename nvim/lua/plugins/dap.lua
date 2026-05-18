return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'nvim-neotest/nvim-nio',
            'theHamsta/nvim-dap-virtual-text',
            'jay-babu/mason-nvim-dap.nvim',
        },
        config = function()
            local dap    = require 'dap'
            local dapui  = require 'dapui'

            -- ── Keymaps ───────────────────────────────────────────────────────
            vim.keymap.set('n', '<F5>',        dap.continue,          { desc = 'Debug: Start/Continue' })
            vim.keymap.set('n', '<F1>',        dap.step_into,         { desc = 'Debug: Step Into' })
            vim.keymap.set('n', '<F2>',        dap.step_over,         { desc = 'Debug: Step Over' })
            vim.keymap.set('n', '<F3>',        dap.step_out,          { desc = 'Debug: Step Out' })
            vim.keymap.set('n', '<leader>bp',  dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
            vim.keymap.set('n', '<leader>BP',  function()
                dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
            end, { desc = 'Debug: Set Breakpoint' })

            -- ── DAP UI ────────────────────────────────────────────────────────
            dapui.setup {
                icons    = { expanded = '▾', collapsed = '▸', current_frame = '*' },
                controls = {
                    icons = {
                        pause      = '⏸',
                        play       = '▶',
                        step_into  = '⏎',
                        step_over  = '⏭',
                        step_out   = '⏮',
                        step_back  = 'b',
                        run_last   = '▶▶',
                        terminate  = '⏹',
                        disconnect = '⏏',
                    },
                },
            }

            -- ── Virtual text ──────────────────────────────────────────────────
            require('nvim-dap-virtual-text').setup { commented = true }

            -- ── Mason DAP — single setup, no automatic_installation ───────────
            -- automatic_installation removed: it calls vim.notify directly and
            -- tries to install node-debug2-adapter which is broken on modern Node
            require('mason-nvim-dap').setup {
                ensure_installed = {
                    'codelldb',  -- C / C++ / Rust
                    'debugpy',   -- Python
                    'delve',     -- Go
                    'js-debug-adapter', -- JS/TS (replaces broken node2)
                },
                automatic_installation = false, -- prevents noisy vim.notify calls
            }

            -- ── Debugger configurations ───────────────────────────────────────
            dap.configurations = {
                c = {{
                    name    = 'Launch',
                    type    = 'codelldb',
                    request = 'launch',
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd      = '${workspaceFolder}',
                    terminal = 'integrated',
                }},
                cpp = {{
                    name    = 'Launch',
                    type    = 'codelldb',
                    request = 'launch',
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd      = '${workspaceFolder}',
                    terminal = 'integrated',
                }},
                rust = {{
                    name    = 'Launch',
                    type    = 'codelldb',
                    request = 'launch',
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                    end,
                    cwd      = '${workspaceFolder}',
                    terminal = 'integrated',
                }},
                python = {
                    {
                        name    = 'Debug Python',
                        type    = 'debugpy',
                        request = 'launch',
                        program = '${file}',
                        console = 'integratedTerminal',
                    },
                    {
                        name    = 'Debug pytest',
                        type    = 'debugpy',
                        request = 'launch',
                        module  = 'pytest',
                        args    = { '-v', '${file}' },
                        console = 'integratedTerminal',
                    },
                },
                go = {{
                    name    = 'Debug',
                    type    = 'delve',
                    request = 'launch',
                    program = '${file}',
                    console = 'integratedTerminal',
                }},
                javascript = {{
                    name    = 'Debug Node',
                    type    = 'pwa-node', -- js-debug-adapter uses pwa-node
                    request = 'launch',
                    program = '${file}',
                    console = 'integratedTerminal',
                }},
                typescript = {{
                    name    = 'Debug TypeScript',
                    type    = 'pwa-node',
                    request = 'launch',
                    program = '${file}',
                    console = 'integratedTerminal',
                }},
            }

            -- ── Auto open/close DAP UI ────────────────────────────────────────
            dap.listeners.after.event_initialized['dapui_config']  = function() dapui.open() end
            dap.listeners.before.event_terminated['dapui_config']  = function() dapui.close() end
            dap.listeners.before.event_exited['dapui_config']      = function() dapui.close() end
        end,
    },

    { 'rcarriga/nvim-dap-ui',             dependencies = { 'nvim-neotest/nvim-nio' }, opts = {} },
    { 'theHamsta/nvim-dap-virtual-text',  opts = {} },
}
