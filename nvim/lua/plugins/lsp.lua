return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' }, -- Pro tip: Add BufNewFile to load LSPs on new files
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} }, -- Fidget defaults are usually fine
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- Keymaps on LSP attach
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        local builtin = require('telescope.builtin')
        map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
        map('gr', builtin.lsp_references, '[G]oto [R]eferences')
        map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- Highlight references on cursor hold
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local hl_group = vim.api.nvim_create_augroup('custom-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = hl_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = hl_group,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('custom-lsp-detach', { clear = true }),
            callback = function(e)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'custom-lsp-highlight', buffer = e.buf }
            end,
          })
        end
      end,
    })

    local capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities()
    )

    -- Streamlined Servers List
    local servers = {
      clangd = {},
      gopls = {
        settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } },
      },
      rust_analyzer = {},
      ts_ls = {},
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      cssls = {},
      tailwindcss = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
          },
        },
      },
      -- Python specific (Pro standard: pyright for types, ruff for linting/formatting)
      pyright = {},
      ruff = {},
    }

    -- Notice we ONLY put LSP servers in this ensure_installed list now.
    require('mason-tool-installer').setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
