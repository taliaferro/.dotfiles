export PATH=~/.local/bin:$PATH
export BASH_SILENCE_DEPRECATION_WARNING=1

######## SPACK ########

if [ -d $HOME/spack ]; then
    SPACK_SKIP_MODULES=1
    source $HOME/spack/share/spack/setup-env.sh
fi;

default_env=$HOME/.spack/environments/default/.spack-env/view

if [ -d $default_env ]; then
    export PATH=$default_env/bin:$PATH
fi;

if which -s kak; then
  export EDITOR=kak;
else
  export EDITOR=vim;
fi;

######### PROMPT ########
# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="\[\e[32m\]\u\[\e[m\]\[\e[37m\] on \[\e[m\]\[\e[33m\]\h\[\e[m\] in \[\e[36m\]\w\[\e[m\] \[\e[35m\]\`parse_git_branch\`\[\e[m\] \n> "

######## ALIASES ########

alias ll="ls -al"
alias gst="git status"
alias dotfiles='git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}'
alias :wq="exit"
alias :x="exit"
alias bw_unlock='export BW_SESSION=$(bw unlock --raw)'
alias mxcc="tmux -CC new -A -s main"
