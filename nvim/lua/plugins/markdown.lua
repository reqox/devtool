-- DEPENDENCIES:
--   Nerd Font                                        (required: icons for headings/checkboxes/links)
--   treesitter parsers: markdown, markdown_inline    install: :TSInstall markdown markdown_inline
--   lua deps (auto via lazy): nvim-web-devicons
--   optional, for LaTeX blocks:
--     install: pip install pylatexenc                (or libtexprintf for `utftex`)
--     install: :TSInstall latex
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.wo.cursorline = true
      end,
    })
  end,
  config = function()
    local render = require("render-markdown")

    render.setup({
      enabled = true,
      anti_conceal = { enabled = false },
      completions = { lsp = { enabled = true } },
      indent = { enabled = true },
      pipe_table = { preset = "round" },
    })

    vim.api.nvim_create_user_command("MdShow", function()
      render.toggle()
    end, { desc = "Включить/выключить оформленный вид markdown в буфере" })
  end,
}
