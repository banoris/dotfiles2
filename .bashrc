# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# set -x

# WA bash_profile in vscode remote ssh terminal
[[ -f ~/dotfiles-eric/.bashrc.eric ]] && source ~/dotfiles-eric/.bashrc.eric

detect_platform() {
    local uname_out
    uname_out="$(uname -s)"

    case "$uname_out" in
        CYGWIN*|MINGW*|MSYS*)
            echo "windows"
            ;;
        Linux*)
            # Check if running under WSL
            if grep -qi microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        Darwin*)
            echo "macos"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}
platform=$(detect_platform)

DOTFILES_DIR=$HOME/dotfiles2

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ble.sh causes issue with VSCode Remote SSH
# if [[ $- == *i* ]] && [[ -f "$DOTFILES_DIR/ble.sh/out/ble.sh" ]] && [[ -z "$VSCODE_IPC_HOOK_CLI" ]] && [[ -n "$SSH_TTY" ]]; then
#     # Slow tab autocomplete, string matching to suggested output
#     # OK after IT restart session. Probably some expensive zombie proc
#     source $HOME/dotfiles/ble.sh/out/ble.sh --noattach
#     # echo NO BLE
# fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# https://askubuntu.com/q/70750/1003460 - prevent bash from escaping $
# upon pressing <Tab>
shopt -s direxpand


# Bash history file per shell session, with optional tmux session name.
tmux_session_name=""
if [ -n "$TMUX" ]; then
    tmux_session_name="-$(tmux display-message -p '#S')"
    [[ -d ~/.bash_history_dir ]] || mkdir --mode=0700 ~/.bash_history_dir
    [[ -d ~/.bash_history_dir ]] && chmod 0700 ~/.bash_history_dir
    HISTFILE=~/.bash_history_dir/bash_history-$(date +"%Y%m%d-%H%M%S")${tmux_session_name}
fi

HISTSIZE=5000
HISTFILESIZE=10000
unset tmux_session_name


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    # alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

set -o ignoreeof # disable CTRL-D to close terminal

# android setting
export PATH=$PATH:$HOME/bin
export USE_CCACHE=1
export CCACHE_DIR=$HOME/.cache
export ANDROID_ADB_SERVER_PORT=5037  # 5037 prob when reflashing
export PATH=$PATH:$HOME/Android/Sdk/build-tools/27.0.1

# Haskell cabal, ghc
export PATH=$PATH:/opt/ghc/bin/
# latex
export PATH=$PATH:/usr/local/texlive/2020/bin/x86_64-linux

# custom binaries
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/bin-amd64:$PATH
export PATH=$DOTFILES_DIR/bin:$PATH

# Clang, llvm
export PATH=$PATH:$HOME/LLVM_10.0.1/bin

# Golang
export PATH=$PATH:$HOME/go/bin

# Erlang rebar
export PATH=$PATH:~/.cache/rebar3/bin


# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f $DOTFILES_DIR/.bash_aliases.sh ]; then
    source $DOTFILES_DIR/.bash_aliases.sh
fi

### BEGIN variables {{{

# https://stackoverflow.com/questions/10517128/change-gnome-terminal-title-to-reflect-the-current-directory
PROMPT_COMMAND='echo -ne "\033]0;\"${PWD##*/}\"\007"' # display only current dir as title
export SER1=R1J56L64e0f8df
export SER2=R1J56L68fb9966
export SER3=R1J56L2006cc32
# bash C-x C-e editor, default is nano
export VISUAL=vim

# grep: warning: GREP_OPTIONS is deprecated; please use an alias or script
# export GREP_OPTIONS='--color=auto'

### END variables }}}

### BEGIN mysetting {{{

# Aggregate history of all terminals in the same .history. https://cfenollosa.com/misc/tricks.txt
# shopt -s histappend
# export HISTSIZE=100000
# export HISTFILESIZE=100000
# export HISTCONTROL=ignoredups:erasedups
# Nahh, all terminal will be dirtied with other cmds from diff terminal!
# export PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"

