# Installation

```
ln -s $HOME/dotfiles/.config/nvim $HOME/.config/
ln -s $HOME/dotfiles/.config/starship.toml $HOME/.config/
ln -s $HOME/dotfiles/.zshrc $HOME/
ln -s $HOME/dotfiles/.gitconfig $HOME/
ln -s $HOME/dotfiles/.gitignore $HOME/
ln -s $HOME/dotfiles/.hushlogin $HOME/
ln -s $HOME/dotfiles/.Xmodmap $HOME/
```

## Zsh

Uses [starship](https://starship.rs/) for the prompt and standalone plugins (no
oh-my-zsh). Install the dependencies:

```
brew install starship zsh-autosuggestions zsh-syntax-highlighting zsh-completions
```

Generate asdf completions once (asdf 0.16+ has no `asdf.sh`):

```
mkdir -p ~/.asdf/completions
asdf completion zsh > ~/.asdf/completions/_asdf
```

## Vim

First install vim-plug:

```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Then open nvim and run: `:PlugInstall`
