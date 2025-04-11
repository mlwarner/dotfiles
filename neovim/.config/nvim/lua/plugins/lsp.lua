return {
    { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- lazydev.nvim is a plugin that properly configures LuaLS for editing your Neovim config by
            -- lazily updating your workspace libraries.
            {
                'folke/lazydev.nvim',
                ft = 'lua',
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                }
            },

            {
                'saghen/blink.cmp',
                enabled = false,
                -- dev = true,
                dependencies = { 'rafamadriz/friendly-snippets', },
                version = '1.*',
                opts = {
                    keymap = { preset = 'default' },

                    completion = {
                        -- Disable showing for all alphanumeric keywords by default. Prefer LSP specific trigger
                        -- characters.
                        -- trigger = { show_on_keyword = false },
                        -- Controls whether the documentation window will automatically show when selecting a completion item
                        documentation = { auto_show = true },
                    },

                    signature = { enabled = true },
                },
            },
        },
        config = function()
            -- vim.api.nvim_create_autocmd('LspAttach', {
            --     callback = function(args)
            --         local map = function(mode, keys, func, desc)
            --             vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            --         end
            --
            --         ---[[Code required to activate autocompletion and trigger it on each keypress
            --         local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            --         client.server_capabilities.completionProvider.triggerCharacters = vim.split("qwertyuiopasdfghjklzxcvbnm. ", "")
            --         vim.api.nvim_create_autocmd({ 'TextChangedI' }, {
            --             buffer = args.buf,
            --             callback = function()
            --                 vim.lsp.completion.get()
            --             end
            --         })
            --         vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
            --         ---]]
            --
            --         ---[[Code required to add documentation popup for an item
            --         local _, cancel_prev = nil, function() end
            --         vim.api.nvim_create_autocmd('CompleteChanged', {
            --             buffer = args.buf,
            --             callback = function()
            --                 cancel_prev()
            --                 local info = vim.fn.complete_info({ 'selected' })
            --                 local completionItem = vim.tbl_get(vim.v.completed_item, 'user_data', 'nvim', 'lsp',
            --                     'completion_item')
            --                 if nil == completionItem then
            --                     return
            --                 end
            --                 _, cancel_prev = vim.lsp.buf_request(args.buf,
            --                     vim.lsp.protocol.Methods.completionItem_resolve,
            --                     completionItem,
            --                     function(err, item, ctx)
            --                         if not item then
            --                             return
            --                         end
            --                         local docs = (item.documentation or {}).value
            --                         local win = vim.api.nvim__complete_set(info['selected'], { info = docs })
            --                         if win.winid and vim.api.nvim_win_is_valid(win.winid) then
            --                             vim.treesitter.start(win.bufnr, 'markdown')
            --                             vim.wo[win.winid].conceallevel = 3
            --                         end
            --                     end)
            --             end
            --         })
            --     end
            -- })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
            -- local capabilities = require('blink.cmp').get_lsp_capabilities()

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                harper_ls = {
                    settings = {
                        ["harper-ls"] = {
                            userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
                        }
                    },
                },
                marksman = {},
                -- markdown_oxide = {},
                rust_analyzer = {},
                -- vale = {},
                -- vale_ls = {},
                vtsls = {
                    settings = {
                        complete_function_calls = true,
                        vtsls = {
                            enableMoveToFileCodeAction = true,
                            autoUseWorkspaceTsdk = true,
                            experimental = {
                                completion = {
                                    enableServerSideFuzzyMatch = true,
                                },
                            },
                        },
                        javascript = {
                            updateImportsOnFileMove = { enabled = "always" },
                            suggest = {
                                completeFunctionCalls = true,
                            },
                            inlayHints = {
                                enumMemberValues = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                parameterNames = { enabled = "literals" },
                                parameterTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                variableTypes = { enabled = false },
                            },
                        },
                        typescript = {
                            updateImportsOnFileMove = { enabled = "always" },
                            suggest = {
                                completeFunctionCalls = true,
                            },
                            inlayHints = {
                                enumMemberValues = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                parameterNames = { enabled = "literals" },
                                parameterTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                variableTypes = { enabled = false },
                            },
                        },
                    },
                },

                lua_ls = {
                    settings = {
                        Lua = {
                            telemetry = { enable = false },
                            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            diagnostics = { disable = { 'missing-fields' } },
                            hint = { enable = true },
                        },
                    },
                },
            }

            -- Special formatted fields cannot be set above
            servers.vtsls.settings['js/ts'] = { implicitProjectConfig = { checkJs = true } }

            require('mason').setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for tsserver)
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }

            require('lspconfig').sourcekit.setup({
                capabilities = capabilities,
                single_file_support = true
            })
        end,
    },
}
