-- Синхронная установка парсеров и Mason-пакетов при сборке образа.
-- Запуск: nvim --headless "+Lazy! sync" "+luafile build.lua" +qa
local TIMEOUT = 15 * 60 * 1000

local function fail(msg)
  io.stderr:write("build.lua: " .. msg .. "\n")
  os.exit(1)
end

local ok, err = pcall(function()
  -- treesitter: install() асинхронный, ждём задачу до конца
  require("nvim-treesitter").install(require("config.parsers")):wait(TIMEOUT)

  -- mason-tool-installer: штатная синхронная команда
  vim.cmd("MasonToolsInstallSync")

  -- mason-lspconfig: в headless он сам ensure_installed пропускает, запускаем вручную
  local refreshed = false
  require("mason-registry").refresh(function()
    refreshed = true
  end)
  if not vim.wait(TIMEOUT, function() return refreshed end, 200) then
    error("mason registry refresh timed out")
  end
  require("mason-lspconfig.features.ensure_installed")()

  local registry = require("mason-registry")
  vim.wait(TIMEOUT, function()
    for _, pkg in ipairs(registry.get_all_packages()) do
      if pkg:is_installing() then
        return false
      end
    end
    return true
  end, 1000)

  local wanted = require("lazy.core.config").plugins["mason-lspconfig.nvim"].opts.ensure_installed
  local have = {}
  for _, name in ipairs(require("mason-lspconfig").get_installed_servers()) do
    have[name] = true
  end
  for _, name in ipairs(wanted) do
    if not have[name] then
      error("mason-lspconfig: server not installed: " .. name)
    end
  end
end)

if not ok then
  fail(tostring(err))
end
