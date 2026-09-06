return {
  "startup-nvim/startup.nvim",
  config = function()
    require"startup".setup(require"korineovim.config.kolabori_startup_theme")
    require"startup".create_mappings({
        ["<leader>ff"]="<cmd>FzfLua files<CR>",
        ["<leader>fh"]="<cmd>FzfLua history<CR>"
    })
  end
}
