return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		{ "folke/lazydev.nvim", opts = {} },
	},

	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				-- Навигация и информация
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Перейти к определению
				-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- Перейти к объявлению
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Показать документацию
				-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- Перейти к реализации
				-- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Показать все использования

				-- Рефакторинг
				vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts) -- Переименовать
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code Action

				-- Диагностика (ошибки/предупреждения)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- Предыдущая ошибка
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- Следующая ошибка
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- Показать ошибку
			end,
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					runtime = { version = "LuaJIT" },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		})
		vim.lsp.config("ts_ls", {
			root_markers = { "package.json", "tsconfig.json" },
		})
		vim.lsp.config("emmet_ls", {
			root_markers = { "package.json" },
			filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact" },
		})
		vim.lsp.config("eslint", {
			root_markers = { ".eslintrc.js", ".eslintrc.json", "eslint.config.js", "package.json" },
			-- settings = {
			-- 	experimental = {
			-- 		useFlatConfig = true,
			-- 	},
			-- 	workingDirectory = { mode = "location" },
			-- },
		})
		vim.lsp.config("graphql", {
			root_markers = { ".graphqlrc", ".graphqlrc.yml", "package.json" },
		})
		vim.lsp.enable({
			"ts_ls",
			"lua_ls",
			"html",
			"cssls",
			"graphql",
			"emmet_ls",
			"sqlls",
			"jsonls",
			"pyright",
			"eslint",
		})
	end,
}
