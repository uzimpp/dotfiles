-- nvim-treesitter on the `main` branch is a rewrite with a minimal API:
--   setup({ install_dir? }), install({langs}), get_installed(), update(), indentexpr()
-- Highlighting is per-buffer via vim.treesitter.start() in a FileType autocmd.
-- Indentation is opt-in via vim.bo.indentexpr.
-- See: nvim-treesitter README, sections "Setup", "Highlighting", "Indentation".

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local nts = require("nvim-treesitter")
      nts.setup({}) -- defaults: install_dir = stdpath('data') .. '/site'

      local ensure = {
        "json", "javascript", "typescript", "tsx", "go", "yaml", "html", "css",
        "python", "http", "prisma", "markdown", "markdown_inline", "svelte", "graphql",
        "bash", "lua", "vim", "dockerfile", "gitignore", "query", "vimdoc",
        "c", "java", "rust", "ron",
      }

      -- Install only what's missing (async; non-blocking).
      local have = {}
      for _, p in ipairs(nts.get_installed()) do have[p] = true end
      local missing = {}
      for _, p in ipairs(ensure) do
        if not have[p] then table.insert(missing, p) end
      end
      if #missing > 0 then nts.install(missing) end

      -- Enable highlight + indent per-buffer when a parser is available.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true }),
        callback = function(args)
          local buf = args.buf
          -- vim.treesitter.start() auto-detects the language; errors if no parser.
          if not pcall(vim.treesitter.start, buf) then return end
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Auto-close / auto-rename tags for HTML/JSX/TSX/Svelte/XML.
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        per_filetype = {
          ["html"] = { enable_close = true },
          ["typescriptreact"] = { enable_close = true },
        },
      })
    end,
  },
}
