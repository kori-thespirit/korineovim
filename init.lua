vim.g.mapleader = " "
require("config.set")
require("config.keymaps")
require("config.lazy")
require('mini.pairs').setup()
require('mini.surround').setup()
require("mason").setup()
-- require("plugins.persistance").save()
-- require("plugins.persistance").load()
