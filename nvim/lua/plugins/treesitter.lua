-- DEPENDENCIES (main branch):
--   Neovim 0.12+
--   tree-sitter CLI 0.26.1+  (apt version is 0.25.9 — too old)
--     install: cargo install --locked tree-sitter-cli
--   tar, curl, C compiler (gcc/clang)
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local parsers = require("config.parsers")

    require("nvim-treesitter").setup({})
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("nvim-treesitter-highlight", { clear = true }),
      pattern = "*",
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
