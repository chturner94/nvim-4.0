-- require('utils').initConfigs()

require('config.options')
require('config.keymaps')
require('config.autocmds')

vim.cmd.colorscheme(require('tokyonight').load())
