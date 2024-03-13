return {
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
    }
}
