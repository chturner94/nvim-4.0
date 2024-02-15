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
                lsp_zero.default_keymaps({
                    buffer = bufnr,
                    exclude = {
                        'gd',   -- these are defined in lua/coding.lua under `lspsaga`
                        'K',    -- `lspsaga`
                        'go',   -- type definition, remapped to gt `lspsaga`
                        '<F2>', -- rename, remaped to <leader>cr `lspsaga`
                        '<F4>', -- code action, remapped to <leader>ca `lspsaga`
                        'x',    -- remapped in keys to <leader>cf
                        'gs',   -- remapped in keys to gK
                        'gl',   -- remapped to cd `lspsaga`
                    },
                })
                lsp_zero.buffer_autoformat()
            end)
        end,
        keys = {
            { '<leader>cf', '<cmd>LspZeroFormat<cr>', desc = 'Format file' },
            { 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', desc = 'Go to declaration' },
            { 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', desc = 'Go to implementation' },
            { 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', desc = 'Go to references' },
            { 'gK', '<cmd>lua vim.lsp.buf.signature_help()<cr>', desc = 'Signature help' },

        }
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
        },
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
            { 'windwp/nvim-autopairs' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' }
        },
        opts = {
            sources = {
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'luasnip' },
                { name = 'path' },
                { name = 'nvim_lsp_signature_help' },

            },
            preselect = 'item',
            completion = {
                completeopt = 'menu,menuone,noinsert'
            },
        },
        config = function(_, opts)
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            local cmp_action = require('lsp-zero').cmp_action()

            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )

            opts.mapping = cmp.mapping.preset.insert({
                -- `Enter` key to confirm completion
                ['<CR>'] = cmp.mapping.confirm({ select = false }),

                -- Ctrl+Space to trigger completion menu
                ['<C-Space>'] = cmp.mapping.complete(),

                -- Navigate between snippet placeholder
                ['<Tab>'] = cmp_action.luasnip_jump_forward(),
                ['<S-Tab>'] = cmp_action.luasnip_jump_backward(),

                -- Scoll up and down in the completion documentation
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            })
            cmp.setup(opts)
            -- `/` cmdline setup.
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp_document_symbol' }
                }, {
                    { name = 'buffer' }
                })
            })
            -- `:` cmdline setup.
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    }
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
