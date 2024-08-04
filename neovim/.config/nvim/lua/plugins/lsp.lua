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
            { 'folke/lazydev.nvim', opts = {} },
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
                    map({ 'n', 'v' }, 'gra', vim.lsp.buf.code_action, 'Code [A]ction')
                    map('i', '<C-s>', vim.lsp.buf.signature_help, '[S]ignature Help')

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map('n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map('n', 'gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('n', '<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('n', '<leader>ds', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('n', '<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, '[f]ormat')

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight',
                            { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                            end,
                        })
                    end

                    -- The following autocommand is used to enable inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map('n', '<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP Specification.
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local nvim_lsp = require('lspconfig')

            local servers = {
                denols = {
                    root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
                    single_file_support = true,
                },
                marksman = {},
                -- markdown_oxide = {},
                rust_analyzer = {},
                vale = {},
                vale_ls = {},
                tsserver = {
                    root_dir = nvim_lsp.util.root_pattern("package.json"),
                    single_file_support = false,
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                        javascript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                includeInlayVariableTypeHints = true,

                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                    },
                },

                lua_ls = {
                    settings = {
                        Lua = {
                            telemetry = { enable = false },
                            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                            hint = { enable = true },
                        },
                    },
                },
            }

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
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities,
                            server.capabilities or {})
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