# check these two in ~/.inputrc
#set completion-ignore-case on
#set show-all-if-ambiguous on
if [ -f ~/.inputrc ]; then
    bind -f ~/.inputrc
fi
# TODO: check server or local machine, use diff color to remind that you are inside server's shell
# export PS1="\[\e[1;36m\][\u@\h \w]\e[35m\$(parse_git_branch)\e[0m\e[1;36m \D{%a %H:%M:%S}\n\$\[\e[m\] "
# Retire above, use git-prompt.sh instead
# [[ -f ~/dotfiles/git-prompt.sh ]] && source ~/dotfiles/git-prompt.sh
# export GIT_PS1_SHOWDIRTYSTATE=true
# export GIT_PS1_SHOWUNTRACKEDFILES=true
# export GIT_PS1_SHOWUPSTREAM="verbose git"
# export PS1="\[\e[1;36m\][\u@\h \w]\e[35m\$(__git_ps1 '[%s]')\e[0m\e[1;36m \D{%a %H:%M:%S}\n\j\$\[\e[m\] "
# export PS1='\[\e[1;36m\][\u@\h \w]\e[35m\$(__git_ps1 "[%s]")\e[0m\e[1;36m \D{%a %H:%M:%S}\n\$\[\e[m\] '

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac
# case $(hostname) in
#     # use this color for local machine
#     EMB*)
#         prompt_color='\033[48;5;16m\033[38;5;46m'
#         ;;
#     *)
#         prompt_color='1;36m'
#         ;;
# esac
# \j - number of background jobs. Show only if job exists
# export PS1="\[\e[1;36m\][\u@\h \w]\e[35m\$(__git_ps1 '[%s]')[\$(__k8_ps1)]\e[0m\e[1;36m \D{%a %H:%M:%S}\n\$([ \j -gt 0 ] && echo [\j])\$\[\e[m\] "
# NOTE: just use the default MINGW/Cygwin PS1. Too much headache to make below work with git prompt.
if [[ "$platform" != "windows" ]]; then
    export PS1="\[\e[1;36m\][\u@\h \w]\e[35m[\$(__k8_ps1)]\e[0m\e[1;36m \D{%a %H:%M:%S}\n\$([ \j -gt 0 ] && echo [\j])\$\[\e[m\] "
fi


# less setting
#export LESS='-XFR'
# -R: remove the ESC\ color thingy, set this so color shows up nicely. -i: case-insensitive search
# -S: no wrap
export LESS='-SiR'

### END mysetting }}}

### BEGIN bashfunction {{{

# e.g. mylog $SER1 -- get logcat from device $SER1
function mylog() {
    adb -s $1 logcat -G 5M
    adb -s $1 logcat -d RouteManager:S PFW:S MDL:S CFG:S AudioStreamOut:S AudioStreamIn:S AudioIntelHal:S _ENV:S CarPowerManagerNative:S PowerTestService:S AVB_CONFIG:S _AMN:S _ASH:S ioc_cbc:S ioc_cbcd:S CarDrivingState:S AudioStreamIn:S CBCProto:S _PTP:S chatty:S IOCDeviceCBC:S DPTF:S _TX1:S _TX2:S ConnectivityService:S wpa_supplicant:S ioc_slcand:S _RXE:S PhoneDoctor:S AudioIntelHal/AudioPlatformState/Pfw:S qtaguid:S NetworkManagementSocketTagger:S DG.WV:S GPTP:S IOC_COMM:S EvsApp:S PowerUI:S ioc_cbcd:S CarDrivingState:S AudioStreamIn:S CBCProto:S _PTP:S chatty:S IOCDeviceCBC:S DPTF:S _TX1:S _TX2:S ConnectivityService:S wpa_supplicant:S ioc_slcand:S _RXE:S PhoneDoctor:S AudioIntelHal/AudioPlatformState/Pfw:S qtaguid:S NetworkManagementSocketTagger:S DG.WV:S GPTP:S IOC_COMM:S EvsApp:S PowerUI:S SensorsHal:S ThermalHal:S RZN:S EVT:S ROU:S SMW:S SMJ:S SXP:S SXC:S BFT:S WifiHAL:S HvacModule:S | vim -
}

