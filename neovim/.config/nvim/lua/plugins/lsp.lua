return {
    "mason-org/mason-lspconfig.nvim",
    -- opts = {
    --     ensure_installed = {
    --         "harper_ls",
    --         "lua_ls",
    --         "marksman",
    --         "pyright",
    --         "rust_analyzer",
    --         -- not included in mason lsp config
    --         -- "sourcekit",
    --         "vtsls",
    --     },
    -- },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
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
    },
    config = function()
        require("mason-lspconfig").setup {
            ensure_installed = {
                "harper_ls",
                "lua_ls",
                "marksman",
                "pyright",
                "rust_analyzer",
                "vtsls",
            },
        }

        -- not included in mason lsp config
        vim.lsp.enable('sourcekit')
    end
}
