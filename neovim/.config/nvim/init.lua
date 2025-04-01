-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader        = ' '
vim.g.maplocalleader   = ' '

-- [[ Setting options ]]
-- See `:help vim.opt`

-- General
vim.opt.undofile       = true  -- Enable persistent undo (see also `:h undodir`)

vim.opt.backup         = false -- Don't store backup while overwriting the file
vim.opt.writebackup    = false -- Don't store backup while overwriting the file

vim.opt.mouse          = 'a'   -- Enable mouse for all available modes

-- Appearance
vim.opt.breakindent    = true     -- Indent wrapped lines to match line start
vim.opt.cursorline     = true     -- Highlight current line
vim.opt.cursorlineopt  = 'number' -- Only highlight the current line number
vim.opt.linebreak      = true     -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.opt.number         = true     -- Show line numbers
vim.opt.relativenumber = true     -- Show relative line numbers
vim.opt.splitbelow     = true     -- Horizontal splits will be below
vim.opt.splitright     = true     -- Vertical splits will be to the right

vim.opt.ruler          = false    -- Don't show cursor position in command line
vim.opt.showmode       = false    -- Don't show mode in command line
vim.opt.wrap           = false    -- Display long lines as just one line

vim.opt.signcolumn     = 'yes'    -- Always show sign column (otherwise it will shift text)

-- See `:help statusline`
-- local statusline = {
--     ' ',
--     '%t',
--     '%r',
--     '%m',
--     '%=', -- separation point.
--     '%y',
--     ' ',
--     '%2p%%',
--     ' ',
--     '%3l:%-2c '
-- }
--
-- vim.o.statusline = table.concat(statusline, '')

-- Editing
vim.opt.ignorecase     = true                        -- Ignore case when searching (use `\C` to force not doing that)
vim.opt.incsearch      = true                        -- Show search results while typing
vim.opt.infercase      = true                        -- Infer letter cases for a richer built-in keyword completion
vim.opt.smartcase      = true                        -- Don't ignore case when searching if pattern has upper case
vim.opt.smartindent    = true                        -- Make indenting smart

vim.opt.completeopt    = 'menuone,noinsert,noselect' -- Customize completions
vim.opt.virtualedit    = 'block'                     -- Allow going past the end of line in visual block mode
vim.opt.formatoptions  = 'qjl1'                      -- Don't autoformat comments

-- Formatting. 4 spaces, no tabs
vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff      = 10

-- Diagnostics
-- See `:help vim.diagnostic.config()`
vim.diagnostic.config({
    underline = true,
    update_in_insert = false, -- Diagnostics are only updated when not entering text
    virtual_text = { current_line = true, severity = { min = "HINT", max = "WARN" } },
    virtual_lines = { current_line = true, severity = { min = "ERROR" } },
    severity_sort = true,
    -- default for vim.diagnostic.JumpOpts sets float to false
    jump = {
        float = true,
    }
})

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local map = vim.keymap.set

-- LSP
map("n", "gd", "<Cmd>Pick lsp scope='definition'<CR>", { desc = "Definitions" })
map("n", "gD", "<Cmd>Pick lsp scope='declaration'<CR>", { desc = "Declaration" })
map("n", "gr", "<Cmd>Pick lsp scope='references'<CR>", { desc = "References" })
map("n", "gI", "<Cmd>Pick lsp scope='implementation'<CR>", { desc = "Implementation" })
map("n", "gy", "<Cmd>Pick lsp scope='type_definition'<CR>", { desc = "Type Definitions" })

