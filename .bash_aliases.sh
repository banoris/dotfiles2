
alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias gvr='gvim --remote-tab'
alias asdnoti='notify-send -t 0'
alias install='sudo apt install'
alias k='konsole'
alias asdsshfast='ssh -XC -c blowfish-cbc,arcfour'
alias noti='notify-send -t 0'
alias dl='wget --no-check-certificate --user=biskhand --ask-password'
alias asdbashrc='source ~/.bashrc'
alias dirs='dirs -v'
alias h="history | cut -c 8- | nvim -c 'set syntax=bash' -" # `cut` removes the line numbers in history
# Need `--color=always` to preserve color when piped to another grep
# NOTE: braces expansion won't work when there's only a single directory. --exclude-dir={.git}
alias gr2='egrep -srnI --exclude-dir=.git --exclude=tags'
alias cd2="cd ../.."
alias cd3="cd ../../.."
alias cd4="cd ../../../.."
alias cd5="cd ../../../../.."

alias adb1='adb -s R1J56L64e0f8df'
alias adb2='adb -s R1J56L68fb9966'
alias adb21='adb -s R1J56L32b70674'
alias parallel='parallel --will-cite'
alias gt='gnome-terminal'
alias fgr-git='git ls-files | grep -i'
alias g='git'
alias kc='kubectl'

# gnome-terminal --title="pod shell" --tab -- /bin/tcsh -c "kubectl exec -it $CONTAINER -- tcsh -c erl; bash"

## USAGE: grep -sr SOMESTUFF | get-file-ext. Why? Grepping some magical
## strings, check what kind of file has it, deduce something... rinse-n-repeat
alias get-file-ext="awk -F. '{print \$NF}' | sort -u"

# Copy to primary clipboard. E.g.: $ realpath /some/path | xc
alias xc="xargs echo -n | xclip -selection c"
alias psgrep="ps -ef | grep "

# Download a file using curl.
#   -L -- resolve redirect
#   -O -- write output to local file
#   Use netrc file for auth
alias curl-dl="curl -OL --netrc-file ~/.netrc"

if [[ -n $(which nvim 2> /dev/null) ]]; then
    alias v-='nvim -'
else
    alias v-='vim -'
fi
