return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
		ensure_installed = {
			-- Frontend & Backend
			"javascript",
			"typescript",
			"tsx",
			"jsx",
			"vue",
			"html",
			"css",
			"scss",
			"sql",
			-- Other
			"lua",
			"vim",
			"vimdoc",
			"json",
			"yaml",
			"markdown",
			"markdown_inline",
			"bash",
			"dockerfile",
			"gitignore",

			"python",
			"c",
			"cpp",
		},
	},
}
