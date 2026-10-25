-- Dependensies - всё вручную/автоматически через Mason
return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters = {
				prettier = {
					prepend_args = {
						"--single-quote",
						"--jsx-single-quote",
						"--bracket-same-line",
						"--print-width",
						"120",
					},
				},
			},
			formatters_by_ft = {
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				svelte = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },
				graphql = { "prettier" },
				python = { "isort", "black" },
				lua = { "stylua" },
				sql = { "sql_formatter" },
				rust = { "rustfmt" },
				dockerfile = { "dockerfmt" },
			},
			format_on_save = {
				timeout_ms = 3000,
				lsp_format = "fallback",
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>fr", function()
			conform.format({
				lsp_format = "fallback",
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range" })
	end,
}
