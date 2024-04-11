export PATH=~/.local/bin:$PATH
export BASH_SILENCE_DEPRECATION_WARNING=1

######## SPACK ########

if [ -d $HOME/spack ]; then
    SPACK_SKIP_MODULES=1
    source $HOME/spack/share/spack/setup-env.sh
fi;

function spack-ref () {
  git -C $HOME/spack fetch origin
  if git -C $HOME/spack remote | grep upstream; then
    git -C $HOME/spack fetch upstream
    git -C $HOME/spack merge upstream/develop origin/develop
  fi
};

default_env=$HOME/.spack/environments/default/.spack-env/view

if [ -d $default_env ]; then
    export PATH=$default_env/bin:$PATH
fi;

if which kak 2>/dev/null > /dev/null; then
  export EDITOR=kak;
else
  export EDITOR=vim;
fi;

function spack-ref () {
  git -C $HOME/spack fetch origin
  if git -C $HOME/spack remote | grep upstream; then
    git -C $HOME/spack fetch upstream
    git -C $HOME/spack merge upstream/develop origin/develop
  fi
}


######### PROMPT ########

function seed_rng() {
  RANDOM=$(echo $1 | md5sum | tr -d '[:alpha:]' | sed 's/-//')
}

function host_color_rgb () {
  # It's useful to be able to tell at a glance what machine I'm on.
  # I want to be able to assign each machine a color to put in the prompt.

  # first, seed bash's pseudorandom number generator with the hostname.
  # it only accepts numbers as seeds so we push it through md5sum and filter
  # out letter characters. (An alternate way to make a seed would be xxd)
  local OLD_RANDOM=$RANDOM
  seed_rng ${1:-$HOSTNAME}

  local MIN=
  local MAX=

  # we pick a "mod color" which is selected from a different range, either
  # higher or lower than the other two; this is to make sure the colors aren't
  # too close together (which would make a white or gray)
  local MOD=$(( RANDOM % 3 ))
  local MOD_HIGH=$(( RANDOM % 2 ))

  for I in {0..2}; do
    test $I -eq $MOD; local IS_MOD=$?
    if [[ $IS_MOD == $MOD_HIGH ]]; then
      MIN=150
      MAX=250
    else
      MIN=0
      MAX=100
    fi
    echo -n $(( MIN + (RANDOM % (MIN - MAX)) ))
  done

  # we still want to be able to make unseeded random numbers again later, so we
  # re-seed the RNG with the last unseeded random number we got
  RANDOM=$OLD_RANDOM
  echo;
}

function host_color_ansi(){
  read -r RED GREEN BLUE <<<$( host_color_rgb ${1:-$HOSTNAME} )
  echo "\x1b[38;2;i${RED};${GREEN};${BLUE}m"
}


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
alias jqless="jq -C | less -R"
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

if which codium 2>/dev/null > /dev/null ; then
  alias code="codium";
fi

######## MISC ########

# tell ollama where the API server is
export OLLAMA_HOST=https://ollama.apps.taliafer.ro

# unset ServerAliveInterval
sed -E -i.bak '/^ServerAliveInterval[[:space:]]+[[:digit:]]+.*/d' ${HOME}/.ssh/config

# Set pane title
# echo -en "\\033]0;${USER}@${HOSTNAME}\\a"
