-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt`

-- General
vim.opt.undofile    = true  -- Enable persistent undo (see also `:h undodir`)

vim.opt.backup      = false -- Don't store backup while overwriting the file
vim.opt.writebackup = false -- Don't store backup while overwriting the file

vim.opt.mouse       = 'a'   -- Enable mouse for all available modes

-- Appearance
vim.opt.breakindent   = true    -- Indent wrapped lines to match line start
vim.opt.cursorline    = true    -- Highlight current line
vim.opt.cursorlineopt = 'number'-- Only highlight the current line number
vim.opt.linebreak     = true    -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.opt.number        = true    -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers
vim.opt.splitbelow    = true    -- Horizontal splits will be below
vim.opt.splitright    = true    -- Vertical splits will be to the right

vim.opt.ruler         = false   -- Don't show cursor position in command line
vim.opt.showmode      = false   -- Don't show mode in command line
vim.opt.wrap          = false   -- Display long lines as just one line

vim.opt.signcolumn    = 'yes'   -- Always show sign column (otherwise it will shift text)

-- Editing
vim.opt.ignorecase  = true -- Ignore case when searching (use `\C` to force not doing that)
vim.opt.incsearch   = true -- Show search results while typing
vim.opt.infercase   = true -- Infer letter cases for a richer built-in keyword completion
vim.opt.smartcase   = true -- Don't ignore case when searching if pattern has upper case
vim.opt.smartindent = true -- Make indenting smart

vim.opt.completeopt   = 'menuone,noinsert,noselect' -- Customize completions
vim.opt.virtualedit   = 'block'                     -- Allow going past the end of line in visual block mode
vim.opt.formatoptions = 'qjl1'                      -- Don't autoformat comments

-- Formatting. 4 spaces, no tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Decrease update time
vim.opt.updatetime = 250

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
    { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
    { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
    { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
    { desc = 'Open diagnostic [Q]uickfix list' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank',
        { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'mail', 'markdown', 'text' },
    command = 'setlocal spell spelllang=en_us'
})

-- LSP keymaps
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local buffer = ev.buf

        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename,
            { buffer = buffer, desc = '[r]e[n]ame' })
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action,
            { buffer = buffer, desc = '[c]ode [a]ction' })

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
            { buffer = buffer, desc = '[g]o to [d]efinition' })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
            { buffer = buffer, desc = '[g]o to [D]eclaration' })
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
            { buffer = buffer, desc = '[g]o to [i]mplementation' })
        vim.keymap.set('n', 'gr', vim.lsp.buf.references,
            { buffer = buffer, desc = '[g]o to [r]eferences' })
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition,
            { buffer = buffer, desc = 'type [D]efinition' })

        -- See `:help K` for why this keymap
        vim.keymap.set('n', 'K', vim.lsp.buf.hover,
            { buffer = buffer, desc = 'show hover' })
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
            { buffer = buffer, desc = 'show signature' })

        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, { buffer = buffer, desc = '[f]ormat' })
    end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
    'tpope/vim-fugitive', -- Git related plugin

    -- Make pretty code snapshots
    { "mistricky/codesnap.nvim", build = "make" },

    {
        'folke/zen-mode.nvim',
        opts = {
            window = {
                options = {
                    signcolumn = "no",
                    number = false,
                    relativenumber = false
                }
            }
        },
        config = function()
            vim.keymap.set('n', '<leader>gy', ':ZenMode<CR>',
                { noremap = true, silent = true })
        end
    },
    {
        'RRethy/base16-nvim',
        priority = 1000,
        init = function()
            vim.opt.termguicolors = true
            vim.cmd.colorscheme 'base16-gruvbox-dark-hard'

            vim.api.nvim_set_hl(0, "CursorLineNr", {}) -- clear the background highlights

            -- Swap property and variable highlighting
            local myTSVariable = vim.deepcopy(vim.api.nvim_get_hl(0, { name = "TSVariable" }))
            local myTSField = vim.deepcopy(vim.api.nvim_get_hl(0, { name = "TSField" }))

            vim.api.nvim_set_hl(0, "TSVariable", myTSField)
            vim.api.nvim_set_hl(0, "TSVariableBuiltin", myTSField)
            vim.api.nvim_set_hl(0, "TSField", myTSVariable)
            vim.api.nvim_set_hl(0, "TSProperty", myTSVariable)

            -- These are undefined in base16, resulting in inconsistent behavior
            -- https://github.com/RRethy/base16-nvim/blob/master/lua/base16-colorscheme.lua#L596-L610
            vim.api.nvim_set_hl(0, "@lsp.type.variable", { link = '@variable' })
            vim.api.nvim_set_hl(0, "@lsp.type.property", { link = '@property' })
        end,
    },
    -- {
    --     -- Theme
    --     'ellisonleao/gruvbox.nvim',
    --     priority = 1000,
    --     init = function()
    --         vim.opt.termguicolors = true
    --
    --         require('gruvbox').setup({
    --             contrast = 'hard',
    --             -- We can debug the text under the cursor using `lua vim.print(vim.treesitter.get_captures_under_cursor())`
    --             -- See `:help vim.treesitter`
    --             -- See palette colors in https://github.com/ellisonleao/gruvbox.nvim/blob/main/lua/gruvbox.lua#L73-L128
    --             palette_overrides = {
    --                 -- dark0 = "#1d2021", -- taken from `contrast = hard`
    --             },
    --             overrides = {
    --                 CursorLineNr = { bg = "#1d2021" }, -- Only highlight the number
    --                 SignColumn = { bg = "#1d2021" },   -- No constrast on sign column
    --             },
    --         })
    --         -- vim.cmd.colorscheme 'gruvbox'
    --     end
    -- },
    { -- Collection of various small independent plugins/modules
        'echasnovski/mini.nvim',
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- "gc" to comment visual regions/lines
            require('mini.comment').setup()

            -- Autocompletion and signature help
            require('mini.completion').setup()

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
            local statusline = require('mini.statusline')
            -- set use_icons to true if you have a Nerd Font
            statusline.setup { use_icons = vim.g.have_nerd_font }

            -- You can configure sections in the statusline by overriding their
            -- default behavior. For example, here we set the section for
            -- cursor location to LINE:COLUMN
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return '%2l:%-2v'
            end

            -- General purpose picker
            local miniPick = require('mini.pick')
            local miniExtra = require('mini.extra')

            miniPick.setup()
            miniExtra.setup()

            local builtin = miniPick.builtin
            local builtinExtra = miniExtra.pickers
            vim.keymap.set('n', '<leader>sh', builtin.help, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtinExtra.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>sw', builtin.grep, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.grep_live, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', builtinExtra.diagnostic, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', builtinExtra.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>/', builtinExtra.buf_lines, { desc = '[/] Fuzzily search in current buffer' })
            vim.keymap.set('n', '<c-p>', builtin.files, { desc = 'find files' })
            vim.keymap.set('n', '<c-f>', builtin.grep_live, { desc = 'live grep' })

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
                },
            })
        end,
    },

    { import = 'plugins' },
}, {})

-- vim: ts=4 sts=4 sw=4 et
