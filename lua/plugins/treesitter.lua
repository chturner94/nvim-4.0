return {
    {
        'nvim-treesitter/nvim-treesitter',
        opts = {
            ensure_installed = {
                'bash',
                'c',
                'diff',
                'html',
                'javascript',
                'jsdoc',
                'json',
                'jsonc',
                'lua',
                'luadoc',
                'luap',
                'markdown',
                'markdown_inline',
                'python',
                'query',
                'regex',
                'toml',
                'tsx',
                'typescript',
                'vim',
                'vimdoc',
                'yaml',
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = 'gnn',
                    node_incremental = 'grn',
                    scope_incremental = 'grc',
                    node_decremental = 'grm',
                },
            },
            textobjects = {
                move = {
                    enable = true,
                    goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
                    goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                    goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
                },
            },
            sync_install = false,
            auto_install = true,
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
            local move = require('nvim-treesitter.textobjects.move') ---@type table< string, fun(...)>
            local configs = require('nvim-treesitter.configs')
            for name, fn in pairs(move) do
                if name:find('goto') == 1 then
                    move[name] = function(q, ...)
                        if vim.wo.diff then
                            local config = configs.get_module('textobjects.move')[name] ---@type<string,string>
                            for key, query in pairs(config or {}) do
                                if q == query and key:find("[%]%[][cC]") then
                                    vim.comd('normal! ' .. key)
                                    return
                                end
                            end
                        end
                        return fn(q, ...)
                    end
                end
            end
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
            enable = true,
            max_lines = 0,
            min_window_height = 0,
            line_numbers = true,
            multiline_threshold = 20,
            trim_scope = 'outer',
            mode = 'cursor',
            separator = nil,
            zindex = 20,
            on_attach = nil,
        },
        config = function(_, opts)
            require('treesitter-context').setup(opts)
        end
    }
}
