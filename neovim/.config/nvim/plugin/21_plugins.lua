-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    -- The main branch is under active development and has different conventions
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        checkout = 'main',
        -- Perform action after every checkout
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })
    add({
        source = 'nvim-treesitter/nvim-treesitter-textobjects',
        checkout = 'main',
    })

    -- Ensure installed
    local ensure_installed = {
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
    }

    -- no-op if already installed
    require('nvim-treesitter').install(ensure_installed)

    -- Ensure enabled
    local filetypes = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable()
    local ts_start = function(ev) vim.treesitter.start(ev.buf) end
    vim.api.nvim_create_autocmd('FileType', { pattern = filetypes, callback = ts_start })
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
        checkout = "v1.5.0", -- check releases for latest tag
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

later(function()
    add({
        source = "jakobkhansen/journal.nvim"
    })
    local notes_dir = vim.fs.normalize('~/Documents/my-notes/journal')

    require('journal').setup({
        root = notes_dir,
        journal = {
            format = "%Y-%m-%d",
            template = "",
            entries = {
                day = {
                    format = "%Y-%m-%d",
                    template = "",
                }
            }
        }
    })
end)
