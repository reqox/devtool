-- DEPENDENCIES:
--   git (required)
return {
	"lewis6991/gitsigns.nvim",
	lazy = false,
	config = function()
		local gitsigns = require("gitsigns")

		gitsigns.setup({
			-- По умолчанию знаков нет; :GitShow / <leader>gs включают и выключают.
			signcolumn = false,
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "-" },
				topdelete = { text = "-" },
				changedelete = { text = "~" },
				untracked = { text = "+" },
			},
			-- Чтобы после git add не появлялись другие символы (┃, ▁, ▔).
			signs_staged = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "-" },
				topdelete = { text = "-" },
				changedelete = { text = "~" },
			},
		})

		vim.api.nvim_create_user_command("GitShow", function()
			gitsigns.toggle_signs()
		end, { desc = "Переключить знаки git в signcolumn" })

		vim.api.nvim_create_user_command("GitReview", function()
			gitsigns.diffthis(nil, { unified = true })
		end, { desc = "Переключить inline-дифф текущего файла" })

		vim.keymap.set("n", "<leader>gs", function()
			gitsigns.toggle_signs()
		end, { desc = "Git: переключить знаки" })

		vim.keymap.set("n", "<leader>gr", function()
			gitsigns.diffthis(nil, { unified = true })
		end, { desc = "Git: переключить review" })
	end,
}
