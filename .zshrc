# zsh
# https://wiki.gentoo.org/wiki/Zsh/Guide
autoload -U colors compinit promptinit
colors
compinit
promptinit

# Enabling and setting git info var to be used in prompt config.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:git*' formats "- (%b) "
precmd() {
    vcs_info
}

function set-prompt {
    VENV=""
    if [ -n "$VIRTUAL_ENV" ]; then
        BN=$(basename $VIRTUAL_ENV)
        VENV="($BN)"
    fi
    BRANCH=$(echo "${vcs_info_msg_0_}" | sed 's/.*(//;s/).*//;')
    PROMPT="$VENV%{$fg_bold[green]%}%n%{$reset_color%} %{$fg_bold[yellow]%}%~%{$fg_bold[magenta]%} ${BRANCH}%{$reset_color%} $1 "
}

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

# Function to query ChatGPT via CLI.
# remember to add the below line to '~/.files/.scratch':
# export OPENAI_API_KEY="$YOUR_API_KEY"
ask_gpt() {
  if [ -z "$1" ]; then echo "Error: No input provided." && return 1; fi
  local API_ENDPOINT="https://api.openai.com/v1/chat/completions"
  local RESPONSE=$(curl -s -X POST "$API_ENDPOINT" -H "Content-Type: application/json" -H "Authorization: Bearer $OPENAI_API_KEY" --data "{\"model\": \"gpt-4\", \"messages\": [{\"role\": \"user\", \"content\": \"$1\"}]}")
  # Uncomment the next line for debugging
  echo "Raw response: $RESPONSE"
  local PARSED_RESPONSE=$(echo $RESPONSE | jq -r '.choices[0].message.content')
  if [ "$PARSED_RESPONSE" = "null" ]; then echo "Error or no response from API. Raw response was: $RESPONSE" && return 2; else echo $PARSED_RESPONSE; fi
}
alias ask="ask_gpt"

# Rapid note-taking
local NOTE_FILE_PATH="/Users/cp/Library/Mobile Documents/N39PJFAFEV~com~metaclassy~byword/Documents/notes/src/adhd.log"
# print notes
adhdp() {
  local DEFAULT_NUM_LINES=5
  if [[ "$1" == "--all" ]] || [[ "$1" == "-a" ]]; then
    cat "$NOTE_FILE_PATH"
  elif [[ "$1" =~ ^[0-9]+$ ]]; then
    tail -n "$1" "$NOTE_FILE_PATH"
  elif [[ -z "$1" ]]; then
    tail -n $DEFAULT_NUM_LINES "$NOTE_FILE_PATH"
  fi
}
# add note
adhd() {
  if [[ -z "$*" ]]; then
    echo "Please provide a note to add."
    return 1
  fi
  local timestamp=$(date "+%Y%m%d-%H%M")
  local note="$*"
  echo "$timestamp $note" >> $NOTE_FILE_PATH
  adhdp
}
# undo last note
alias adhdz="sed -i '' -e '\$ d' '$NOTE_FILE_PATH'; adhdp"

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

# Web search
function explainshell() {
    open -na "Google Chrome" --args "https://explainshell.com/explain?cmd=$*"
}
function localhostHTTPS() {
    open "https://localhost:$*"
}
function localhostHTTP() {
    open "http://localhost:$*"
}
function google() {
    open -na "Google Chrome" --args "https://www.google.com/search?q=$*"
}
function stackoverflow() {
    open -na "Google Chrome" --args "https://www.google.com/search?q=site:stackoverflow.com $*"
}

# Add aliases on the fly
function add { echo "alias $@" >> $HOME/.zshrc; source $HOME/.zshrc;}
function adds { echo "alias $@" >> $HOME/.scratch; source $HOME/.zshrc;}

# Make new directory and navitgate into it
function mcd() { mkdir -p $1 && cd $1 }

# Virtual environment deactivation
function deactivate_venv() {
    venv_active=$(which deactivate)
    if [[ $venv_active != *"deactivate not found"* ]]; then deactivate; fi
}

# Search for files in the current folder
function lag() {
    ls -lAh | ag $*
}

# Navigate to a directory, print the current path, and list files.
# Requires `setopt auto_cd` (cd by directly typing directory name).
function cd() {
    $*;
    pwd && ls -lAh;
}

# Web search
alias es=explainshell
alias gg=google
alias lh=localhostHTTPS
alias lhs=localhostHTTPS
alias lhh=localhostHTTP
alias soa='open https://stackoverflow.com/questions/ask'
alias so=stackoverflow

# Nav
alias .f="cd ~/.files/"
alias df="cd ~/.files/"
alias db="cd ~/Dropbox/"
alias dt="cd ~/Desktop/"
alias dl="cd ~/Downloads/"
alias dv="cd ~/dev/"
alias notes="cd '/users/cp/Library/Mobile Documents/N39PJFAFEV~com~metaclassy~byword/Documents/notes/src/'"
alias nt="notes"

