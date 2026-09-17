local dap = require("dap")
require("korineovim.plugins.nvim-dap-ui")

dap.adapters.codelldb = {
    type = 'executable',
    -- :lua print(vim.fn.stdpath("data")) -> ~/.local/share/nvim
    command = vim.fn.stdpath("data") .. '/mason/packages/codelldb/codelldb',
}

dap.configurations.c = {
    {
        name = "macOS debug with LLDB",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    }
}

-- Duplicate configuration for C++ if necessary
dap.configurations.cpp = dap.configurations.c
