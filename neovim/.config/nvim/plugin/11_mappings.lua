-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local map = vim.keymap.set

-- Setup notes
local notes_dir = vim.fs.normalize('~/Documents/my-notes/')

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

-- General search
map('n', '<c-p>', '<cmd>Pick files<cr>', { desc = 'find files' })
map('n', '<c-f>', '<cmd>Pick grep_live<cr>', { desc = 'live grep' })
map('n', '<leader>,', '<cmd>Pick buffers<cr>', { desc = '[ ] Find existing buffers' })
map('n', '<leader>/', '<cmd>Pick buf_lines<cr>', { desc = '[/] Fuzzily search in current buffer' })

-- buffer
map('n', '<leader>bs', function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end, { desc = 'Scratch' })

-- code companion
map({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
map({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
map("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- edit
map('n', '<leader>ed', '<cmd>lua MiniFiles.open()<cr>', { desc = 'Directory' })
map('n', '<leader>es', '<cmd>lua MiniSessions.select()<cr>', { desc = 'Sessions' })

-- git
map('n', '<leader>ga', '<cmd>Git diff --cached<cr>', { desc = 'Added diff' })
map('n', '<leader>gA', '<cmd>Git diff --cached -- %<cr>', { desc = 'Added diff buffer' })
map('n', '<leader>gc', '<cmd>Git commit<cr>', { desc = 'Commit' })
map('n', '<leader>gC', '<cmd>Git commit --amend<cr>', { desc = 'Commit amend' })
map('n', '<leader>gd', '<cmd>Git diff<cr>', { desc = 'Diff' })
map('n', '<leader>gD', '<cmd>Git diff -- %<cr>', { desc = 'Diff buffer' })
map('n', '<leader>gl', '<cmd>Git log<cr>', { desc = 'Log' })
map('n', '<leader>gL', '<cmd>Git log --follow -- %<cr>', { desc = 'Log buffer' })
map('n', '<leader>go', '<cmd>lua MiniDiff.toggle_overlay()<cr>', { desc = 'Toggle overlay' })
map('n', '<leader>gs', '<cmd>lua MiniGit.show_at_cursor()<cr>', { desc = 'Show at cursor' })

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

-- notes
map('n', '<leader>ni', function() vim.cmd.edit(vim.fs.joinpath(notes_dir, 'index.md')) end,
    { desc = 'Open [N]otes index' })
map('n', '<leader>nd', function() dailyNotes.open_daily_note() end, { desc = 'Open [N]otes [D]aily' })
map('n', '<leader>nsf', '<cmd>Pick notes<cr>', { desc = '[N]otes [S]earch [F]iles' })
map('n', '<leader>nsg', '<cmd>Pick notes_grep<cr>', { desc = '[N]otes [S]earch by [G]rep' })

-- other
map('n', '<leader>ot', '<cmd>lua MiniTrailspace.trim()', { desc = 'Trim trailspace' })
map('n', '<leader>oz', '<cmd>lua MiniMisc.zoom()<cr>', { desc = 'Zoom toggle' })

-- search
map('n', '<leader>s/', '<cmd>Pick history scope="/"<cr>', { desc = '"/" history' })
map('n', '<leader>s:', '<cmd>Pick history scope=":"<cr>', { desc = '":" history' })
map('n', '<leader>s.', '<cmd>Pick oldfiles<cr>', { desc = 'Oldfiles ("." for repeat)' })
map('n', '<leader>sa', '<cmd>Pick git_hunks scope="staged"<cr>', { desc = 'Added hunks (all)' })
map('n', '<leader>sc', '<cmd>Pick git_commits<cr>', { desc = 'Commits (all)' })
map('n', '<leader>sG', '<cmd>Pick grep pattern="<cword>"<cr>', { desc = 'Grep current word' })
map('n', '<leader>sd', '<cmd>Pick diagnostic<cr>', { desc = 'Diagnostics' })
map('n', '<leader>sf', '<cmd>Pick files<cr>', { desc = 'Files' })
map('n', '<leader>sg', '<cmd>Pick grep_live<cr>', { desc = 'Grep live' })
map('n', '<leader>sh', '<cmd>Pick help<cr>', { desc = 'Help' })
map('n', '<leader>sk', '<cmd>Pick keymaps<cr>', { desc = 'Keymaps' })
map('n', '<leader>sl', '<cmd>Pick buf_lines scope="all"<cr>', { desc = 'Lines (all)' })
map('n', '<leader>sm', '<cmd>Pick git_hunks scope="staged"<cr>', { desc = 'Modified hunks (all)' })
map('n', '<leader>sr', '<cmd>Pick resume<cr>', { desc = 'Resume' })
map('n', '<leader>sv', '<cmd>Pick visit_paths cwd=""<cr>', { desc = 'Visits paths (all)' })
map('n', '<leader>sV', '<cmd>Pick visit_paths<cr>', { desc = 'Visits paths (cwd)' })

-- visits
map('n', '<leader>va', '<Cmd>lua MiniVisits.add_label()<CR>', { desc = 'Add label' })
map('n', '<leader>vr', '<Cmd>lua MiniVisits.remove_label()<CR>', { desc = 'Remove label' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--- NOTE: ref to keymaps for builtin completion
--- https://gist.github.com/MariaSolOs/2e44a86f569323c478e5a078d0cf98cc
