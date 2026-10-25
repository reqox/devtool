-- DEPENDENCIES:
--   Neovim 0.11+ (проверено на 0.12.5)   -- vim.lsp.config()/vim.lsp.enable(), vim.diagnostic.jump()
--   внешних бинарников не нужно: серверы ставит mason'ом mason-lspconfig.nvim, см. lsp/mason.lua
--   (там же системные требования mason: git/curl/unzip/tar/gzip + node/npm)
--   Nerd Font                             -- иконки в mason-UI
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    { "folke/lazydev.nvim", opts = {} },
  },

  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-keymaps", { clear = true }),
      callback = function(ev)
        local function opts(desc)
          return { buffer = ev.buf, silent = true, desc = desc }
        end

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("LSP: goto definition"))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("LSP: goto declaration"))
        vim.keymap.set("n", "gK", vim.lsp.buf.hover, opts("LSP: hover"))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("LSP: goto implementation"))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("LSP: references"))

        vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts("LSP: rename"))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("LSP: code action"))

        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1 })
        end, opts("Диагностика: предыдущая ошибка"))
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1 })
        end, opts("Диагностика: следующая ошибка"))
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts("Диагностика: показать ошибку"))
      end,
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          runtime = { version = "LuaJIT" },
          telemetry = { enable = false },
        },
      },
    })
  end,
}
