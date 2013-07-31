# zsh init file


# only do this if your system has a global profile :)
source /etc/profile

# make opts
MAKEOPTS="-j5"

# autoloads
autoload -U compinit promptinit
compinit
promptinit

# custom function for pkill completion (same as killall)
compdef -a _pkill pkill

# bash style words (delete at / delimiter, etc)
autoload -U select-word-style
select-word-style bash

# functions for completiong whole command lines
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

# Prompts
autoload colors ; colors

git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

hg_prompt_info() {
  echo `hg branch 2>/dev/null`
}

rvm_version() {
  gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
  if [ "$gemset" != "" ] && [ "$version" != "" ]; then
    echo "$version%%$gemset"
  fi
}

prompt_info() {
  git=$(git_prompt_info)
  hg=$(hg_prompt_info)

  if [ "$git" != "" ]; then
    rvm=$(rvm_version)
    if [ "$rvm" != "" ]; then
      echo " %{$fg[green]%}[$git $rvm]"
    else
      echo " %{$fg[green]%}[$git]"
    fi
  elif [ "$hg" != "" ]; then
    echo " %{$fg[red]%}[$hg]"
  fi
}

# Note: wrap characters, that do *not* consume space in %{…%}
PROMPT=$'%n@%m$(prompt_info) %{\e[1;38;5;33m%}~%{\e[0m%} '
RPROMPT=' %~'                 # prompt for right side of screen

# Constants
export EDITOR='vim'

# Aliases
alias pp='python -mjson.tool'

# no spelling correction for these commands
alias vim='nocorrect vim'
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias git tag='nocorrect git tag'
alias rspec='nocorrect rspec'

# colors and shorthands
if [ "$(uname)" = "Darwin" ]; then
  alias ls='ls -G'
  alias l='ls -G'
  alias l.='ls -d .[a-zA-Z]* -G'
  alias ll='ls -l -G'
else
  alias ls='ls --color=auto'
  alias l="ls --color=auto"
  alias l.='ls -d .[a-zA-Z]* --color=auto'
  alias ll='ls -l --color=auto'
fi
alias d='ls -d `find . -maxdepth 1 -type d -not -name ".*"`'
alias q='exit'
alias :q='exit'

#Avoid typing cd ../../ for going two dirs down and so on
alias -g '...'='../..'
alias -g '....'='../../..'
alias -g '.....'='../../../..'
alias -g '......'='../../../../..'
alias -g '.......'='../../../../../..'

# find normally doesn't need globbing but it does
#  use wildcards, this makes: find -name *asd* wor
#  like find -name '*asd*'
alias find='noglob find'

# history settings
HISTFILE=~/.zshhistory
HISTSIZE=50000
SAVEHIST=50000

# only ask if a list does not fit to the screen
LISTMAX=0

# Expansion options
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
zstyle ':completion:*' use-cache 1
zstyle ':completion:*' cache-path ~/.zsh/cache


# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands

zstyle ':completion::complete:*' '\'

#  tag-order 'globbed-files directories' all-files
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'

# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'


zstyle ':completion:*:history-words' stop verbose
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:::::' completer _complete _correct _approximate
zstyle ':completion:*:correct:::' max-errors 2

# process completion
zstyle ':completion:*:processes' command 'ps -u$USER'

## case-insensitive (uppercase from lowercase) completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## case-insensitive (all) completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
## case-insensitive,partial-word and then substring completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
## case-insensitive,partial-word and then substring completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*:*:killall:*:processes-names' command 'ps -u $USER -eo command'
zstyle ':completion:*:*:pkill:*:processes-names' command 'ps -u $USER -eo command'

# don't complete usernames with cd
zstyle ':completion:*:*:cd::' tag-order '! users' -


