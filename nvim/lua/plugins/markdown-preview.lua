return {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview' },
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
    keys = {
        { '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', desc = 'Markdown Preview' },
    },
}
