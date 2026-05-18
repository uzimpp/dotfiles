return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>bf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "n",
			desc = "Buffer Format",
		},
	},
	config = function()
		require("conform").setup({
			notify_on_error = true,
			format_on_save = false, -- manual only via <leader>bf

			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format", "ruff_organize_imports" },
				go = { "goimports", "gofumpt" },
				rust = { lsp_format = "fallback" },
				java = { lsp_format = "fallback" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				["*"] = { "trim_whitespace" },
			},

			formatters = {
				shfmt = {
					prepend_args = { "-i", "2", "-ci", "-sr" },
				},
				prettier = {
					prepend_args = { "--prose-wrap", "always" },
				},
			},
		})
	end,
}
