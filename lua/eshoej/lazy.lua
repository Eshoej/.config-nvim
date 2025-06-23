local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {


        { "github/copilot.vim" },
        { "tpope/vim-fugitive" },
        { "mfussenegger/nvim-lint" },
        {
            "CopilotC-Nvim/CopilotChat.nvim",
            dependencies = {
                { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
                { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
            },
            build = "make tiktoken",                            -- Only on MacOS or Linux
            opts = {
                -- See Configuration section for options
            },
            -- See Commands section for default commands if you want to lazy load on them
        },

        {
            "folke/snacks.nvim",
            priority = 1000,
            lazy = false,
        },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' }
        },
        {
            "rose-pine/neovim",
            name = "rose-pine",
            config = function()
                vim.cmd("colorscheme rose-pine")
            end,
        },
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            -- or                              , branch = '0.1.x',
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        { "nvim-lua/plenary.nvim" },
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "master",
            lazy = false,
            build = ":TSUpdate",
        },
        {
            "stevearc/conform.nvim",
            opts = {},
        },
        { "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
        { "neovim/nvim-lspconfig" },
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp" },
        {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        {
            "nvimtools/none-ls.nvim",
            config = function()
                require("null-ls").setup()
            end,
            requires = { "nvim-lua/plenary.nvim" },
        },
    },

    install = { colorscheme = { "rose-pine" } },
    checker = { enabled = true },
})