# zsh Options
setopt                      \
    NO_all_export           \
    always_last_prompt      \
    NO_always_to_end        \
    append_history          \
    auto_cd                 \
    auto_list               \
    auto_menu               \
    NO_auto_name_dirs       \
    auto_param_keys         \
    auto_param_slash        \
    auto_pushd              \
    auto_remove_slash       \
    NO_auto_resume          \
    bad_pattern             \
    bang_hist               \
    NO_beep                 \
    brace_ccl               \
    NO_bsd_echo             \
    cdable_vars             \
    NO_chase_links          \
    NO_clobber              \
    complete_aliases        \
    complete_in_word        \
    correct                 \
    correct_all             \
    csh_junkie_history      \
    NO_csh_junkie_loops     \
    NO_csh_junkie_quotes    \
    NO_csh_null_glob        \
    equals                  \
    extended_glob           \
    extended_history        \
    function_argzero        \
    glob                    \
    NO_glob_assign          \
    glob_complete           \
    NO_glob_dots            \
    glob_subst              \
    hash_cmds               \
    hash_dirs               \
    hash_list_all           \
    hist_allow_clobber      \
    hist_beep               \
    hist_ignore_dups        \
    hist_ignore_space       \
    NO_hist_no_store        \
    hist_verify             \
    NO_hup                  \
    NO_ignore_braces        \
    NO_ignore_eof           \
    interactive_comments    \
    inc_append_history      \
    NO_list_ambiguous       \
    NO_list_beep            \
    list_types              \
    long_list_jobs          \
    magic_equal_subst       \
    NO_mail_warning         \
    NO_mark_dirs            \
    NO_menu_complete        \
    multios                 \
    nomatch                 \
    notify                  \
    NO_null_glob            \
    numeric_glob_sort       \
    NO_overstrike           \
    path_dirs               \
    NO_print_exit_value     \
    NO_prompt_cr            \
    prompt_subst            \
    pushd_ignore_dups       \
    NO_pushd_minus          \
    pushd_silent            \
    pushd_to_home           \
    rc_expand_param         \
    NO_rc_quotes            \
    NO_rm_star_silent       \
    NO_sh_file_expansion    \
    sh_option_letters       \
    short_loops             \
    NO_sh_word_split        \
    NO_single_line_zle      \
    NO_sun_keyboard_hack    \
    unset                   \
    NO_verbose              \
    zle                     \
    promptcr

if [ "$TERM" = 'screen' -o "$TERM" = 'linux' ]; then
    bindkey '[1~' vi-beginning-of-line    # home
    bindkey '[4~' vi-end-of-line          # end
else
    bindkey '[7~' vi-beginning-of-line    # home
    bindkey '[8~' vi-end-of-line          # end
fi

bindkey '[2~' beep                        # insert
bindkey '[3~' delete-char                 # del
bindkey '[5~' up-line-or-beginning-search   # page up
bindkey '[6~' down-line-or-beginning-search # page down

# make ctrl/shift-up/down work the same as up/down
bindkey 'Oa' up-line-or-history           # ctrl-up
bindkey 'Ob' down-line-or-history         # ctrl-down
bindkey '[a' up-line-or-history           # shift-up
bindkey '[b' down-line-or-history         # shift-down

bindkey '' backward-kill-word             # ctrl-backspace

bindkey '^[^[[D' backward-delete-word       # shift-left
bindkey '^[^[[C' delete-word                # shift-right

if [ "$TERM" = 'linux' ]; then
    bindkey '^[[D' backward-word          # ctrl-left
    bindkey '^[[C' forward-word           # ctrl-right
else
    bindkey '^[Od' backward-word            # ctrl-left
    bindkey '^[Oc' forward-word             # ctrl-right
fi

# use reset not clear-screen for clearing the screen
#  this way the backlog is also cleared
reset-screen() {
	reset         # clear backlog and screen
	zle redisplay # redisplay prompt
}
zle -N reset-screen
bindkey '^L' reset-screen                   # ctrl-L

# helper function that converts several lines to one
toline() {
    while read TEMPVAR; do
        echo -n "${TEMPVAR} "
    done
}

precmd() {
	[[ -t 1 ]] || return
  case $TERM in
		sun-cmd) print -Pn "\e]l%~\e\\"
  ;;
		*xterm*|rxvt*|(dt|k|E)term) { print -Pn "\e]0;%~\a" }
	;;
  esac
}
precmd

# local machine-specific configuration if exists
[ -e ~/.zshrc_additional ] && source ~/.zshrc_additional

# rvm
[ -e "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"
#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Ruby
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_HEAP_FREE_MIN=200000
#export RUBY_DISABLE_GC_FOR_SPECS="true"

# Use 1.9
export RBXOPT="-X19"
export JRUBY_OPTS="--1.9"

export GOROOT=/usr/local/go

# Java
#export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
