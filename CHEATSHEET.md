# Cheatsheet

> **Leader** = `Space`  |  **Prefix** (tmux) = `Ctrl+A`

---

## 🖥️ Terminal (WezTerm / Ghostty)

| Key | Action |
|-----|--------|
| `Ctrl+Shift+\|` | Split pane horizontally |
| `Ctrl+Shift+-` | Split pane vertically |
| `Ctrl+Shift+H/J/K/L` | Navigate panes (left/down/up/right) |
| `Ctrl+Shift+X` | Close current pane |
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+[` | Previous tab |
| `Ctrl+Shift+]` | Next tab |

---

## 🗂️ Tmux (Prefix = `Ctrl+A`)

| Key | Action |
|-----|--------|
| `Prefix + c` | New window |
| `Prefix + n` | Next window |
| `Prefix + p` | Previous window |
| `Prefix + ,` | Rename window |
| `Prefix + &` | Kill window |
| `Prefix + %` | Split pane vertically |
| `Prefix + "` | Split pane horizontally |
| `Prefix + x` | Kill pane |
| `Prefix + z` | Toggle pane zoom |
| `Prefix + d` | Detach session |
| `Prefix + $` | Rename session |
| `Prefix + s` | List sessions |
| `Prefix + [` | Enter copy mode (vi keys) |
| `Prefix + ]` | Paste |

---

## ✏️ Neovim

### General

| Key | Action |
|-----|--------|
| `Esc` | Clear search highlights |
| `Ctrl+S` | Save file |
| `Ctrl+Q` | Quit |
| `<leader>W` | Save all buffers |
| `<leader>sn` | Save without auto-format |
| `;` | Enter command mode (`:`) |
| `Ctrl+A` | Select all |
| `<leader>j` | Replace word under cursor (across buffer) |
| `<leader>Y` | Yank to system clipboard (line) |
| `<leader>y` | Yank to system clipboard (n/v) |
| `<leader>+` | Increment number |
| `<leader>-` | Decrement number |

### Navigation

| Key | Action |
|-----|--------|
| `j` / `k` | Move through wrapped lines |
| `H` | Start of line (first non-blank) |
| `L` | End of line |
| `Ctrl+D` / `Ctrl+U` | Scroll down/up (centered) |
| `n` / `N` | Next/prev search result (centered) |
| `Ctrl+O` / `Ctrl+I` | Jump back/forward (centered) |
| `gf` | Open file under cursor in vsplit |

### Windows & Splits

| Key | Action |
|-----|--------|
| `<leader>\|` | Split vertically |
| `<leader>_` | Split horizontally |
| `<leader>we` | Equalize splits |
| `<leader>wq` | Close current split |
| `Ctrl+H/J/K/L` | Navigate between splits |
| `↑ ↓ ← →` (arrows) | Resize splits |

### Buffers

| Key | Action |
|-----|--------|
| `Tab` | Next buffer |
| `Shift+Tab` | Previous buffer |
| `<leader>1`–`9` | Jump to buffer by index |
| `<leader>[` | Move buffer left |
| `<leader>]` | Move buffer right |
| `<leader>bp` | Pick buffer |
| `<leader>bP` | Pick buffer to close |
| `<leader>x` | Close current buffer |
| `<leader>X` | Close ALL buffers |
| `<leader>bn` | New buffer |
| `<leader>bo` | Close other buffers |
| `<leader><leader>` | Fuzzy search open buffers |

### Tabs

| Key | Action |
|-----|--------|
| `<leader>to` | Open new tab |
| `<leader>tx` | Close current tab |
| `<leader>tn` | Next tab |
| `<leader>tp` | Previous tab |

### Toggle Options

| Key | Action |
|-----|--------|
| `<leader>lw` | Toggle line wrap |
| `<leader>ln` | Toggle relative numbers |
| `<leader>do` | Toggle diagnostics |
| `<leader>bg` | Toggle transparency |
| `<leader>th` | Toggle inlay hints (LSP) |

### Move Lines

| Key | Action |
|-----|--------|
| `Alt+J` | Move line/selection down |
| `Alt+K` | Move line/selection up |

### Duplicate Lines

| Key | Action |
|-----|--------|
| `<leader>dd` | Duplicate line down |
| `<leader>dD` | Duplicate line up |

### Diagnostics & Quickfix

