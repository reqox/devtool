-- DEPENDENCIES:
--   Neovim >= 0.11.7 (with LuaJIT)                install: built-in (0.12.5 OK)
--   ripgrep  (live_grep, grep_string)             install: sudo apt install ripgrep
--   fd       (find_files finder)                 install: sudo apt install fd-find
--                                                      (Ubuntu binary is "fdfind", telescope handles it)
--   build-essential (make + g++, fzf-native)      install: sudo apt install build-essential
--   lua deps (auto via lazy): plenary.nvim, nvim-web-devicons
return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
        sorting_strategy = "ascending",
        file_ignore_patterns = { "%.git/" },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    telescope.load_extension("fzf")

    local keymap = vim.keymap
    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Найти файл по имени" })
    keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Поиск по содержимому файлов" })
    keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Список открытых буферов" })
    keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Недавно открытые файлы" })
    keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Поиск слова под курсором" })
  end,
}