# Misc
alias l='pwd && ls -lAh'
alias lc='clear && pwd && ls -lAh'
alias cl='lc'
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
alias of='nvim $(fzfp)'
alias cdf="fzf | cd"
alias catf='fzf | xargs cat'
alias batf='fzf | xargs bat'

alias trash='safe_rm'
alias t='safe_rm'
alias grep='grep -H -n'
alias cwd='pwd | tr -d "\r\n" | pbcopy' # copy working directory
alias h='history'
alias ppath="echo $PATH | tr ':' '\n'" # print path
alias q="exit"
alias c="clear"

alias copy="tr -d '\n' | pbcopy" # remove carriage return at the end of pbcopy on a mac.
alias d="deactivate_venv"

alias qa='tmux kill-server && exit' # kill all tmux sessions
alias t8='tmuxinator'
alias t8s='tmuxinator start'

alias vc='nvim ~/.vimrc'
alias zc='nvim ~/.zshrc'
alias .zc='source ~/.zshrc'

alias v='nvim'
alias v.="nvim ."

alias chrome='open -na "Google Chrome" --args' # example usage: chrome "https://example.xyz"

# Yarn
alias y='yarn'
alias ys='yarn start'
alias yt='yarn test'
alias ytw='yarn test:watch'

# Git
alias ghcp='o https://github.com/chrispalmo'

## Git standards
alias ga='git add'
alias gb='git branch' # list branches
alias gba='git branch -a' # list all branches
alias gbd='git branch --delete'
alias gbdr='git push origin --delete' # delete remote branch. use: gbdr [branch-name]
alias gbl='git branch --list'
alias gcnv='git commit --no-verify'
alias gcnvm='git commit --no-verify -m'
alias gcp='git cherry-pick'
alias gc='git commit'
alias gca='git commit --amend' # overwrite last commit
alias gd='git diff'
alias gdn='git diff --name-only'
alias gds='git diff --staged'
alias gdsn='gd --staged --name-only'
alias gf='git fetch'
alias gl='git log'
alias glf='git log --name-only' # log includes list of files changed
alias glm='git log --merge' # list of commits that conflict during merge
alias gm='git merge'
alias gmm='git merge master; git status'
alias go='git checkout' # switch branch
alias gob='git checkout -b' # create new branch, switch to it
alias gom='git checkout master'
alias gomu='git checkout master && git pull --rebase'
alias go-='git checkout -'
alias gp='git push'
alias gpf='git push --force'
alias gpu='git push --set-upstream origin' # use: gpu branch-name
alias grc='git reset HEAD^' # reset to state before last commit, keeping changes
alias gr='git reset && git status'
alias grh='git reset --hard; git status;
alias grbi="git rebase --interactive" # use: `grbi [commit-hash-before-changes]. effect: Merge together all commits AFTER [commit-hash]. Refer: https://www.internalpointers.com/post/squash-commits-into-one-git. Use `git push --force origin [branch-name], but this isn't great... aim to avoid rebasing and squashing with by using git commit --amend in the first place.
alias gs='git status'
alias gsd='git status; git diff'
alias gss='git status -s' # git status --short
alias gsn="git status -s | sed 's#.*/##'" # git status --short
alias gsh='git show'
alias gshn='git show --name-only' # list files changed in latest commit
alias gst='git stash save; git status' # `gst "message"` locally save uncommited changes (both staged and unstaged)
alias gsta='git stash apply; git status' # apply stashed changes to working copy, without deleting from stash.
alias gstd='git stash drop' # delete a stash
alias gstk='git stash save --keep-index; git status' # keeps staged changes and stashes un-tracked changes
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
function gcm () { [[ $@ != '' ]] && { COMMIT_MESSAGE="$@" ; git commit -m "$COMMIT_MESSAGE" } || git commit ; git status}
function gcnvm () { [[ $@ != '' ]] && { COMMIT_MESSAGE="$@" ; git commit --no-verify -m "$COMMIT_MESSAGE" } || git commit --no-verify; git status}
function gcam () { [[ $@ != '' ]] && { COMMIT_MESSAGE="$@" ; git commit --amend -m "$COMMIT_MESSAGE" } || git commit --amend ; git status}
function gcamp () { COMMIT_MESSAGE=$(git reflog -1 | sed 's/^.*: //') ; gcam "$COMMIT_MESSAGE" ; git status}

alias gcd='$(git rev-parse --show-toplevel)' # cd to repo root
alias gbn="git rev-parse --abbrev-ref HEAD" # return current branch name
alias gfiles='echo "$(git ls-files --others --exclude-standard ; git diff --name-only; git diff --staged --name-only)"' # list modified files
alias gbranches='git for-each-ref --format="%(refname:short)" refs/' # list all branches
alias gbranches_raw='{branches=$(gbranches); echo ${branches//origin\/};}' # list all branches, sans 'origin/' prefic

