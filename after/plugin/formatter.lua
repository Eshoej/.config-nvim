require("conform").setup({
    format_on_save = {
        time_out = 500,
        lsp_format = "fallback",
    },
    formatters_by_ft = {
        go = { "gofmt" },
        lua = { "lua_ls" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        html = { "html" },
        yaml = { "yamlfix" },
    },
})

require("lint").linters_by_ft = {
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescriptreact = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
