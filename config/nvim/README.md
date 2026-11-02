# Neovim terminal workflow

Initialize multicursor.nvim after cloning or pulling these dotfiles:

```sh
git -C ~/Desktop/dotfiles submodule update --init --recursive
```

For a new clone, use `git clone --recurse-submodules https://github.com/lucascompython/dotfiles`.

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
