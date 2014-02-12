#--- Aliases -----------------------------------------------------------------

alias di=diff

# ss<x> aliases:
# t: tmux attach
# x: X11 forwarding with WindowID, useful for e.g. forwarding vim clipboards
function sst() {
    ssh -t $@ '$SHELL -l -c "tmux attach || tmux"'
}
alias ssx='ssh -X -o "SendEnv WINDOWID"'

if (( $+commands[brew] )); then
    alias brew='GREP_OPTIONS= brew'
    alias up="brew update --rebase && brew upgrade"
fi

if (( $+commands[selecta] )); then
    alias v='vim $(find . -type f | selecta)'
fi

if (( $+commands[weechat-curses] )); then
    alias weechat="weechat-curses -d $XDG_CONFIG_HOME/weechat"
fi

# Suffix Aliases
alias -s tex=vim

# Try to get myself to stop typing fg; stop putting it in the history
alias fg=' fg'

# noglobs
alias find='noglob find'
alias git='noglob git'

alias sed="sed -E"

if ls --color &> /dev/null; then
    alias ls='ls --color=auto --human-readable --group-directories-first'
else
    alias ls='ls -Gh'
fi

if (( $+commands[ag] )); then
    AG_OPTIONS='--smart-case'
    alias ag="noglob ag $AG_OPTIONS"

    # Find the pattern in tests / not in tests
    alias agg="ag --ignore '*test*'"
    alias agp="ag --ignore '*test*' -G '\.py'"
    alias agt="ag -G '\btests?\b'"
    alias agtp="ag -G '\btests?\b.*\.py'"
fi

if (( $+commands[dircolors] )); then
    eval $( dircolors -b $XDG_CONFIG_HOME/dircolors )
fi

if (( $+commands[fasd])); then
    export _FASD_DATA=$XDG_DATA_HOME/fasd/fasd
    export _FASD_VIMINFO=$XDG_CACHE_HOME/vim/info
    eval "$(fasd --init auto)"
fi

function cdd() { cd *$1*/ } # stolen from @garybernhardt stolen from @topfunky
function cdc() { cd **/*$1*/ }


# This was written entirely by Michael Magnusson (Mikachu)
# Type '...' to get '../..' with successive .'s adding /..
function _rationalise-dot() {
  local MATCH MBEGIN MEND
  if [[ $LBUFFER =~ '(^|/| |	|'$'\n''|\||;|&)\.\.$' ]]; then
    LBUFFER+=/
    zle self-insert
    zle self-insert
  else
    zle self-insert
  fi
}

zle -N _rationalise-dot
bindkey . _rationalise-dot

# without this, typing a . aborts incremental history search
bindkey -M isearch . self-insert

disable r

# Disable the shell reserved word time if a binary is present
if (( $+commands[time] )); then
    disable -r time
fi


alias :q=exit
alias :w='echo Haha no.'

# tmux helpers
function :sp () { tmux split-window }
function :Sp () { tmux split-window }
function :vsp () { tmux split-window -h }
function :Vsp () { tmux split-window -h }

# Run tests on current directory in a corresponding venv, otherwise globally
function t() {
    emulate -L zsh
    unsetopt NO_MATCH

    local project=${$(pwd):t:l}
    local venv_runner=~[$PYTHON_TEST_RUNNER]
    if [[ -f "$venv_runner" ]]; then
        $venv_runner $@ $project
    else
        $PYTHON_TEST_RUNNER $@ $project
    fi
}
