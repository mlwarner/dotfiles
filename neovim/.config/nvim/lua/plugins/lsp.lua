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
                -- dev = true,
                dependencies = { 'rafamadriz/friendly-snippets', },
                version = 'v0.*',
                opts = {
                    keymap = { preset = 'default' },

                    completion = {
                        -- Controls whether the documentation window will automatically show when selecting a completion item
                        documentation = { auto_show = true },
                    },

                    signature = { enabled = true },

                    appearance = {
                        use_nvim_cmp_as_default = true,
                        nerd_font_variant = 'mono'
                    },

                },
            },
        },
        config = function()
            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(mode, keys, func, desc)
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Defaults in nvim >= 0.10
                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap.
                    map('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')

                    -- Taken from defaults in nvim >= 0.11
                    -- https://github.com/neovim/neovim/blob/master/runtime/doc/news.txt#L103
                    map('n', 'grn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('n', 'grr', vim.lsp.buf.references, '[R]efe[r]ences')
                    map('n', 'gri', vim.lsp.buf.implementation, '[I]mplementation')
                    map('n', 'gO', vim.lsp.buf.document_symbol, 'D[o]cument symbol')
                    map({ 'n', 'v' }, 'gra', vim.lsp.buf.code_action, 'Code [A]ction')
                    map({ 'i', 's' }, '<C-s>', vim.lsp.buf.signature_help, '[S]ignature Help')

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map('n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('n', '<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('n', '<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, '[f]ormat')

                    -- The following autocommand is used to enable inlay hints in your
                    -- code, if the language server you are using supports them
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map('n', '<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, '[T]oggle Inlay [H]ints')
                    end

                    -- built in completion in nvim-0.11+, still has some limitations compared to other clients:
                    -- 1. Only triggers on autotrigger characters by default (e.g. '[', '{', '.', etc). Most plugins
                    -- auto trigger on any text entry
                    -- 2. If autotrigger doesn't activate, manually triggering via `vim.lsp.completion.trigger` doesn't
                    -- seem to consider the current cursor position and has to adjust.
                    --  - I found while using it I didn't mind manual triggers, I just disliked that it didn't consider
                    -- 3. Doesn't show function docs while completing.
                    --  my cursor position.
                    -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
                    --     if vim.fn.has('nvim-0.11') then
                    --         vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
                    --     end
                    -- end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

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
