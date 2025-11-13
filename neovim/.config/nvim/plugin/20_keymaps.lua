-- ┌─────────────────┐
-- │ Custom mappings │
-- └─────────────────┘
--
-- This file contains definitions of custom general and Leader mappings.

-- General mappings ===========================================================

-- Use this section to add custom general mappings. See `:h vim.keymap.set()`.
local map = vim.keymap.set

-- Helper for creating Normal mode mappings
local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

-- Copy/paste with system clipboard
map({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to system clipboard' })
map('n', 'gp', '"+p', { desc = 'Paste from system clipboard' })

-- Paste in Visual with `P` to not copy selected text (`:h v_P`)
map('x', 'gp', '"+P', { desc = 'Paste from system clipboard' })

-- Moves lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Navigate wrapped lines
nmap("j", "gj", "Down (wrapped)")
nmap("k", "gk", "Up (wrapped)")

-- General search - quick access without leader
nmap('<C-p>', '<cmd>Pick files<cr>', 'Pick files')
nmap('<C-f>', '<cmd>Pick grep_live<cr>', 'Pick grep live')

-- stylua: ignore start
-- The next part (until `-- stylua: ignore end`) is aligned manually for easier
-- reading. Consider preserving this or remove `-- stylua` lines to autoformat.

-- Leader mappings ============================================================

-- Neovim has the concept of a Leader key (see `:h <Leader>`). It is a configurable
-- key that is primarily used for "workflow" mappings (opposed to text editing).
-- Like "open file explorer", "create scratch buffer", "pick from buffers".
--
-- In 'plugin/10_options.lua' <Leader> is set to <Space>, i.e. press <Space>
-- whenever there is a suggestion to press <Leader>.
--
-- This config uses a "two key Leader mappings" approach: first key describes
-- semantic group, second key executes an action. Both keys are usually chosen
-- to create some kind of mnemonic.
-- Example: `<Leader>s` groups "search" type of actions; `<Leader>sf` - search files.

-- Create a global table with information about Leader groups in certain modes.
-- This is used to provide 'mini.clue' with extra clues.
-- Add an entry if you create a new group.
_G.Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>e', desc = '+Explore/Edit' },
  { mode = 'n', keys = '<Leader>g', desc = '+Git' },
  { mode = 'n', keys = '<Leader>l', desc = '+Language' },
  { mode = 'n', keys = '<Leader>n', desc = '+Notes' },
  { mode = 'n', keys = '<Leader>o', desc = '+Other' },
  { mode = 'n', keys = '<Leader>s', desc = '+Search' },
  { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
  { mode = 'n', keys = '<Leader>v', desc = '+Visits' },

  { mode = 'x', keys = '<Leader>g', desc = '+Git' },
  { mode = 'x', keys = '<Leader>l', desc = '+Language' },
}

-- Helpers for a more concise `<Leader>` mappings.
local nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end
local xmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc })
end

-- Quick buffer/line navigation
nmap_leader(',', '<cmd>Pick buffers<cr>',    'Buffers')
nmap_leader('/', '<cmd>Pick buf_lines<cr>',  'Lines (current buffer)')

-- b is for 'Buffer'. Common usage:
-- - `<Leader>bs` - create scratch (temporary) buffer
-- - `<Leader>bd` - delete current buffer
-- - `<Leader>bw` - wipeout current buffer (remove from memory)
-- - `[b` / `]b` - navigate to previous/next buffer (from mini.bracketed)
local new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

nmap_leader('ba', '<Cmd>b#<CR>',                                 'Alternate')
nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>',         'Delete')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>',  'Delete!')
nmap_leader('bs', new_scratch_buffer,                            'Scratch')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>',        'Wipeout')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout!')

-- e is for 'Explore' and 'Edit'. Common usage:
-- - `<Leader>ed` - open explorer at current working directory
-- - `<Leader>ef` - open directory of current file (needs to be present on disk)
-- - `<Leader>ei` - edit 'init.lua'
-- - All mappings that use `edit_plugin_file` - edit 'plugin/' config files
local edit_plugin_file = function(filename)
  return string.format('<Cmd>edit %s/plugin/%s<CR>', vim.fn.stdpath('config'), filename)
end
local explore_at_file = '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>'

nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>',       'Directory')
nmap_leader('ef', explore_at_file,                       'File directory')
nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>',              'init.lua')
nmap_leader('ek', edit_plugin_file('20_keymaps.lua'),    'Keymaps config')
nmap_leader('em', edit_plugin_file('30_mini.lua'),       'MINI config')
nmap_leader('en', '<Cmd>lua MiniNotify.show_history()<CR>', 'Notifications')
nmap_leader('eo', edit_plugin_file('10_options.lua'),    'Options config')
nmap_leader('ep', edit_plugin_file('40_plugins.lua'),    'Plugins config')
nmap_leader('es', '<Cmd>lua MiniSessions.select()<CR>',  'Sessions')

-- g is for 'Git'. Common usage:
-- - `<Leader>gs` - show information at cursor
-- - `<Leader>go` - toggle 'mini.diff' overlay to show in-buffer unstaged changes
-- - `<Leader>gd` - show unstaged changes as a patch in separate tabpage
-- - `<Leader>gL` - show Git log of current file
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. ' --follow -- %'

nmap_leader('ga', '<Cmd>Git diff --cached<CR>',             'Added diff')
nmap_leader('gA', '<Cmd>Git diff --cached -- %<CR>',        'Added diff buffer')
nmap_leader('gc', '<Cmd>Git commit<CR>',                    'Commit')
nmap_leader('gC', '<Cmd>Git commit --amend<CR>',            'Commit amend')
nmap_leader('gd', '<Cmd>Git diff<CR>',                      'Diff')
nmap_leader('gD', '<Cmd>Git diff -- %<CR>',                 'Diff buffer')
nmap_leader('gl', '<Cmd>' .. git_log_cmd .. '<CR>',         'Log')
nmap_leader('gL', '<Cmd>' .. git_log_buf_cmd .. '<CR>',     'Log buffer')
nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Toggle overlay')
nmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>',  'Show at cursor')

xmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at selection')

-- l is for 'Language' (LSP). Common usage:
-- - `grn` - perform rename via LSP (replaces built-in that conflicts with mini.operators)
-- - `gra` - show code actions
-- - `<Leader>lf` - format buffer
-- - `<Leader>lh` - show hover information
nmap('grn', vim.lsp.buf.rename,      'LSP Rename')
map({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, { desc = 'LSP Code Action' })

nmap_leader('lf', function() vim.lsp.buf.format({ async = true }) end, 'Format')
nmap_leader('lh', vim.lsp.buf.hover,                                   'Hover')

-- Uncomment these if you prefer <Leader> mappings over built-in `gr*` mappings
-- nmap_leader('lr', '<Cmd>lua vim.lsp.buf.references()<CR>',      'References')
-- nmap_leader('li', '<Cmd>lua vim.lsp.buf.implementation()<CR>',  'Implementation')
-- nmap_leader('ld', '<Cmd>lua vim.lsp.buf.definition()<CR>',      'Definition')
-- nmap_leader('lD', '<Cmd>lua vim.lsp.buf.declaration()<CR>',     'Declaration')
-- nmap_leader('lt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type definition')

-- n is for 'Notes'. Common usage:
-- - `<Leader>nd` - open today's daily note
-- - `<Leader>ni` - open notes index
-- - `<Leader>nf` - find notes files
-- - `<Leader>ng` - grep in notes
local dailyNotes = require('daily-notes')
dailyNotes.setup({
  root_dir = '~/Documents/my-notes/',
  journal_dir = 'journal',
})

nmap_leader('nd', dailyNotes.open_daily_note, 'Daily note')
nmap_leader('ni', dailyNotes.open_index,      'Index')
nmap_leader('nf', '<Cmd>Pick notes<CR>',      'Find files')
nmap_leader('ng', '<Cmd>Pick notes_grep<CR>', 'Grep')

-- o is for 'Other'. Common usage:
-- - `<Leader>oz` - toggle between "zoomed" and regular view of current buffer
-- - `<Leader>ot` - trim trailing whitespace
nmap_leader('ot', '<Cmd>lua MiniTrailspace.trim()<CR>', 'Trim trailspace')
nmap_leader('oz', '<Cmd>lua MiniMisc.zoom()<CR>',       'Zoom toggle')

-- s is for 'Search' (Fuzzy Find). Common usage:
-- - `<Leader>sf` - search files; for best performance requires `ripgrep`
-- - `<Leader>sg` - search inside files (grep); requires `ripgrep`
-- - `<Leader>sh` - search help tags
-- - `<Leader>sr` - resume latest picker
-- - `<Leader>sv` - all visited paths; requires 'mini.visits'
--
-- All these use 'mini.pick'. See `:h MiniPick-overview` for an overview.
nmap_leader('s/', '<Cmd>Pick history scope="/"<CR>',         '"/" history')
nmap_leader('s:', '<Cmd>Pick history scope=":"<CR>',         '":" history')
nmap_leader('s.', '<Cmd>Pick oldfiles<CR>',                  'Oldfiles')
nmap_leader('sa', '<Cmd>Pick git_hunks scope="staged"<CR>',  'Added hunks (all)')
nmap_leader('sb', '<Cmd>Pick buffers<CR>',                   'Buffers')
nmap_leader('sc', '<Cmd>Pick git_commits<CR>',               'Commits (all)') nmap_leader('sd', '<Cmd>Pick diagnostic<CR>',                'Diagnostics')
nmap_leader('sf', '<Cmd>Pick files<CR>',                     'Files')
nmap_leader('sg', '<Cmd>Pick grep_live<CR>',                 'Grep live')
nmap_leader('sG', '<Cmd>Pick grep pattern="<cword>"<CR>',    'Grep current word')
nmap_leader('sh', '<Cmd>Pick help<CR>',                      'Help tags')
nmap_leader('sk', '<Cmd>Pick keymaps<CR>',                   'Keymaps')
nmap_leader('sl', '<Cmd>Pick buf_lines scope="all"<CR>',     'Lines (all)')
nmap_leader('sm', '<Cmd>Pick git_hunks<CR>',                 'Modified hunks (all)')
nmap_leader('sr', '<Cmd>Pick resume<CR>',                    'Resume')
nmap_leader('sv', '<Cmd>Pick visit_paths cwd=""<CR>',        'Visit paths (all)')
nmap_leader('sV', '<Cmd>Pick visit_paths<CR>',               'Visit paths (cwd)')

-- t is for 'Toggle'
nmap_leader('th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, 'Inlay hints')

-- v is for 'Visits'. Common usage:
-- - `<Leader>va` - add label to current file
-- - `<Leader>vr` - remove label from current file
nmap_leader('va', '<Cmd>lua MiniVisits.add_label()<CR>',    'Add label')
nmap_leader('vr', '<Cmd>lua MiniVisits.remove_label()<CR>', 'Remove label')

-- AI Assistant mappings
map({ "n", "v" }, "<C-a>",         "<Cmd>CodeCompanionActions<CR>",     { desc = 'AI Actions' })
map({ "n", "v" }, "<LocalLeader>a", "<Cmd>CodeCompanionChat Toggle<CR>", { desc = 'AI Chat Toggle' })
map("v",          "ga",             "<Cmd>CodeCompanionChat Add<CR>",     { desc = 'AI Chat Add' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- stylua: ignore end
