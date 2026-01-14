# Neovim Cheatsheet

> Leader key: `Space`

---

## 📌 Vim Motions (Built-in)

### Basic Movement
| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | Left, Down, Up, Right |
| `w` | Next word (start) |
| `W` | Next WORD (whitespace separated) |
| `b` | Previous word (start) |
| `B` | Previous WORD |
| `e` | End of word |
| `E` | End of WORD |
| `0` | Start of line |
| `^` | First non-blank character |
| `$` | End of line |
| `gg` | First line |
| `G` | Last line |
| `{number}G` | Go to line number |
| `{` / `}` | Previous/next paragraph |
| `(` / `)` | Previous/next sentence |
| `%` | Matching bracket |
| `f{char}` | Find char forward (on) |
| `F{char}` | Find char backward (on) |
| `t{char}` | Find char forward (before) |
| `T{char}` | Find char backward (before) |
| `;` / `,` | Repeat f/t forward/backward |

### Scrolling
| Key | Action |
|-----|--------|
| `Ctrl+d` | Scroll down half page (centered) |
| `Ctrl+u` | Scroll up half page (centered) |
| `Ctrl+f` | Scroll down full page |
| `Ctrl+b` | Scroll up full page |
| `zz` | Center cursor line |
| `zt` | Cursor line to top |
| `zb` | Cursor line to bottom |

### Text Objects (use with operators like `d`, `c`, `y`, `v`)
| Key | Action |
|-----|--------|
| `iw` / `aw` | Inner/around word |
| `iW` / `aW` | Inner/around WORD |
| `is` / `as` | Inner/around sentence |
| `ip` / `ap` | Inner/around paragraph |
| `i"` / `a"` | Inner/around double quotes |
| `i'` / `a'` | Inner/around single quotes |
| `i)` / `a)` | Inner/around parentheses |
| `i]` / `a]` | Inner/around brackets |
| `i}` / `a}` | Inner/around braces |
| `i>` / `a>` | Inner/around angle brackets |
| `it` / `at` | Inner/around HTML tags |
| `ib` / `ab` | Inner/around block () |
| `iB` / `aB` | Inner/around Block {} |

### Operators
| Key | Action |
|-----|--------|
| `d` | Delete |
| `c` | Change (delete + insert) |
| `y` | Yank (copy) |
| `v` | Visual select |
| `>` / `<` | Indent right/left |
| `=` | Auto-indent |
| `gU` | Uppercase |
| `gu` | Lowercase |
| `g~` | Toggle case |

### Common Combinations
| Key | Action |
|-----|--------|
| `dd` | Delete line |
| `yy` | Yank line |
| `cc` | Change line |
| `D` | Delete to end of line |
| `C` | Change to end of line |
| `Y` | Yank line (custom: to end) |
| `diw` | Delete inner word |
| `ciw` | Change inner word |
| `yiw` | Yank inner word |
| `di"` | Delete inside quotes |
| `ci"` | Change inside quotes |
| `da"` | Delete around quotes |
| `dap` | Delete around paragraph |
| `cit` | Change inside HTML tag |

---

## ⌨️ Custom Keymaps

### Insert Mode
| Key | Action |
|-----|--------|
| `jk` / `jj` / `kj` | Exit insert mode |
| `Ctrl+BS` / `Ctrl+H` | Delete word backwards |

### Navigation (Custom)
| Key | Action |
|-----|--------|
| `H` | Start of line (first non-blank) |
| `L` | End of line |
| `n` / `N` | Next/prev search (centered) |
| `Ctrl+o` | Jump back (centered) |
| `Ctrl+i` | Jump forward (centered) |

### File Operations
| Key | Action |
|-----|--------|
| `Ctrl+s` | Save file |
| `Ctrl+q` | Quit |
| `<leader>sn` | Save without formatting |
| `<leader>W` | Save all buffers |