--- keymaps for builtin completion
--- https://gist.github.com/MariaSolOs/2e44a86f569323c478e5a078d0cf98cc
-----@param keys string
local function feedkeys(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

---Is the completion menu open?
local function pumvisible()
    return tonumber(vim.fn.pumvisible()) ~= 0
end

-- Use enter to accept completions.
vim.keymap.set('i', '<cr>', function()
    return pumvisible() and '<C-y>' or '<cr>'
end, { expr = true })

-- Use slash to dismiss the completion menu.
vim.keymap.set('i', '/', function()
    return pumvisible() and '<C-e>' or '/'
end, { expr = true })

-- Use <C-n> to navigate to the next completion or:
-- - Trigger LSP completion.
-- - If there's no one, fallback to vanilla omnifunc.
-- vim.keymap.set('i', '<C-n>', function()
--     if pumvisible() then
--         feedkeys '<C-n>'
--     else
--         if next(vim.lsp.get_clients { bufnr = 0 }) then
--             vim.lsp.completion.trigger()
--         else
--             if vim.bo.omnifunc == '' then
--                 feedkeys '<C-x><C-n>'
--             else
--                 feedkeys '<C-x><C-o>'
--             end
--         end
--     end
-- end, { desc = 'Trigger/select next completion' })

-- Buffer completions.
-- vim.keymap.set('i', '<C-u>', '<C-x><C-n>', { desc = 'Buffer completions' })

-- Use <Tab> to accept a Copilot suggestion, navigate between snippet tabstops,
-- or select the next completion.
-- Do something similar with <S-Tab>.
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
    if pumvisible() then
        feedkeys '<C-n>'
    elseif vim.snippet.active { direction = 1 } then
        vim.snippet.jump(1)
    else
        feedkeys '<Tab>'
    end
end, {})
vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
    if pumvisible() then
        feedkeys '<C-p>'
    elseif vim.snippet.active { direction = -1 } then
        vim.snippet.jump(-1)
    else
        feedkeys '<S-Tab>'
    end
