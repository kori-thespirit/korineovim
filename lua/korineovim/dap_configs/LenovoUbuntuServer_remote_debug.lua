local dap = require("dap")
require("korineovim.plugins.nvim-dap-ui")

-- Define reusable variables
-- local home = os.getenv("HOME") -- lua environment variable
local home = vim.fn.expand("$HOME") -- vim function
local gdb_path   = home .. "/arm-gnu-toolchain-15.3.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-gdb"
local elf_path   = home .. "/stm32_usb_bootloader/unit_test/f446_cmake/Use_UART_STlinkv21/build/Use_UART_STlinkv21.elf"
local remote_ip  = "koris-lenovo-ubuntu-server"
local gdb_remote_port = "3333"
-- local remote_ip  = function() return vim.fn.input('Remote IP: ', '100.79.135.13') end
-- local remote_port = function() return vim.fn.input('Port: ', '3333') end

dap.adapters.cpptools = {
    id = 'cppdbg', -- Optional, not necessary
    type = 'executable',
    -- :lua print(vim.fn.stdpath("data")) -> ~/.local/share/nvim
    command = vim.fn.stdpath("data") .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}

dap.configurations.c = {
    {
        name = "Remote debug via OpenOCD",
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
        miDebuggerServerAddress = remote_ip .. ":" .. gdb_remote_port, -- OpenOCD GDB server
    },
}

-- Duplicate configuration for C++ if necessary
dap.configurations.cpp = dap.configurations.c
