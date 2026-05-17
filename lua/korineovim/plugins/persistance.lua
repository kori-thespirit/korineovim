return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- load before reading buffers
  opts = {
    dir = vim.fn.stdpath("state") .. "/sessions/", -- session save directory
    options = { "buffers", "curdir", "tabpages", "winsize" } -- what to save
  }
}
