return {
	"ramojus/mellifluous.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- Every UI/plugin override lives here so it re-applies on each
		-- :colorscheme reload (e.g. the <leader>bg transparency toggle). The
		-- highlighter API runs after mellifluous' own highlights and survives a
		-- re-setup(), which is why the previous hand-rolled ColorScheme autocmd
		-- is no longer needed. Colors are used straight from mellifluous' native
		-- palette (+ shades), so the UI tracks the colorset. Shade meanings:
		--   dark_bg = split/float bg, bg2 = cursorline/borders, bg3 = floats/
		--   selection, fg2 = split text, fg4 = line numbers, fg5 = hidden/dim.
		local function ui_overrides(hl, colors)
			-- Git status colors, kept distinct from the colorset accents.
			local git = {
				add = "#97b393",
				change = "#bfb68e",
				delete = "#d59192",
				untracked = "#b99bb5",
			}

			-- Transparent-aware surface backgrounds. We hardcode bg on many
			-- groups, which would otherwise stay opaque when transparency is on.
			-- Mirror mellifluous' own gating: a surface goes "NONE" when
			-- transparency is enabled AND its sub-flag is set, so these overrides
			-- blend through the <leader>bg toggle just like the built-in groups.
			local tb = require("mellifluous.config").config.transparent_background or {}
			local on = tb.enabled
			local function surface(solid, flag)
				if flag == nil then
					flag = true -- main editor surfaces follow the master flag
				end
				return (on and flag) and "NONE" or solid
			end
			local bg_editor = surface(colors.bg) -- signcolumn, linenr, gitsigns, splits
			local bg_cline = surface(colors.bg, tb.cursor_line)
			local bg_sign = surface(colors.dark_bg) -- diagnostic signs (in signcolumn)
			local bg_dash = surface(colors.dark_bg) -- alpha dashboard
			local bg_tree = surface(colors.dark_bg, tb.file_tree)
			local bg_tel = surface(colors.dark_bg, tb.telescope)
			local bg_float = surface(colors.dark_bg, tb.floating_windows)
			local bg_status = surface(colors.dark_bg, tb.status_line)

			-- ── General ─────────────────────────────────────────────────────
			hl.set("Cursor", { bg = colors.fg, fg = colors.bg })
			hl.set("TermCursor", { link = "Cursor" })
			hl.set("Comment", { fg = colors.fg4, style = { italic = true } })
			hl.set("@comment", { link = "Comment" })
			hl.set("ColorColumn", { bg = colors.dark_bg })
			hl.set("VertSplit", { bg = bg_editor, fg = colors.fg5 })
			hl.set("LineNr", { bg = bg_editor, fg = colors.fg4 })
			hl.set("CursorLineNr", { bg = bg_editor, fg = colors.fg, style = { bold = true, italic = true } })
			hl.set("CursorColumn", { bg = colors.bg2 })
			hl.set("CursorLine", { bg = bg_cline })
			hl.set("SignColumn", { bg = bg_editor, fg = colors.fg5 })
			hl.set("GitSignsAdd", { bg = bg_editor, fg = git.add })
			hl.set("GitSignsChange", { bg = bg_editor, fg = git.change })
			hl.set("GitSignsDelete", { bg = bg_editor, fg = git.delete })

			-- ── Diagnostics ─────────────────────────────────────────────────
			hl.set("DiagnosticSignWarn", { bg = bg_sign, fg = colors.orange })
			hl.set("DiagnosticSignError", { bg = bg_sign, fg = colors.red })
			hl.set("DiagnosticSignInfo", { bg = bg_sign, fg = colors.blue })
			hl.set("DiagnosticSignHint", { bg = bg_sign, fg = colors.purple })
			hl.set("DiagnosticSignOk", { bg = bg_sign, fg = colors.green })

			-- ── Alpha Dashboard ─────────────────────────────────────────────
			hl.set("AlphaBackground", { bg = bg_dash, fg = colors.fg })
			hl.set("AlphaHeader", { fg = colors.red, bg = bg_dash })
			hl.set("AlphaButtons", { fg = colors.fg5, bg = bg_dash, style = { italic = true } })
			hl.set("AlphaFooter", { fg = colors.fg5, bg = bg_dash })

			-- ── Neo-tree ────────────────────────────────────────────────────
			hl.set("NeoTreeNormal", { bg = bg_tree, fg = colors.fg4 })
			hl.set("NeoTreeNormalNC", { bg = bg_tree, fg = colors.fg4 })
			hl.set("NeoTreeEndOfBuffer", { bg = bg_tree, fg = bg_tree })
			hl.set("NeoTreeCursorLine", { bg = colors.bg3 })
			hl.set("NeoTreeIndentMarker", { fg = colors.fg4 })
			hl.set("NeoTreeFileName", { fg = colors.fg4 })
			hl.set("NeoTreeDirectoryName", { fg = colors.fg4 })
			hl.set("NeoTreeDirectoryIcon", { fg = colors.fg4 })
			hl.set("NeoTreeRootName", { fg = colors.orange, style = { bold = true } })
			hl.set("NeoTreeFloatBorder", { bg = bg_float, fg = colors.bg2 })
			hl.set("NeoTreeFloatTitle", { bg = bg_float, fg = colors.fg })
			hl.set("NeoTreeGitAdded", { fg = git.add })
			hl.set("NeoTreeGitModified", { fg = git.change })
			hl.set("NeoTreeGitDeleted", { fg = git.delete })
			hl.set("NeoTreeGitUntracked", { fg = git.untracked })
			hl.set("NeoTreeDimText", { fg = colors.fg5 })
			hl.set("NeoTreeDotfile", { fg = colors.fg5 })
			hl.set("NeoTreeHiddenByName", { fg = colors.fg5 })
			hl.set("NeoTreeGitIgnored", { fg = colors.fg5 })
			hl.set("NeoTreeIgnored", { fg = colors.fg5 })

			-- ── Telescope ───────────────────────────────────────────────────
			hl.set("TelescopeNormal", { bg = bg_tel, fg = colors.fg4 })
			hl.set("TelescopeBorder", { fg = bg_tel, bg = bg_tel })

			hl.set("TelescopePromptNormal", { bg = bg_tel, fg = colors.fg })
			hl.set("TelescopePromptBorder", { bg = bg_tel, fg = colors.bg2 })
			hl.set("TelescopePromptTitle", { bg = bg_tel, fg = colors.fg2 })

			hl.set("TelescopeResultsNormal", { bg = bg_tel, fg = colors.fg2 })
			hl.set("TelescopeResultsBorder", { bg = bg_tel, fg = colors.bg2 })
			hl.set("TelescopeResultsTitle", { bg = bg_tel, fg = colors.fg2 })
			hl.set("TelescopeResultsLineNr", { bg = bg_tel, fg = colors.fg4 })
			hl.set("TelescopeResultsNumber", { fg = colors.purple })
			hl.set("TelescopeResultsOperator", { fg = colors.ui_blue })
			hl.set("TelescopeResultsVariable", { fg = colors.orange })

			hl.set("TelescopePreviewNormal", { bg = surface(colors.bg, tb.telescope) })
			hl.set("TelescopePreviewBorder", { bg = bg_tel, fg = colors.bg2 })
			hl.set("TelescopePreviewTitle", { bg = bg_tel, fg = colors.fg2 })
			hl.set("TelescopePreviewMatch", { bg = colors.bg3, fg = colors.orange })
			hl.set("TelescopePreviewLine", { bg = colors.bg3 })

			hl.set("TelescopeSelection", { bg = colors.bg3 })
			hl.set("TelescopeSelectionCaret", { fg = colors.dark_bg })
			hl.set("TelescopeMatching", { fg = colors.orange, style = { bold = true } })

			-- ── Cmp (popup menu, kept opaque like Pmenu) ────────────────────
			hl.set("CmpDocumentationBorder", { bg = colors.bg3 })
			hl.set("CmpItemAbbr", { fg = colors.fg2 })
			hl.set("CmpItemAbbrDeprecated", { fg = colors.comments })
			hl.set("CmpItemAbbrMatch", { fg = colors.fg })
			hl.set("CmpItemKind", { fg = colors.ui_blue })

			-- ── Mason (floating installer UI) ───────────────────────────────
			hl.set("MasonNormal", { bg = bg_float, fg = colors.fg2 })
			hl.set("MasonHeader", { bg = colors.orange, fg = colors.bg, style = { bold = true } })
			hl.set("MasonHeaderSecondary", { bg = colors.purple, fg = colors.bg, style = { bold = true } })
			hl.set("MasonHighlight", { fg = colors.orange })
			hl.set("MasonHighlightBlock", { bg = colors.ui_blue, fg = colors.bg })
			hl.set("MasonHighlightBlockBold", { bg = colors.ui_blue, fg = colors.bg, style = { bold = true } })
			hl.set("MasonHighlightSecondary", { fg = colors.purple })
			hl.set("MasonHighlightBlockSecondary", { bg = colors.purple, fg = colors.bg })
			hl.set("MasonHighlightBlockBoldSecondary", { bg = colors.purple, fg = colors.bg, style = { bold = true } })
			hl.set("MasonMuted", { fg = colors.fg5 })
			hl.set("MasonMutedBlock", { bg = colors.bg2, fg = colors.fg4 })
			hl.set("MasonMutedBlockBold", { bg = colors.bg2, fg = colors.fg, style = { bold = true } })
			hl.set("MasonError", { fg = colors.red })
			hl.set("MasonWarning", { fg = colors.orange })

			-- ── WhichKey ────────────────────────────────────────────────────
			hl.set("WhichKey", { fg = colors.ui_blue, style = { bold = true } }) -- The key itself
			hl.set("WhichKeyGroup", { fg = colors.blue }) -- A group of keys
			hl.set("WhichKeyDesc", { fg = colors.purple }) -- The description of the key
			hl.set("WhichKeySeparator", { fg = colors.fg5 }) -- Separator between key and desc
			hl.set("WhichKeyFloat", { bg = bg_float }) -- Floating window background
			hl.set("WhichKeyNormal", { bg = bg_float }) -- Window background (newer versions)
			hl.set("WhichKeyBorder", { fg = colors.bg2, bg = bg_float }) -- Window border
			hl.set("WhichKeyValue", { fg = colors.fg2 })

			-- ── Notify / Noice / Statusline ─────────────────────────────────
			hl.set("NotifyBackground", { bg = surface(colors.bg, tb.floating_windows), fg = colors.fg })
			hl.set("NoicePopup", { bg = bg_float, fg = colors.fg })
			hl.set("NoiceCmdlinePopup", { bg = bg_float, fg = colors.fg })
			hl.set("StatusLineNC", { bg = bg_status, fg = bg_status })
			hl.set("StatusLine", { bg = bg_status, fg = bg_status })
		end

		require("mellifluous").setup({
			colorset = "mellifluous",
			-- modify some colors for mellifluous colorset
			mellifluous = {
				highlight_overrides = {
					dark = function(highlighter, colors)
						highlighter.set("Keyword", { fg = colors.main_keywords })
						highlighter.set("Identifier", { fg = colors.fg })
						highlighter.set("Type", { fg = colors.types })
						highlighter.set("Operator", { fg = colors.operators })
						highlighter.set("String", { fg = colors.strings })
						highlighter.set("Function", { fg = colors.functions })
						highlighter.set("Constant", { fg = colors.constants })
						highlighter.set("@keyword", { fg = colors.main_keywords })
						highlighter.set("@type", { fg = colors.types })
						highlighter.set("@operator", { fg = colors.operators })
						highlighter.set("@string", { fg = colors.strings })
						highlighter.set("@function", { fg = colors.functions })
						highlighter.set("@constant", { fg = colors.constants })
						-- UI / plugin overrides (Comment + @comment are set here)
						ui_overrides(highlighter, colors)
					end,
					light = function(highlighter, colors)
						highlighter.set("Keyword", { fg = colors.main_keywords })
						highlighter.set("Identifier", { fg = colors.fg })
						highlighter.set("Type", { fg = colors.types })
						highlighter.set("Operator", { fg = colors.operators })
						highlighter.set("String", { fg = colors.strings })
						highlighter.set("Function", { fg = colors.functions })
						highlighter.set("Constant", { fg = colors.constants })
						highlighter.set("Comment", { fg = colors.comments })
						highlighter.set("@keyword", { fg = colors.main_keywords })
						highlighter.set("@type", { fg = colors.types })
						highlighter.set("@operator", { fg = colors.operators })
						highlighter.set("@string", { fg = colors.strings })
						highlighter.set("@function", { fg = colors.functions })
						highlighter.set("@constant", { fg = colors.constants })
						highlighter.set("@comment", { fg = colors.comments })
					end,
				},
			},
			styles = {
				comments = { italic = true },
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				main_keywords = {},
				other_keywords = {},
				operators = {},
				functions = { bold = true },
				constants = {},
			},

			transparent_background = {},

			flat_background = {},

			plugins = {
				cmp = true,
				gitsigns = true,
				indent_blankline = true,
				nvim_tree = { enabled = true },
				neo_tree = { enabled = true },
				telescope = { enabled = true },
				treesitter = { enabled = true, colored_brackets = true },
			},
		})

		vim.cmd.colorscheme("mellifluous")

		-- Toggle transparency
		local bg_transparent = true
		vim.keymap.set("n", "<leader>bg", function()
			bg_transparent = not bg_transparent
			require("mellifluous").setup({
				transparent_background = { enabled = bg_transparent },
			})
			vim.cmd.colorscheme("mellifluous")
		end, { noremap = true, silent = true, desc = "Toggle transparency" })
	end,
}
