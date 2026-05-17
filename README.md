# homebrew-zz-drop

Homebrew tap for [zz-drop](https://github.com/zz-drop/zz-drop).

```
brew install zz-drop/zz-drop/zz-drop
```

This single formula installs both binaries: `zz-drop` (CLI +
agent) and `zz-tui` (configuration TUI, invoked by `zz c`). It
also creates the `zz` shorthand symlink and wires bash / zsh /
fish completions.

`Formula/zz-drop.rb` is auto-maintained by cargo-dist on every
release of `zz-drop/zz-drop` and must not be hand-edited;
`README.md` (this file) is the only human-edited surface in the
tap.
