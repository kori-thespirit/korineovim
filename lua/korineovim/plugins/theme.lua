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
    vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#4b71d1", bg = "NONE" })
    vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#4b71d1", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e3f545", bold = true })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#b85ec4", bold = true })
  end
}
