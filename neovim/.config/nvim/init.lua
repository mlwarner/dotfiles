-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
  { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
  { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
  { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>',
  { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>',
  { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>',
  { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>',
  { desc = 'Move focus to the upper window' })

-- Swap lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
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

-- silicon for screenshots
-- https://github.com/Aloxaf/silicon
vim.api.nvim_create_user_command('Silicon',
  function(opts)
    local line1 = opts.line1
    local line2 = opts.line2
    local curDate = os.date('%Y-%m-%dT%T')
    -- TODO handle missing file extension - Maybe a fallback we can use?
    local fileExtension = vim.bo.filetype
    local fileOutName = string.format('Screenshot-%s.png', curDate)
    local writeCommand = string.format('%s,%swrite !silicon -l %s -o %s',
      line1, line2, fileExtension, fileOutName
    )
    vim.cmd(writeCommand)
  end,
  { nargs = 0, range = '%' }
)

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
  'tpope/vim-sleuth',   -- Detect tabstop and shiftwidth automatically
  'tpope/vim-fugitive', -- Git related plugin

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  event = 'VimEnter', opts = {} },

  {
    'opdavies/toggle-checkbox.nvim',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'markdown' },
        callback = function(args)
          vim.keymap.set("n", "<leader>tt",
            function() require('toggle-checkbox').toggle() end,
            { buffer = args.buf, desc = '[T]oggle [T]ask' })
        end
      })
    end
  },

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
      vim.o.background = 'dark'
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
          CursorLineNr = { bg = "#1d2021" },     -- Only highlight the number
          SignColumn = { bg = "#1d2021" },       -- No constrast on sign column
        },
      })
      vim.cmd.colorscheme 'gruvbox'
    end
  },


  { import = 'plugins' },
}, {})

-- vim: ts=2 sts=2 sw=2 et
