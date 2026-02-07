return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		local function on_attach(bufnr)
			local api = require("nvim-tree.api")
			api.config.mappings.default_on_attach(bufnr)
			vim.keymap.set("n", "<CR>", function()
				print('o, ПОПАЛСЯ! Нажми "o"')
			end, { buffer = bufnr })
		end

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			on_attach = on_attach,
			view = {
				width = 50,
				relativenumber = true,
			},
			-- change folder arrow icons
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					git_placement = "signcolumn",
					glyphs = {
						folder = {
							-- arrow_closed = "", -- arrow when folder is closed
							arrow_closed = "c", -- arrow when folder is closed
							-- arrow_open = "", -- arrow when folder is open
							arrow_open = "o", -- arrow when folder is open
						},
						git = {
							unstaged = "M",
							staged = "S",
							renamed = "R",
							untracked = "U",
							deleted = "D",
							ignored = "I",
						},
					},
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer

		vim.api.nvim_create_user_command("Ex", function()
			local view = require("nvim-tree.view")

			if view.is_visible() then
				vim.cmd("NvimTreeFocus")
			else
				vim.cmd("NvimTreeOpen")
			end
		end, {})
	end,
}
