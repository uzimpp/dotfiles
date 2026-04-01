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
			desc = "buffer format",
		},
	},
	config = function()
		-- 1. Setup Conform
		require("conform").setup({
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable autoformat on certain filetypes if you want
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return
				end
				return {
					timeout_ms = 500,
					lsp_fallback = true,
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" }, -- ruff is much faster than autopep8/black
				javascript = { "prettier" },
				typescript = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				go = { "goimports", "gofmt" }, -- runs sequentially
			},
		})

		-- 2. Tell Mason to auto-install these formatters so you don't have to do it manually
		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua",
				"prettier",
				"goimports",
			},
			-- We don't need to put 'ruff' here because it's already installed via the LSP config
		})
	end,
}
