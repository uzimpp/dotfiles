return {
	"mhinz/vim-startify",
	lazy = false, -- must load at startup to take over the start screen
	dependencies = {
		"ahmedkhalf/project.nvim", -- source for recent projects
	},
	-- g:startify_* are read when startify draws (VimEnter), so set them in
	-- `init` (runs before the plugin loads) rather than `config`.
	init = function()
		-- Single source of truth for list sizes. Recent files take indices
		-- 0..FILES-1, Recent projects take FILES..FILES+PROJECTS-1.
		local FILES = 10
		local PROJECTS = 10

		-- Recent projects from project.nvim's history file (reliable at startup,
		-- unlike the async get_recent_projects()). Newest entries are at the end.
		-- No built-in startify list covers this, so it stays a custom funcref.
		function _G.startify_recent_projects()
			local out = {}
			local hist = vim.fn.stdpath("data") .. "/project_nvim/project_history"
			if vim.fn.filereadable(hist) == 0 then
				return out
			end
			local seen = {}
			local lines = vim.fn.readfile(hist)
			for i = #lines, 1, -1 do
				local p = lines[i]
				if p ~= "" and not seen[p] and vim.fn.isdirectory(p) == 1 then
					seen[p] = true
					out[#out + 1] = {
						line = vim.fn.fnamemodify(p, ":~"),
						cmd = "cd " .. vim.fn.fnameescape(p) .. " | Telescope find_files",
					}
					if #out >= PROJECTS then
						break
					end
				end
			end
			return out
		end

		vim.cmd([[
			function! StartifyRecentProjects() abort
				return v:lua.startify_recent_projects()
			endfunction

			let g:startify_lists = [
				\ { 'type': 'commands',                          'header': ['   Menu'] },
				\ { 'type': 'files',                             'header': ['   Recent files'] },
				\ { 'type': function('StartifyRecentProjects'),  'header': ['   Recent projects'] },
				\ ]
		]])

		vim.g.startify_commands = {
			{ e = { "New file", ":enew" } },
			{ f = { "Find files", ":Telescope find_files" } },
			{ r = { "Recent files", ":Telescope oldfiles" } },
			{ p = { "Recent projects", ":Telescope projects" } },
			{ m = { "Mason", ":Mason" } },
			{ q = { "Quit", ":qa" } },
		}

		vim.g.startify_files_number = FILES -- length of the Recent files list
		vim.g.startify_enable_special = 0 -- drop built-in [empty buffer]/[quit]
		-- Auto-index pool, drawn in list order: Recent files take 0..FILES-1,
		-- Recent projects continue from there.
		local indices = {}
		for i = 0, FILES + PROJECTS - 1 do
			indices[#indices + 1] = tostring(i)
		end
		vim.g.startify_custom_indices = indices

		vim.g.startify_custom_header = {
			[[                                                      ]],
			[[   888888ba                             oo            ]],
			[[   88    `8b                                          ]],
			[[   88     88 .d8888b. .d8888b. dP   .dP dP 88d8b.d8b. ]],
			[[   88     88 88ooood8 88'  `88 88   d8' 88 88'`88'`88 ]],
			[[   88     88 88.  ... 88.  .88 88 .88'  88 88  88  88 ]],
			[[   dP     dP `88888P' `88888P' 8888P'   dP dP  dP  dP ]],
			[[                                                      ]],
		}

		-- Hide the statusline on the dashboard.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "startify",
			callback = function(args)
				local saved = vim.o.laststatus
				vim.o.laststatus = 0
				vim.api.nvim_create_autocmd("BufUnload", {
					buffer = args.buf,
					once = true,
					callback = function()
						vim.o.laststatus = saved
					end,
				})
			end,
		})
	end,
}
