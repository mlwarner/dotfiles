-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        -- Use 'master' while monitoring updates in 'main'
        checkout = 'master',
        monitor = 'main',
        -- Perform action after every checkout
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })
    require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
            'bash',
            'c_sharp',
            'css',
            'diff',
            'html',
            'javascript',
            'jsdoc',
            'json',
            'lua',
            'markdown',
            'markdown_inline',
            'perl',
            'python',
            'regex',
            'rust',
            'swift',
            'tsx',
            'typescript',
            'vim',
            'vimdoc',
        },

        -- Autoinstall languages that are not installed.
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    }
end)

later(function()
    add({
        source = 'mason-org/mason-lspconfig.nvim',
        depends = {
            'mason-org/mason.nvim',
            'neovim/nvim-lspconfig',
        }
    })
    require('mason').setup()
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
end)

later(function()
    -- use a release tag to download pre-built binaries
    add({
        source = "saghen/blink.cmp",
        depends = { "rafamadriz/friendly-snippets" },
        checkout = "v1.4.1", -- check releases for latest tag
    })
    require('blink.cmp').setup({
        keymap = { preset = 'default' },

        completion = {
            -- Disable showing for all alphanumeric keywords by default. Prefer LSP specific trigger
            -- characters.
            -- trigger = { show_on_keyword = false },
            -- Controls whether the documentation window will automatically show when selecting a completion item
            documentation = { auto_show = true },
        },

        signature = { enabled = true },
    })
end)

later(function()
    add({
        source = "olimorris/codecompanion.nvim",
        depends = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        }
    })
    require("codecompanion").setup({
        display = {
            action_palette = {
                provider = "snacks",
            },
        },
        strategies = {
            chat = {
                adapter = "anthropic",
            },
            inline = {
                adapter = "anthropic",
            },
        },
    })
    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd([[cab cc CodeCompanion]])
end)

later(function()
    add({
        source = "mistricky/codesnap.nvim",
        hooks = {
            post_checkout = function()
                vim.cmd('make')
            end
        }
    })
end)

later(function()
    add({
        source = "opdavies/toggle-checkbox.nvim"
    })
end)
