# zsh
# https://wiki.gentoo.org/wiki/Zsh/Guide
autoload -U colors compinit promptinit
colors
compinit
promptinit

function set-prompt {
    V=""
    if [ -n "$VIRTUAL_ENV" ]; then
        BN=$(basename $VIRTUAL_ENV)
        V="($BN) "
    fi
    PROMPT="$V%{$fg_bold[green]%}%n@%m%{$reset_color%}%{$fg[black]%}:%{$fg_bold[blue]%}%~%{$fg_bold[magenta]%}%{$reset_color%}"$'\n'"$1 "
}

set-prompt '$'

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

setopt auto_cd # cd by directly typing directory name
setopt inc_append_history # update history after each command, from multiple shells
setopt menu_complete
setopt share_history
setopt NO_BEEP

zstyle ':completion:*' menu select
zstyle ':completion:*' ignored-patterns '*?.pyc' '__pycache__' '*.class' '.zcompdump' '.zsh_history'

export TERM=xterm-256color
export EDITOR=nvim
export GIT_EDITOR=nvim

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# Zsh Line Editor (visual mode)
## Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
    set-prompt "${${KEYMAP/vicmd/N}/(main|viins)/\$}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# =================== #
# Functions & Aliases #
# =================== #

# Safe rm procedure
safe_rm()
{
    # Cycle through each argument for deletion
    for file in $*; do
        if [ -e $file ]; then
            # Target exists and can be moved to Trash safely
            if [ ! -e ~/.Trash/$file ]; then
                mv $file ~/.Trash
            # Target exists and conflicts with target in Trash
            elif [ -e ~/.Trash/$file ]; then
                # Increment target name until
                # there is no longer a conflict
                i=1
                while [ -e ~/.Trash/$file.$i ];
                do
                    i=$(($i + 1))
                done
                # Move to the Trash with non-conflicting name
                mv $file ~/.Trash/$file.$i
            fi
        # Target doesn't exist, return error
        else
            echo "rm: $file: No such file or directory";
        fi
    done
}

# web search
function explainshell() {
    open -na "Google Chrome" --args "https://explainshell.com/explain?cmd=$*"
}
function localhost() {
    open "https://localhost:$*"
}
function google() {
    open -na "Google Chrome" --args "https://www.google.com/search?q=$*"
}
function stackoverflow() {
    open -na "Google Chrome" --args "https://www.google.com/search?q=site:stackoverflow.com $*"
}

# Make new directory and navitgate into it
function mcd() { mkdir -p $1 && cd $1 }

# Virtual environment deactivation
function deactivate_venv() {
    venv_active=$(which deactivate)
    if [[ $venv_active != *"deactivate not found"* ]]; then deactivate; fi
}

# Web search
alias es=explainshell
alias gg=google
alias lh=localhost
alias soa='open https://stackoverflow.com/questions/ask'
alias so=stackoverflow

# MacOS
alias db="cd ~/Dropbox/"
alias dt="cd ~/Desktop/"
alias dl="cd ~/Downloads/"
alias dv="cd ~/dev/"
alias lh4200="o http://localhost:4200/"

# Misc
alias l='pwd && ls -lAh'
alias cl='clear; pwd && ls -lAh'
alias cp='cp -i'
alias mv='mv -i'
alias x='xargs'

alias ..="cd .."
alias ..2="cd ../../"
alias ..3="cd ../../../"
alias b='cd -'
alias ~='cd ~'
alias o='open'
alias o.='open .'
alias of='vim $(fzfp)'
alias cf="fzf | cd"

alias trash='safe_rm'
alias t='safe_rm'
alias grep='grep -H -n'
alias cwd='pwd | tr -d "\r\n" | pbcopy' #copy working directory
alias h='history'
alias ppath="echo $PATH | tr ':' '\n'" #print path
alias q="exit"
alias :q="exit"
alias :Q='exit'

alias copy="tr -d '\n' | pbcopy" # remove carriage return at the end of pbcopy on a mac.
alias d="deactivate"

alias vim='nvim'
alias v='vim'
alias tmux='tmux -2'
alias ta='tmux a'
alias tm='TMUX= tmux'
alias tx='tmuxinator start'
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
alias v.="vim ."
alias bf='fzf | xargs bat'

# Git
alias ghcp="o https://github.com/chrispalmo"