## Git (helper-assisted)
alias ga.='gcd; ga .; gs; -'
### compare current branch to master on github website
alias ghbc='{CURRENT_BRANCH=$(gbn); CURRENT_REPO=$(cut -d . -f 1 <<< $(cut -d : -f 2 <<< $(git config --get remote.origin.url))); o https://github.com/"$CURRENT_REPO"/compare/"$CURRENT_BRANCH";}'
### compare current branch to master on gitlab website
alias glbc='{CURRENT_BRANCH=$(gbn); CURRENT_REPO=$(cut -d / -f 2,3 <<< $(cut -d . -f 2 <<< $(git config --get remote.origin.url))); o https://gitlab.com/"$CURRENT_REPO"/-/compare/master..."$CURRENT_BRANCH";}'
### misc
alias gbnc='gbn | copy'
alias gpu='gbn | xargs git push --set-upstream origin'
alias glag='gl | ag'
function gac() { ga. ; gcm "$@"; gs }
function gacp() { ga. ; gcm "$@" ; gp; gs }
function gacpu() { ga. ; gcm "$@" ; gpu; gs }
function gacnvp() { ga. ; gcnvm "$@" ; gp; gs }
function gacnvpu() { ga. ; gcnvm "$@" ; gpu; gs }

### fzf
alias gaf='gcd ; gfiles | fzf8 | xargs git add ; gs; -' # fzf-assisted git add
alias gbdf='gcd ; gbranches_raw | fzf8 | xargs git branch --delete' # fzf-assisted git delete branch
alias gbdrf='gcd ; gbranches_raw | fzf8 | xargs git push origin --delete' # fzf-assisted git delete remote branch
alias gdf='gcd ; gfiles | fzf8 | xargs git diff ; -' # fzf-assisted git diff
alias gdsf='gcd ; gfiles | fzf8 | xargs git diff --staged ; -' # fzf-assisted git diff
alias gof='gcd ; gfiles | fzf8 | xargs git checkout ; gs; -' # fzf-assisted git checkout
alias gobf='gbranches_raw | fzf8 | xargs git checkout' # fzf-assisted git checkout branch
alias grf='gcd ; git diff --staged --name-only | fzf -m --height=8 | xargs git reset ; gs; -'
alias grmf='gcd ; git diff --name-only --diff-filter=U | fzf -m --height=8 | xargs git rm ; gs; -'

## Github CLI
alias ghprv='gh pr view --web'
alias ghprc='gh pr create --fill --draft ; gh pr view --web'
alias ghprc-nodraft='gh pr create --fill ; gh pr view --web'
alias ghprs='gh search prs'
alias ghprscp='gh search prs "author:chrispalmo"'
alias ghprscpo='gh search prs "author:chrispalmo" "is:open"'
alias ghprscpm='gh search prs "author:chrispalmo" "is:merged"'

## Gitlab CLI
alias glmrv='glab mr view'
alias glmrc='glab mr create'
alias glprv='glmrv'
alias glprc='ghmrv'

## Azure DevOps (ADO) CLI
alias azprc='az repos pr create --open --draft'
alias azprl='az repos pr list -o table --creator cpalmieri@microsoft.com'
alias azpr#='git rev-parse --abbrev-ref HEAD |  \
                xargs az repos pr list -s | \
                grep pullRequestId | \
                sed -n "s/^.*[^0-9]\([0-9][0-9]*\).*/\1/p"'
# View a pull request on ADO web
#
# $1 - The pull request number (PR#). If this argument is not supplied,
#      defaults to the first PR# associated with the current branch.
#
# Examples
#   azprv
#   azprv 12345
function azprv() {
    if [ -z "$1" ]; then
        PR_NUMBER=`azpr#`
    else
        PR_NUMBER="$1"
    fi
    open -na "Google Chrome" --args "https://dev.azure.com/onedrive/Clipchamp/_git/clipchamp-stack/pullrequest/$PR_NUMBER"
}

# ================ #
# Project-specific #
# ================ #

# anki-gen
alias ags="dv; cd anki-gen; ys"

# cc-stack
CS1=~/dev/cs1
CS2=~/dev/cs2
CS3=~/dev/cs3
CS4=~/dev/cs4

CR1=~/dev/cr1
CR2=~/dev/cr2
CR3=~/dev/cr3

export MS_ALIAS=cpalmieri

alias t8cs="t8 start cs"

alias cc1="make --directory=$CS1 --no-print-directory --"
alias cc2="make --directory=$CS2 --no-print-directory --"
alias cc3="make --directory=$CS3 --no-print-directory --"
alias cc4="make --directory=$CS4 --no-print-directory --"

