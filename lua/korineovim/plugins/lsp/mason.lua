return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            },
        },
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
                "neocmake",
                -- "pyright",
                -- "yamlls",
                -- "docker_compose_language_service",
                -- "dockerls",
                -- "bashls",
                -- "jsonls",
                -- "nginx_language_server",
            },
            automatic_enable = true,

        })
    end
}