# Download and unzip flashfile
function dluz {
	dl $1;
	unzip $(basename $1);
	touch ./* # change the file timestamp to current timetouch * # change the file timestamp to current time
	noti DL_UNZIP_COMPLETE;
}

# cp and unzip $1 to $2
cpuz() {
	echo 'Copying........'
	cp $1 $2;
	echo 'cp done, unzipping...'
	unzip "$2/$(basename $1)" -d $2;
	touch $2/* # change the file timestamp to current time
	noti CP_UNZIP_COMPLETE;
}

# zsh style cd
# https://gist.github.com/saagarjha/f9e9186479975d36dc18b15a87849205
# cd -h # list history
# cd -<n> # pick the nth item from history
# TODO:feature: avoid duplicate folders. Use set datastructure with LRU?
cd() {
	# Set the current directory to the 0th history item
	cd_history[0]=$PWD
	if [[ $1 == -h ]]; then
		for i in ${!cd_history[@]}; do
			echo $i: "${cd_history[$i]}"
		done
		return
    # list path in pager instead of stdout
    elif [[ $1 == "-hh" ]]; then
        printf "%s\n" "${cd_history[@]}" | less -N
	elif [[ $1 =~ ^-[0-9]+ ]]; then
		builtin cd "${cd_history[${1//-}]}" || # Remove the argument's dash
		return
	else
		builtin cd "$@" || return # Bail if cd fails
	fi
	# cd_history = ["", $OLDPWD, cd_history[1:]]
	cd_history=("" "$OLDPWD" "${cd_history[@]:1:${#cd_history[@]}}")
}

# function to set terminal title (gnome-terminal)
set-title() {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}


### END bashfunction }}}

# enable forward search in bash  https://stackoverflow.com/questions/791765/unable-to-forward-search-bash-history-similarly-as-with-ctrl-r
stty -ixon

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
[[ -f ~/.bash_tmux_completion ]] && source ~/.bash_tmux_completion
[[ -f $DOTFILES_DIR/.git-completion.bash ]] && source $DOTFILES_DIR/.git-completion.bash
[[ -f $DOTFILES_DIR/.kubectl-completion.bash ]] && source $DOTFILES_DIR/.kubectl-completion.bash
[[ -f $DOTFILES_DIR/completions/helm-completion.bash ]] && source $DOTFILES_DIR/completions/helm-completion.bash
[[ -f $DOTFILES_DIR/k8-namespace-prompt.sh ]] && source $DOTFILES_DIR/k8-namespace-prompt.sh
[[ -f ~/.kubech/kubech ]] && source ~/.kubech/kubech
[[ -f ~/.kubech/completion/kubech.bash ]] && source ~/.kubech/completion/kubech.bash

# Setup autocomplete for aliases
#  Note: without 'nospace' a backslash will appear after completion
# complete -o default -o nospace -F _git g # not working in newer linux/mac?
__git_complete g __git_main
complete -o default -F __start_kubectl kc

# gnome-terminal bug
# https://askubuntu.com/questions/511633/terminal-tab-not-opening-in-same-directory
# NOTE: sensitive to execution order, so source at the end
[[ -f /etc/profile.d/vte.sh ]] && . /etc/profile.d/vte.sh

# ble.sh
[[ ${BLE_VERSION-} ]] && ble-attach

# NOTE: put at top
# # WA bash_profile in vscode remote ssh terminal
# [[ -f ~/dotfiles-eric/.bashrc.eric ]] && source ~/dotfiles-eric/.bashrc.eric

