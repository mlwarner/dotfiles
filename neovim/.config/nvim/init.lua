-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  {'tpope/vim-fugitive'},

  -- Detect tabstop and shiftwidth automatically
  {'tpope/vim-sleuth'},

  -- Vimwiki related functionality
  {'lervag/lists.vim'},
  {'lervag/wiki.vim'},

  -- Lsp related plugins
  {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'saadparwaiz1/cmp_luasnip'},
  {'hrsh7th/nvim-cmp'},
  {
    'L3MON4D3/LuaSnip',
    dependencies = { "rafamadriz/friendly-snippets" },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  -- Pretty prompts
  { 'stevearc/dressing.nvim', opts = {} },
  {
    -- Theme
    'ellisonleao/gruvbox.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,
    -- config = function ()
    --   vim.cmd([[colorscheme gruvbox]])
    -- end,
    config = true,
    opts = {
      contrast = 'hard',
      -- We can debug the text under the cursor using `lua vim.print(vim.treesitter.get_captures_under_cursor())`
      -- See `:help vim.treesitter`
      -- See palette colors in https://github.com/ellisonleao/gruvbox.nvim/blob/main/lua/gruvbox.lua#L73-L128
      overrides = {
        SignColumn = { bg = "#1d2021" },          -- No constrast on sign column
        Todo = { bg = "#1d2021", fg = "#928374" }, -- No constrast on sign column
      },
    }
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        globalstatus = true,
        --theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  { "folke/neodev.nvim", opts = {} },
  {'folke/zen-mode.nvim', opts = {
    window = {
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false
      }
    }
  }},

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'ThePrimeagen/refactoring.nvim'
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Disable cursor styling
vim.o.guicursor = ""

-- Incremental search and disable highlighting
vim.o.hlsearch = false
vim.o.incsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Highlight current line number
vim.wo.cursorlineopt = 'number'
vim.wo.cursorline = true

-- Enable break indent
-- vim.o.breakindent = true
-- Do not wrap long lines
vim.opt.wrap = false

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Add 8 lines of padding around cursor at all times
vim.o.scrolloff = 8

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Set colorscheme
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<c-p>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<c-f>', require('telescope.builtin').live_grep, { desc = '[S]earch [F]iles' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
     -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'lua', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'swift' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  }
end, 0)

-- LSP settings.
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({
    buffer = bufnr,
    preserve_mappings = false
  })

  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { buffer = bufnr; desc = '[r]e[n]ame' })
  vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, { buffer = bufnr; desc = '[c]ode [a]ction' })
  vim.keymap.set('n', '<space>f', function()
    vim.lsp.buf.format { async = true }
  end, { buffer = bufnr; desc = '[f]ormat' })

end)

-- see :help lsp-zero-guide:integrate-with-mason-nvim
-- to learn how to use mason.nvim with lsp-zero
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'tsserver',
    'marksman',
    'lua_ls',
    -- 'solargraph',
  },
  handlers = {
    lsp_zero.default_setup,
  }
})

-- setup servers which are not managed by mason
require('lspconfig').sourcekit.setup({
  single_file_support = true
})

-- Setup lua for nvim workspace
local lua_opts = lsp_zero.nvim_lua_ls()
require('lspconfig').lua_ls.setup(lua_opts)

-- Setup cmp for completions
local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },

  }),
})

-- Refactor.nvim
vim.keymap.set({"n", "x"}, "<leader>rr", require('refactoring').select_refactor, { desc = '[r]efacto[r]' })

-- zen-mode.nvim
vim.api.nvim_set_keymap('n', '<leader>gy', ':ZenMode<CR>', { noremap = true, silent = true })

-- custom filetype detection
vim.filetype.add({
  extension = {
    m = "mason",
    mi = "mason",
    mhtml = "mason",
    kata = "kata",
  }
})

--  Configure autocommands
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

-- Set colorscheme
vim.cmd("colorscheme gruvbox")

-- Lists.vim
-- Filetype detection does not work out of the box. Need to create an autocmd for it.
vim.g.lists_filetypes = { 'md', 'markdown' }
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown' },
  command = 'ListsEnable'
})

-- Wiki.vim
vim.g.wiki_root = '~/Vimwiki'
vim.g.wiki_journal_index = {
  link_url_parser = function(_, isoDate, _)
    return isoDate
  end,
  link_test_parser = function(_, _, absolutePath)
    return absolutePath
  end
}

vim.g.wiki_mappings_local_journal = {
  ['<plug>(wiki-journal-prev)'] = '[w',
  ['<plug>(wiki-journal-next)'] = ']w',
}
