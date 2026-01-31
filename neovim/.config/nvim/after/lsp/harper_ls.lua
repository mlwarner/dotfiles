return {
    settings = {
        ["harper-ls"] = {
            userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
            linters = {
                SpellCheck = false,
                SentenceCapitalization = false,
                TitleCase = false,
            },
        }
    },
}