## Git standards
alias ga='git add'
alias gb='git branch' # list branches
alias gba='git branch -a' # list all branches
alias gbd="git branch --delete"
alias gbdr="git push origin --delete" # delete remote branch. use: gbdr [branch-name]
alias gcnv='git commit --no-verify'
alias gcp='git cherry-pick'
alias gc='git commit'
alias gca='git commit --amend ' # overwrite last commit
alias gcnv="git commit --no-verify"
alias gd='git diff'
alias gdn='git diff --name-only'
alias gds='git diff --staged'
alias gdsn='gd --staged --name-only'
alias gf='git fetch'
alias gl='git log'
alias glf='git log --name-only' # log includes list of files changed
alias glm='git log --merge' # list of commits that conflict during merge
alias gm='git merge'
alias gmm='git merge master'
alias go='git checkout' # switch branch
alias gob='git checkout -b' # create new branch, switch to it
alias gom='git checkout master'
alias gomu='git checkout master && git pull --rebase'
alias go-='git checkout -'
alias gp='git push'
alias gpf='git push --force'
alias gpu='git push --set-upstream origin' # use: gpu branch-name
alias gr1c='git reset HEAD^' # reset to state before last commit, keeping changes
alias gr='git reset'
alias grh='git reset --hard'
alias grbi="git rebase --interactive" # use: `grbi [commit-hash-before-changes]. effect: Merge together all commits AFTER [commit-hash]. Refer: https://www.internalpointers.com/post/squash-commits-into-one-git. Use `git push --force origin [branch-name], but this isn't great... aim to avoid rebasing and squashing with by using git commit --amend in the first place.
alias gs='git status'
alias gss='git status -s' # git status --short
alias gsn="git status -s | sed 's#.*/##'" # git status --short
alias gsh='git show'
alias gshn='git show --name-only' # list files changed in latest commit
alias gst='git stash save' # `gst "message"` locally save uncommited changes (both staged and unstaged)
alias gsta='git stash apply' # apply stashed changes to working copy, without deleting from stash.
alias gstd='git stash drop' # delete a stash
alias gstk='git stash save --keep-index' # keeps staged changes and stashes un-tracked changes
alias gstl="git stash list"
alias gstls="git stash list --stat" # list files changed for each stash
alias gstp='git stash pop' # delete stash; apply stashed changes to working copy
alias gu='git pull --rebase'
alias git-undo-last-commit='git reset --soft HEAD~1'
alias git-redo-next-commit='git reset ORIG_HEAD'
alias gulc='git-undo-last-commit'
alias grnc="git-redo-next-commit"

## Git helpers
alias fzf8="fzf -m --height=8"
function gcm () { [[ $@ != '' ]] && { COMMIT_MESSAGE="$@" ; git commit -m $COMMIT_MESSAGE } || git commit }
function gcam () { [[ $@ != '' ]] && { COMMIT_MESSAGE="$@" ; git commit --amend -m $COMMIT_MESSAGE } || git commit }
function gcamp () { MESSAGE=$(git reflog -1 | sed 's/^.*: //') ; gcam $MESSAGE }
alias gcd='cd $(git rev-parse --show-toplevel)' # cd to repo root
alias gbn="git rev-parse --abbrev-ref HEAD" # return current branch name
alias gfiles='echo "$(git ls-files --others --exclude-standard ; git diff --name-only; git diff --staged --name-only)"' # list modified files
alias gbranches='git for-each-ref --format="%(refname:short)" refs/' # list all branches
alias gbranches_raw='{branches=$(gbranches); echo ${branches//origin\/};}' # list all branches, sans 'origin/' prefic

## Git (helper-assisted)
alias ga.='gcd; ga .; cd -'
### compare current branch to master on github website
alias ghbc='{CURRENT_BRANCH=$(gbn); CURRENT_REPO=$(cut -d . -f 1 <<< $(cut -d : -f 2 <<< $(git config --get remote.origin.url))); o https://github.com/"$CURRENT_REPO"/compare/"$CURRENT_BRANCH";}'
### compare current branch to master on gitlab website
alias glbc='{CURRENT_BRANCH=$(gbn); CURRENT_REPO=$(cut -d / -f 2,3 <<< $(cut -d . -f 2 <<< $(git config --get remote.origin.url))); o https://gitlab.com/"$CURRENT_REPO"/-/compare/master..."$CURRENT_BRANCH";}'
### misc
alias gbnc='gbn | copy'
alias gpu='gbn | xargs git push --set-upstream origin'
function gac() { ga. ; gcm "$@" }
function gacp() { ga. ; gcm "$@" ; gp }
function gacpu() { ga. ; gcm "$@" ; gpu }
### fzf
alias gaf='gcd ; gfiles | fzf8 | xargs git add ; cd -' # fzf-assisted git add
alias gbdf='gcd ; gbranches_raw | fzf8 | xargs git branch --delete' # fzf-assisted git delete branch
alias gbdrf='gcd ; gbranches_raw | fzf8 | xargs git push origin --delete' # fzf-assisted git delete remote branch
alias gdf='gcd ; gfiles | fzf8 | xargs git diff ; cd -' # fzf-assisted git diff
alias gdsf='gcd ; gfiles | fzf8 | xargs git diff --staged ; cd -' # fzf-assisted git diff
alias gof='gcd ; gfiles | fzf8 | xargs git checkout ; cd -' # fzf-assisted git checkout
alias gobf='gbranches_raw | fzf8 | xargs git checkout' # fzf-assisted git checkout branch
alias grf='gcd ; git diff --staged --name-only | fzf -m --height=8 | xargs git reset ; cd -'
alias grmf='gcd ; git diff --name-only --diff-filter=U | fzf -m --height=8 | xargs git rm ; cd -'

