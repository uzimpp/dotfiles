return {
	-- ── Mason ─────────────────────────────────────────────────────────────
	{
		"mason-org/mason.nvim",
		lazy = false,
		priority = 200,
		dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
				},
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"clangd",
					"gopls",
					"rust-analyzer",
					"typescript-language-server",
					"html-lsp",
					"css-lsp",
					"tailwindcss-language-server",
					"lua-language-server",
					"pyright",
					"ruff",
					"bash-language-server",
					"dockerfile-language-server",
					"docker-compose-language-service",
					"yaml-language-server",
					"json-lsp",
					"eslint-lsp",
					"jdtls",
					"marksman",
					"stylua",
					"prettier",
					"goimports",
					"gofumpt",
					"clang-format",
					"shfmt",
					"shellcheck",
					"hadolint",
					"golangci-lint",
					"yamllint",
					"markdownlint",
				},
				run_on_start = true,
				auto_update = false,
			})
		end,
	},

	-- ── LSP ───────────────────────────────────────────────────────────────
	{
		"mason-org/mason-lspconfig.nvim", -- only used for ensure_installed bridging
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "mason-org/mason.nvim" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "b0o/schemastore.nvim" },
		},
		config = function()
			local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

			-- ── Global capabilities ────────────────────────────────────
			vim.lsp.config("*", {
				capabilities = vim.tbl_deep_extend(
					"force",
					vim.lsp.protocol.make_client_capabilities(),
					require("cmp_nvim_lsp").default_capabilities()
				),
			})

			-- ── Keymaps on attach ──────────────────────────────────────
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
				callback = function(event)
					local buf = event.buf
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local map = function(keys, func, desc, mode)
						vim.keymap.set(mode or "n", keys, func, { buffer = buf, desc = "LSP: " .. desc })
					end

					local b = require("telescope.builtin")
					map("gd", b.lsp_definitions, "[G]oto [D]efinition")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gr", b.lsp_references, "[G]oto [R]eferences")
					map("gI", b.lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", b.lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", b.lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>ws", b.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<C-k>", vim.lsp.buf.signature_help, "Signature Help", "i")

					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
						end, "[T]oggle Inlay [H]ints")
					end

					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local hl = vim.api.nvim_create_augroup("custom-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = buf,
							group = hl,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = buf,
							group = hl,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("custom-lsp-detach", { clear = true }),
							callback = function(e)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "custom-lsp-highlight", buffer = e.buf })
							end,
						})
					end
				end,
			})

			-- ── Server configs (cmd points directly to mason binaries) ─────
			vim.lsp.config("clangd", {
				cmd = {
					mason_bin .. "clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders=true",
				},
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
				init_options = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true },
			})

			vim.lsp.config("gopls", {
				cmd = { mason_bin .. "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
				settings = {
					gopls = {
						analyses = { unusedparams = true, shadow = true, fieldalignment = true },
						staticcheck = true,
						gofumpt = true,
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			})

			vim.lsp.config("rust_analyzer", {
				cmd = { mason_bin .. "rust-analyzer" },
				filetypes = { "rust" },
				root_markers = { "Cargo.toml", "Cargo.lock", ".git" },
				settings = {
					["rust-analyzer"] = {
						checkOnSave = { command = "clippy" },
						cargo = { allFeatures = true },
						procMacro = { enable = true },
						inlayHints = {
							bindingModeHints = { enable = true },
							closureCaptureHints = { enable = true },
							expressionAdjustmentHints = { enable = "reborrow" },
							parameterHints = { enable = true },
							typeHints = { enable = true },
						},
					},
				},
			})

			vim.lsp.config("ts_ls", {
				cmd = { mason_bin .. "typescript-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
				},
			})

			vim.lsp.config("eslint", {
				cmd = { mason_bin .. "vscode-eslint-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_markers = {
					"eslint.config.js",
					"eslint.config.mjs",
					"eslint.config.cjs",
					"eslint.config.ts",
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.json",
					"package.json",
					".git",
				},
				settings = { workingDirectory = { mode = "auto" } },
			})

			vim.lsp.config("pyright", {
				cmd = { mason_bin .. "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = {
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					".git",
					".venv",
					".env.local",
				},
				settings = {
					pyright = { autoImportCompletion = true },
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
							typeCheckingMode = "basic",
						},
					},
				},
			})

			vim.lsp.config("ruff", {
				cmd = { mason_bin .. "ruff", "server" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
				on_attach = function(client)
					client.server_capabilities.hoverProvider = false
				end,
			})

			vim.lsp.config("lua_ls", {
				cmd = { mason_bin .. "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
						completion = { callSnippet = "Replace" },
						diagnostics = { disable = { "missing-fields" }, globals = { "vim" } },
						telemetry = { enable = false },
						hint = { enable = true },
					},
				},
			})

			vim.lsp.config("jdtls", {
				cmd = { mason_bin .. "jdtls" },
				filetypes = { "java" },
				root_markers = { "pom.xml", "build.gradle", ".git" },
				settings = {
					java = {
						format = { enabled = true },
						saveActions = { organizeImports = true },
						signatureHelp = { enabled = true },
						contentProvider = { preferred = "fernflower" },
						inlayHints = { parameterNames = { enabled = "all" } },
						completion = {
							favoriteStaticMembers = {
								"org.junit.jupiter.api.Assertions.*",
								"org.mockito.Mockito.*",
								"org.mockito.ArgumentMatchers.*",
								"org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
								"org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
							},
						},
					},
				},
			})

			vim.lsp.config("bashls", {
				cmd = { mason_bin .. "bash-language-server", "start" },
				filetypes = { "sh", "bash", "zsh" },
				root_markers = { ".git" },
			})

			vim.lsp.config("html", {
				cmd = { mason_bin .. "vscode-html-language-server", "--stdio" },
				filetypes = { "html", "twig", "hbs", "jsx", "tsx" },
				root_markers = { "package.json", ".git" },
			})

			vim.lsp.config("cssls", {
				cmd = { mason_bin .. "vscode-css-language-server", "--stdio" },
				filetypes = { "css", "scss", "less" },
				root_markers = { "package.json", ".git" },
			})

			vim.lsp.config("tailwindcss", {
				cmd = { mason_bin .. "tailwindcss-language-server", "--stdio" },
				filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_markers = { "tailwind.config.js", "tailwind.config.ts", "package.json", ".git" },
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = { "tw`([^`]*)", "tw\\(([^)]*)\\)", 'className="([^"]*)"' },
						},
					},
				},
			})

			vim.lsp.config("dockerls", {
				cmd = { mason_bin .. "docker-langserver", "--stdio" },
				filetypes = { "dockerfile" },
				root_markers = { "Dockerfile", ".git" },
			})

			vim.lsp.config("docker_compose_language_service", {
				cmd = { mason_bin .. "docker-compose-langserver", "--stdio" },
				filetypes = { "yaml.docker-compose" },
				root_markers = { "docker-compose.yml", "docker-compose.yaml", ".git" },
			})

			vim.lsp.config("yamlls", {
				cmd = { mason_bin .. "yaml-language-server", "--stdio" },
				filetypes = { "yaml", "yaml.docker-compose" },
				root_markers = { ".git" },
				settings = {
					yaml = {
						schemaStore = { enable = false, url = "" },
						schemas = require("schemastore").yaml.schemas(),
						validate = { enable = true },
						completion = true,
						hover = true,
						format = { enable = true },
					},
				},
			})

			vim.lsp.config("jsonls", {
				cmd = { mason_bin .. "vscode-json-language-server", "--stdio" },
				filetypes = { "json", "jsonc" },
				root_markers = { "package.json", ".git" },
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			vim.lsp.config("marksman", {
				cmd = { mason_bin .. "marksman", "server" },
				filetypes = { "markdown" },
				root_markers = { ".marksman.toml", ".git" },
			})

			-- Enable all — each starts exactly once, no nvim-lspconfig conflict
			vim.lsp.enable({
				"clangd",
				"gopls",
				"rust_analyzer",
				"ts_ls",
				"eslint",
				"pyright",
				"ruff",
				"lua_ls",
				"jdtls",
				"bashls",
				"html",
				"cssls",
				"tailwindcss",
				"dockerls",
				"docker_compose_language_service",
				"yamlls",
				"jsonls",
				"marksman",
			})

			-- mason-lspconfig only used to ensure servers are installed
			require("mason-lspconfig").setup({
				automatic_enable = false, -- we call vim.lsp.enable() manually above
			})
		end,
	},

	-- ── Linters ───────────────────────────────────────────────────────────
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufWritePost" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				dockerfile = { "hadolint" },
				yaml = { "yamllint" },
				markdown = { "markdownlint" },
			}
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("custom-lint", { clear = true }),
				callback = function()
					if lint.linters_by_ft[vim.bo.filetype] then
						lint.try_lint()
					end
				end,
			})
		end,
	},
}
