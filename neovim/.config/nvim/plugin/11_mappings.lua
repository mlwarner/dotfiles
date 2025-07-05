-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local map = vim.keymap.set

-- Setup notes
local notes_dir = vim.fs.normalize('~/Documents/my-notes')

-- Daily journal
local dailyNotes = require('daily-notes')
dailyNotes.setup({ dir = vim.fs.joinpath(notes_dir, 'journal') })

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
map('n', '<c-p>', '<cmd>Pick files<cr>', { desc = 'find files' })
map('n', '<c-f>', '<cmd>Pick grep_live<cr>', { desc = 'live grep' })
map('n', '<leader>,', '<cmd>Pick buffers<cr>', { desc = '[ ] Find existing buffers' })
map('n', '<leader>/', '<cmd>Pick buf_lines<cr>', { desc = '[/] Fuzzily search in current buffer' })
map('n', '<leader>s.', '<cmd>Pick oldfiles<cr>', { desc = '[S]earch Recent Files ("." for repeat)' })

-- git
map('n', '<leader>gc', '<cmd>Pick git_commits<cr>', { desc = 'Git Commits' })
map('n', '<leader>gb', '<cmd>Pick git_branches<cr>', { desc = 'Git Branches' })
map('n', '<leader>gh', '<cmd>Pick git_hunks<cr>', { desc = 'Git Hunks' })

-- grep
map('n', '<leader>sd', '<cmd>Pick diagnostic<cr>', { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sg', '<cmd>Pick grep_live<cr>', { desc = '[S]earch by [G]rep' })
map('n', '<leader>sw', '<cmd>Pick grep<cr>', { desc = '[S]earch current [W]ord' })

-- search
map('n', '<leader>sf', '<cmd>Pick files<cr>', { desc = '[S]earch [F]iles' })
map('n', '<leader>sh', '<cmd>Pick help<cr>', { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', '<cmd>Pick keymaps<cr>', { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sr', '<cmd>Pick resume<cr>', { desc = '[S]earch [R]esume' })
map('n', '<leader>sv', '<cmd>Pick visit_paths<cr>', { desc = '[S]earch [V]isits' })

-- notes
map('n', '<leader>ni', function() vim.cmd.edit(vim.fs.joinpath(notes_dir, 'index.md')) end,
    { desc = 'Open [N]otes index' })
map('n', '<leader>nd', function() dailyNotes.open_daily_note() end, { desc = 'Open [N]otes [D]aily' })
map('n', '<leader>nsf', '<cmd>Pick notes<cr>', { desc = '[N]otes [S]earch [F]iles' })
map('n', '<leader>nsg', '<cmd>Pick notes_grep<cr>', { desc = '[N]otes [S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>nd', open_daily_journal, { desc = 'Open [N]otes [D]aily journal' })

-- LSP
map('n', 'grn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
map({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, { desc = '[G]oto Code [A]ction' })
map("n", "gO", "<Cmd>Pick lsp scope='document_symbol'<CR>", { desc = "Open document symbols" })
map("n", "gW", "<Cmd>Pick lsp scope='workspace_symbol'<CR>", { desc = "Open workspace symbols" })
map("n", "grr", "<Cmd>Pick lsp scope='references'<CR>", { desc = "[R]eferences" })
map("n", "gri", "<Cmd>Pick lsp scope='implementation'<CR>", { desc = "[I]mplementation" })
map("n", "grd", "<Cmd>Pick lsp scope='definition'<CR>", { desc = "[G]oto [D]efinition" })
map("n", "grD", "<Cmd>Pick lsp scope='declaration'<CR>", { desc = "[G]oto [D]eclaration" })
map("n", "grt", "<Cmd>Pick lsp scope='type_definition'<CR>", { desc = "[G]oto [T]ype Definition" })
map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { desc = '[F]ormat' })
map('n', '<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })) end,
    { desc = '[T]oggle Inlay [H]ints' })

-- mini.files
map('n', '<leader>e', function() require('mini.files').open() end, { desc = 'File [E]xplorer' })

-- mini.misc
map('n', '<leader>z', function() require('mini.misc').zoom() end, { desc = 'Zoom window' })

-- mini.visits
map('n', '<leader>vv', '<Cmd>Pick visit_labels<CR>', { desc = 'Visit labels' })
map('n', '<leader>va', '<Cmd>lua MiniVisits.add_label()<CR>', { desc = 'Add label' })
map('n', '<leader>vr', '<Cmd>lua MiniVisits.remove_label()<CR>', { desc = 'Remove label' })

-- code companion
map({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
map({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
map("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

--- NOTE: ref to keymaps for builtin completion
--- https://gist.github.com/MariaSolOs/2e44a86f569323c478e5a078d0cf98cc

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
