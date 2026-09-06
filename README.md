# dotfiles

Config files live in this repo and get symlinked into `$HOME`. Some files
have a macOS and a Linux variant. Everything else is shared.

## Install

Shared:

```
ln -s $HOME/dotfiles/.zshrc $HOME/
ln -s $HOME/dotfiles/.gitconfig $HOME/
ln -s $HOME/dotfiles/.gitignore $HOME/
ln -s $HOME/dotfiles/.config/nvim $HOME/.config/
ln -s $HOME/dotfiles/.config/starship.toml $HOME/.config/
```

macOS only:

```
ln -s $HOME/dotfiles/.hushlogin $HOME/
ln -s $HOME/dotfiles/.config/kitty/kitty-osx.conf $HOME/.config/kitty/kitty.conf
```

Linux only:

```
ln -s $HOME/dotfiles/.config/kitty/kitty-linux.conf $HOME/.config/kitty/kitty.conf
```

## Zsh

`.zshrc` uses [starship](https://starship.rs/) for the prompt and standalone
plugins from Homebrew. No oh-my-zsh.

```
brew install starship fzf zsh-autosuggestions zsh-syntax-highlighting zsh-completions
```

`.zshrc` expects Homebrew at `/opt/homebrew`. On Linux, Homebrew lives under
`/home/linuxbrew`, so an untracked `~/.zprofile` puts it on the PATH first:

```
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

asdf 0.16+ has no `asdf.sh`, so generate its completions once:

```
mkdir -p ~/.asdf/completions
asdf completion zsh > ~/.asdf/completions/_asdf
```

Machine-local aliases and secrets go in `~/.zshrc.private`, which `.zshrc`
sources if it exists.

## Neovim

`init.lua` sources the older `old-init.vim` first, then sets up completion and
LSP in Lua. Plugins are managed by vim-plug. Install it once:

```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Then open nvim and run `:PlugInstall`.

## Kitty

`kitty-osx.conf` and `kitty-linux.conf` both include `kitty-common.conf` by an
absolute path. Kitty resolves relative includes against the directory of the
`kitty.conf` symlink, not the real file. Tab shortcuts match across platforms:
Cmd+Enter opens a tab in the same directory, Cmd+Left and Cmd+Right switch
tabs, Cmd+Comma and Cmd+Period move a tab. On Linux, Toshy turns the Cmd
combos into the Ctrl combos that `kitty-linux.conf` binds.

Reload config in a running kitty with Ctrl+Shift+F5.

## Keyboard (Linux)

[Toshy](https://github.com/RedBearAK/toshy) gives Linux macOS-style
shortcuts. It owns its own config under `~/.config/toshy`. Only the customized
slice of that config is tracked here. See `.config/toshy/README.md` for how to
restore it and how to check for drift after a Toshy upgrade.

## Claude Code

`.claude/settings.json` and `.claude/CLAUDE.md` are symlinked into both
`~/.claude` (work) and `~/.claude-personal` (personal):

```
ln -s $HOME/dotfiles/.claude/settings.json $HOME/.claude/
ln -s $HOME/dotfiles/.claude/CLAUDE.md $HOME/.claude/
ln -s $HOME/dotfiles/.claude/settings.json $HOME/.claude-personal/
ln -s $HOME/dotfiles/.claude/CLAUDE.md $HOME/.claude-personal/
```

The `claude-personal` alias in `.zshrc` starts Claude with
`CLAUDE_CONFIG_DIR=~/.claude-personal`.

The status line script referenced from `settings.json` comes from the
`salemove/claude-code-plugins` repo:

```
ln -s $HOME/salemove/claude-code-plugins/scripts/statusline.sh $HOME/.claude/
ln -s $HOME/salemove/claude-code-plugins/scripts/statusline.sh $HOME/.claude-personal/
```

## Legacy

These files are kept only for reference: `.slate` (Slate window manager for
macOS), `.Xdefaults`, `.fonts.conf` and `git-mine-by-day`. `.xkb` holds custom
X keymaps from the kinto era. It may still be symlinked as `~/.xkb` on older
Linux setups, but nothing in this repo uses it since Toshy replaced kinto.
