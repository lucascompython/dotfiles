# Neovim terminal workflow

Initialize the plugin submodules after cloning or pulling these dotfiles:

```sh
git -C ~/Desktop/dotfiles submodule update --init --recursive
```

For a new clone, use `git clone --recurse-submodules https://github.com/lucascompython/dotfiles`.

Inside an integrated terminal, `nvim <file>` opens the file in the existing
Neovim process, in a temporary tab. `:wq` saves and closes that edit, restores
the terminal you launched it from, and resumes shell input. `:q!` returns without
writing the file. Relative paths, spaces in filenames, and `nvim +12 file` work.
An ordinary `nvim <file>` launch outside a Neovim terminal opens normally.

This uses [flatten.nvim](https://github.com/willothy/flatten.nvim), installed as
a Git submodule at `pack/terminal/start/flatten.nvim`. It forwards nested file
opens through Neovim's local RPC connection. The terminal tab stays alive during
the edit; use `:qa` when you intend to exit the whole Neovim session.

After installing updates, restart the outer Neovim before trying the handoff.
The `gd` shortcut for opening a path in `$VISUAL` applies to terminal buffers;
file buffers use Neovim's normal keybindings.

- `Esc` from shell input enters terminal navigation: `hjkl`, `w`, `b`, `/`, etc.
- `i`, `a`, `I`, and `A` enter real zsh input at the chosen position. Zsh keeps
  rendering its colors, bold, underline, completions, and grey autosuggestions.
  The terminal input cursor stays a thin vertical bar, including after Enter.
- On the current command, use `dw`, `dd`, `ciw`, visual `c`/`d`, `p`, etc.
  Single change operations return to real zsh input for typing.
- `ga` (g then a), or `gA`, selects matching words or selected text. Cursors
  appear inline. Multicursor editing uses a native Vim editor on that line.
- `gl` adds the next matching word/selection; `gL` adds the previous one. Repeat
  to grow the selection; matching wraps and skips matches already selected.
  Both use the same inline editing and Escape behavior as `gA`.
- `c` replaces the selections. `Esc` from insert mode keeps every cursor in
  normal mode, allowing another edit. `Esc` in normal mode collapses the cursors
  and sends the edited command back to zsh without executing it.
- `Enter` in multicursor mode applies and executes the command. `Ctrl-C` cancels
  that editing session. Normal zsh input keeps zsh's usual Enter/Ctrl-C behavior.
- Terminal `p`/`P` paste the selected register into the current shell input,
  including text yanked from scrollback with `yy` or `2yy`. Newlines, including
  a linewise register's final newline, are preserved without executing the text.
  Named registers and counts work (`"ap`, `2p`). On the current command, `p`
  inserts after the navigation cursor and `P` before it; from scrollback they
  paste at the shell's input cursor. Multiline input can then be edited in zsh.

Modal command editing supports one unwrapped line with the risto prompt theme.
Scrollback remains available for navigation and copying. Regular insert mode
uses the shell's full terminal display. Multicursor edits stay in the inline Vim
editor until the cursors are collapsed or the command is executed.

Default zsh terminals load the files in `zsh/` after sourcing your normal
`.zshenv` and `.zshrc`. The integration reads and updates zsh's actual `BUFFER`,
so a grey suggestion is never copied into the command. It adds private ZLE
widgets, no edits to your personal zsh startup files are needed. Use `:terminal`,
`Space t`, or `vt` to start an integrated terminal. An explicit `:terminal zsh`
bypasses the configured shell wrapper.