alias cs1="deactivate_venv; $CS1; pwd"
alias cs1f="cs1; pwd; git status; cc1 start-create"
alias cs1b="cs1; pwd; git status; cc1 start-backend"
alias cs1bp='cs1; pwd; git status; podman machine start; yarn bazelisk run //apps/create:backend_docker;'
alias cs1install="cs1; cc1 install-requirements"
alias cs1clone="cd ~/dev; git clone https://${MS_ALIAS?}@dev.azure.com/onedrive/Clipchamp/_git/clipchamp-stack cs1; git lfs pull; cs1install"
alias cs1e2e="cs1; cd tools/test/create_e2e && npm run create-e2e:dev && gcd"
alias cs1test="cs1; gcd && cd apps/create && yarn test:file"
alias t8cs1="t8 start cs1"

alias cs2="deactivate_venv; $CS2; pwd"
alias cs2f="cs2; pwd; git status; cc2 start-create"
alias cs2b="cs2; pwd; git status; cc2 start-backend"
alias cs2bp='cs2; pwd; git status; podman machine start; yarn bazelisk run //apps/create:backend_docker;'
alias cs2install="cs2; cc2 install-requirements"
alias cs2clone="cd ~/dev; git clone https://${MS_ALIAS?}@dev.azure.com/onedrive/Clipchamp/_git/clipchamp-stack cs2; git lfs pull; cs2install"
alias cs2e2e="cs2; cd tools/test/create_e2e && npm run create-e2e:dev && gcd"
alias cs2test="cs2; gcd && cd apps/create && yarn test:file"
alias t8cs2="t8 start cs2"

alias cs3="deactivate_venv; $CS3; pwd"
alias cs3f="cs3; pwd; git status; cc3 start-create"
alias cs3b="cs3; pwd; git status; cc3 start-backend"
alias cs3bp='cs3; pwd; git status; podman machine start; yarn bazelisk run //apps/create:backend_docker;'
alias cs3install="cs3; cc3 install-requirements"
alias cs3clone="cd ~/dev; git clone https://${MS_ALIAS?}@dev.azure.com/onedrive/Clipchamp/_git/clipchamp-stack cs3; git lfs pull; cs3install"
alias cs3e2e="cs3; cd tools/test/create_e2e && npm run create-e2e:dev && gcd"
alias cs3test="cs3; gcd && cd apps/create && yarn test:file"
alias t8cs3="t8 start cs3"

alias cs4="deactivate_venv; $CS4; pwd"
alias cs4f="cs4; pwd; git status; cc4 start-create"
alias cs4b="cs4; pwd; git status; cc4 start-backend"
alias cs4bp='cs4; pwd; git status; podman machine start; yarn bazelisk run //apps/create:backend_docker;'
alias cs4install="cs4; cc4 install-requirements"
alias cs4clone="cd ~/dev; git clone https://${MS_ALIAS?}@dev.azure.com/onedrive/Clipchamp/_git/clipchamp-stack cs4; git lfs pull; cs4install"
alias cs4e2e="cs4; cd tools/test/create_e2e && npm run create-e2e:dev && gcd"
alias cs4test="cs4; gcd && cd apps/create && yarn test:file"
alias t8cs4="t8 start cs4"

alias cr1="cd $CR1"
alias cr1install="cr1; yarn install; cd libs/content; yarn prepare; cr1; cd libs/content-hooks; yarn prepare; cr1"
alias cr1a="cr1; yarn workspace content-repo-api dev"
alias cr1f="cr1; yarn workspace portal dev"
alias cr1b="cr1; yarn workspace portal-backend start:ts"

alias adocs="chrome 'https://dev.azure.com/onedrive/Clipchamp/_git/clipchamp-stack'"
alias adoprs="chrome 'https://dev.azure.com/onedrive/Clipchamp/_git/clipchamp-stack/pullrequests?_a=mine'"
alias ado="adoprs"

alias ghcs="chrome 'https://github.com/clipchamp/clipchamp-stack'"
alias ghcr="chrome 'https://github.com/clipchamp/content-repository'"

alias csgs="cs1; gs; echo; cs2; gs; echo; cs3; gs; echo"
alias csinstall="csgs; cs1; gomu; cs1install; cs2; gomu; cs2install; cs3; gomu; cs3install"

# ==== #
# Path #
# ==== #

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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/cp/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/cp/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/cp/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/cp/google-cloud-sdk/completion.zsh.inc'; fi

# Open tmux, ensuring
#   1. `tmux` exists on system
#   2. we are inside an interactive shell
#   3. `tmux` doesn't run inside iteself
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# Import ad-hoc, untracked aliases
source ~/.files/.scratch

# MSFT Torus
source ~/.torusrc
