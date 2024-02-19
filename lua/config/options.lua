local opt = vim.opt
local g = vim.g

g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

-- g.loaded_netrw = 0
g.autoformat = true
g.mousemoveevent = true
opt.autowrite = true
opt.clipboard = 'unnamedplus'
opt.completeopt = 'menu,menuone,noselect'
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.ignorecase = true
opt.inccommand = 'nosplit'
opt.laststatus = 3
opt.shiftwidth = 4
opt.tabstop = 4
opt.shiftround = true
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitkeep = 'screen'
opt.splitright = true
opt.number = true
opt.undofile = true
opt.undolevels = 1000
opt.updatetime = 200
