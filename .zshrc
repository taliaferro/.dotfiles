######## GLOBALS ########

export PATH=${HOME}/.local/bin:${PATH}
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

if [[ $USER =~ "taliaferro1|jtaliafe" ]]; then
    export IS_LLNL=true
else
    export IS_LLNL=false
fi

if $IS_LLNL; then \
    if [[ -e "/etc/pki/tls/cert.pem" ]]; then
        export REQUESTS_CA_BUNDLE="/etc/pki/tls/cert.pem"
    else
        # export REQUESTS_CA_BUNDLE="${HOME}/.config/cert.pem"
    fi
fi


######## SPACK ########

if [ -d $HOME/spack ]; then
    SPACK_SKIP_MODULES=1
    source $HOME/spack/share/spack/setup-env.sh
fi;

default_env=$HOME/.spack/environments/default/.spack-env/view

if [ -d $default_env ]; then
    export PATH=$default_env/bin:$PATH
fi;

######## EDITOR ########
if which kak > /dev/null 2> /dev/null; then
    export EDITOR=kak
elif which vim > /dev/null 2> /dev/null; then
    export EDITOR=vim
else
    export EDITOR=vi
fi

######## OPTIONS ########
setopt autopushd

######## FUNCTIONS ########
function set-pod () {
    # Reference: https://www.netmeister.org/blog/keychain-passwords.html
    # Alternate: From an LC system:
    #     - `/usr/global/tools/sdm/bin/getpod`
    #     - `hopper -getpod`
    echo -n "Enter Password of the Day: "
    read -s POD
    [ -z "$POD" ] && echo "Must provide POD, must be non-empty..." && return 1
    security add-generic-password -U -a ${USER} -s "LC Password of the Day" -w ${POD}
}

function get-pod () {
    security find-generic-password -a ${USER} -s "LC Password of the Day" | grep mdat | cut -d'"' -f 4 | cut -d "\\" -f1 | sed 's/Z/GMT/' | xargs -I {} date -jf %Y%m%d%H%M%S%Z "{}"
    security find-generic-password -a ${USER} -s "LC Password of the Day" -w | pbcopy
}

function spack-ref () {
  git -C $HOME/spack fetch origin
  if git -C $HOME/spack remote | grep upstream; then
    git -C $HOME/spack fetch upstream
    git -C $HOME/spack merge upstream/develop origin/develop
  fi
}

# adapted from https://github.com/ysl2/mini-simple-zsh-prompt
######## PROMPT ########
# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%F{white}git:%F{magenta}%b'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST

PROMPT='
%B%F{green}%n %F{white}on %F{yellow}%m %F{white}in %F{cyan}%(5~|%-2~/.../%2~|%~) ${vcs_info_msg_0_}
%F{white}> %f%b%F{white}'

######## ALIASES ########
alias ll="ls -al"
alias gst="git status"
alias dotfiles='git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}'
alias :wq="exit"
alias :x="exit"
alias bw_unlock='export BW_SESSION=$(bw unlock --raw)'
alias mxcc="tmux -CC new -A -s main" # tmux control mode for iterm2
alias spack-up="spack -e default concretize --fresh --force; spack -e default install"
alias emacs="emacs -nw"
# alias kssh="kitty +kitten ssh"

######## EXTERNAL ########
source ~/.iterm2_shell_integration.zsh

# Set pane title
echo -en "\\033]0;${USER}@${HOSTNAME}\\a"
