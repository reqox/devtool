-- DEPENDENCIES:
--   Neovim 0.11+ (проверено на 0.12.5)
--   git, curl|wget, unzip, tar, gzip install: sudo apt install git curl unzip tar gzip

--   node + npm install: nvm install --lts (нужен большинству LSP-серверов:
--   ts_ls, eslint, html, cssls, jsonls, emmet_ls, graphql, vue, pyright, sqlls)

--   Nerd Font (иконки в :Mason)
--   Всё ставится mason'ом в ~/.local/share/nvim/mason/bin + add to PATH
return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			automatic_enable = true,
			ensure_installed = {
				"html",
				"cssls",
				"emmet_ls",
				"lua_ls",
				"ts_ls",
				"vue_ls",
				"eslint",
				"sqlls",
				"jsonls",
				"pyright",
				"rust_analyzer",
			},
		},
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"prettier",
				"stylua",
				"sql-formatter",
				"isort",
				"black",
			},
		},
		dependencies = {
			"mason-org/mason.nvim",
		},
	},
}