end, {})

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'mail', 'markdown', 'text' },
    command = 'setlocal spell spelllang=en_us'
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
    -- Make pretty code snapshots
    { "mistricky/codesnap.nvim", build = "make" },
    -- {
    --     "Exafunction/codeium.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         -- "hrsh7th/nvim-cmp",
    --     },
    --     config = function()
    --         require("codeium").setup({
    --             enable_cmp_source = false,
    --             virtual_text = {
    --                 enabled = true,
    --             }
    --         })
    --     end
    -- },
    {
        "folke/snacks.nvim",
        enabled = false,
        priority = 1000,
        lazy = false,
        dependencies = {
            {
                "folke/todo-comments.nvim",
                opts = {},
                keys = {
                    { "<leader>st", function() Snacks.picker.todo_comments() end,                                          desc = "Todo" },
                    { "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
                },
            }
        },
        ---@type snacks.Config
        opts = {
            explorer = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
        },
        keys = {
            -- Top Pickers & Explorer
            { "<leader><space>", function() Snacks.picker.smart() end,           desc = "Smart Find Files" },
            { "<leader>,",       function() Snacks.picker.buffers() end,         desc = "Buffers" },
            { "<leader>/",       function() Snacks.picker.grep() end,            desc = "Grep" },
            { "<leader>:",       function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<leader>n",       function() Snacks.picker.notifications() end,   desc = "Notification History" },
            { "<leader>e",       function() Snacks.explorer() end,               desc = "File Explorer" },
            -- git
            { "<leader>gb",      function() Snacks.picker.git_branches() end,    desc = "Git Branches" },
            { "<leader>gl",      function() Snacks.picker.git_log() end,         desc = "Git Log" },
            { "<leader>gL",      function() Snacks.picker.git_log_line() end,    desc = "Git Log Line" },
            { "<leader>gs",      function() Snacks.picker.git_status() end,      desc = "Git Status" },
            { "<leader>gS",      function() Snacks.picker.git_stash() end,       desc = "Git Stash" },
            { "<leader>gd",      function() Snacks.picker.git_diff() end,        desc = "Git Diff (Hunks)" },
            { "<leader>gf",      function() Snacks.picker.git_log_file() end,    desc = "Git Log File" },
            -- Grep
            { "<leader>sb",      function() Snacks.picker.lines() end,           desc = "Buffer Lines" },
            { "<leader>sB",      function() Snacks.picker.grep_buffers() end,    desc = "Grep Open Buffers" },
            { "<leader>sg",      function() Snacks.picker.grep() end,            desc = "Grep" },
            { "<leader>sw",      function() Snacks.picker.grep_word() end,       desc = "Visual selection or word",      mode = { "n", "x" } },
            -- search
            { "<leader>sd",      function() Snacks.picker.diagnostics() end,     desc = "[S]earch [D]iagnostics" },
            { "<leader>sf",      function() Snacks.picker.files() end,           desc = "[S]earch [F]iles" },
            { "<leader>sh",      function() Snacks.picker.help() end,            desc = "[S]earch [H]elp" },
            { "<leader>sk",      function() Snacks.picker.keymaps() end,         desc = "[S]earch [K]eymaps" },
            { "<leader>sw",      function() Snacks.picker.grep_word() end,       desc = "[S]earch current [W]ord" },
            { "<leader>sr",      function() Snacks.picker.resume() end,          desc = "[S]earch [R]esume" },
            -- Other
            { "gz",              function() Snacks.zen() end,                    desc = "Toggle Zen Mode" },
            { "gZ",              function() Snacks.zen.zoom() end,               desc = "Toggle Zoom" },
            { "<leader>.",       function() Snacks.scratch() end,                desc = "Toggle Scratch Buffer" },
            { "<leader>S",       function() Snacks.scratch.select() end,         desc = "Select Scratch Buffer" },
            { "<leader>cR",      function() Snacks.rename.rename_file() end,     desc = "Rename File" },
            { "<c-/>",           function() Snacks.terminal() end,               desc = "Toggle Terminal" },
            { "<leader>ps",      function() Snacks.profiler.scratch() end,       desc = "Profiler Scratch Bufer" },
            { "<leader>pp",      function() Snacks.profiler.toggle() end,        desc = "Toggle the profiler" },
            { "<leader>ph",      function() Snacks.profiler.highlight() end,     desc = "Toggle the profiler highlights" },
        },
    },
    {
        -- Theme
        'ellisonleao/gruvbox.nvim',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.opt.termguicolors = true

            require('gruvbox').setup({
                contrast = 'hard',
                -- We can debug the text under the cursor using `lua vim.print(vim.treesitter.get_captures_under_cursor())`
                -- See `:help vim.treesitter`
                -- See palette colors in https://github.com/ellisonleao/gruvbox.nvim/blob/main/lua/gruvbox.lua#L73-L128
                palette_overrides = {
                    -- dark0 = "#1d2021", -- taken from `contrast = hard`
                },
                overrides = {
                    CursorLineNr = { bg = "#1d2021" }, -- Only highlight the number
                    SignColumn = { bg = "#1d2021" },   -- No constrast on sign column
                    MiniPickNormal = { link = "Normal" },
                },
            })
            vim.cmd.colorscheme 'gruvbox'
            -- vim.api.nvim_set_hl(0, "MiniPickNormal", { link = "Normal"}) -- Clear highlights
        end
    },
    {
        -- Theme
        'sainnhe/gruvbox-material',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_foreground = 'original'
            vim.g.gruvbox_material_background = 'hard'
            vim.cmd.colorscheme 'gruvbox-material'
        end
    },
    {
        -- Theme
        'rebelot/kanagawa.nvim',
        -- enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
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
            vim.cmd.colorscheme 'kanagawa'
        end
    },
    {
        -- Theme
        'rose-pine/neovim',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme 'rose-pine'
        end
    },
    { -- Collection of various small independent plugins/modules
        'echasnovski/mini.nvim',
        -- Add snippet repo for mini.snippets
        dependencies = { 'rafamadriz/friendly-snippets', },
        config = function()
            -- Common configuration presets
            require('mini.basics').setup()

            -- Align text interactively
            require('mini.align').setup()

            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Go forward/backward with square brackets
            -- require('mini.bracketed').setup()

            -- Comment lines
            -- require('mini.comment').setup()

            -- Autocompletion and signature help
            -- require('mini.completion').setup()

            -- Highlight usages of the word under the cursor
            require('mini.cursorword').setup()

            -- Work with diff hunks
            require('mini.diff').setup()

            -- file explorer
            require('mini.files').setup()
            vim.keymap.set('n', '<leader>e', function() require('mini.files').open() end,
                { desc = '[E]xplorer' })
            -- vim.api.nvim_create_autocmd("User", {
            --     pattern = "MiniFilesActionRename",
            --     callback = function(event)
            --         Snacks.rename.on_rename_file(event.data.from, event.data.to)
            --     end,
            -- })

            -- icon provider
            require('mini.icons').setup()

            -- Visualize and work with indent scope
            require('mini.indentscope').setup()

            -- Work with 'git'
            require('mini.git').setup()

            -- Highlight patterns in text
            local hipatterns = require('mini.hipatterns')
            hipatterns.setup({
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })

            -- Miscellaneous useful functions
            local miniMisc = require('mini.misc')
            vim.keymap.set('n', '<leader>z', function() miniMisc.zoom() end, { desc = 'Zoom window' })

            -- Move any selection in any direction
            require('mini.move').setup()

            -- Show notifications
            require('mini.notify').setup()

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require('mini.surround').setup()

            -- Simple and easy statusline.
            require('mini.statusline').setup()

            -- Trailspace (highlight and remove)
            require('mini.trailspace').setup()

            -- Track and reuse file system visits
            require('mini.visits').setup()
            vim.keymap.set('n', '<leader>vv', '<Cmd>Pick visit_labels<CR>', { desc = 'Visit labels' })
            vim.keymap.set('n', '<leader>va', '<Cmd>lua MiniVisits.add_label()<CR>', { desc = 'Add label' })
            vim.keymap.set('n', '<leader>vr', '<Cmd>lua MiniVisits.remove_label()<CR>', { desc = 'Remove label' })

            -- General purpose picker
            local MiniPick = require('mini.pick')
            local MiniExtra = require('mini.extra')

            MiniPick.setup()
            MiniExtra.setup()

            -- Override `vim.ui.select()`
            vim.ui.select = MiniPick.ui_select

            local builtin = MiniPick.builtin
            local builtinExtra = MiniExtra.pickers

            local notes_dir = vim.fs.normalize('~/Documents/my-notes')

            MiniPick.registry.notes = function(local_opts)
                local opts = { source = { cwd = notes_dir } }
                return MiniPick.builtin.files(local_opts, opts)
            end

            MiniPick.registry.notes_grep = function(local_opts)
                local opts = { source = { cwd = notes_dir } }
                return MiniPick.builtin.grep_live(local_opts, opts)
            end

            -- Top pickers
            vim.keymap.set('n', '<c-p>', builtin.files, { desc = 'find files' })
            vim.keymap.set('n', '<c-f>', builtin.grep_live, { desc = 'live grep' })
            vim.keymap.set('n', '<leader>,', builtin.buffers, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>/', builtinExtra.buf_lines, { desc = '[/] Fuzzily search in current buffer' })
            vim.keymap.set('n', '<leader>s.', builtinExtra.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            -- git
            vim.keymap.set('n', '<leader>gc', builtinExtra.git_commits, { desc = 'Git Commits' })
            vim.keymap.set('n', '<leader>gb', builtinExtra.git_branches, { desc = 'Git Branches' })
            vim.keymap.set('n', '<leader>gh', builtinExtra.git_hunks, { desc = 'Git Hunks' })
            -- grep
            vim.keymap.set('n', '<leader>sd', builtinExtra.diagnostic, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sg', builtin.grep_live, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sw', builtin.grep, { desc = '[S]earch current [W]ord' })
            -- search
            vim.keymap.set('n', '<leader>sf', builtin.files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>sh', builtin.help, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtinExtra.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>sv', builtinExtra.visit_paths, { desc = '[S]earch [V]isits' })
            -- notes
            vim.keymap.set('n', '<leader>wsf', '<cmd>Pick notes<cr>', { desc = '[W]iki [S]earch [F]iles' })
            vim.keymap.set('n', '<leader>wsg', '<cmd>Pick notes_grep<cr>', { desc = '[W]iki [S]earch by [G]rep' })

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
                    { mode = 'n', keys = '<Leader>s', desc = '+Search' },
                    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
                },
            })

            -- Manage and expand snippets
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
        end,
    },

    { import = 'plugins' },
}, {})

-- vim: ts=4 sts=4 sw=4 et
