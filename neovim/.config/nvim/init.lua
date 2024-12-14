-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader       = ' '
vim.g.maplocalleader  = ' '

-- [[ Setting options ]]
-- See `:help vim.opt`

-- General
vim.opt.undofile      = true  -- Enable persistent undo (see also `:h undodir`)

vim.opt.backup        = false -- Don't store backup while overwriting the file
vim.opt.writebackup   = false -- Don't store backup while overwriting the file

vim.opt.mouse         = 'a'   -- Enable mouse for all available modes

-- Appearance
vim.opt.breakindent   = true     -- Indent wrapped lines to match line start
vim.opt.cursorline    = true     -- Highlight current line
vim.opt.cursorlineopt = 'number' -- Only highlight the current line number
vim.opt.linebreak     = true     -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.opt.number        = true     -- Show line numbers
-- vim.opt.relativenumber = true     -- Show relative line numbers
vim.opt.splitbelow    = true     -- Horizontal splits will be below
vim.opt.splitright    = true     -- Vertical splits will be to the right

vim.opt.ruler         = false    -- Don't show cursor position in command line
vim.opt.showmode      = false    -- Don't show mode in command line
vim.opt.wrap          = false    -- Display long lines as just one line

vim.opt.signcolumn    = 'yes'    -- Always show sign column (otherwise it will shift text)

-- Editing
vim.opt.ignorecase    = true                        -- Ignore case when searching (use `\C` to force not doing that)
vim.opt.incsearch     = true                        -- Show search results while typing
vim.opt.infercase     = true                        -- Infer letter cases for a richer built-in keyword completion
vim.opt.smartcase     = true                        -- Don't ignore case when searching if pattern has upper case
vim.opt.smartindent   = true                        -- Make indenting smart

vim.opt.completeopt   = 'menuone,noinsert,noselect' -- Customize completions
vim.opt.virtualedit   = 'block'                     -- Allow going past the end of line in visual block mode
vim.opt.formatoptions = 'qjl1'                      -- Don't autoformat comments

-- Formatting. 4 spaces, no tabs
vim.opt.tabstop       = 4
vim.opt.softtabstop   = 4
vim.opt.shiftwidth    = 4
vim.opt.expandtab     = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff     = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

--- keymaps for builtin completion
--- https://gist.github.com/MariaSolOs/2e44a86f569323c478e5a078d0cf98cc
---@param keys string
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
vim.keymap.set('i', '<C-n>', function()
    if pumvisible() then
        feedkeys '<C-n>'
    else
        if next(vim.lsp.get_clients { bufnr = 0 }) then
            vim.lsp.completion.trigger()
        else
            if vim.bo.omnifunc == '' then
                feedkeys '<C-x><C-n>'
            else
                feedkeys '<C-x><C-o>'
            end
        end
    end
end, { desc = 'Trigger/select next completion' })

-- Buffer completions.
vim.keymap.set('i', '<C-u>', '<C-x><C-n>', { desc = 'Buffer completions' })

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
    {
        "Exafunction/codeium.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
                enable_cmp_source = false,
                virtual_text = {
                    enabled = true,
                }
            })
        end
    },

    {
        'folke/zen-mode.nvim',
        config = function()
            require('zen-mode').setup({
                window = {
                    options = {
                        signcolumn = "no",
                        number = false,
                        relativenumber = false
                    }
                }
            })
            vim.keymap.set('n', 'gz', ':ZenMode<CR>', { noremap = true, silent = true })
        end
    },
    -- {
    --     'RRethy/base16-nvim',
    --     priority = 1000,
    --     init = function()
    --         vim.opt.termguicolors = true
    --         vim.cmd.colorscheme 'base16-gruvbox-dark-hard'
    --
    --         vim.api.nvim_set_hl(0, "LineNr", { link = "NonText" }) -- don't emphasize line numbers
    --         vim.api.nvim_set_hl(0, "CursorLineNr", {})            -- clear the background highlights
    --
    --         -- Swap property and variable highlighting
    --         local myTSVariable = vim.deepcopy(vim.api.nvim_get_hl(0, { name = "TSVariable" }))
    --         local myTSField = vim.deepcopy(vim.api.nvim_get_hl(0, { name = "TSField" }))
    --
    --         -- https://github.com/RRethy/base16-nvim/blob/master/lua/base16-colorscheme.lua#L596-L610
    --         -- TODO should there be a higher level mapping than TSVariable ? Maybe @variable? See below
    --         -- vim.api.nvim_set_hl(0, "@lsp.type.variable", { link = '@variable' })
    --         vim.api.nvim_set_hl(0, "TSVariable", myTSField)
    --         vim.api.nvim_set_hl(0, "TSVariableBuiltin", myTSField)
    --         vim.api.nvim_set_hl(0, "TSField", myTSVariable)
    --         vim.api.nvim_set_hl(0, "TSProperty", myTSVariable)
    --     end,
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
                    MiniPickNormal = { link = "Normal" },
                },
            })
            vim.cmd.colorscheme 'gruvbox'
            -- vim.api.nvim_set_hl(0, "MiniPickNormal", { link = "Normal"}) -- Clear highlights
        end
    },
    { -- Collection of various small independent plugins/modules
        'echasnovski/mini.nvim',
        config = function()
            -- Common configuration presets
            require('mini.basics').setup()

            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Go forward/backward with square brackets
            -- Prefer built in vim-unimpaired keybinds
            if vim.fn.has('nvim-0.11') == 0 then
                require('mini.bracketed').setup()
            else
                -- default for vim.diagnostic.JumpOpts sets float to false
                vim.diagnostic.config({
                    jump = {
                        float = true,
                    }
                })
            end

            -- Autocompletion and signature help
            -- Prefer built in completion in nvim 0.11+
            if vim.fn.has('nvim-0.11') == 0 then
                require('mini.completion').setup()
            end

            -- Highlight usages of the word under the cursor
            require('mini.cursorword').setup()

            -- Work with diff hunks
            require('mini.diff').setup()

            -- file explorer
            require('mini.files').setup()

            -- icon provider
            require('mini.icons').setup()

            -- Work with 'git'
            require('mini.git').setup()

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

            -- General purpose picker
            local miniPick = require('mini.pick')
            local miniExtra = require('mini.extra')

            miniPick.setup()
            miniExtra.setup()

            -- Override `vim.ui.select()`
            vim.ui.select = miniPick.ui_select

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
