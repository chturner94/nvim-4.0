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
