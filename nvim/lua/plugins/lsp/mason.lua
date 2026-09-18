return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			automatic_installation = true,
			ensure_installed = {
				"html", "cssls", "emmet_ls", "lua_ls", 
				-- "ts_ls", "eslint", 
				-- "graphql", "sqlls", "jsonls",
				-- "pyright",
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
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
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
			},
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
}
