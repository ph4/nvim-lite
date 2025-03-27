return {
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
        'akinsho/toggleterm.nvim',
        cmd = 'ToggleTerm',
        keys = { { '<leader><cr>', [[<Cmd>execute v:count . "ToggleTerm"<CR>]], mode = 'n', desc = 'Toggle terminal' } },
        opts = {
            shell = vim.fn.has('win32') == 1 and 'powershell' or nil,
            direction = 'horizontal',
        },
    },

}
