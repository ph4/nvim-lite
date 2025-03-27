return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup_handlers {
                function (server_name)
                    require("lspconfig")[server_name].setup {on_attach =
                    function(_client, bufnr)
                        --local builtins = require 'telescope.builtin'
                        require('which-key').register({
                            ['[d'] = { vim.diagnostic.goto_prev, 'Previous diagnostic' },
                            [']d'] = { vim.diagnostic.goto_next, 'Next diagnostic' },
                            ['[e'] = { vim.diagnostic.goto_prev, 'Previous diagnostic' },
                            [']e'] = { vim.diagnostic.goto_next, 'Next diagnostic' },
                            ['gD'] = { vim.lsp.buf.declaration, 'Go to declaration' },
                            ['gd'] = { vim.lsp.buf.definition, 'Go to definition' },
                            ['gr'] = { vim.lsp.buf.references, 'Go to references' },
                            ['gi'] = { vim.lsp.buf.implementation, 'Go to implementation' },
                            ['gt'] = { vim.lsp.buf.type_definition, 'Go to type definition' },
                            ['K'] = { vim.lsp.buf.hover, 'Document hover' },
                            --['<C-k>'] = { vim.lsp.buf.signature_help, "Signature help" },

                            ['<leader>'] = {
                                -- ['-'] = { M.toggle_lsplines, 'Toggle lsplines' },
                                ['r'] = { vim.lsp.buf.rename, 'Rename symbol' },
                                -- ['r'] = { [[:IncRename ]], 'Rename symbol' },
                                ['l'] = {
                                    ['d'] = { vim.diagnostic.setloclist, 'Document diagnostics' },
                                    -- ['a'] = { as.bind(vim.lsp.buf.code_action, { context = { _only = { 'refactor' } } }), 'Code action' },
                                    ['a'] = { vim.lsp.buf.code_action, 'Code action' },
                                    --['a'] = { [[<cmd>CodeActionMenu<cr>]], "Code action" },
                                    ['c'] = { vim.lsp.codelens.run, 'Run code lens' },
                                    ['t'] = { vim.lsp.buf.type_definition, 'Go to type definition' },
                                    ['r'] = { vim.lsp.buf.rename, 'Rename symbol' },
                                    ['f'] = { function() vim.lsp.buf.format { async = true } end, 'Format file' },
                                    ['l'] = { vim.diagnostic.open_float, 'Line diagnostics' },
                                    ['s'] = { [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]], 'Document symbols' },
                                    ['p'] = {
                                        function()
                                            local params = vim.lsp.util.make_position_params()
                                            local cb = function(_, result)
                                                if result == nil or vim.tbl_isempty(result) then return nil end
                                                vim.lsp.util.preview_location(result[1], { border = as.lsp.borders })
                                            end
                                            return vim.lsp.buf_request(0, 'textDocument/definition', params, cb)
                                        end,
                                        'Peek definition',
                                    },

                                    ['w'] = { name = 'Workspace' },
                                    ['wa'] = { vim.lsp.buf.add_workspace_folder, 'Add folder to workspace' },
                                    ['wr'] = { vim.lsp.buf.remove_workspace_folder, 'Remove folder from workspace' },
                                    ['wd'] = { vim.lsp.diagnostic.set_qflist, 'Workspace diagnostics' },
                                    --['ws'] = { builtins.lsp_workspace_symbols, "Workspace symbols" },
                                    ['wl'] = {
                                        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
                                        'List workspace folders',
                                    },
                                },
                            },
                        }, { mode = 'n', buffer = bufnr })
                    end
                }
                end,
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup {
                        settings = {
                            Lua = {
                                runtime = { version = 'LuaJIT' },
                                diagnostics = {
                                    globals = { 'vim', 'as' },
                                    unusedLocalExclude = { '_*' },
                                },
                                workspace = {
                                    checkThirdParty = false,
                                    library = vim.api.nvim_get_runtime_file('', true),
                                    maxPreload = 10000,
                                    preloadFileSize = 50000,
                                },
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                }
                end
                -- ["rust_analyzer"] = function ()
                --     require("rust-tools").setup {}
                -- end
            }
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        version = false, --last release is old
        dependencies = {
            "L3MON4D3/LuaSnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "onsails/lspkind.nvim",
        },
        opts = function ()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            return {
                sources = cmp.config.sources({
                    { name = "codeium" },
                }),
                formatting = {
                    format = lspkind.cmp_format { with_text = true, maxwidth = 50 },
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<down>'] = cmp.mapping.select_next_item(),
                    ['<up>'] = cmp.mapping.select_prev_item(),
                    ['<C-j>'] = cmp.mapping.select_next_item(),
                    ['<C-k>'] = cmp.mapping.select_prev_item(),
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm {
                                behavior = cmp.ConfirmBehavior.Insert,
                                select = true,
                            }
                        elseif luasnip.expandable() then
                            luasnip.expand {}
                        else
                            fallback()
                        end
                    end),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm {
                                behavior = cmp.ConfirmBehavior.Insert,
                                select = true,
                            }
                        elseif luasnip.expandable() then
                            luasnip.expand {}
                        else
                            fallback()
                        end
                    end),
                }
            }
            end
        },
    {
        "Exafunction/codeium.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
            })
        end
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
}
