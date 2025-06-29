return {
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
                    'diff',
                    'html',
                    'javascript',
                    'jsdoc',
                    'json',
                    'lua',
                    'markdown',
                    'markdown_inline',
                    'perl',
                    'python',
                    'regex',
                    'rust',
                    'swift',
                    'tsx',
                    'typescript',
                    'vim',
                    'vimdoc',
                },

                -- Autoinstall languages that are not installed.
                auto_install = true,
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
                    swap = {
                        enable = true,
                        swap_next = {
                            -- ['<leader>a'] = '@parameter.inner',
                        },
                        swap_previous = {
                            -- ['<leader>A'] = '@parameter.inner',
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
}
