######## EXTERNAL ########
source ~/.iterm2_shell_integration.zsh

######## GLOBALS ########
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
        export REQUESTS_CA_BUNDLE="${HOME}/.config/cert.pem"
    fi
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
# adapted from https://github.com/ysl2/mini-simple-zsh-prompt





######## Vim mode setup ########

bindkey -v # enable vim mode

# credit to rotareti on stackoverflow
# https://unix.stackexchange.com/a/327572
function zle-keymap-select zle-line-init
{
    # change cursor shape in iTerm2
    case $KEYMAP in
        vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
        viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
    esac

    zle reset-prompt
    zle -R
}

function zle-line-finish
{
    print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select


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
