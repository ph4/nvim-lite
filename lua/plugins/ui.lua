return {
    { "Aliqyan-21/darkvoid.nvim" },
    {
        "zenbones-theme/zenbones.nvim",
        dependencies = "rktjmp/lush.nvim"
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = true,
        event = 'VeryLazy',
        keys = {
            { '<Tab>', [[<cmd>BufferLineCycleNext<CR>]] },
            { '<S-Tab>', [[<cmd>BufferLineCyclePrev<CR>]] },
            { '<S-l>', [[<cmd>BufferLineCycleNext<CR>]] },
            { '<S-h>', [[<cmd>BufferLineCyclePrev<CR>]] },
            { '<]b>', [[<cmd>BufferLineCycleNext<CR>]] },
            { '<[b>', [[<cmd>BufferLineCyclePrev<CR>]] },
            { '<leader>bb', '<cmd>e #<cr>', desc = 'Switch to Other Buffer' },
            { '<leader>`', '<cmd>e #<cr>', desc = 'Switch to Other Buffer' },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            {
                's1n7ax/nvim-window-picker',
                version = '2.*',
                config = function()
                    require 'window-picker'.setup({
                        hint = "floating-big-letter",
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
        keys = {
            {"<leader>e", "<CMD>Neotree toggle<CR>", desc = "NeoTree"}
        },
        config = {
            window = {
                width = 32
            }
        }
    },
    {
        "vladdoster/remember.nvim",
        config = true,
    }

}
