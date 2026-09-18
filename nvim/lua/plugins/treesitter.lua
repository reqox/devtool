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
		auto_install = true,
		ensure_installed = {
			"html", "css", "javascript",
			"jsx", "tsx", "typescript",
			"lua", "vim", "vimdoc",
			"json", "yaml", "markdown", "markdown_inline", 
			"query", "sql", "vue",
			"bash", "dockerfile",
			"python", "c", "rust",
		},
	},
}
