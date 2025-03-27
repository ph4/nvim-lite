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
        "vladdoster/remember.nvim",
        config = true,
    },
    {
        "rmagatti/auto-session",
    },
}
