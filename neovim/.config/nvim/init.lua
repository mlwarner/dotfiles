-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt`

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Default formatting. 4 spaces, no tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Disable line wrapping
vim.opt.wrap = false

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Show which line your cursor is on
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

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

-- Swap lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

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
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'mail' },
    command = 'setlocal formatoptions+=aw textwidth=150'
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'crontab' },
    command = 'setlocal nobackup | set nowritebackup'
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

-- [[ Basic UserCommands ]]

-- custom filetype detection
vim.filetype.add({
    extension = {
        m = "mason",
        mi = "mason",
        mhtml = "mason",
        kata = "kata",
    }
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

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim',  event = 'VimEnter', opts = {} },

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
    -- {
    --   'RRethy/base16-nvim',
    --   priority = 1000,
    --   init = function()
    --     vim.opt.termguicolors = true
    --     vim.cmd.colorscheme 'base16-gruvbox-dark-hard'
    --     vim.api.nvim_set_hl(0, "CursorLineNr", { bg = nil }) -- clear the backgorund highlights
    --   end,
    -- },
    {
        -- Theme
        'ellisonleao/gruvbox.nvim',
        priority = 1000,
        init = function()
            vim.opt.termguicolors = true

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
                },
            })
            vim.cmd.colorscheme 'gruvbox'
        end
    },
    { -- Collection of various small independent plugins/modules
        'echasnovski/mini.nvim',
        config = function()
            -- "gc" to comment visual regions/lines
            require('mini.comment').setup()

            -- Autocompletion and signature help
            require('mini.completion').setup()

            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require('mini.surround').setup()

            -- Simple and easy statusline.
            --  You could remove this setup call if you don't like it,
            --  and try some other statusline plugin
            local statusline = require 'mini.statusline'
            -- set use_icons to true if you have a Nerd Font
            statusline.setup { use_icons = vim.g.have_nerd_font }

            -- You can configure sections in the statusline by overriding their
            -- default behavior. For example, here we set the section for
            -- cursor location to LINE:COLUMN
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return '%2l:%-2v'
            end

            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },


    { import = 'plugins' },
}, {})

-- vim: ts=4 sts=4 sw=4 et
