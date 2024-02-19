local M = {}

function M.SetupLSP()
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
end
