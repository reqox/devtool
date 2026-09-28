return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
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
        -- .git не показываем, но .gitignore не форсим - обычные dotfiles видны
        file_ignore_patterns = { "%.git/" },
      },
      pickers = {
        find_files = {
          hidden = true, -- показывать dotfiles (.env, .config и т.п.)
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
