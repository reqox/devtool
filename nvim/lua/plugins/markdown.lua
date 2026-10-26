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
    local function toggle_checkbox()
      local ok, parser = pcall(vim.treesitter.get_parser, 0, "markdown")
      if not ok or not parser then
        return false
      end
      parser:parse()

      local node = vim.treesitter.get_node({ bufnr = 0 })
      if not node then
        return false
      end

      local kind = node:type()
      if kind ~= "task_list_marker_unchecked" and kind ~= "task_list_marker_checked" then
        return false
      end

      local start_row, start_col, end_row, end_col = node:range()
      local replacement = kind == "task_list_marker_unchecked" and "[x]" or "[ ]"
      vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, { replacement })
      return true
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(args)
        vim.wo.cursorline = true

        vim.keymap.set("n", "x", function()
          if toggle_checkbox() then
            return
          end

          local count = vim.v.count
          vim.cmd(("normal! %sx"):format(count > 0 and count or ""))
        end, { buffer = args.buf, desc = "Markdown: переключить чекбокс или удалить символ" })

        vim.keymap.set("n", "<leader>mds", function()
          require("render-markdown").buf_toggle()
        end, { buffer = args.buf, desc = "Markdown: переключить оформленный вид" })
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
      render.buf_toggle()
    end, { desc = "Включить/выключить оформленный вид markdown в буфере" })
  end,
}
