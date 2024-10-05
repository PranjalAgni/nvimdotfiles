-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require("mason").setup({
  ensure_installed = {
      "luacheck",
			"shellcheck",
			"shfmt",
			"tailwindcss-language-server",
			"typescript-language-server",
			"css-lsp",
  }
})
require("mason-lspconfig").setup({
  ensure_installed = {"lua_ls", "ts_ls", "textlsp", "spectral"}
})
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({})
lspconfig.ts_ls.setup({})
lspconfig.textlsp.setup({})
lspconfig.spectral.setup({})

require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
  }
}
require("telescope").load_extension("ui-select")

-- require("catppuccin").setup()
-- vim.cmd.colorscheme "catppuccin"
-- vim.cmd("colorscheme rose-pine")
local onedarkconfig = require("onedark")
onedarkconfig.setup {
    style = 'warmer'
}
onedarkconfig.load()

local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = {"astro", "cpp", "css", "gitignore", "go", "graphql", "http", "java", "rust", "scss", "sql", "svelte"},
  highlight = { enable = true },
  indent = { enable = true },
})
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal right<CR>', {})

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.completion.spell,
        null_ls.builtins.diagnostics.eslint_d
    },
})
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

