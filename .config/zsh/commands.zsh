#--- Aliases -----------------------------------------------------------------

alias m='mv -nv'
alias n=nvim

# ss<x> aliases:
# p: ssh more suitable for mass parallelizing
# t: tmux attach
# x: X11 forwarding with WindowID, useful for e.g. forwarding vim clipboards
function ssp() {
    parallel --nonall --sshlogin $@
}
function sst() {
    ssh -t $@ '$SHELL -l -c "tmux attach || tmux"'
}
alias ssx='ssh -X -o "SendEnv WINDOWID"'

function p() {
    parallel --tag --progress --nonall --sshlogin - $@
}

# SSH SOCKS Proxy
function tunnel() {
    local tunnel_host=${tunnel_host:-pi.grayvines.com}
    local tunnel_port=${tunnel_port:-8080}
    networksetup -setsocksfirewallproxystate Wi-Fi on
    printf 'Tunneling to %s:%s...\n' $tunnel_port $tunnel_host
    ssh -D $tunnel_port -C -N $tunnel_host
    networksetup -setsocksfirewallproxystate Wi-Fi off
}

if (( $+commands[colordiff] )); then
    alias diff='colordiff'
fi
function d() {
    wdiff -n $@ | diff
}
alias di=diff

if (( $+commands[brew] )); then
    alias brew='GREP_OPTIONS= brew'
    alias up="brew update && brew upgrade --all"
fi

if (( $+commands[selecta] )); then
    alias v='vim $(find . -type f | selecta)'

    function insert-selecta-path-in-command-line() {
        # Copied from https://github.com/garybernhardt/selecta/blob/master/EXAMPLES.md
        local selected_path
        echo
        selected_path=$(find . -type f | selecta) || return
        eval 'LBUFFER="$LBUFFER$selected_path "'
        zle reset-prompt
    }
    zle -N insert-selecta-path-in-command-line

    bindkey "^S" insert-selecta-path-in-command-line
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
alias parallel='noglob parallel'
alias pip='noglob pip'

# git convenience
alias g='noglob git'
alias git='noglob git'
alias dev='git checkout develop'
alias master='git checkout master'

alias sed="sed -E"

if ls --color &> /dev/null; then
    alias ls='ls --color=auto --human-readable --group-directories-first'
else
    export CLICOLOR=true
    alias ls='ls -h'
fi

if (( $+commands[ag] )); then
    AG_OPTIONS='--smart-case'
    alias ag="ag $AG_OPTIONS"

    alias pag='parallel"" -X ag'

    # Find the pattern in tests / not in tests
    alias agg="ag --ignore '*test*'"
    alias agp="ag --ignore '*test*' --python"
    alias agt="ag -G '\btests?\b'"
    alias agpt="ag -G '\btests?\b.*\.py'"
fi

if (( $+commands[dircolors] )); then
    eval $( dircolors -b $XDG_CONFIG_HOME/dircolors )
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


# tmux helpers
function :sp () { tmux split-window }
function :Sp () { tmux split-window }
function :vsp () { tmux split-window -h }
function :Vsp () { tmux split-window -h }

# Associated project name for the current directory
function project() { echo ${${1:-$PWD}:t:l:gs/-/_} }

# Print a Python str
function pp() {
    python -c "print '$@'"
}

# Run tests on current directory in a corresponding venv, otherwise globally
function t() {
    emulate -L zsh
    setopt LOCAL_OPTIONS NO_NOMATCH
    local venv_runner=~[$PYTHON_TEST_RUNNER]
    if [[ -f "$venv_runner" ]]; then
        $venv_runner $@ $(project)
    else
        $PYTHON_TEST_RUNNER $@ $(project)
    fi
}
