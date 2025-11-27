-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘
--
-- This file contains installation and configuration of plugins outside of MINI.
-- They significantly improve user experience in a way not yet possible with MINI.
--
-- Use this file to install and configure other such plugins.

-- Make concise helpers for installing/adding plugins in two stages
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = _G.Config.now_if_args

-- Tree-sitter ================================================================
now_if_args(function()
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
    local languages = {
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
        'ruby',
        'rust',
        'swift',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml'
    }
    local isnt_installed = function(lang)
        return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
    end
    local to_install = vim.tbl_filter(isnt_installed, languages)
    if #to_install > 0 then require('nvim-treesitter').install(to_install) end

    -- Enable tree-sitter after opening a file for a target language
    local filetypes = {}
    for _, lang in ipairs(languages) do
        for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
            table.insert(filetypes, ft)
        end
    end
    local ts_start = function(ev) vim.treesitter.start(ev.buf) end
    _G.Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')


    -- Disable injections in 'lua' language
    local ts_query = require('vim.treesitter.query')
    local ts_query_set = vim.fn.has('nvim-0.9') == 1 and ts_query.set or ts_query.set_query
    ts_query_set('lua', 'injections', '')
end)

-- Language servers ===========================================================
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

-- Completion =================================================================
later(function()
    -- use a release tag to download pre-built binaries
    add({
        source = "saghen/blink.cmp",
        depends = { "rafamadriz/friendly-snippets" },
        checkout = "v1.8.0", -- check releases for latest tag
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

-- AI Assistants ==============================================================
later(function()
    add({
        source = "olimorris/codecompanion.nvim",
        checkout = "v17.33.0",
        depends = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        }
    })

    require("codecompanion").setup({
        strategies = {
            chat = {
                -- Use claude code subscription over API access
                adapter = "claude_code",
            },
            inline = {
                adapter = "anthropic",
                -- acp adapter not supported for inline
                -- adapter = "claude_code",
            },
        },
    })

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd([[cab cc CodeCompanion]])
end)

-- Utilities ==================================================================
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

-- now(function()
--     add({
--         source = 'rebelot/kanagawa.nvim'
--     })
--
--     require('kanagawa').setup({
--         colors = {
--             theme = {
--                 all = {
--                     ui = {
--                         bg_gutter = "none"
--                     }
--                 }
--             }
--         },
--         theme = "dragon",    -- vim.o.background = ""
--         background = {
--             dark = "dragon", -- vim.o.background = "dark"
--             light = "lotus"  -- vim.o.background = "light"
--         },
--         -- overrides = function(colors)
--         --     return {
--         --         BlinkCmpLabelDetail = { bg = colors.palette.dragonBlack3 },
--         --         BlinkCmpMenu = { bg = colors.palette.dragonBlack3 },
--         --         BlinkCmpMenuBorder = { bg = colors.palette.dragonBlack3 },
--         --         BlinkCmpMenuSelection = { bg = colors.palette.waveBlue1 },
--         --     }
--         -- end,
--     })
--     vim.cmd('colorscheme kanagawa')
-- end)

now(function()
    add({
        source = 'rose-pine/neovim'
    })
    require('rose-pine').setup()

    vim.cmd('colorscheme rose-pine')
end)
