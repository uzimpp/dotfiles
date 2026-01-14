-- Keymaps for better default experience

-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- For conciseness
local opts = { noremap = true, silent = true }

--------------------------------------------------------------------------------
-- NORMAL MODE
--------------------------------------------------------------------------------

-- Disable spacebar default behavior
vim.keymap.set('n', '<Space>', '<Nop>', { silent = true })

-- Allow moving cursor through wrapped lines
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clear highlights
vim.keymap.set('n', '<Esc>', ':noh<CR>', opts)

-- File operations
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts) -- save without auto-formatting
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)
vim.keymap.set('n', '<leader>W', '<cmd>wa<CR>', opts) -- save all buffers

-- Delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Center cursor after jumping
vim.keymap.set('n', '<C-o>', '<C-o>zz', opts)
vim.keymap.set('n', '<C-i>', '<C-i>zz', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffer management
vim.keymap.set('n', '<leader>x', ':Bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>X', ':bufdo Bdelete!<CR>', opts) -- close ALL buffers
vim.keymap.set('n', '<leader>bn', '<cmd>enew<CR>', opts) -- new buffer
vim.keymap.set('n', '<leader>bo', '<cmd>%bd|e#|bd#<CR>', opts) -- close other buffers

-- Increment/decrement numbers
vim.keymap.set('n', '<leader>+', '<C-a>', opts)
vim.keymap.set('n', '<leader>-', '<C-x>', opts)

-- Window/split management
vim.keymap.set('n', '<leader>|', '<C-w>v', opts) -- split vertically
vim.keymap.set('n', '<leader>_', '<C-w>s', opts) -- split horizontally
vim.keymap.set('n', '<leader>we', '<C-w>=', opts) -- equalize splits
vim.keymap.set('n', '<leader>wq', ':close<CR>', opts) -- close current split

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) -- next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) -- previous tab

-- Toggle options
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts) -- toggle line wrap
vim.keymap.set('n', '<leader>ln', ':set relativenumber!<CR>', { desc = 'Toggle relative numbers' })

-- Replace word under cursor
vim.keymap.set('n', '<leader>j', '*``cgn', opts)

-- Yank to system clipboard
vim.keymap.set('n', '<leader>Y', [["+Y]], opts)

-- Toggle diagnostics
local diagnostics_active = true
vim.keymap.set('n', '<leader>do', function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.enable(true)
  else
    vim.diagnostic.enable(false)
  end
end, { desc = 'Toggle diagnostics' })

-- Diagnostic navigation
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Select all
vim.keymap.set('n', '<C-a>', 'gg<S-v>G', opts)

-- Move lines up/down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', opts)
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', opts)

-- Quick fix list navigation
vim.keymap.set('n', '[q', ':cprev<CR>zz', { desc = 'Previous quickfix' })
vim.keymap.set('n', ']q', ':cnext<CR>zz', { desc = 'Next quickfix' })

-- Location list navigation
vim.keymap.set('n', '[l', ':lprev<CR>zz', { desc = 'Previous location' })
vim.keymap.set('n', ']l', ':lnext<CR>zz', { desc = 'Next location' })

-- Duplicate line
vim.keymap.set('n', '<leader>dd', 'yyp', { desc = 'Duplicate line down' })
vim.keymap.set('n', '<leader>dD', 'yyP', { desc = 'Duplicate line up' })

-- Open file under cursor in vertical split
vim.keymap.set('n', 'gf', '<C-w>vgf', { desc = 'Open file under cursor in vsplit' })

-- Open cheatsheet
vim.keymap.set('n', '<leader>?', '<cmd>edit ~/.config/nvim/CHEATSHEET.md<CR>', { desc = 'Open Cheatsheet' })

-- Command mode shortcut
vim.keymap.set('n', ';', ':', { noremap = true })

--------------------------------------------------------------------------------
-- INSERT MODE
--------------------------------------------------------------------------------

-- Exit insert mode
vim.keymap.set('i', 'hh', '<ESC>', opts)
vim.keymap.set('i', 'jj', '<ESC>', opts)
-- vim.keymap.set('i', 'kk', '<ESC>', opts)
-- vim.keymap.set('i', 'll', '<ESC>', opts)
vim.keymap.set('i', 'jk', '<ESC>', opts)
vim.keymap.set('i', 'kj', '<ESC>', opts)

-- Delete word backwards (Ctrl+Backspace)
vim.keymap.set('i', '<C-BS>', '<C-w>', opts)
vim.keymap.set('i', '<C-H>', '<C-w>', opts) -- Some terminals send <C-H> for <C-BS>

--------------------------------------------------------------------------------
-- VISUAL MODE
--------------------------------------------------------------------------------

-- Disable spacebar default behavior
vim.keymap.set('v', '<Space>', '<Nop>', { silent = true })

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Move text up and down
vim.keymap.set('v', '<A-j>', ':m .+1<CR>==', opts)
vim.keymap.set('v', '<A-k>', ':m .-2<CR>==', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

--------------------------------------------------------------------------------
-- VISUAL BLOCK MODE (x)
--------------------------------------------------------------------------------

-- Better paste (don't yank replaced text)
vim.keymap.set('x', 'p', [["_dP]], opts)

--------------------------------------------------------------------------------
-- NORMAL + VISUAL MODE
--------------------------------------------------------------------------------

-- Yank to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], opts)

-- Go to start/end of line
vim.keymap.set({ 'n', 'v' }, 'H', '^', opts) -- Start of line (first non-blank)
vim.keymap.set({ 'n', 'v' }, 'L', '$', opts) -- End of line