### Buffers
| Key | Action |
|-----|--------|
| `Tab` | Next buffer |
| `Shift+Tab` | Previous buffer |
| `<leader>1-9` | **Go to buffer 1-9** |
| `<leader>[` / `<leader>]` | Move buffer left/right |
| `<leader>x` | Close buffer |
| `<leader>X` | Close ALL buffers |
| `<leader>bo` | Close other buffers (keep current) |
| `<leader>bn` | New buffer |
| `<leader><leader>` | Find buffer (Telescope) |
| `<leader>bn` | New buffer |

### Windows/Splits
| Key | Action |
|-----|--------|
| `<leader>\|` | Vertical split |
| `<leader>_` | Horizontal split |
| `<leader>we` | Equalize splits |
| `<leader>wq` | Close split |
| `Ctrl+h/j/k/l` | Navigate splits |
| `↑↓←→` | Resize splits |

### Tabs
| Key | Action |
|-----|--------|
| `<leader>to` | New tab |
| `<leader>tx` | Close tab |
| `<leader>tn` | Next tab |
| `<leader>tp` | Previous tab |

### Editing
| Key | Action |
|-----|--------|
| `x` | Delete char (no register) |
| `<leader>+` / `<leader>-` | Increment/decrement number |
| `<leader>j` | Replace word under cursor |
| `<leader>y` | Yank to system clipboard |
| `<leader>Y` | Yank line to system clipboard |
| `<leader>dd` | Duplicate line down |
| `<leader>dD` | Duplicate line up |
| `Alt+j` / `Alt+k` | Move line down/up |
| `<` / `>` (visual) | Indent (stays in visual) |
| `p` (visual) | Paste without yanking replaced |
| `Ctrl+a` | Select all |

### Toggles
| Key | Action |
|-----|--------|
| `<leader>lw` | Toggle line wrap |
| `<leader>ln` | Toggle relative numbers |
| `<leader>do` | Toggle diagnostics |

### Quickfix & Location List
| Key | Action |
|-----|--------|
| `]q` / `[q` | Next/prev quickfix |
| `]l` / `[l` | Next/prev location |
| `]d` / `[d` | Next/prev diagnostic |
| `<leader>d` | Open diagnostic float |
| `<leader>q` | Open diagnostics list |

---

## 🔍 Telescope (Fuzzy Finder)

### Primary (single key - fast access)
| Key | Action |
|-----|--------|
| `<leader>f` | **Find text (grep)** |
| `<leader>F` | **Find files** |
| `<leader>r` | **Recent files** |
| `<leader>p` | **Projects** |
| `<leader><leader>` | **Buffers** |
| `<leader>/` | **Search in current buffer** |

### Secondary (s prefix - less frequent)
| Key | Action |
|-----|--------|
| `<leader>sw` | Search word under cursor |
| `<leader>sh` | Search help |
| `<leader>sk` | Search keymaps |
| `<leader>sd` | Search diagnostics |
| `<leader>sc` | Search git commits |
| `<leader>ss` | Search git status |
| `<leader>st` | Search telescope pickers |
| `<leader>sR` | Resume last search |
| `<leader>s/` | Search in open files |

**Inside Telescope:**
| Key | Action |
|-----|--------|
| `Ctrl+j` / `Ctrl+k` | Move selection |
| `Ctrl+l` / `Enter` | Open file |
| `Ctrl+/` or `?` | Show help |

---

