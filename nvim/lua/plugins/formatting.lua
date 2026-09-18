return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters = {
				prettier = {
					prepend_args = {
						--Кавычки и запятые
						"--single-quote",
						"--jsx-single-quote",
						"--trailing-comma", "all",
						--Точка с запятой и скобки
						"--semi",
						"--bracket-spacing",
						"--bracket-same-line",
						--Отступы и длина строки
						"--tab-width", "2",
						"--use-tabs", "false",
						"--print-width", "120",
						--Стрелочные функции и переносы
						"--arrow-parens", "always",
						"--prose-wrap", "preserve",
						"--end-of-line", "lf",
						--HTML/JSX
						"--single-attribute-per-line", "false",
					},
				},
			},
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				svelte = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				python = { "isort", "black" },
				lua = { "stylua" },
				sql = { "sql_formatter" },
				rust = { "rustfmt" },
			},
			format_on_save = {
				timeout_ms = 3000,
				lsp_fallback = true,
				async = false,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range" })
	end,
}
