return {
    {
        'nvimdev/lspsaga.nvim',
        opts = {
        },
        event = 'LspAttach',
        config = function(_, opts)
            require('lspsaga').setup(opts)
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons'
        },
        keys = {
            { 'K', '<cmd>Lspsaga hover_doc<cr>', desc = 'Hover doc' },
            { '<leader>ca', '<cmd>Lspsaga code_action<cr>', desc = 'Code action' },
            { '<leader>cd', '<cmd>Lspsaga show_line_diagnostics<cr>', desc = 'Show line diagnostics'},
            { '<leader>cD', '<cmd>Lspsaga peek_definition<cr>', desc = 'Peak definition' },
            { '<leader>cT', '<cmd>Lspsaga peek_type_definition<cr>', desc = 'Peak type definition' },
            { '<leader>ci', '<cmd>Lspsaga incoming_calls<cr>', desc = 'Incoming calls' },
            { '<leader>co', '<cmd>Lspsaga outgoing_calls<cr>', desc = 'Outgoing calls' },
            { '<leader>cs', '<cmd>Lspsaga outline<cr>', desc = 'Symbol outline' },
            { '<leader>cr', '<cmd>Lspsaga rename<cr>', desc = 'Rename' },
            { '<leader>gd', '<cmd>Lspsaga goto_definition<cr>', desc = 'Go to definition' },
            { '<leader>gt', '<cmd>Lspsaga goto_type_definitions<cr>', desc = 'Go to type definition' }
        }
    },
    {
        'windwp/nvim-autopairs',
        dependencies = {
            'hrsh7th/nvim-cmp'
        },
        event = 'InsertEnter',
        opts = {
            disable_filetype = {
                'TelescopePrompt',
                'clap_input'
            },
        },
        config = function(_, opts)
            require('nvim-autopairs').setup(opts)
        end
    }
}