## 📁 Neo-tree (File Explorer)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle explorer |
| `<leader>w` | Float explorer |
| `\` | Reveal current file |

**Inside Neo-tree:**
| Key | Action |
|-----|--------|
| `Enter` / `l` | Open file/expand |
| `h` | Collapse |
| `a` | Add file |
| `A` | Add directory |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `y` | Copy to clipboard |
| `x` | Cut to clipboard |
| `p` | Paste from clipboard |
| `P` | Toggle preview |
| `H` | Toggle hidden |
| `/` | Fuzzy finder |
| `?` | Show help |
| `q` | Close |

---

## 🎯 Harpoon (Marked Files)

| Key | Action |
|-----|--------|
| `<leader>m` | Toggle harpoon menu |
| `<leader>M` | Mark/add current file |
| `<leader>m1-5` | Jump to mark 1-5 |
| `<leader>mp` | Previous marked file |
| `<leader>mn` | Next marked file |

---

## 🐙 Git

### Gitsigns
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
| `<leader>gD` | Diff this ~ |
| `<leader>gt` | Toggle deleted |

### LazyGit
| Key | Action |
|-----|--------|
| `<leader>lg` | Open LazyGit |

---

## 📝 LSP (Language Server)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `<leader>th` | Toggle inlay hints |
| `K` | Hover documentation |

---

## 🔧 Formatting & Linting

| Key | Action |
|-----|--------|
| `<leader>cf` | Format buffer |

---

## 💬 Comments

| Key | Action |
|-----|--------|
| `Ctrl+/` | Toggle comment |
| `Ctrl+c` | Toggle comment |
| `gcc` | Comment line (default) |
| `gc{motion}` | Comment motion |

---

## ✂️ Surround (nvim-surround)

| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surround |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround |

**Examples:**
- `ysiw"` → Surround word with `"`
- `yss)` → Surround line with `()`
- `ds'` → Delete surrounding `'`
- `cs"'` → Change `"` to `'`
- `ysiw<div>` → Surround word with `<div></div>`

---

## ⚡ Flash (Quick Jump)

| Key | Action |
|-----|--------|
| `s` | Flash jump |
| `S` | Flash treesitter |

---

## 🔄 Other Tools

### Spectre (Search & Replace)
| Key | Action |
|-----|--------|
| `<leader>sr` | Toggle Spectre |
| `<leader>sW` | Search current word |

### Undotree
| Key | Action |
|-----|--------|
| `<leader>u` | Toggle undo tree |

### Terminal
| Key | Action |
|-----|--------|
| `Ctrl+\` | Toggle terminal |
| `<leader>tt` | Float terminal |
| `<leader>th` | Horizontal terminal |
| `<leader>tv` | Vertical terminal |

### Zen Mode
| Key | Action |
|-----|--------|
| `<leader>z` | Toggle zen mode |

### Trouble (Diagnostics)
| Key | Action |
|-----|--------|
| `<leader>xx` | Document diagnostics |
| `<leader>xX` | Workspace diagnostics |
| `<leader>xL` | Location list |
| `<leader>xQ` | Quickfix list |

### Session
| Key | Action |
|-----|--------|
| `<leader>qs` | Restore session |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save session |

### Markdown
| Key | Action |
|-----|--------|
| `<leader>mp` | Markdown preview |

### DAP (Debugging)
| Key | Action |
|-----|--------|
| `F5` | Start/Continue |
| `F1` | Step into |
| `F2` | Step over |
| `F3` | Step out |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Conditional breakpoint |

---

## 🎨 Alpha Dashboard

| Key | Action |
|-----|--------|
| `e` | New file |
| `f` | Find file |
| `r` | Recent files |
| `p` | Projects |
| `l` | Lazy (plugins) |
| `s` | Restore session |
| `q` | Quit |

---

## 💡 Tips

1. **Repeat last action**: `.`
2. **Undo/Redo**: `u` / `Ctrl+r`
3. **Record macro**: `q{letter}` ... `q`, replay: `@{letter}`
4. **Marks**: `m{letter}` to set, `'{letter}` to jump
5. **Registers**: `"{letter}` before yank/paste
6. **Command history**: `q:` or `:` then `Ctrl+f`
7. **Search history**: `q/` or `/` then `Ctrl+f`
8. **Help**: `:help {topic}` or `<leader>sh`
9. **Which-key**: Press `<leader>` and wait for menu

