return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		lazy = true,
		opts = {},
		config = function(_, opts)
			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_lspconfig()

			lsp_zero.on_attach(function(client, bufnr)
				lsp_zero.default_keymaps({buffer = bufnr})
			end)
		end,
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{'hrsh7th/cmp-nvim-lsp'},
		},
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			{'L3MON4D3/LuaSnip'},
                        {'windwp/nvim-autopairs'},
		},
                opts = {},
                config = function(_, opts)
                    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
                    local cmp = require('cmp')
                    local cmp_action = require('lsp-zero').cmp_action()

                    cmp.event:on(
                        'confirm_done',
                        cmp_autopairs.on_confirm_done()
                    )
                    cmp.setup({
                        mapping = cmp.mapping.preset.insert({
                            -- `Enter` key to confirm completion
                            ['<CR>'] = cmp.mapping.confirm({select = false}),

                            -- Ctrl+Space to trigger completion menu
                            ['<C-Space>'] = cmp.mapping.complete(),

                            -- Navigate between snippet placeholder
                            ['<Tab>'] = cmp_action.luasnip_jump_forward(),
                            ['<S-Tab>'] = cmp_action.luasnip_jump_backward(),

                            -- Scoll up and down in the completion documentation
                            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                        })
                    })
                end
	},
	{
		'williamboman/mason.nvim',
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				'stylua',
				'shfmt',
			},
		},
		config = function(_, opts)
			require('mason').setup(opts)
		end
	},
	{
		'williamboman/mason-lspconfig.nvim',
		config = function() 
			local lsp_zero = require('lsp-zero')
			require('mason-lspconfig').setup({
				handlers = {
					lsp_zero.default_setup,
				},
			})
		end
	},

}
