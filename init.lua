vim.g.mapleader = " "
require("korineovim.config.set")
require("korineovim.config.keymaps")
require("korineovim.config.lazy")
require("korineovim.lsp")
require('mini.pairs').setup()
require('mini.surround').setup()
require("mason").setup()
vim.opt.clipboard = "unnamedplus"
-- require("plugins.persistance").save()
-- require("plugins.persistance").load()
