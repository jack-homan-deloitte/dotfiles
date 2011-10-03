export HISTSIZE=200
export HISTFILE=~/.zsh_history
export SAVEHIST=200

setopt NO_BEEP              # shh!
setopt EXTENDED_GLOB        # extended patterns support

export EDITOR="vim"

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

export GREP_OPTIONS='-IR --exclude-dir=.[a-zA-Z0-9]* --exclude=.* --color=auto'

export LESSHISTFILE="-"     # ugh, stupid less. Disable ridiculous history file

export NODE_PATH="/usr/local/lib/node/"

if [[ "$OSTYPE" == darwin* ]]
then
    export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules
    export PATH=/usr/local/share/python:/usr/local/share/python3:/usr/local/share/pypy:/usr/local/share/npm/bin:/Developer/usr/bin:$PATH:/usr/local/sbin
fi

export PATH=/usr/local/bin:$HOME/bin:$HOME/.local/bin:$PATH

export PYTHONSTARTUP=~/.pythonrc

# virtualenvwrapper (needs to be sourced *after* the PATH is set correctly)
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Development
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
source virtualenvwrapper.sh

#--- Prompt ------------------------------------------------------------------

PS1="%15<...<%~%# "
RPS1="%B%n%b@%m"

#--- Options -----------------------------------------------------------------

bindkey -v                  # set vim bindings in zsh

# Changing Directories

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# History

setopt HIST_IGNORE_DUPS       # ignore duplicates if last cmd is same
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY   # append lines to history incrementally
setopt SHARE_HISTORY

#--- Aliases -----------------------------------------------------------------

# Suffix Aliases
alias -s tex=vim

# Global Aliases
# alias -g CA="2>&1 | cat -A"
# alias -g C='| wc -l'
# alias -g DN=/dev/null

alias playalbums='mplayer */* -shuffle'
alias nosecov='coverage run --branch --source=. `which nosetests`'
alias nosecov3='coverage-3.2 run --branch --source=. `which nosetests-3.2`'
alias arssi="ssh julian@arch-desktop -t 'tmux attach-session -t irssi || tmux new-session -s irssi'"

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# assumes OSX has gnu coreutils installed from homebrew
alias ls='ls --color=auto --human-readable --group-directories-first'

eval $( dircolors -b $HOME/.dircolors )

# This was written entirely by Michael Magnusson (Mikachu)
# Basically type '...' to get '../..' with successive .'s adding /..
function rationalise-dot() {
if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
else
    LBUFFER+=.
fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

#--- Completion --------------------------------------------------------------

# Completions
fpath=(~/.zsh/zsh-completions $fpath)
autoload -U compinit
compinit

# Use cache for slow functions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

#  Fuzzy completion matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Allow more errors for longer commands
zstyle -e ':completion:*:approximate:*' \
        max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# If using a directory as arg, remove the trailing slash (useful for ln)
zstyle ':completion:*' squeeze-slashes true

# cd will never select the parent directory (e.g.: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