## Github CLI
alias ghprv='gh pr view --web'
alias ghprc='gh pr create'
alias ghprcd='gh pr create --fill --draft ; gh pr view --web'

## Gitlab CLI
alias glmrv='glab mr view'
alias glmrc='glab mr create'
alias glprv='glmrv'
alias glprc='ghmrv'

# ================ #
# Project-specific #
# ================ #

# Clipchamp
CS1=~/dev/cs1
CS2=~/dev/cs2
CS3=~/dev/cs3
alias cs="cd $CS1"
alias cs="cd $CS2"
alias cs="cd $CS3"

alias cc1="make --directory=$CS1 --no-print-directory --"
alias cc2="make --directory=$CS2 --no-print-directory --"
alias cc3="make --directory=$CS3 --no-print-directory --"

alias cs1="deactivate_venv; cd $CS1/; source .venv39/bin/activate"
alias cs1f="cs1; yarn create:download-translations; cs1; cd apps/create; yarn start"
alias cs1b="cs1; npx @bazel/bazelisk run //apps/create:backend"
alias cs1install="cs1; git pull --rebase; ./installRequirements.sh backend; source .venv39/bin/activate; ./installRequirements.sh frontend sharedjs;"
alias cs1installClean="cs1; git pull --rebase; ./installRequirements.sh --clean;"
alias cs1clone="git clone git@github.com:clipchamp/clipchamp-stack.git cs1; cs1install"

alias cs2="deactivate_venv; cd $CS2/; source .venv39/bin/activate"
alias cs2f="cs2; yarn create:download-translations; cs2; cd apps/create; yarn start"
alias cs2b="cs2; npx @bazel/bazelisk run //apps/create:backend"
alias cs2install="cs2; git pull --rebase; ./installRequirements.sh backend; source .venv39/bin/activate; ./installRequirements.sh frontend sharedjs;"
alias cs2installClean="cs2; git pull --rebase; ./installRequirements.sh --clean;"
alias cs2clone="git clone git@github.com:clipchamp/clipchamp-stack.git cs2; cs2install"

alias cs3="deactivate_venv; cd $CS3/; source .venv39/bin/activate"
alias cs3f="cs3; yarn create:download-translations; cs3; cd apps/create; yarn start"
alias cs3b="cs3; npx @bazel/bazelisk run //apps/create:backend"
alias cs3install="cs3; git pull --rebase; ./installRequirements.sh backend; source .venv39/bin/activate; ./installRequirements.sh frontend sharedjs;"
alias cs3installClean="cs3; git pull --rebase; ./installRequirements.sh --clean;"
alias cs3clone="git clone git@github.com:clipchamp/clipchamp-stack.git cs3; cs3install"

alias ghcs="o https://github.com/clipchamp/clipchamp-stack"
alias ghcr="o https://github.com/clipchamp/content-repository"

# ==== #
# Path #
# ==== #

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/cp/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/cp/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/cp/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/cp/google-cloud-sdk/completion.zsh.inc'; fi
alias cc="make --directory=/Users/cp/dev/cs2 --no-print-directory --"

# n
# To avoid using sudo and sudo-related permission issues, set the N_PREFIX location to something in the user library.
export N_PREFIX=~/.npm
export PATH=$PATH:~/.npm/bin

# vscode
export PATH="/usr/local/bin/code:$PATH"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
export FZF_DEFAULT_OPTS='--bind ctrl-s:select-all'
alias fzfp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}
