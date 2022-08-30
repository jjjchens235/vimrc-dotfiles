#!/bin/bash
#based off of https://gist.github.com/zachbrowne/8bc414c9f30192067831fafebd14255c

#######################################################
# Sourcing
#######################################################
# Source global definitions
if [ -f /etc/bashrc ]; then
	 . /etc/bashrc
fi

[ -f ~/.bash_prompt ] && source ~/.bash_prompt;
[ -f ~/.inputrc ] && source ~/.inputrc;

[ -f /usr/local/etc/bash_completion.d/git-completion.bash ] && source /usr/local/etc/bash_completion.d/git-completion.bash

#fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

#######################################################
# Colors
#######################################################
#old cmd line color scheme, updated in .bash_prompt
#PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\W\[\033[1;31m\]\$\[\033[0m\] '

# set 256 color profile where possible
if [[ $COLORTERM == gnome-* && $TERM == xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
		export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
		export TERM=xterm-256color
fi

#LS Colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

#######################################################
# GENERAL ALIAS'S
#######################################################

#need to use gnu expr rather than default osx bsd expr
if [ -f /usr/local/opt/coreutils/libexec/gnubin/expr ]; then
	alias expr="/usr/local/opt/coreutils/libexec/gnubin/expr"
	iatest=$(expr index "$-" i)
	# Disable the bell
	if [[ $iatest > 0 ]]; then bind "set bell-style visible"; fi
	if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi
fi

if type rg &> /dev/null; then
	alias grep='rg'
else
	alias grep="/usr/local/opt/grep/libexec/gnubin/grep"
fi

if type gxargs &> /dev/null; then
	alias xargs='gxargs'
fi

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

pro_dir=$HOME/'Programming/'
# Edit this .bashrc file
alias ,eb='vi ~/.bashrc'
alias ,sb='source ~/.bashrc'
alias ,ev='vi ~/.vimrc'

alias ,es='vi ~/Programming/Playground/buffer'
alias ,eq='vi ~/Programming/SQL/scratch.sql'
alias ,ep='vi ~/Programming/Python/scratch.py'
alias ,em='vi ~/Programming/Markdown/scratch.md'

# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias cdsql="cd $pro_dir/SQL/"

alias cdpy="cd $pro_dir/Python"
alias cdpr="cd $pro_dir/Python/DEngineering/Udacity/data_modeling_project/"
alias cdlc="cd $pro_dir/Python/Algorithims_DS/leetcode/2022_daily_leetcode_gitlab/"

alias cdxe="cd $pro_dir/Python/evernote-sdk-python3/lib/"
alias cdbr="cd $pro_dir/Python/bing-rewards-master/BingRewards/"
alias cdde="cd $pro_dir/Python/DEngineering"

alias cdpg="cd $pro_dir/Playground/"
alias cdpro="cd $pro_dir/"
alias cdc='cd ~/Cabinet/'

alias lsl='ls -alh'
alias lsd='ls -alht'

# Search command line history
alias h="history | grep "

# Search files in the current folder
#alias f="find . | grep "
#alias f="find . \( ! -name VoiceTrigger -o -prune \) | grep "

alias cl="clear"
alias cat='bat'
alias man='tldr'

#######################################################
# My preferences gathered over the years
#######################################################
#put vim env in bash shell
set -o vi
#alias vi=vim
export VISUAL=vim
export EDITOR="$VISUAL"

#src: https://unix.stackexchange.com/questions/104094/is-there-any-way-to-enable-ctrll-to-clear-screen-when-set-o-vi-is-set
#These mess with typing, for example 'h' stops working for some reason
#bind -m vi-insert "\C-p": previous-history
#bind -m vi-insert "\C-n": next-history
#bind -m vi-insert "\C-l": clear-screen
#These two don't work on mac machines
#bind -m vi-insert "\C-a": beginning-of-line
#bind -m vi-insert "\C-e": end-of-line

#silence zsh warning
export BASH_SILENCE_DEPRECATION_WARNING=1
#disable mail msg
unset MAILCHECK

#######################################################
# EXPORTS
#######################################################
# Expand the history size
export HISTFILESIZE=5000
export HISTSIZE=500

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace
# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# Allow ctrl-S for history navigation (with ctrl-R)
stty -ixon

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

if type fd &> /dev/null; then
	#note that all files inside ~/.gitignore and .fdignore are ignored
	
	#default command is useful for fzf.vim and piping
	export FZF_DEFAULT_COMMAND='fd -H -tf'
	#these 2 are useful for everyday terminal navigation
	export FZF_CTRL_T_COMMAND="fd -H -tf ."
	export FZF_ALT_C_COMMAND="fd -H -a -td ."
fi


# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#######################################################
# HELPER FUNCTIONS
#######################################################
function cd() {
	#if user specifies file, cd will specify to folder of file
	#if user specifies a folder, cd will behave as expected
	if [ $# -eq 0 ] ; then
		builtin cd ~
	elif [[ -d $@ ]] || [ "$1" == "-" ] ; then
			builtin cd "$@" && ls | sed 's/ /\\ /g' | head -30 |xargs ls -d
	else
			builtin cd "$(dirname $1)" && ls | sed 's/ /\\ /g' | head -30 | xargs ls -d
	fi
}

#cd to git root dir
function cdr() {
	cd "$(git rev-parse --show-toplevel)"
}

function f() {
	#find file, will look at the full path of the filename
	#list of flags: https://github.com/sharkdp/fd#command-line-options
	#optional flags should be passed in first, then PATTERN and PATH
	#remove -tf flag if you want to return dirs too
	if type fd &> /dev/null; then
		fd -H -p -tf "$@"
	elif type rg &> /dev/null; then
		rg --files "${PWD}" | rg --regexp ".*/.*$1.*" #| sort | nl
	else
		find . | grep $1 
	fi 
}

function ff() {
	#find file, will look at just the filename
	if type fd &> /dev/null; then
		fd -H -tf "$@"
	elif type rg &> /dev/null; then
		rg --files "${PWD}" | rg --regexp "$1[^/]*$"
	fi 
}

function fdir() {
	#returns directories only
	if type fd &> /dev/null; then
		fd -H -p  "$@"
	fi 
}


function fn() {
	#same as ff, but with --no-ignore
	fd --no-ignore -H -tf "$@"
}

function OpenFileInEnclosingVim {
#in vim :term mode, open new file in current buffer instead of a new instance of vim
#source: https://www.reddit.com/r/vim/comments/edrs9q/open_file_in_enclosing_vim_when_using_terminal_on/
if [ -z "${VIM_TERMINAL}" ]; then
		echo "Not running in Vim's terminal. Open a new vim!"
		return
fi

# See :help terminal-api for what this is and why it works. Basically the
# vim embedded terminal reads this 51 command
echo -e "\033]51;[\"drop\", \"$1\"]\007"
}

function vi() {
	#make vi command behave as normal unless being run in vim terminal mode
	if [ -z "${VIM_TERMINAL}" ]; then
		vim $@
	else
		OpenFileInEnclosingVim $@
	fi
}

#Function pbcopy
function pb() {
	cat $1 | pbcopy
}

# -------- cd vim terminal change dir ---- 
#source:https://vi.stackexchange.com/questions/21798/how-to-change-local-directory-of-terminal-buffer-whenever-its-shell-change-direc
cdv()
{
	printf '\033]51;["call", "Tapi_lcd", ["%s"]]\007' "$(pwd)"
}

cd_and_cdv()
{
	'cd' "$@" && cdv
}

hookvim()
{
	alias cd=cd_and_cdv
}

if [[ ! -z "$VIM_TERMINAL" ]]; then
	hookvim
fi

# ----------git checkout fzf ---------
#shows list of local branches
#https://github.com/junegunn/fzf/wiki/examples#git
gch() {
	local branches branch
	branches=$(git --no-pager branch) &&
	branch=$(echo "$branches" | fzf +m) &&
	git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}
gbr() {
	#example of how to use this: `git merge $(gbr)`
	git --no-pager branch | fzf
}

# returns the list of edited files in current branch compared to master
# https://confluence.atlassian.com/bitbucketserverkb/understanding-diff-view-in-bitbucket-server-859450562.html
# https://medium.com/@GroundControl/better-git-diffs-with-fzf-89083739a9cb
# alias glf='git diff $(git merge-base $(git rev-parse --abbrev-ref HEAD) master) $(git rev-parse --abbrev-ref HEAD) --name-only | cat'
gd() {
	if [ -d .git ]; then
		current_br="$(git rev-parse --abbrev-ref HEAD)"
		preview="git diff $(git merge-base $current_br master) $current_br --color=always -- {-1}"
		git diff $(git merge-base $current_br master) $current_br --name-only | fzf -m --ansi --preview "$preview"
	else
		echo "Not a git repository"
	fi;
}
alias vgd='vi $(gd)'

#git diff all
gda() {
		current_br="$(git rev-parse --abbrev-ref HEAD)"
		git diff $(git merge-base $current_br master) $current_br --name-only 
}
alias vgda='vi $(gda)'

# open all files with merge conflict
alias vgc='vi $(git diff --name-only --diff-filter=U)'
