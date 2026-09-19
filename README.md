# tmux configuration

This is a macOS-oriented tmux configuration with TPM, Catppuccin, keyboard-layout aliases, mouse link opening, and pane/session helpers.

## Install

Clone or update the repository:

```sh
if [ -d "$HOME/tmux-config/.git" ]; then
  git -C "$HOME/tmux-config" pull --ff-only
else
  git clone git@github.com:Khnzh/tmux-config.git "$HOME/tmux-config"
fi
```

Back up the active config, then install the config and helper scripts:

```sh
if [ -f ~/.tmux.conf ]; then
  cp ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y%m%d-%H%M%S)
fi
mkdir -p ~/.tmux
cp ~/tmux-config/.tmux.conf ~/.tmux.conf
cp ~/tmux-config/.tmux/*.sh ~/.tmux/
chmod +x ~/.tmux/*.sh
```

The repository intentionally does not include `.tmux/plugins/`. TPM installs those local plugin checkouts from the declarations in `.tmux.conf`.

## Install or update plugins

Start tmux, then press the prefix followed by `I` (capital i):

```text
tmux new -s work
Prefix + I
```

The default prefix is `C-a`. The config bootstraps TPM when it is missing. Plugin installation requires network access.

## Live reload

Inside any running tmux session, press:

```text
C-a r
```

If you have toggled the prefix to `C-b`, use `C-b r` instead. The direct equivalent is:

```sh
tmux source-file ~/.tmux.conf
tmux display-message 'tmux config reloaded'
```

Keybindings, status-bar settings, and most server options apply immediately. After pulling new repository changes, copy the config and scripts again, then run `tmux source-file ~/.tmux.conf`.

## Updating

```sh
git -C ~/tmux-config pull --ff-only
cp ~/tmux-config/.tmux.conf ~/.tmux.conf
cp ~/tmux-config/.tmux/*.sh ~/.tmux/
chmod +x ~/.tmux/*.sh
tmux source-file ~/.tmux.conf
```
