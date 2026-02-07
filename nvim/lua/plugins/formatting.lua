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
						"--semi",
						"--tab-width",
						"2",
						"--trailing-comma",
						"all",
						"--arrow-parens",
						"always",
						"--print-width",
						"120",
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
			},
			format_on_save = {
				timeout_ms = 3000,
				lsp_fallback = true, -- Если prettier не найден, использовать LSP
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
