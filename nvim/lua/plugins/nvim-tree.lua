-- DEPENDENCIES:
--   external tools: none
--   lua deps (auto via lazy): nvim-web-devicons
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    local function on_attach(bufnr)
      local api = require("nvim-tree.api")
      api.map.on_attach.default(bufnr)
      vim.keymap.set("n", "<CR>", function()
        print('o, ПОПАЛСЯ! Нажми "o"')
      end, { buffer = bufnr })
    end

    nvimtree.setup({
      disable_netrw = true,
      on_attach = on_attach,
      view = {
        width = 50,
        relativenumber = true,
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          git_placement = "signcolumn",
          glyphs = {
            git = {
              unstaged = "M",
              staged = "S",
              renamed = "R",
              untracked = "U",
              deleted = "D",
              ignored = "I",
            },
          },
        },
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
        git_ignored = false,
      },
    })

    local keymap = vim.keymap
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Toggle file explorer on current file" })
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

    vim.api.nvim_create_user_command("Ex", function()
      local view = require("nvim-tree.view")

      if view.is_visible() then
        vim.cmd("NvimTreeFocus")
      else
        vim.cmd("NvimTreeOpen")
      end
    end, {})
  end,
}
