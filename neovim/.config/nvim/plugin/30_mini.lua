-- ┌────────────────────┐
-- │ MINI configuration │
-- └────────────────────┘
--
-- This file contains configuration of the MINI parts of the config.
-- It contains only configs for the 'mini.nvim' plugin (installed in 'init.lua').
--
-- 'mini.nvim' is a library of modules. Each is enabled independently via
-- `require('mini.xxx').setup()` convention. It creates all intended side effects:
-- mappings, autocommands, highlight groups, etc. It also creates a global
-- `MiniXxx` table that can be later used to access module's features.
--
-- See `:h mini.nvim-general-principles` for more general principles.

-- To minimize the time until first screen draw, modules are enabled in two steps:
-- - Step one enables everything that is needed for first draw with `now()`.
-- - Everything else is delayed until the first draw with `later()`.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = _G.Config.now_if_args

-- Step one ===================================================================
-- Load immediately -----------------------------

now(function()
    add({
        source = 'rebelot/kanagawa.nvim'
    })

    require('kanagawa').setup({
        colors = {
            theme = {
                all = {
                    ui = {
                        bg_gutter = "none"
                    }
                }
            }
        },
        theme = "dragon",    -- vim.o.background = ""
        background = {
            dark = "dragon", -- vim.o.background = "dark"
            light = "lotus"  -- vim.o.background = "light"
        },
    })
    vim.cmd('colorscheme kanagawa')

    -- Builtin colorschemes
    -- vim.cmd('colorscheme retrobox')
    -- vim.cmd('colorscheme default')
end)

now(function()
    require('mini.basics').setup({
        -- Manage options manually in a spirit of transparency
        options = { basic = false },
        mappings = { windows = true, move_with_alt = true },
        autocommands = { relnum_in_visual_mode = true },
    })
end)

now(function() require('mini.files').setup({ windows = { preview = true } }) end)

now(function()
    require('mini.icons').setup()
    later(MiniIcons.mock_nvim_web_devicons)
    later(MiniIcons.tweak_lsp_kind)
end)

now(function() require('mini.notify').setup() end)

now(function() require('mini.sessions').setup() end)

now(function()
    local starter = require("mini.starter")
    starter.setup({
        evaluate_single = true,
        footer = os.date(),
        items = {
            starter.sections.pick(),
            starter.sections.sessions(),
            starter.sections.builtin_actions(),
        },
    })
end)

now(function() require('mini.statusline').setup() end)

-- Step two ===================================================================
-- Lazy load -------------------------------------

later(function() require('mini.extra').setup() end)

later(function()
    local ai = require('mini.ai')
    local gen_ai_spec = MiniExtra.gen_ai_spec
    ai.setup({
        custom_textobjects = {
            B = gen_ai_spec.buffer(),
            D = gen_ai_spec.diagnostic(),
            F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
            I = gen_ai_spec.indent(),
            L = gen_ai_spec.line(),
            N = gen_ai_spec.number(),
            o = ai.gen_spec.treesitter({
                a = { '@conditional.outer', '@loop.outer' },
                i = { '@conditional.inner', '@loop.inner' },
            }),
        },
    })
end)

later(function() require('mini.align').setup() end)

