require('utils').initPlugins()
return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      window = {
        border = 'none', -- none, single, double, shadow
        position = 'bottom', -- bottom, top
        margin = { 1, 0, 1, 0 }, -- additional window margin [top, right, bottom, left
        padding = { 1, 2, 1, 2 },
        winblend = 0,
        zindex = 1000,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3, -- spacing between columns
        align = 'left', -- align columns left, center, or right
      },
    },
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup(opts)
    end
  },
  { 'folke/neoconf.nvim' },
}
