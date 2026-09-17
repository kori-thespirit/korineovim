-- https://github.com/Marus/cortex-debug/tree/master
-- https://sourceware.org/gdb/current/onlinedocs/gdb#Debugger-Adapter-Protocol
-- HTTPS://CODEBERG.ORG/MFUSSENEGGER/NVIM-DAP/WIKI/DEBUG-ADAPTER-INSTALLATION#C-C-RUST-VIA-GDB
-- https://www.youtube.com/watch?v=pGbrIuHwXBY
return {
    "rcarriga/nvim-dap-ui",
    dependencies =
    {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio"
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        -- Basic requirement to link Debug Adapter Protocol with DAP UI
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
        vim.fn.sign_define('DapBreakpoint', {text='🔵', texthl='', linehl='', numhl=''})
        vim.fn.sign_define('DapStopped', {text='👉', texthl='', linehl='', numhl=''})
        vim.fn.sign_define('DapBreakpointRejected', {text='⭕', texthl='', linehl='', numhl=''})
        -- Keymap set for debug command
        vim.keymap.set('n', '<F3>', function() dap.up() end, { desc = 'Debug: Go up stacktrace' })
        vim.keymap.set('n', '<F4>', function() dap.down() end, { desc = 'Debug: Go down stacktrace' })
        vim.keymap.set('n', '<F5>', function() dap.step_into() end, { desc = 'Debug: Step Into' })
        vim.keymap.set('n', '<F6>', function() dap.step_over() end, { desc = 'Debug: Step Over' })
        vim.keymap.set('n', '<F7>', function() dap.step_out() end, { desc = 'Debug: Step Out' })
        vim.keymap.set('n', '<F8>', function() dap.continue() end, { desc = 'Debug: Start/Continue' })
        vim.keymap.set('n', '<F9>', function() dap.disconnect() end, { desc = 'Debug: Disconnect' })
        vim.keymap.set('n', '<F10>', function() dap.terminate() end, { desc = 'Debug: Terminate' })
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = 'Toggle debug breakpoint'})
        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = 'Continue'})
        dapui.setup()
    end,
}