later(function()
    -- Show next key clues. Example usage:
    -- - Press `<Leader>` and wait for 1 second. A window with information about
    --   next available keys should appear.
    -- - Press one of the listed keys. Window updates immediately to show information
    --   about new next available keys. You can press `<BS>` to go back in key sequence.
    -- - Press keys until they resolve into some mapping.
    --
    -- See also:
    -- - `:h MiniClue-examples` - examples of common setups
    local miniclue = require('mini.clue')
    -- stylua: ignore
    miniclue.setup({
        -- Define which clues to show. By default shows only clues for custom mappings
        -- (uses `desc` field from the mapping; takes precedence over custom clue).
        clues = {
            -- This is defined in 'plugin/20_keymaps.lua' with Leader group descriptions
            Config.leader_group_clues,
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
        },
        -- Explicitly opt-in for set of common keys to trigger clue window
        triggers = {
            { mode = 'n', keys = '<Leader>' }, -- Leader triggers
            { mode = 'x', keys = '<Leader>' },
            { mode = 'n', keys = '[' },        -- mini.bracketed
            { mode = 'n', keys = ']' },
            { mode = 'x', keys = '[' },
            { mode = 'x', keys = ']' },
            { mode = 'i', keys = '<C-x>' },    -- Built-in completion
            { mode = 'n', keys = 'g' },        -- `g` key
            { mode = 'x', keys = 'g' },
            { mode = 'n', keys = "'" },        -- Marks
            { mode = 'n', keys = '`' },
            { mode = 'x', keys = "'" },
            { mode = 'x', keys = '`' },
            { mode = 'n', keys = '"' },        -- Registers
            { mode = 'x', keys = '"' },
            { mode = 'i', keys = '<C-r>' },
            { mode = 'c', keys = '<C-r>' },
            { mode = 'n', keys = '<C-w>' },    -- Window commands
            { mode = 'n', keys = 'z' },        -- `z` key
            { mode = 'x', keys = 'z' },
        },
    })
end)

later(function() require('mini.comment').setup() end)

later(function() require('mini.cursorword').setup() end)

later(function() require('mini.diff').setup() end)

later(function() require('mini.git').setup() end)

later(function()
    local hipatterns = require('mini.hipatterns')
    local hi_words = MiniExtra.gen_highlighter.words
    hipatterns.setup({
        highlighters = {
            fixme     = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
            hack      = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
            tk        = hi_words({ 'TK', 'Tk', 'tk' }, 'MiniHipatternsTodo'),
            todo      = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
            note      = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end)

later(function() require('mini.indentscope').setup() end)

later(function() require('mini.misc').setup() end)

later(function() require('mini.move').setup() end)

later(function() require('mini.pairs').setup({ modes = { insert = true, command = true, terminal = true } }) end)

later(function()
    -- Pick anything
    require('mini.pick').setup()
    vim.ui.select = MiniPick.ui_select

    -- Expects daily notes to be setup
    dailyNotes = require('daily-notes')

    MiniPick.registry.notes = function(local_opts)
        local opts = { source = { cwd = dailyNotes.get_notes_dir() } }
        return MiniPick.builtin.files(local_opts, opts)
    end

    MiniPick.registry.notes_grep = function(local_opts)
        local opts = { source = { cwd = dailyNotes.get_notes_dir() } }
        return MiniPick.builtin.grep_live(local_opts, opts)
    end
end)

later(function()
    local gen_loader = require('mini.snippets').gen_loader
    require('mini.snippets').setup({
        -- Use Neovim's built-in snippet expansion
        expand = {
            insert = function(snippet, _) vim.snippet.expand(snippet.body) end
        },
        snippets = {
            -- Load custom file with global snippets first (adjust for Windows)
            gen_loader.from_file('~/.config/nvim/snippets/global.json'),

            -- Load snippets based on current language by reading files from
            -- "snippets/" subdirectories from 'runtimepath' directories.
            gen_loader.from_lang(),
        },
    })
    -- Make jump mappings or skip to use built-in <Tab>/<S-Tab> in Neovim>=0.11
    local jump_next = function()
        if vim.snippet.active({ direction = 1 }) then return vim.snippet.jump(1) end
    end
    local jump_prev = function()
        if vim.snippet.active({ direction = -1 }) then vim.snippet.jump(-1) end
    end
    vim.keymap.set({ 'i', 's' }, '<C-l>', jump_next)
    vim.keymap.set({ 'i', 's' }, '<C-h>', jump_prev)
end)

later(function() require('mini.surround').setup() end)

later(function() require('mini.trailspace').setup() end)

later(function() require('mini.visits').setup() end)
