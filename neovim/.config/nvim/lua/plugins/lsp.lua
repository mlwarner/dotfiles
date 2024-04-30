return {
    { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            { 'folke/neodev.nvim', opts = {} },
        },
        config = function()
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
            local servers = {
                marksman = {},
                rust_analyzer = {},
                tsserver = {},
                vale = {},
                vale_ls = {},

                lua_ls = {
                    settings = {
                        Lua = {
                            telemetry = { enable = false },
                            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
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
