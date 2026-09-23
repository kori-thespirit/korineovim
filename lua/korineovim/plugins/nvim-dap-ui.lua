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
        vim.keymap.set('n', '<leader>dp', function() dap.pause()        end, { desc = 'Debug: Pause thread ' })
        vim.keymap.set('n', '<leader>du', function() dap.up()           end, { desc = 'Debug: Go up stacktrace 🔼' })
        vim.keymap.set('n', '<leader>dd', function() dap.down()         end, { desc = 'Debug: Go down stacktrace 🔽' })
        vim.keymap.set('n', '<leader>di', function() dap.step_into()    end, { desc = 'Debug: Step Into ' })
        vim.keymap.set('n', '<leader>do', function() dap.step_over()    end, { desc = 'Debug: Step Over ' })
        vim.keymap.set('n', '<leader>dt', function() dap.terminate()    end, { desc = 'Debug: Terminate ' })
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint,             { desc = 'Debug: Toggle breakpoint 🔵'})
        vim.keymap.set("n", "<leader>dc", dap.continue,                      { desc = 'Debug: Start/Continue '})
        vim.keymap.set({'n', 'v'}, '<Leader>dh', function() require('dap.ui.widgets').hover() end, { desc = 'Debug: Hover '})
        vim.keymap.set({'n', 'v'}, '<Leader><F4>', function() require('dap.ui.widgets').preview() end, { desc = 'Debug: Open preview window'})
        vim.keymap.set('n', '<Leader><F5>', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
        end, { desc = 'Debug: Widgets frames center float'})
        vim.keymap.set('n', '<Leader><F6>', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
        end, { desc = 'Debug: Widgets scropes center float'})

        dapui.setup()
    end,
}
