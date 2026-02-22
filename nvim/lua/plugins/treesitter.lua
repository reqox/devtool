return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			ensure_installed = {
				"javascript",
				"typescript",
				"tsx",
				"vue",
				"html",
				"css",
				"scss",
				"sql",
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
		})
	end,
}
