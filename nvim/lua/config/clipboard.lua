-- Системный буфер обмена через OSC 52.
-- Работает на уровне терминала, поэтому одинаково ведёт себя в контейнере,
-- в tmux и по ssh: nvim пишет escape-последовательность в свой tty,
-- а tmux (с set-clipboard on) передаёт её наружу вплоть до Alacritty.
--
-- Провайдер только на запись. Чтение системного буфера намеренно не
-- реализовано: иначе любой процесс в контейнере или на удалённом хосте
-- мог бы вытащить локальный буфер. "+p" возвращает последнее скопированное
-- из самого nvim, а вставка из системы — терминалом (Ctrl+Shift+V).
local osc52 = require('vim.ui.clipboard.osc52')

local last = {}

local function copy(lines)
  last = vim.deepcopy(lines)
  -- В headless нет UI, и nvim_ui_send упал бы. Копировать всё равно некуда.
  if #vim.api.nvim_list_uis() == 0 then
    return
  end
  osc52.copy('+')(lines)
end

vim.g.clipboard = {
  name = 'osc52-write-only',
  copy = { ['+'] = copy, ['*'] = copy },
  paste = { ['+'] = function() return last end, ['*'] = function() return last end },
}

-- clipboard не включаем: иначе unnamedplus сделает "+" регистром по умолчанию
-- и обычный p начнёт читать системный буфер, которого мы не читаем.
