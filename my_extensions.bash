export PS1="\[\e[32m\]\w\[\e[m\] \n$ "
# my old prompt
# adadapted from https://gist.github.com/srguiwiz/de87bf6355717f0eede5
# more comprehensive version here: https://github.com/jcgoble3/gitstuff/blob/master/gitprompt.sh
function git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
function markup_git_branch {
  if [[ "x$1" = "x" ]]; then
    echo -e "$1"
  else
    if [[ $(git status 2> /dev/null | tail -n1) = "nothing to commit, working tree clean" ]]; then
      echo -e '\033[1;32m['"$1"']\033[0;0m'
    else
      echo -e '\033[1;31m['"$1"']\033[0;0m'
    fi
  fi
}
export PS1='\n\[\e[32m\]\w\[\e[m\] $(markup_git_branch $(git_branch)) \n$ '
source ~/.git-completion.bash
###################################

export LSCOLORS=gxfxcxdxbxegedabagacad
# https://geoff.greer.fm/lscolors/

alias ls="ls -G"
alias ll="ls -laFG"
alias reloadbash="source ~/.bash_profile"
alias atombashprofile="atom ~/.bash_profile"

alias aa="atom ."
alias cc="code ."
alias ga="git add ."
alias gst="git status"
alias glog="git log --oneline --graph --decorate"
alias glo="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gc-="git checkout -"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cat="bat"
alias nn="npm test"

function gac () {
  git add .
  git commit -m "$@"
}
function hh () {
  history | grep "$@"
}

function mkcd () { mkdir -p "$@" && cd "$@"; }



function shell-z () {
  chsh -s /bin/zsh
  tab
}
function shell-b () {
  chsh -s /bin/bash
  tab
}
#!/bin/bash
#
# Open new Terminal tabs from the command line
#
# Author: Justin Hileman (http://justinhileman.com)
#
# Installation:
#     Add the following function to your `.bashrc` or `.bash_profile`,
#     or save it somewhere (e.g. `~/.tab.bash`) and source it in `.bashrc`
#
# Usage:
#     tab                   Opens the current directory in a new tab
#     tab [PATH]            Open PATH in a new tab
#     tab [CMD]             Open a new tab and execute CMD
#     tab [PATH] [CMD] ...  You can prob'ly guess
# # Only for teh Mac users
# [ `uname -s` != "Darwin" ] && return
#  https://gist.github.com/bobthecow/757788
function tab () {
  echo "Making a new tab..."
    local cdto="$PWD"
    local args="$@"
    if [ -d "$1" ]; then
        cdto=`cd "$1"; pwd`
        args="${@:2}"
    fi
    osascript -i <<EOF
        tell application "iTerm2"
                tell current window
                        create tab with default profile
                        tell the current session
                                # write text "cd \"$cdto\" && $args"
                        end tell
                end tell
        end tell
EOF
}



####################################################
####           better cd with history           ####
####################################################
# from https://aijaz.net/2010/02/20/navigating-the-directory-stack-in-bash/index.html

# An enhanced 'cd' - push directories
# onto a stack as you navigate to it.
#
# The current directory is at the top
# of the stack.
#
function stack_cd {
    if [ $1 ]; then
        # use the pushd bash command to push the directory
        # to the top of the stack, and enter that directory
        pushd "$1" > /dev/null
    else
        # the normal cd behavior is to enter $HOME if no
        # arguments are specified
        pushd $HOME > /dev/null
    fi
    # clear
    ls
}
# the cd command is now an alias to the stack_cd function
#
alias cd=stack_cd
# Swap the top two directories on the stack
#
function swap {
    pushd > /dev/null
}
# s is an alias to the swap function
alias s=swap
# Pop the top (current) directory off the stack
# and move to the next directory
#
function pop_stack {
    popd > /dev/null
}
alias p=pop_stack
# Display the stack of directories and prompt
# the user for an entry.
#
# If the user enters 'p', pop the stack.
# If the user enters a number, move that
# directory to the top of the stack
# If the user enters 'q', don't do anything.
#
function display_stack
{
    dirs -v
    echo -n "#: "
    read dir
    if [[ $dir = 'p' ]]; then
        pushd > /dev/null
    elif [[ $dir != 'q' ]]; then
        d=$(dirs -l +$dir);
        popd +$dir > /dev/null
        pushd "$d" > /dev/null
    fi
}
alias d=display_stack


###########################

function findgrep {
  foo=$@
  echo ${@}
  # echo finding files matching $1
  # echo grepping inside them for $2

  # find . -name node_modules -prune -o -type f -iname "*.json" -exec grep -n "serverless" {} \+
}