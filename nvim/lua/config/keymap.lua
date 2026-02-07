--[[ vim.keymap.set({mode}, {lhs}, {rhs}, {opts})

  1. {mode} - Режим
      'n' - normal - default or <Esc>
      'i' - insert - i, a, o, I, A
      'v' - visual - <C-v> символьное выделение
      'x' - visual block - <C-V> выделение столбцами
      't' - terminal - :term (<C-\><C-n> для выхода из t-mode)
      'c' - command - Нажать : в normal mode
      's' - select - Используется редко, обычно для сниппетов

  2. {lhs} - Клавиши, которые вы нажимаете (Left Hand Side)
      Модификаторы:
        <C-...> - Control + ...
        <A-...> or <M-...> - Alt + ...
        <S-...> - Shift + ...
      Специальные клавиши:
        <leader> - задаётся через vim.g.mapleader
        <CR> - Enter
        <Esc> - Escape
        <Space>, <Tab>, <BS> (Backspace)
        <Up>, <Down>, <Left>, <Right> Стрелки
      Комбинации:
        Можно делать последовательности/комбинации
        <leader>sv - сначала <leader>, потом s, потом v
        <C-o><C-k> - сначала Control + O, потом Control + k. NeoVim будет ждать следующего нажатия, если есть совпадения
        <C-S-o> - Control + Shift + O

  3. {rhc} - Команда или функция, которая должна выполниться (Right Hand Side)
      Если это строка: Буквально пишем то, что нажимали бы на клавиатуре
        ":w<CR>" - : -> w -> Enter
        "daw" - Удалит слово под курсором (delete around word)
        "iHello<Esc>" - Перейдёт в режим вставки, напишет Hello и выйдет в normal mode
      Если это lua function
        function()
          print("Hello, World!")
        end

  4. {opts} - таблица дополнительных настроек (опционально)
    Это таблица {}, которая меняет поведение keymap'а.
      silent = true - Neovim не будет показывать ввод команды (ввод :w в command). Будет чистый экран.
      noremap = true - Запрещает рекурсию, по умолчанию true. Если вы замапили a на b, а b на c, то a напечатает b, а не c
      remap = false - Позволяет рекурсию
      desc = "Description" - Это текст, который будет виден в меню помощи или в плагине which-key
      buffer = true (или ID) - Маппинг будет работать только в этом файле
      expr = false - Позволяет rhc возвращать строку, которая затем будет исполнена.
]]

local k = vim.keymap

k.set({ "n" }, "<leader>o", ":put _<CR>", { desc = "Вставить пустую строку ниже" })
k.set({ "n" }, "<leader>O", ":put! _<CR>", { desc = "Вставить пустую строку выше" })

k.set({ "n" }, "<C-j>", "<C-w>j", { desc = "Move to lower window" })
k.set({ "n" }, "<C-k>", "<C-w>k", { desc = "Move to upper window" })
k.set({ "n" }, "<C-h>", "<C-w>h", { desc = "Move to left window" })
k.set({ "n" }, "<C-l>", "<C-w>l", { desc = "Move to right window" })

k.set({ "n" }, "<C-S-j>", "<C-w>J", { desc = "Move window to lower" })
k.set({ "n" }, "<C-S-k>", "<C-w>K", { desc = "Move window to upper" })
k.set({ "n" }, "<C-S-h>", "<C-w>H", { desc = "Move window to left" })
k.set({ "n" }, "<C-S-l>", "<C-w>L", { desc = "Move window to right" })
