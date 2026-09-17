vim.g.mapleader = " "
require("korineovim.config.set")
require("korineovim.config.keymaps")
require("korineovim.config.fzf_keymaps")
require("korineovim.config.lazy")
require("korineovim.lsp")
require('mini.pairs').setup()
require('mini.surround').setup()
require("mason").setup()
-- require("korineovim.dap_configs.macOS_debug")
require("korineovim.dap_configs.LenovoUbuntuServer_remote_debug.lua")
vim.opt.clipboard = "unnamedplus"
-- require("plugins.persistance").save()
-- require("plugins.persistance").load()
-- set rtp+=/opt/homebrew/opt/fzf
