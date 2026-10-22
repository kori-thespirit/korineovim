return {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            terminal_colors = true,
            undercurl = true,
            underline = false,
            bold = true,
            italic = {
                strings = false,
                emphasis = false,
                comments = true,
                operators = false,
                folds = false,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            invert_intend_guides = false,
            inverse = true, -- invert background for search, diffs, statuslines and errors
            contrast = "hard",
            palette_overrides = {},
            overrides = {},
            dim_inactive = false,
            transparent_mode = true,
        })


        vim.cmd.colorscheme("tokyonight-storm")
        vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#5b91bd", bold = false })
        vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#6192fa", bg = "NONE" })
        vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#6192fa", bg = "NONE" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e3f545", bold = true })
        vim.api.nvim_set_hl(0, "Comment", { fg = "#b85ec4", bold = false })
        vim.api.nvim_set_hl(0, "ComplHint", { fg = "#5b91bd", bg = "NONE" })
        -- :hi BlinkCmp<Tab> to show suggestion
        vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#489abd" })
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                -- This runs every time a colorscheme is loaded
                vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#5b91bd", bold = false })
                vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#6192fa", bg = "NONE" })
                vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#6192fa", bg = "NONE" })
                vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e3f545", bold = true })
                vim.api.nvim_set_hl(0, "Comment", { fg = "#b85ec4", bold = false })
                vim.api.nvim_set_hl(0, "ComplHint", { fg = "#5b91bd", bg = "NONE" })
            end,
        })
    end
}
