-- DEPENDENCIES:
--   (нет внешних — чистая Lua-тема, Nerd Font не требуется)
return {
  "projekt0n/github-nvim-theme",
  name = "github-theme",
  lazy = false,
  priority = 1000,
  config = function()
    require("github-theme").setup({
      options = {
        styles = {
          comments = "italic",
          keywords = "bold",
        },
      },
    })

    vim.cmd("colorscheme github_dark_default")
  end,
}
