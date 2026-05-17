vim.g.mapleader = " "
require("korineovim.config.set")
require("korineovim.config.keymaps")
require("korineovim.config.lazy")
require('mini.pairs').setup()
require('mini.surround').setup()
require("mason").setup()
-- require("plugins.persistance").save()
-- require("plugins.persistance").load()
