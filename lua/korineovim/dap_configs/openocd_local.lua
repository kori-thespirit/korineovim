local dap = require("dap")
require("korineovim.plugins.nvim-dap-ui")

-- Define reusable variables
-- local home = os.getenv("HOME") -- lua environment variable
local home = vim.fn.expand("$HOME") -- vim function
local gdb_path   = "/opt/ST/STM32CubeCLT_1.22.0/GNU-tools-for-STM32/bin/arm-none-eabi-gdb"
local elf_path   = home .. "/stm32_usb_bootloader/unit_test/cmake_build/BlinkLED/build/BlinkLED.elf"


dap.adapters.cpptools = {
    id = 'cppdbg', -- Optional, not necessary
    type = 'executable',
    -- :lua print(vim.fn.stdpath("data")) -> ~/.local/share/nvim
    command = vim.fn.stdpath("data") .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}

dap.configurations.c = {
    {
        name = "Local debug via OpenOCD",
        type = "cpptools",
        request = "launch",
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        -- Use one of two method to load binary file to program field
        --[[ program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end, ]]
        program = elf_path,
        MIMode = "gdb",
        miDebuggerPath = gdb_path,
        miDebuggerServerAddress = "127.0.0.1" .. ":" .. "3333", -- OpenOCD GDB server
        setupCommands = {
            {
                text = 'set output-radix 16',
                description = 'Show hexadecimal value format',
                ignoreFailures = false
            },
        },
    },
}

-- Duplicate configuration for C++ if necessary
dap.configurations.cpp = dap.configurations.c
