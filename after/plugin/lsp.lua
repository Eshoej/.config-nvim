local lsp_zero = require("lsp-zero")

vim.diagnostic.config({
    virtual_text = {
        prefix = "●", -- symbol before text
        spacing = 2,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

local lsp_attach = function(client, bufnr)
    local lsp_zero = require("lsp-zero")

    local lsp_attach = function(client, bufnr)
        local opts = { buffer = bufnr }

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    end

    local null_ls = require("null-ls")

    null_ls.setup({
        sources = {
            null_ls.builtins.formatting.yamlfmt.with({
                command = "yamlfmt",
                args = { "$FILENAME" },
                to_temp_file = true,
                from_temp_file = true,
            }),
        },
    })

    lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })
    require("lspconfig").gdscript.setup({})
    require("mason").setup({})
    require("mason-lspconfig").setup({
        --    automatic_enable = false,
        -- Replace the language servers listed here
        -- with the ones you want to install
        ensure_installed = { "lua_ls", "gopls", "marksman" },
        handlers = {
            function(server_name)
                local opts = {}
                if server_name == "gopls" then
                    opts = {
                        settings = {
                            gopls = {
                                buildFlags = { "-tags=integration" },
                            },
                        },
                    }
                end
                require("lspconfig")[server_name].setup(opts)
            end,
        },
    })

    local pipepath = vim.fn.stdpath("cache") .. "/server.pipe"
    if not vim.loop.fs_stat(pipepath) then
        vim.fn.serverstart(pipepath)
    end

    lsp_zero.format_on_save({
        format_opts = {
            async = false,
            timeout_ms = 10000,
        },
        servers = {
            ["lua_ls"] = { "lua" },
            ["elixirls"] = { "elixir", "heex" },
            --['ts_ls'] = {'typescript', 'javascript'},
            ["gopls"] = { "go" },
            ["null_ls"] = { "yamlfmt" },
        },
    })

    -- These are just examples. Replace them with the language
    -- servers you have installed in your system
    --require('lspconfig').gleam.setup({})
    --require('lspconfig').rust_analyzer.setup({})
    --require('lspconfig').lua_ls.setup({})
    require("lspconfig").elixirls.setup({
        cmd = { "/opt/homebrew/Cellar/elixir-ls/0.23.0/libexec/language_server.sh" },
    })

    ---
    -- Autocompletion setup
    ---
    local cmp = require("cmp")

    cmp.setup.filetype("copilot-chat", {
        enabled = true,
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "buffer" },
        }),
        mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
    })
    cmp.setup({
        sources = {
            { name = "copilot-chat" },
            { name = "nvim_lsp" },
        },
        snippet = {
            expand = function(args)
                -- You need Neovim v0.10 to use vim.snippet
                vim.snippet.expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-y>"] = cmp.mapping.confirm(),
            ["<C-Space>"] = cmp.mapping.complete(),
        }),
    })

    -- Prettier as formatter
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.css", "*.html", "*.yaml", "*.md" },
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
    })

    require("mason").setup()
    require("mason-lspconfig").setup()
    local opts = { buffer = bufnr }

    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
    vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
end

local null_ls = require("null-ls")

--null_ls.setup({
--    sources = {
--        null_ls.builtins.formatting.yamlfmt.with({
--            command = "yamlfmt",
--            args = { "$FILENAME" },
--            to_temp_file = true,
--            from_temp_file = true,
--        }),
--    },
--})

lsp_zero.extend_lspconfig({
    sign_text = true,
    lsp_attach = lsp_attach,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
require("lspconfig").gdscript.setup({})
require("mason").setup({})
require("mason-lspconfig").setup({
    --    automatic_enable = false,
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = { "lua_ls", "gopls", "marksman" },
    handlers = {
        function(server_name)
            local opts = {}
            if server_name == "gopls" then
                opts = {
                    settings = {
                        gopls = {
                            buildFlags = { "-tags=integration" },
                        },
                    },
                }
            end
            require("lspconfig")[server_name].setup(opts)
        end,
    },
})

local pipepath = vim.fn.stdpath("cache") .. "/server.pipe"
if not vim.loop.fs_stat(pipepath) then
    vim.fn.serverstart(pipepath)
end

lsp_zero.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ["lua_ls"] = { "lua" },
        ["elixirls"] = { "elixir", "heex" },
        --['ts_ls'] = {'typescript', 'javascript'},
        ["gopls"] = { "go" },
        --["null_ls"] = { "yamlfmt" },
    },
})

-- These are just examples. Replace them with the language
-- servers you have installed in your system
--require('lspconfig').gleam.setup({})
--require('lspconfig').rust_analyzer.setup({})
--require('lspconfig').lua_ls.setup({})
require("lspconfig").elixirls.setup({
    cmd = { "/opt/homebrew/Cellar/elixir-ls/0.23.0/libexec/language_server.sh" },
})

---
-- Autocompletion setup
---
local cmp = require("cmp")

cmp.setup.filetype("copilot-chat", {
    enabled = true,
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
})
cmp.setup({
    sources = {
        { name = "copilot-chat" },
        { name = "nvim_lsp" },
    },
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-y>"] = cmp.mapping.confirm(),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
})

-- Prettier as formatter
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.css", "*.html", "*.yaml", "*.md" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

require("mason").setup()
require("mason-lspconfig").setup()
