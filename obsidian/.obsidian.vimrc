" ============================================================
" .obsidian.vimrc — nvim keymaps ported to Obsidian vim mode
" Requires: Vimrc Support plugin (by esm7)
" Place at: <vault-root>/.obsidian.vimrc
" ============================================================

" ------------------------------------------------------------
" NORMAL MODE
" ------------------------------------------------------------

" Wrapped-line navigation (like nvim's gj/gk expr maps)
nmap j gj
nmap k gk

" Line start / end
nmap H ^
nmap L $

" Delete character without yanking
nmap x "_x

" Clear search highlight
nmap <Esc> :nohl

" Save
exmap save obcommand editor:save-file
nmap <C-s> :save

" Follow link under cursor (closest to nvim's gf)
exmap followLink obcommand editor:follow-link
nmap gf :followLink

" Toggle line wrap
exmap toggleWrap obcommand editor:toggle-line-wrap
nmap <Space>lw :toggleWrap

" Find file (Quick Switcher)
exmap findFile obcommand switcher:open
nmap <Space><Space> :findFile

" Grep across files (Global Search)
exmap grep obcommand global-search:open
nmap <Space>f :grep

" ------------------------------------------------------------
" INSERT MODE
" ------------------------------------------------------------

" Escape shortcuts
imap jj <Esc>
imap jk <Esc>
imap kj <Esc>
imap kk <Esc>

" ------------------------------------------------------------
" VISUAL MODE
" ------------------------------------------------------------

" Line start / end
vmap H ^
vmap L $

" Wrapped-line navigation
vmap j gj
vmap k gk

" Stay in indent mode after indent
vmap < <gv
vmap > >gv

" ------------------------------------------------------------
" NOT PORTABLE — no equivalent in Obsidian/CodeMirror vim
" ------------------------------------------------------------
" <C-d>zz / <C-u>zz     — zz centering not supported
" <C-o>zz / <C-i>zz     — jump list + zz not supported
" n/Nzzzv                — find + center not supported
" "_dP (visual paste)    — named registers not supported
" "+y / "+Y              — system clipboard register not supported
" <leader>x/X (Bdelete)  — no buffer concept in Obsidian
" <leader>| / _ (splits) — no splits in Obsidian
" <C-h/j/k/l> (windows) — no window navigation in Obsidian
" <leader>to/tx/tn/tp    — no tabs in Obsidian
" [d / ]d (diagnostics)  — no LSP in Obsidian
" <A-j/k> (move lines)  — not supported
" [q/]q / [l/]l         — no quickfix/location list
" <Tab>/<S-Tab> buffers  — no buffers in Obsidian