| Key | Action |
|-----|--------|
| `[d` / `]d` | Prev/next diagnostic |
| `<leader>d` | Open floating diagnostic |
| `<leader>q` | Open diagnostics list |
| `[q` / `]q` | Prev/next quickfix item |
| `[l` / `]l` | Prev/next location list item |

### Insert Mode

| Key | Action |
|-----|--------|
| `hh` / `jj` / `jk` / `kj` | Exit insert mode |
| `Ctrl+Backspace` | Delete word backwards |

### Visual Mode

| Key | Action |
|-----|--------|
| `<` / `>` | Indent (stay in visual mode) |
| `p` | Paste (keep last yank) |

---

## 🔭 Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader>f` | Live grep (search text) |
| `<leader>F` | Find files |
| `<leader>r` | Recent files |
| `<leader>p` | Projects |
| `<leader><leader>` | Buffers |
| `<leader>/` | Fuzzy search in current buffer |
| `<leader>sw` | Search word under cursor |
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>sd` | Search diagnostics |
| `<leader>sc` | Search git commits |
| `<leader>ss` | Search git status |
| `<leader>st` | Search telescope pickers |
| `<leader>sR` | Resume last search |

---

## 🪝 Harpoon

| Key | Action |
|-----|--------|
| `<leader>M` | Add file to Harpoon |
| `<leader>m` | Open Harpoon menu |
| `<leader>m1`–`5` | Jump to Harpoon file 1–5 |
| `<leader>mp` | Prev Harpoon file |
| `<leader>mn` | Next Harpoon file |

---

## 🌳 File Explorer

| Key | Action |
|-----|--------|
| `-` | Open Oil (file explorer in buffer) |

---

## 💬 Comments

| Key | Action |
|-----|--------|
| `Ctrl+/` (or `Ctrl+C`) | Toggle comment (normal & visual) |

---

## 🔗 LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>th` | Toggle inlay hints |

---

## 🐛 Debugger (DAP)

| Key | Action |
|-----|--------|
| `F5` | Start / Continue |
| `F1` | Step into |
| `F2` | Step over |
| `F3` | Step out |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Conditional breakpoint |

---

## 🔥 Git (Gitsigns)

| Key | Action |
|-----|--------|
| `]c` / `[c` | Next/prev git hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gS` | Stage buffer |
| `<leader>gu` | Undo stage hunk |
| `<leader>gR` | Reset buffer |
| `<leader>gp` | Preview hunk |
| `<leader>gd` | Diff this |
| `<leader>gD` | Diff this (against `~`) |
| `<leader>gt` | Toggle deleted |
| `<leader>lg` | Open LazyGit |

---

## 🔴 Trouble (Diagnostics Panel)

| Key | Action |
|-----|--------|
| `<leader>xx` | Document diagnostics |
| `<leader>xX` | Workspace diagnostics |
| `<leader>xL` | Location list |
| `<leader>xQ` | Quickfix list |

---

## 💾 Sessions

| Key | Action |
|-----|--------|
| `<leader>qs` | Save session |
| `<leader>ql` | Load last session |
| `<leader>qd` | Delete session |

---

## 🐚 Shell Aliases

### Git
| Alias | Command |
|-------|---------|
| `g` | `git` |
| `ga` | `git add` |
| `gs` / `gss` | `git status` / `git status -s` |
| `gc` / `gcm` | `git commit -v` / `git commit -m` |
| `gp` / `gpo` | `git push` / `git push origin` |
| `gl` / `glo` | `git pull` / `git pull origin` |
| `gf` | `git fetch` |
| `gd` | `git diff` |
| `gb` | `git branch` |
| `gco` / `gcob` | `git checkout` / `git checkout -b` |
| `gm` | `git merge` |
| `gqc` | Quick commit with ticket ID from branch |
| `gqcp` | Quick commit + push with ticket ID |
| `gafzf` | `git add` with fzf picker |
| `gcofzf` | `git checkout` with fzf branch picker |
| `lg` | `lazygit` |

### System
| Alias | Command |
|-------|---------|
| `v` / `vi` | Neovim (Poetry-aware) |
| `ls` | `eza --all --icons=always` |
| `r` | Ranger |
| `c` | `clear` |
| `e` | `exit` |
| `fh` | Fuzzy search command history |
| `fd` | Fuzzy `cd` to directory |
