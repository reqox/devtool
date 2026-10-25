-- DEPENDENCIES:
--   Nerd Font                         (required: filetype/mode icons)
--   lua deps (auto via lazy): nvim-web-devicons
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto",
			},
			sections = {
				lualine_x = {
					{ "encoding" },
					{ "fileformat", symbols = { unix = "" } },
					{ "filetype" },
				},
			},
		})
	end,
}
