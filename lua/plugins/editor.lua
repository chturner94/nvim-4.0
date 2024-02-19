local Util = require('utils')
return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {
            open_mapping = [[<C-/>]],
        },
        config = function(_, opts)
            require('toggleterm').setup(opts)
        end
    },
    {
        'kdheepak/lazygit.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        keys = {
            { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'Lazy Git' },
        }
    },
    {
        'willothy/wezterm.nvim',
        event = "VeryLazy",
        enabled = true,
        cond = function()
            return vim.fn.executable('wezterm') ~= 0
        end,
        config = function()
            local w = require('wezterm')
            w.setup({})
        end,
    },
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        ft = 'netrw',
        cmd = 'Neotree',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
            {
                's1n7ax/nvim-window-picker',
                version = '2.*',
                config = function()
                    require 'window-picker'.setup({
                        filter_rules = {
                            include_current_win = false,
                            autoselect_one = true,
                            -- filter using buffer options
                            bo = {
                                -- if the file type is one of following, the window will be ignored
                                filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                                -- if the buffer type is one of following, the window will be ignored
                                buftype = { 'terminal', "quickfix" },
                            },
                        },
                    })
                end,
            },
        },
        init = function()
            if vim.fn.argc(-1) == 1 then
                local stat = vim.uv.fs_stat(vim.fn.argv(0))
                if stat and stat.type == 'directory' then
                    require('neo-tree')
                end
            end
        end,
        opts = {
            window = {
                position = 'current',
            },
            sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
            open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble' },
            nesting_rules = {},
            filesystem = {
                hijack_netrw_behavior = 'open_current',
                filtered_items = {
                    visible = false, -- when true, they will just be displayed differently than normal items
                    hide_dotfiles = true,
                    hide_gitignored = true,
                    hide_hidden = true, -- only works on Windows for hidden files/directories
                    hide_by_name = {
                        --"node_modules"
                    },
                    hide_by_pattern = { -- uses glob style patterns
                        --"*.meta",
                        --"*/src/*/tsconfig.json",
                    },
                    always_show = { -- remains visible even if other settings would normally hide it
                        --".gitignored",
                    },
                    never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                        --".DS_Store",
                        --"thumbs.db"
                    },
                    never_show_by_pattern = { -- uses glob style patterns
                        --".null-ls_*",
                    },
                },
                follow_current_file = {
                    enabled = true,          -- This will find and focus the file in the active buffer every time
                    --               -- the current file is changed while the tree is open.
                    leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                },
                -- in whatever position is specified in window.position
                -- "open_current",  -- netrw disabled, opening a directory opens within the
                -- window like netrw would, regardless of window.position
                -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
                use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                -- instead of relying on nvim autocmd events.
            }
        },
        config = function(_, opts)
            require('neo-tree').setup()
        end,
        keys = {
            {
                "<leader>fe",
                function()
                    require("neo-tree.command").execute({ toggle = true, })
                end,
                desc = "Explorer NeoTree (root dir)",
            },
            {
                "<leader>fE",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
            { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)",      remap = true },
            {
                "<leader>ge",
                function()
                    require("neo-tree.command").execute({ source = "git_status", toggle = true })
                end,
                desc = "Git explorer",
            },
            {
                "<leader>be",
                function()
                    require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end,
                desc = "Buffer explorer",
            },
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        version = false,
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                enabled = vim.fn.executable('make') == 1,
                config = function()
                    require('telescope').load_extension('fzf')
                end,
            }
        },
        opts = function()
            local actions = require('telescope.actions')
            return {
                defaults = {
                    mappings = {
                    }
                },
                pickers = {
                    -- picker_name = {
                    --      picker_key = value,
                    -- }
                },
                extensions = {
                    -- extension_name = {
                    --      extension_key = value,
                    -- }


                }
            }
        end,
        config = function(_, opts)
            require('telescope').setup(opts)
        end,
        keys = {
            { '<leader>/',       '<cmd>Telescope live_grep<cr>',                                desc = 'Grep workspace' },
            { '<leader>:',       '<cmd>Telescope command_history<cr>',                          desc = 'Command History' },
            { '<leader><space>', '<Telescope find_files<cr>',                                   desc = 'Find files' },
            -- find
            { '<leader>fb',      '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', desc = 'Buffers' },
            { '<leader>fg',      '<cmd>Telescope git_files<cr>',                                desc = 'Find files (git-files)' },
            { '<leader>fg',      '<cmd>Telescope oldfiles<cr>',                                 desc = 'Recent' },
            -- git
            { '<leader>gc',      '<cmd>Telescope git_commits<cr>',                              desc = 'commits' },
            { '<leader>gs',      '<cmd>Telescope git_status<cr>',                               desc = 'status' },
            -- search
            { '<leader>s"',      "<cmd>Telescope registers<cr>",                                desc = "Registers" },
            { "<leader>sa",      "<cmd>Telescope autocommands<cr>",                             desc = "Auto Commands" },
            { "<leader>sb",      "<cmd>Telescope current_buffer_fuzzy_find<cr>",                desc = "Buffer" },
            { "<leader>sc",      "<cmd>Telescope command_history<cr>",                          desc = "Command History" },
            { "<leader>sC",      "<cmd>Telescope commands<cr>",                                 desc = "Commands" },
            { "<leader>sd",      "<cmd>Telescope diagnostics bufnr=0<cr>",                      desc = "Document diagnostics" },
            { "<leader>sD",      "<cmd>Telescope diagnostics<cr>",                              desc = "Workspace diagnostics" },
            { "<leader>sh",      "<cmd>Telescope help_tags<cr>",                                desc = "Help Pages" },
            { "<leader>sH",      "<cmd>Telescope highlights<cr>",                               desc = "Search Highlight Groups" },
            { "<leader>sk",      "<cmd>Telescope keymaps<cr>",                                  desc = "Key Maps" },
            { "<leader>sM",      "<cmd>Telescope man_pages<cr>",                                desc = "Man Pages" },
            { "<leader>sm",      "<cmd>Telescope marks<cr>",                                    desc = "Jump to Mark" },
            { "<leader>so",      "<cmd>Telescope vim_options<cr>",                              desc = "Options" },
            { "<leader>sR",      "<cmd>Telescope resume<cr>",                                   desc = "Resume" },
        }
    },
    {
        'folke/trouble.nvim',
        cmd = { 'TroubleToggle', 'Trouble' },
        opts = { use_diagnostic_signs = true },
        keys = {
            { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
            { "<leader>xL", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List (Trouble)" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").previous({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous trouble/quickfix item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next trouble/quickfix item",
            },
        }
    },
    {
        'folke/todo-comments.nvim',
        cmd = { "TodoTrouble", 'TodoTelescope' },
        config = true,
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
            { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
            { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
        },
    },
    {
        'mbbill/undotree'
    },
    {
        "echasnovski/mini.bufremove",
        keys = {
            {
                "<leader>bd",
                function()
                    local bd = require("mini.bufremove").delete
                    if vim.bo.modified then
                        local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()),
                            "&Yes\n&No\n&Cancel")
                        if choice == 1 then -- Yes
                            vim.cmd.write()
                            bd(0)
                        elseif choice == 2 then -- No
                            bd(0, true)
                        end
                    else
                        bd(0)
                    end
                end,
                desc = "Delete Buffer",
            },
            -- stylua: ignore
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
        },
    },
}
