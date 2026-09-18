return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
		},
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets", -- 🔥 Тонна готовых сниппетов
		"onsails/lspkind.nvim", -- VS Code иконки
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		-- Загрузка готовых сниппетов из friendly-snippets
		require("luasnip.loaders.from_vscode").lazy_load()
		local s = luasnip.snippet
		local t = luasnip.text_node

		cmp.setup({
			view = {
				docs = {
					auto_open = false, -- Документация не будет открываться автоматически
				},
			},
			snippet = {
				expand = function(args)
					local ok, _ = pcall(luasnip.lsp_expand, args.body)
					if not ok then
						vim.snippet.expand(args.body)
					end
				end,
			},
			mapping = cmp.mapping.preset.insert({
				-- Tab = подтвердить (твой вариант — удобнее!)
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = true })
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Скролл документации (новое!)
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				["<C-Space>"] = cmp.mapping.complete(),
				["<C-a>"] = cmp.mapping.abort(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),
			window = {
				completion = cmp.config.window.bordered({
					max_height = 10,
				}),
				documentation = cmp.config.window.bordered({
					max_height = 10,
				}),
			},
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text", -- Иконка + текст
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})
	end,
}
