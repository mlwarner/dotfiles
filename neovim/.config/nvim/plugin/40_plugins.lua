-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘
--
-- This file contains installation and configuration of plugins outside of MINI.
-- They significantly improve user experience in a way not yet possible with MINI.
--
-- Use this file to install and configure other such plugins.

-- Make concise helpers for installing/adding plugins in two stages
local add = vim.pack.add
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Tree-sitter ================================================================
now_if_args(function()
    -- The main branch is under active development and has different conventions
    -- Define hook to update tree-sitter parsers after plugin is updated
    local ts_update = function() vim.cmd('TSUpdate') end
    Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

    add({
        'https://github.com/nvim-treesitter/nvim-treesitter',
        'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
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
        'terraform',
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
    Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')


    -- Disable injections in 'lua' language
    local ts_query = require('vim.treesitter.query')
    local ts_query_set = vim.fn.has('nvim-0.9') == 1 and ts_query.set or ts_query.set_query
    ts_query_set('lua', 'injections', '')
end)

-- Language servers ===========================================================
later(function()
    add({
        'https://github.com/neovim/nvim-lspconfig',
        'https://github.com/mason-org/mason.nvim',
        'https://github.com/mason-org/mason-lspconfig.nvim',
    })
    require('mason').setup()
    require("mason-lspconfig").setup {
        ensure_installed = {
            "harper_ls",
            "lua_ls",
            "marksman",
            "pyright",
            "rust_analyzer",
            "terraformls",
            "tsgo",
        },
    }

    -- not included in mason lsp config
    vim.lsp.enable('sourcekit')
end)

-- Completion =================================================================
later(function()
    -- use a release tag to download pre-built binaries
    add({
        { src = "https://github.com/rafamadriz/friendly-snippets" },
        { src = "https://github.com/saghen/blink.cmp",            version = "v1.9.1" },
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
        { src = "https://github.com/nvim-lua/plenary.nvim" },
        { src = "https://github.com/olimorris/codecompanion.nvim", version = "v19.3.0" },
    })

    require("codecompanion").setup({
        interactions = {
            chat = { adapter = "claude_code", },
        },
    })

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd([[cab cc CodeCompanion]])
end)

-- Utilities ==================================================================
later(function()
    local make = function() vim.cmd('make') end
    -- TODO run post checkout
    Config.on_packchanged('codesnap.nvim', { 'update' }, make)

    add({ { src = "https://github.com/mistricky/codesnap.nvim", version = "v1.6.3", } })
end)

later(function()
    add({
        "https://github.com/opdavies/toggle-checkbox.nvim"
    })
end)

-- now(function()
--     add({ 'https://github.com/rebelot/kanagawa.nvim' })
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
    add({ 'https://github.com/rose-pine/neovim' })

    require('rose-pine').setup()

    vim.cmd('colorscheme rose-pine')
end)
