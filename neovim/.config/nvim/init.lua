-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.o`

-- General
vim.o.undofile       = true  -- Enable persistent undo (see also `:h undodir`)

vim.o.backup         = false -- Don't store backup while overwriting the file
vim.o.writebackup    = false -- Don't store backup while overwriting the file

vim.o.mouse          = 'a'   -- Enable mouse for all available modes

-- Appearance
vim.o.breakindent    = true         -- Indent wrapped lines to match line start
vim.o.cursorline     = true         -- Highlight current line
vim.o.cursorlineopt  = 'number'     -- Only highlight the current line number
vim.o.laststatus     = 3            -- Always show status line
vim.o.linebreak      = true         -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.number         = true         -- Show line numbers
vim.o.relativenumber = true         -- Show relative line numbers
vim.o.ruler          = false        -- Don't show cursor position in command line
vim.o.scrolloff      = 8            -- scroll context
vim.o.shortmess      = 'aoOtTWcCFS' -- Disable certain messages from |ins-completion-menu|
vim.o.showmode       = false        -- Don't show mode in command line
vim.o.sidescrolloff  = 8            -- line scroll context
vim.o.signcolumn     = 'yes'        -- Always show sign column (otherwise it will shift text)
vim.o.splitbelow     = true         -- Horizontal splits will be below
vim.o.splitright     = true         -- Vertical splits will be to the right
vim.o.wrap           = false        -- Display long lines as just one line

-- Editing
vim.o.cindent        = true                                    -- Or else comments do not indent in visualmode + > or <
vim.o.completeopt    = 'menuone,noinsert,noselect,popup,fuzzy' -- Customize completions
vim.o.expandtab      = true
vim.o.formatoptions  = 'rqnl1j'                                -- Improve comment editing
vim.o.ignorecase     = true                                    -- Ignore case when searching (use `\C` to force not doing that)
vim.o.incsearch      = true                                    -- Show search results while typing
vim.o.infercase      = true                                    -- Infer letter cases for a richer built-in keyword completion
vim.o.shiftwidth     = 4
vim.o.smartcase      = true                                    -- Don't ignore case when searching if pattern has upper case
vim.o.smartindent    = true                                    -- Make indenting smart
vim.o.softtabstop    = -1                                      -- Copy shiftwidth value
vim.o.tabstop        = 4
vim.o.virtualedit    = 'block'                                 -- Allow going past the end of line in visual block mode

-- Spelling
vim.o.spelllang      = 'en_us' -- Define spelling dictionaries
vim.o.spelloptions   = 'camel' -- Treat parts of camelCase words as separate words

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
local notes_dir = vim.fs.normalize('~/Documents/my-notes')

-- Copy/paste with system clipboard
map({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to system clipboard' })
map('n', 'gp', '"+p', { desc = 'Paste from system clipboard' })

-- Paste in Visual with `P` to not copy selected text (`:h v_P`)
map('x', 'gp', '"+P', { desc = 'Paste from system clipboard' })

-- Moves lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Navigate wrapped lines
map("n", "j", "gj")
map("n", "k", "gk")

-- mini.pick
-- Top pickers
-- map('n', '<c-p>', '<cmd>Pick files<cr>', { desc = 'find files' })
-- map('n', '<c-f>', '<cmd>Pick grep_live<cr>', { desc = 'live grep' })
-- map('n', '<leader>,', '<cmd>Pick buffers<cr>', { desc = '[ ] Find existing buffers' })
-- map('n', '<leader>/', '<cmd>Pick buf_lines<cr>', { desc = '[/] Fuzzily search in current buffer' })
-- map('n', '<leader>s.', '<cmd>Pick oldfiles<cr>', { desc = '[S]earch Recent Files ("." for repeat)' })

-- git
-- map('n', '<leader>gc', '<cmd>Pick git_commits<cr>', { desc = 'Git Commits' })
-- map('n', '<leader>gb', '<cmd>Pick git_branches<cr>', { desc = 'Git Branches' })
-- map('n', '<leader>gh', '<cmd>Pick git_hunks<cr>', { desc = 'Git Hunks' })

-- grep
-- map('n', '<leader>sd', '<cmd>Pick diagnostic<cr>', { desc = '[S]earch [D]iagnostics' })
-- map('n', '<leader>sg', '<cmd>Pick grep_live<cr>', { desc = '[S]earch by [G]rep' })
-- map('n', '<leader>sw', '<cmd>Pick grep<cr>', { desc = '[S]earch current [W]ord' })

-- search
-- map('n', '<leader>sf', '<cmd>Pick files<cr>', { desc = '[S]earch [F]iles' })
-- map('n', '<leader>sh', '<cmd>Pick help<cr>', { desc = '[S]earch [H]elp' })
-- map('n', '<leader>sk', '<cmd>Pick keymaps<cr>', { desc = '[S]earch [K]eymaps' })
-- map('n', '<leader>sr', '<cmd>Pick resume<cr>', { desc = '[S]earch [R]esume' })
-- map('n', '<leader>sv', '<cmd>Pick visit_paths<cr>', { desc = '[S]earch [V]isits' })

-- notes
-- map('n', '<leader>nsf', '<cmd>Pick notes<cr>', { desc = '[N]otes [S]earch [F]iles' })
-- map('n', '<leader>nsg', '<cmd>Pick notes_grep<cr>', { desc = '[N]otes [S]earch by [G]rep' })

-- LSP
map('n', 'grn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
map({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, { desc = '[G]oto Code [A]ction' })
-- map("n", "gO", "<Cmd>Pick lsp scope='document_symbol'<CR>", { desc = "Open document symbols" })
-- map("n", "gW", "<Cmd>Pick lsp scope='workspace_symbol'<CR>", { desc = "Open workspace symbols" })
-- map("n", "grr", "<Cmd>Pick lsp scope='references'<CR>", { desc = "[R]eferences" })
-- map("n", "gri", "<Cmd>Pick lsp scope='implementation'<CR>", { desc = "[I]mplementation" })
-- map("n", "grd", "<Cmd>Pick lsp scope='definition'<CR>", { desc = "[G]oto [D]efinition" })
-- map("n", "grD", "<Cmd>Pick lsp scope='declaration'<CR>", { desc = "[G]oto [D]eclaration" })
-- map("n", "grt", "<Cmd>Pick lsp scope='type_definition'<CR>", { desc = "[G]oto [T]ype Definition" })
map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { desc = '[F]ormat' })
map('n', '<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })) end,
    { desc = '[T]oggle Inlay [H]ints' })

-- mini.files
-- map('n', '<leader>e', function() require('mini.files').open() end, { desc = 'File [E]xplorer' })

-- mini.misc
-- map('n', '<leader>z', function() require('mini.misc').zoom() end, { desc = 'Zoom window' })

-- mini.visits
-- map('n', '<leader>vv', '<Cmd>Pick visit_labels<CR>', { desc = 'Visit labels' })
-- map('n', '<leader>va', '<Cmd>lua MiniVisits.add_label()<CR>', { desc = 'Add label' })
-- map('n', '<leader>vr', '<Cmd>lua MiniVisits.remove_label()<CR>', { desc = 'Remove label' })

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
-- map('i', '<cr>', function()
--     return pumvisible() and '<C-y>' or '<cr>'
-- end, { expr = true })

-- Use slash to dismiss the completion menu.
-- map('i', '/', function()
--     return pumvisible() and '<C-e>' or '/'
-- end, { expr = true })

-- Use <C-n> to navigate to the next completion or:
-- - Trigger LSP completion.
-- - If there's no one, fallback to vanilla omnifunc.
-- map('i', '<C-n>', function()
--     if pumvisible() then
--         feedkeys '<C-n>'
--     else
--         if next(vim.lsp.get_clients { bufnr = 0 }) then
--             vim.lsp.completion.get()
--         else
--             if vim.bo.omnifunc == '' then
--                 feedkeys '<C-x><C-n>'
--             else
--                 feedkeys '<C-x><C-o>'
--             end
--         end
--     end
-- end, { desc = 'Get/select next completion' })

-- Buffer completions.
-- map('i', '<C-u>', '<C-x><C-n>', { desc = 'Buffer completions' })

-- Use <Tab> to accept a Copilot suggestion, navigate between snippet tabstops,
-- or select the next completion.
-- Do something similar with <S-Tab>.
-- map({ 'i', 's' }, '<Tab>', function()
--     if pumvisible() then
--         feedkeys '<C-n>'
--     elseif vim.snippet.active { direction = 1 } then
--         vim.snippet.jump(1)
--     else
--         feedkeys '<Tab>'
--     end
-- end, {})
-- map({ 'i', 's' }, '<S-Tab>', function()
--     if pumvisible() then
--         feedkeys '<C-p>'
--     elseif vim.snippet.active { direction = -1 } then
--         vim.snippet.jump(-1)
--     else
--         feedkeys '<S-Tab>'
--     end
-- end, {})

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Enable spell checking in text files
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
    {
        "folke/snacks.nvim",
        -- enabled = false,
        priority = 1000,
        lazy = false,
        dependencies = {
            {
                "folke/todo-comments.nvim",
                opts = {
                    keywords = {
                        TODO = { alt = { "TK" } },
                    },
                },
                keys = {
                    { "<leader>st", function() Snacks.picker.todo_comments() end,                                                desc = "Todo" },
                    { "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "TK", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
                },
            }
        },
        ---@type snacks.Config
        opts = {
            explorer = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
        },
        keys = {
            -- Top Pickers & Explorer
            { "<leader><space>", function() Snacks.picker.smart() end,                    desc = "Smart Find Files" },
            { "<leader>,",       function() Snacks.picker.buffers() end,                  desc = "Buffers" },
            { "<leader>/",       function() Snacks.picker.grep() end,                     desc = "Grep" },
            { "<leader>:",       function() Snacks.picker.command_history() end,          desc = "Command History" },
            { "<leader>n",       function() Snacks.picker.notifications() end,            desc = "Notification History" },
            { "<leader>e",       function() Snacks.explorer() end,                        desc = "File Explorer" },
            -- git
            { "<leader>gb",      function() Snacks.picker.git_branches() end,             desc = "Git Branches" },
            { "<leader>gl",      function() Snacks.picker.git_log() end,                  desc = "Git Log" },
            { "<leader>gL",      function() Snacks.picker.git_log_line() end,             desc = "Git Log Line" },
            { "<leader>gs",      function() Snacks.picker.git_status() end,               desc = "Git Status" },
            { "<leader>gS",      function() Snacks.picker.git_stash() end,                desc = "Git Stash" },
            { "<leader>gd",      function() Snacks.picker.git_diff() end,                 desc = "Git Diff (Hunks)" },
            { "<leader>gf",      function() Snacks.picker.git_log_file() end,             desc = "Git Log File" },
            -- Grep
            { "<leader>sb",      function() Snacks.picker.lines() end,                    desc = "Buffer Lines" },
            { "<leader>sB",      function() Snacks.picker.grep_buffers() end,             desc = "Grep Open Buffers" },
            { "<leader>sg",      function() Snacks.picker.grep() end,                     desc = "Grep" },
            { "<leader>sw",      function() Snacks.picker.grep_word() end,                desc = "Visual selection or word",      mode = { "n", "x" } },
            -- search
            { "<leader>sd",      function() Snacks.picker.diagnostics() end,              desc = "[S]earch [D]iagnostics" },
            { "<leader>sf",      function() Snacks.picker.files() end,                    desc = "[S]earch [F]iles" },
            { "<leader>sh",      function() Snacks.picker.help() end,                     desc = "[S]earch [H]elp" },
            { "<leader>sk",      function() Snacks.picker.keymaps() end,                  desc = "[S]earch [K]eymaps" },
            { "<leader>sw",      function() Snacks.picker.grep_word() end,                desc = "[S]earch current [W]ord" },
            { "<leader>sr",      function() Snacks.picker.resume() end,                   desc = "[S]earch [R]esume" },
            -- notes
            { "<leader>nsf",     function() Snacks.picker.files({ cwd = notes_dir }) end, desc = "[N]otes [S]earch [F]iles" },
            { "<leader>nsg",     function() Snacks.picker.grep({ cwd = notes_dir }) end,  desc = "[N]otes [S]earch by [G]rep" },
            -- LSP
            { "gO",              function() Snacks.picker.lsp_symbols() end,              desc = "LSP Symbols" },
            { "gW",              function() Snacks.picker.lsp_workspace_symbols() end,    desc = "LSP Workspace Symbols" },
            { "grr",             function() Snacks.picker.lsp_references() end,           nowait = true,                          desc = "References" },
            { "gri",             function() Snacks.picker.lsp_implementations() end,      desc = "Goto Implementation" },
            { "grd",             function() Snacks.picker.lsp_definitions() end,          desc = "Goto Definition" },
            { "grD",             function() Snacks.picker.lsp_declarations() end,         desc = "Goto Declaration" },
            { "grt",             function() Snacks.picker.lsp_type_definitions() end,     desc = "Goto T[y]pe Definition" },
            -- Other
            { "gz",              function() Snacks.zen() end,                             desc = "Toggle Zen Mode" },
            { "gZ",              function() Snacks.zen.zoom() end,                        desc = "Toggle Zoom" },
            { "<leader>.",       function() Snacks.scratch() end,                         desc = "Toggle Scratch Buffer" },
            { "<leader>S",       function() Snacks.scratch.select() end,                  desc = "Select Scratch Buffer" },
            { "<leader>cR",      function() Snacks.rename.rename_file() end,              desc = "Rename File" },
            { "<leader>gb",      function() Snacks.git.blame_line() end,                  desc = "Git blame",                     mode = { "n", "v" } },
            { "<leader>gB",      function() Snacks.gitbrowse() end,                       desc = "Git Browse",                    mode = { "n", "v" } },
            { "<c-/>",           function() Snacks.terminal() end,                        desc = "Toggle Terminal" },
            { "<leader>ps",      function() Snacks.profiler.scratch() end,                desc = "Profiler Scratch Bufer" },
            { "<leader>pp",      function() Snacks.profiler.toggle() end,                 desc = "Toggle the profiler" },
            { "<leader>ph",      function() Snacks.profiler.highlight() end,              desc = "Toggle the profiler highlights" },
        },
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
            -- Align text interactively
            require('mini.align').setup()

            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Autocompletion and signature help
            -- require('mini.completion').setup({
            --     delay = {
            --         signature = 200,
            --     }
            -- })
            -- require('mini.icons').tweak_lsp_kind()

            -- Highlight usages of the word under the cursor
            -- require('mini.cursorword').setup()

            -- Work with diff hunks
            -- require('mini.diff').setup()

            -- file explorer
            -- require('mini.files').setup()
            -- vim.api.nvim_create_autocmd("User", {
            --     pattern = "MiniFilesActionRename",
            --     callback = function(event)
            --         Snacks.rename.on_rename_file(event.data.from, event.data.to)
            --     end,
            -- })

            -- icon provider
            require('mini.icons').setup()

            -- Visualize and work with indent scope
            -- require('mini.indentscope').setup()

            -- Work with 'git'
            -- require('mini.git').setup()

            -- Highlight patterns in text
            -- local hipatterns = require('mini.hipatterns')
            -- hipatterns.setup({
            --     highlighters = {
            --         -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            --         fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
            --         hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
            --         tk        = { pattern = '%f[%w]()TK()%f[%W]', group = 'MiniHipatternsTodo' },
            --         todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
            --         note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
            --
            --         -- Highlight hex color strings (`#rrggbb`) using that color
            --         hex_color = hipatterns.gen_highlighter.hex_color(),
            --     },
            -- })

            -- Miscellaneous useful functions
            require('mini.misc')

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

            -- General purpose picker
            -- local MiniPick = require('mini.pick')
            -- local MiniExtra = require('mini.extra')
            --
            -- MiniPick.setup()
            -- MiniExtra.setup()

            -- Override `vim.ui.select()`
            -- vim.ui.select = MiniPick.ui_select
            --
            -- local notes_dir = vim.fs.normalize('~/Documents/my-notes')
            --
            -- MiniPick.registry.notes = function(local_opts)
            --     local opts = { source = { cwd = notes_dir } }
            --     return MiniPick.builtin.files(local_opts, opts)
            -- end
            --
            -- MiniPick.registry.notes_grep = function(local_opts)
            --     local opts = { source = { cwd = notes_dir } }
            --     return MiniPick.builtin.grep_live(local_opts, opts)
            -- end

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
                    { mode = 'n', keys = '<Leader>g', desc = '[G]it' },
                    { mode = 'n', keys = '<Leader>n', desc = '[N]otes' },
                    { mode = 'n', keys = '<Leader>s', desc = '[S]earch' },
                    { mode = 'n', keys = '<Leader>t', desc = '[T]oggle' },
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
