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

		luasnip.add_snippets("typescriptreact", {
			s("Image", {
				t("<Image "),
				t("className={''} "),
				t("src={''} "),
				t("alt={''} "),
				t("width={100} "),
				t("height={100} "),
				t("loading={'lazy'} "),
				t(" />"),
			}),
		})

		cmp.setup({
			view = {
				docs = {
					auto_open = false, -- Документация не будет открываться автоматически
				},
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
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

				-- Навигация (можно оставить твой Ctrl+n/p или заменить на Ctrl+j/k)
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),

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
