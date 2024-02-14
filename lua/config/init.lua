-- require('utils').initConfigs()

require('config.options')
require('config.keymaps')

vim.cmd.colorscheme(require('tokyonight').load())
