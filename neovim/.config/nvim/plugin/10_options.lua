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
