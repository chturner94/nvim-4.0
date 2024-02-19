local Utilities = require('utils')
return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        dependencies = {
            {
                'lvimuser/lsp-inlayhints.nvim'
            },
        },
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
            { '<leader>cf', '<cmd>LspZeroFormat<cr>',                    desc = 'Format file' },
            { 'gD',         '<cmd>lua vim.lsp.buf.declaration()<cr>',    desc = 'Go to declaration' },
            { 'gi',         '<cmd>lua vim.lsp.buf.implementation()<cr>', desc = 'Go to implementation' },
            { 'gr',         '<cmd>lua vim.lsp.buf.references()<cr>',     desc = 'Go to references' },
            { 'gK',         '<cmd>lua vim.lsp.buf.signature_help()<cr>', desc = 'Signature help' },

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
                ['<Tab>'] = cmp_action.luasnip_supertab(),
                ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),

                -- Scoll up and down in the completion documentation
                ['<C-u>'] = cmp.mapping.scroll_docs(4),
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
                'lua_ls',
                'tsserver',
                'gopls',
                'marksman',
                'svelte-language-server',
                'gopls',

            },
        },
        config = function(_, opts)
            require('mason').setup(opts)
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            {
                'folke/neodev.nvim',
            }
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            require('mason-lspconfig').setup({
                handlers = {
                    lsp_zero.default_setup,
                    -- lua
                    lua_ls = function()
                        require('neodev').setup()
                        local lspconfig = require('lspconfig')
                        local neodevOptions = {
                            settings = {
                                Lua = {
                                    completion = {
                                        callSnippet = 'Replace'
                                    }
                                }
                            }
                        }
                        lspconfig.lua_ls.setup(neodevOptions)
                    end,
                    -- tsserver
                    tsserver = function()
                        require('lspconfig').tsserver.setup({
                            on_attach = function(client, bufnr)
                                local wk = require('which-key')
                                local ih = require('lsp-inlayhints')
                                ih.setup()
                                ih.on_attach(client, bufnr)
                                wk.register({
                                    ['<leader>cR'] = {
                                        vim.lsp.buf.code_action({
                                            apply = true,
                                            context = {
                                                only = { 'source.removeUnused.ts' },
                                                diagnostics = {},
                                            }
                                        }),
                                        'Remove unused imports'
                                    },
                                })
                            end,
                            settings = {
                                typescript = {
                                    inlayHints = {
                                        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                        includeInlayVariableTypeHints = true,
                                        includeInlayFunctionParameterTypeHints = true,
                                        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                                        includeInlayPropertyDeclarationTypeHints = true,
                                        includeInlayFunctionLikeReturnTypeHints = true,
                                        includeInlayEnumMemberValueHints = true,
                                    },
                                },
                                javascript = {
                                    inlayHints = {
                                        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                        includeInlayVariableTypeHints = true,

                                        includeInlayFunctionParameterTypeHints = true,
                                        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                                        includeInlayPropertyDeclarationTypeHints = true,
                                        includeInlayFunctionLikeReturnTypeHints = true,
                                        includeInlayEnumMemberValueHints = true,
                                    }
                                }
                            },
                        })
                    end,
                    -- gopls
                    gopls = function()
                        require('lspconfig').gopls.setup({
                            on_attach = function(client, bufnr)
                                local wk = require('which-key')
                                local ih = require('lsp-inlayhints')
                                if client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
                                    local semantic = client.config.capabilities.textDocument.semanticTokens
                                    client.server_capabilities.semanticTokensProvider = {
                                        full = true,
                                        legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
                                        range = true,
                                    }
                                end
                                ih.setup()
                                ih.on_attach(client, bufnr)
                                wk.register({

                                })
                            end,
                            settings = {
                                gopls = {
                                    gofumpt = true,
                                    codelenses = {
                                        gc_details = true,
                                        generate = true,
                                        regenerate_cgo = true,
                                        run_govulncheck = true,
                                        test = true,
                                        tidy = true,
                                        upgrade_dependency = true,
                                        vendor = true,
                                    },
                                    hints = {
                                        assignVariableTypes = true,
                                        compositeLiteralFields = true,
                                        compositeLiteralTypes = true,
                                        constantValues = true,
                                        functionTypeParameters = true,
                                        parameterNames = true,
                                        rangeVariableTypes = true,
                                    },
                                    analyses = {
                                        fieldalignment = true,
                                        nilness = true,
                                        unusedparams = true,
                                        unusedwrite = true,
                                        useany = true,
                                    },
                                    usePlaceholders = true,
                                    completeUnimported = true,
                                    staticcheck = true,
                                    directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                                    semanticTokens = true,
                                }
                            }
                        })
                    end,
                    -- new servers go here
                    -- server_name = function()
                    --  require('lspconfig').server_name.setup({
                    --  config here
                    --  on_attach = function(client, bufnr) -- can be used like this
                    --          print('hello and other methods')
                    --  end
                    --  })

                },
            })
        end
    },

}
