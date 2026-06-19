# Homebrew env. Sets HOMEBREW_PREFIX + adds brew bin to PATH; must run before
# any PATH use below and before $HOMEBREW_PREFIX is read later.
# Cache the eval: `brew shellenv` forks Ruby (~20ms). Output is static per brew
# version, so regenerate only when the brew binary is newer than the cache.
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p $ZSH_CACHE_DIR
_brew_cache=$ZSH_CACHE_DIR/brew-shellenv.zsh
[[ -r $_brew_cache && ! /opt/homebrew/bin/brew -nt $_brew_cache ]] || /opt/homebrew/bin/brew shellenv > $_brew_cache
source $_brew_cache
unset _brew_cache

# Locale
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Core env
export EDITOR='nvim'
export MAKEFLAGS="-j12"
export ERL_AFLAGS="-kernel shell_history enabled"

# PATH (typeset -U dedups on nested shells)
typeset -U path PATH
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:$HOME/bin"
export PATH="$HOME/.local/bin:$PATH"

# asdf shims
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Glia
export NS_NAME=indrek
export PATH="$HOME/salemove/sm-configuration/bin:$PATH"
export SCHEMA_REGISTRY_URL=https://schema-registry.beta.glia.com

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Completions (fpath must be set BEFORE compinit)
# Cache brew prefix once: `brew --prefix` forks a Ruby process (~20ms) and was
# called 3x. Prefer $HOMEBREW_PREFIX (set by brew shellenv) to skip the fork.
BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"

fpath=(
  $BREW_PREFIX/share/zsh-completions
  ${ASDF_DATA_DIR:-$HOME/.asdf}/completions
  $fpath
)

# -i ignores the group-writable Homebrew share dir (single-user Mac); without it
# compinit prompts on every startup.
# Rebuild the dump at most once/day; otherwise load cached (-C skips the audit +
# regeneration that otherwise rewrite ~/.zcompdump on every startup, ~150ms).
autoload -Uz compinit
# Glob qualifier (N.mh+24) = plain file modified >24h ago; matches only a stale
# dump. Glob must expand outside [[ ]] (no filename generation there).
zcompdump_stale=(${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24))
if (( ${#zcompdump_stale} )) || [[ ! -f ${ZDOTDIR:-$HOME}/.zcompdump ]]; then
  compinit -i        # full rebuild: audit + regenerate dump
else
  compinit -C -i     # trust cache: skip audit + regeneration
fi
unset zcompdump_stale

# Byte-compile the dump so compinit loads bytecode instead of reparsing ~58KB.
# Recompile only when the dump is newer than its .zwc (also covers a missing .zwc).
_zcd=${ZDOTDIR:-$HOME}/.zcompdump
[[ -s $_zcd && ( ! -s $_zcd.zwc || $_zcd -nt $_zcd.zwc ) ]] && zcompile -R $_zcd 2>/dev/null
unset _zcd

zmodload zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Keybindings
bindkey -e
bindkey '\e[1;9D' backward-word         # alt-left
bindkey '\e[1;9C' forward-word          # alt-right
bindkey '\e[1;10D' beginning-of-line    # cmd-left
bindkey '\e[1;10C' end-of-line          # cmd-right
bindkey '^H' backward-kill-word         # ctrl-backspace
bindkey -M menuselect '^M' .accept-line # Return accepts selected match

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=500000
SAVEHIST=100000
unsetopt share_history
setopt inc_append_history   # write each cmd as it runs, not only on shell exit
setopt hist_ignore_all_dups # drop older duplicate of a cmd, keep newest
setopt hist_ignore_space    # don't record cmds prefixed with a space
setopt hist_verify          # expand !history into the line, let me edit before run
setopt hist_reduce_blanks   # strip redundant whitespace before saving
setopt extended_history     # save timestamp + duration per entry

# Aliases
alias vim='nocorrect nvim'
alias find='noglob find'

# Curated git aliases
alias gp='git push'
alias gl='git pull'
alias gf='git fetch'

# fzf
_fzf_cache=$ZSH_CACHE_DIR/fzf-init.zsh
[[ -r $_fzf_cache && ! $commands[fzf] -nt $_fzf_cache ]] || fzf --zsh > $_fzf_cache
source $_fzf_cache
unset _fzf_cache

# asdf golang env (sets GOROOT/GOPATH/GOBIN via precmd hook)
_asdf_go_env="${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/golang/set-env.zsh"
[ -r "$_asdf_go_env" ] && . "$_asdf_go_env"
unset _asdf_go_env

# Bun completions (needs compinit already loaded)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Linux container specifics ($OSTYPE guard skips the fork on macOS)
if [[ $OSTYPE == linux* ]] && command -v apt > /dev/null; then
  export AWS_OKTA_BACKEND=secret-service
  kitty + complete setup zsh | source /dev/stdin
fi

# Prompt
_starship_cache=$ZSH_CACHE_DIR/starship-init.zsh
[[ -r $_starship_cache && ! $commands[starship] -nt $_starship_cache ]] || starship init zsh > $_starship_cache
source $_starship_cache
unset _starship_cache

# Plugins (autosuggestions, then syntax-highlighting LAST)
source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Machine-local / private config (may define more aliases)
[ -e ~/.zshrc.private ] && source ~/.zshrc.private

# MUST be the very last sourced file
source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
