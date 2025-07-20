local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Use 'HEAD' because I personally update it and don't want to follow `main`
-- This means that 'start/mini.nvim' will usually be present twice in
-- 'runtimepath' as there is a '.../pack/*/start/*' entry there.
add({ name = 'mini.nvim', checkout = 'HEAD' })

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

now(function()
    require('mini.notify').setup()
    vim.notify = require('mini.notify').make_notify()
end)

now(function() require('mini.sessions').setup() end)

-- now(function() require('mini.starter').setup() end)

now(function() require('mini.statusline').setup() end)

-- Lazy load -------------------------------------

later(function() require('mini.extra').setup() end)

later(function()
    local ai = require('mini.ai')
    ai.setup({
        custom_textobjects = {
            B = MiniExtra.gen_ai_spec.buffer(),
            F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
            o = ai.gen_spec.treesitter({
                a = { '@conditional.outer', '@loop.outer' },
                i = { '@conditional.inner', '@loop.inner' },
            })
        },
    })
end)

later(function() require('mini.align').setup() end)

later(function()
    -- Show next key clues
    local miniclue = require('mini.clue')
    miniclue.setup({
        triggers = {
            -- Leader triggers
            { mode = 'n', keys = '<Leader>' },
            { mode = 'x', keys = '<Leader>' },

            -- Built-in completion
            { mode = 'i', keys = '<C-x>' },

            -- `g` key
            { mode = 'n', keys = 'g' },
            { mode = 'x', keys = 'g' },

            -- Marks
            { mode = 'n', keys = "'" },
            { mode = 'n', keys = '`' },
            { mode = 'x', keys = "'" },
            { mode = 'x', keys = '`' },

            -- Registers
            { mode = 'n', keys = '"' },
            { mode = 'x', keys = '"' },
            { mode = 'i', keys = '<C-r>' },
            { mode = 'c', keys = '<C-r>' },

            -- Window commands
            { mode = 'n', keys = '<C-w>' },

            -- `z` key
            { mode = 'n', keys = 'z' },
            { mode = 'x', keys = 'z' },
        },

        clues = {
            -- Enhance this by adding descriptions for <Leader> mapping groups
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
            { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
            { mode = 'n', keys = '<Leader>e', desc = '+Explore' },
            { mode = 'n', keys = '<Leader>g', desc = '+Git' },
            { mode = 'n', keys = '<Leader>n', desc = '+Notes' },
            { mode = 'n', keys = '<Leader>o', desc = '+Other' },
            { mode = 'n', keys = '<Leader>s', desc = '+Search' },
            { mode = 'n', keys = '<Leader>v', desc = '+Visits' },
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
    local notes_dir = vim.fs.normalize('~/Documents/my-notes')

    MiniPick.registry.notes = function(local_opts)
        local opts = { source = { cwd = notes_dir } }
        return MiniPick.builtin.files(local_opts, opts)
    end

    MiniPick.registry.notes_grep = function(local_opts)
        local opts = { source = { cwd = notes_dir } }
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
