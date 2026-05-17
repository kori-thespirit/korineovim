return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    require('lualine').setup({
        theme = 'palenight',
        options = {
          icons_enabled = false,
          -- section_separators = { left = '', right = '' },
          -- component_separators = { left = '', right = '' }
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },

        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff' },
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { 'diagnostics' },
          lualine_y = { 'filetype', 'lsp_status' },
          lualine_z = { 'location' }
        },
        tabline = {
          lualine_a = { 'buffers' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'tabs' }
        },
        refresh = {                  -- sets how often lualine should refresh it's contents (in ms)
          statusline = 100,         -- The refresh option sets minimum time that lualine tries
          tabline = 100,            -- to maintain between refresh. It's not guarantied if situation
          winbar = 100,             -- arises that lualine needs to refresh itself before this time
                                    -- it'll do it.
          refresh_time = 16,        -- ~60fps the time after which refresh queue is processed. Mininum refreshtime for lualine
          events = {                -- The auto command events at which lualine refreshes
            'WinEnter',
            'BufEnter',
            'BufWritePost',
            'SessionLoadPost',
            'FileChangedShellPost',
            'VimResized',
            'Filetype',
            'CursorMoved',
            'CursorMovedI',
            'ModeChanged',
          },
                                     -- Also you can force lualine's refresh by calling refresh function
                                     -- like require('lualine').refresh()
        },
      })

  end
}
