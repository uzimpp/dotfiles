return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	priority = 1000,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- The mellifluous statusline theme lives in
		-- lua/lualine/themes/mellifluous.lua; options.theme = "auto" resolves it
		-- from the runtimepath when mellifluous is the active colorscheme.
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
			icon = "",
			-- Prepend the filetype icon to whatever lsp_status outputs
			fmt = function(str)
				if str == "" then
					return ""
				end
				local ok, devicons = pcall(require, "nvim-web-devicons")
				if ok then
					local icon = devicons.get_icon_by_filetype(vim.bo.filetype, { default = false })
					if icon and icon ~= "" then
						return icon .. " " .. str
					end
				end
				return str
			end,
			symbols = {
				spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
				done = "",
				separator = " ",
			},
			ignore_lsp = {},
			show_name = true,
		}

		local branch = {
			"branch",
			icon = "",
		}
		-- Read gitsigns' blame cache synchronously so the statusline tracks the
		-- cursor without waiting on gitsigns' async update.
		local git_blame = {
			function()
				local ok, gs_cache = pcall(require, "gitsigns.cache")
				if ok then
					local bcache = gs_cache.cache[vim.api.nvim_get_current_buf()]
					local entries = bcache and bcache.blame and bcache.blame.entries
					local entry = entries and entries[vim.api.nvim_win_get_cursor(0)[1]]
					if entry then
						local info = require("gitsigns.util").convert_blame_info(entry)
						local fmt = info.author == "Not Committed Yet"
								and "  Not committed yet"
							or "  <author> at <author_time:%d %b %Y>"
						return require("gitsigns.blame_formatter").expand_string(
							fmt,
							bcache.git_obj.repo.username,
							info,
							{ self_author_text = "You" }
						)
					end
				end
				return vim.b.gitsigns_blame_line or ""
			end,
			cond = function()
				return vim.b.gitsigns_blame_line ~= nil and vim.b.gitsigns_blame_line ~= ""
			end,
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				-- https://www.nerdfonts.com/cheat-sheet
				--             ▓▒░ ░▒▓
				component_separators = { left = "", right = "" }, -- 
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					"alpha",
					statusline = {},
					winbar = {},
				},
				globalstatus = false,
				always_divide_middle = true,
				ignore_focus = {},
				always_show_tabline = false,
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
				lualine_x = { branch, git_blame },
				lualine_y = { lsp },
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
			tabline = {
				-- lualine_a = { mode },
				-- lualine_b = { 'branch' },
				-- lualine_c = { filename },
				-- lualine_x = { git_blame  },
				-- lualine_x = { diagnostics },
				-- lualine_y = { 'progress' },
				-- lualine_z = { 'location' },
				-- lualine_a = { mode },
				-- lualine_b = { filename },
				-- lualine_c = { diagnostics },
				-- lualine_x = { git_blame },
				-- lualine_x = { branch },
				-- lualine_y = { git_blame },
				-- lualine_z = { "location" },
			},
			extensions = { "fugitive", "neo-tree" },
		})
	end,
}
