return {
    settings = {
        ["harper-ls"] = {
            userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
            linters = {
                spell_check = false,
                sentence_capitalization = false,
                title_case = false,
            },
        }
    },
}
