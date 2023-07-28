######## EXTERNAL ########
source ~/.iterm2_shell_integration.zsh

######## GLOBALS ########
export REQUESTS_CA_BUNDLE="${HOME}/.config/cert.pem"
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

######## OPTIONS ########
setopt autopushd
bindkey -v

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
alias bw_unlock="export BW_SESSION=$(bw unlock --raw)"
