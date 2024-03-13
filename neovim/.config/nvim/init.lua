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
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth',   -- Detect tabstop and shiftwidth automatically
  'tpope/vim-fugitive', -- Git related plugin

  -- Markdown wiki
  {
    'lervag/wiki.vim',
    config = function()
      -- vim.g.wiki_root = '~/Documents/my_notes'
      vim.g.wiki_root =
      '/Users/mwarner/Library/Mobile Documents/iCloud~md~obsidian/Documents/my_notes'
      -- vim.g.wiki_root = '/Users/mwarner/Library/CloudStorage/ProtonDrive-warnmat@proton.me/my_notes'
      vim.g.wiki_journal_index = {
        link_url_parser = function(_, isoDate, _)
          return isoDate
        end,
        link_test_parser = function(_, _, absolutePath)
          return absolutePath
        end
      }

      vim.g.wiki_mappings_local = {
        ['<plug>(wiki-pages)'] = '<leader>ws',
      }

      vim.keymap.set('n', '<leader>wf', function()
        require('telescope.builtin').find_files({ cwd = vim.g.wiki_root })
      end, { desc = '[W]iki [F]iles' })
      vim.keymap.set('n', '<leader>wg', function()
        require('telescope.builtin').live_grep({ cwd = vim.g.wiki_root })
      end, { desc = '[W]iki [G]rep' })

      vim.g.wiki_mappings_local_journal = {
        ['<plug>(wiki-journal-prev)'] = '[w',
        ['<plug>(wiki-journal-next)'] = ']w',
      }
    end
  },
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

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  event = 'VimEnter', opts = {} },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags,
        { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps,
        { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files,
        { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin,
        { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string,
        { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep,
        { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics,
        { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume,
        { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles,
        { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers,
        { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find,
        { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<c-p>', require('telescope.builtin').find_files,
        { desc = 'find files' })
      vim.keymap.set('n', '<c-f>', require('telescope.builtin').live_grep,
        { desc = 'live grep' })
    end,
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities,
        require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        marksman = {},
        rust_analyzer = {},
        tsserver = {},

        lua_ls = {
          settings = {
            Lua = {
              telemetry = { enable = false },
              workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
              },
              -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities,
              server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      require('lspconfig').sourcekit.setup({
        capabilities = capabilities,
        single_file_support = true
      })
    end,
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- Codium AI (personal use only)
      { "Exafunction/codeium.nvim", opts = {} },
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local cmp = require('cmp')

      -- Setup luasnip
      -- This comes with a huge repository of snippets for various languages. e.g. 'date' for markdown files
      local luasnip = require 'luasnip'
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            -- select = true,
          })
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'codeium' },
        },
      })
    end
  },

  {
    'RRethy/base16-nvim',
    priority = 1000,
    init = function()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme 'base16-gruvbox-dark-hard'
      vim.api.nvim_set_hl(0, "CursorLineNr", { bg = nil }) -- clear the backgorund highlights
    end,
  },
  -- {
  --     -- Theme
  --     'ellisonleao/gruvbox.nvim',
  --     lazy = true,
  --     -- lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --     priority = 1000,
  --     config = true,
  --     opts = {
  --         contrast = 'hard',
  --         -- We can debug the text under the cursor using `lua vim.print(vim.treesitter.get_captures_under_cursor())`
  --         -- See `:help vim.treesitter`
  --         -- See palette colors in https://github.com/ellisonleao/gruvbox.nvim/blob/main/lua/gruvbox.lua#L73-L128
  --         palette_overrides = {
  --             -- dark0 = "#1d2021", -- taken from `contrast = hard`
  --         },
  --         overrides = {
  --             CursorLineNr = { bg = "#1d2021" }, -- Only highlight the number
  --             SignColumn = { bg = "#1d2021" },   -- No constrast on sign column
  --         },
  --     },
  -- },

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
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'ThePrimeagen/refactoring.nvim'
    },
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
          'bash',
          'c_sharp',
          'css',
          'html',
          'javascript',
          'json',
          'lua',
          'markdown',
          'markdown_inline',
          'perl',
          'python',
          'rust',
          'swift',
          'tsx',
          'typescript',
          'vim',
          'vimdoc',
        },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }
      -- Refactor.nvim
      vim.keymap.set({ "n", "x" }, "<leader>rr",
        function() require('refactoring').select_refactor() end,
        { desc = '[r]efacto[r]' })
    end
  },
}, {})

-- vim: ts=2 sts=2 sw=2 et
