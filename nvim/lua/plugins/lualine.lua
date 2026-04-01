return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	priority = 1000,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local mode = {
			"mode",
			fmt = function(str)
				return "" .. str
			end,
		}

		local filename = {
			"filename",
			file_status = true,
			path = 4,
		}

		local hide_in_width = function()
			return vim.fn.winwidth(0) > 10
		end

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
			colored = true,
			update_in_insert = true,
			always_visible = false,
			cond = hide_in_width,
		}

		local diff = {
			"diff",
			colored = true,
			symbols = { added = "+", modified = "~", removed = "-" },
			cond = hide_in_width,
		}

		local lsp = {
			"lsp_status",
			symbols = {
				-- Standard unicode symbols to cycle through for LSP progress:
				spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
				-- Standard unicode symbol for when LSP is done:
				done = "✓",
				-- Delimiter inserted between LSP names:
				separator = " ",
			},
			-- List of LSP names to ignore (e.g., `null-ls`):
			ignore_lsp = {},
			-- Display the LSP name
			show_name = true,
		}

		local branch = {
			"branch",
			icon = { "" },
		}
		-- -- Git blame component using git-blame.nvim (like VS Code GitLens)
		local git_blame = {
			function()
				local gitblame = require("gitblame")
				return gitblame.get_current_blame_text()
			end,
			cond = function()
				local ok, gitblame = pcall(require, "gitblame")
				return ok and gitblame.is_blame_text_available()
			end,
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				-- https://www.nerdfonts.com/cheat-sheet
				--             ▓▒░ ░▒▓
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha" },
				globalstatus = false,
				always_divide_middle = true,
			},
			sections = {
				-- lualine_a = { mode },
				-- lualine_b = { 'branch' },
				-- lualine_c = { filename },
				-- -- lualine_x = { git_blame  },
				-- lualine_x = { diagnostics },
				-- lualine_y = { 'progress' },
				-- lualine_z = { 'location' },
				lualine_a = { mode },
				lualine_b = { filename },
				lualine_c = { diagnostics },
				-- lualine_x = { git_blame },
				lualine_x = { branch },
				lualine_y = { git_blame },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = { { "filename", path = 4 } },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive", "neo-tree" },
		})
	end,
}
