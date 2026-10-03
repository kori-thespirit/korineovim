vim.g.mapleader = " "
require("korineovim.config.set")
require("korineovim.config.keymaps")
require("korineovim.config.fzf_keymaps")
require("korineovim.config.lazy")
require("korineovim.lsp")
require('mini.pairs').setup()
require('mini.surround').setup()
require("mason").setup()
require("korineovim.dap_configs.openocd_local")
-- require("korineovim.dap_configs.macOS_debug")
-- require("korineovim.dap_configs.LenovoUbuntuServer_remote_debug")
-- vim.g.clipboard = {
--     name = "OSC52",
--   copy = {
--     ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--   },
--   paste = {
--     ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--   },
-- }
vim.opt.clipboard = "unnamedplus"


-- require("plugins.persistance").save()
-- require("plugins.persistance").load()
-- set rtp+=/opt/homebrew/opt/fzf
