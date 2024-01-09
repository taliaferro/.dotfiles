######## SPACK ########

if [ -d $HOME/spack ]; then
    SPACK_SKIP_MODULES=1
    source $HOME/spack/share/spack/setup-env.sh
fi;

default_env=$HOME/.spack/environments/default/.spack-env/view

if [ -d $default_env ]; then
    export PATH=$default_env/bin:$PATH
fi;

######## ALIASES ########

alias ll="ls -al"
alias gst="git status"
alias dotfiles='git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}'
alias :wq="exit"
alias :x="exit"
alias bw_unlock='export BW_SESSION=$(bw unlock --raw)'
alias mxcc="tmux -CC new -A -s main"
if ! infocmp $TERM > /dev/null; then export TERM="xterm-256color"; fi
