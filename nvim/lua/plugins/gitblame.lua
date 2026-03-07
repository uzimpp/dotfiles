return {
    -- Git blame plugin (shows in lualine only)
    'f-person/git-blame.nvim',
    event = 'VeryLazy',
    config = function()
        vim.g.gitblame_display_virtual_text = 0       -- Disable inline, show in lualine only
        vim.g.gitblame_message_template = '<author> at <date> • <summary>'
        vim.g.gitblame_date_format = '%d %b %Y'       -- Jul 7 2026
        vim.g.gitblame_message_when_not_committed = 'Not committed yet'
        vim.g.gitblame_max_commit_summary_length = 20 -- Truncate long commit messages
    end,
}
