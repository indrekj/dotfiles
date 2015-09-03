# zsh init file


# only do this if your system has a global profile :)
source /etc/profile

# bash style words (delete at / delimiter, etc)
autoload -U select-word-style
select-word-style bash

# functions for completiong whole command lines
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

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
