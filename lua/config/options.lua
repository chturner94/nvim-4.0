local opt = vim.opt
local g = vim.g

g.autoformat = true
opt.autowrite = true
opt.clipboard = 'unnamedplus'
opt.completeopt = 'menu,menuone,noselect'
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.ignorecase = true
opt.shiftwidth = 4
opt.shiftround = true
opt.number = true
