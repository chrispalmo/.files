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
	VENV="%{%B%F{39}%}($BN)%{%f%b%} "
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

# Keyboard brightness controls
alias kbb='mac-brightnessctl'
kbb-get() { kbb | awk '{print $3}'; }
kbb-max() { kbb 1.0; }
kbb-min() { [[ "$(kbb-get)" == "0.01" ]] && kbb 0 || kbb 0.01; }
kbb-up() { kbb $(echo "$(kbb-get) + 0.2" | bc | awk '{print ($1>1.0)?"1.0":$1}'); }
kbb-down() { kbb $(echo "$(kbb-get) - 0.2" | bc | awk '{print ($1<0)?"0":$1}'); }

# Get names of all repos (public and private) from a github user (provided as first arg)
alias gh_repos='gh repo list "$1" --limit 1000 --json name --jq ".[].name"'

# Clone a GitHub repo via SSH.
# Usage: gh_clone_ssh <github_user> <repo_name>
# Example: gh_clone_ssh chrispalmo my-repo
function gh_clone_ssh() {
    if [ $# -ne 2 ]; then
        echo "Usage: gh_clone_ssh <github_user> <repo_name>"
        return 1
    fi
    git clone "git@github.com:$1/$2.git"
}
alias ghc='gh_clone_ssh'

# Fuzzy-select and clone a GitHub repo via SSH.
function gh_fzf_clone() {
    local user=${1:-chrispalmo}
    [[ "$1" == "" ]] && echo "No username provided, defaulting to chrispalmo"
    local repo=$(gh repo list "$user" --limit 1000 --json name,url --jq ".[] | select(.url | contains(\"$user\")) | .name" | fzf --prompt="Select repo to clone: ")
    [[ -n "$repo" ]] && gh repo clone "$user/$repo"
}
alias ghcf='gh_fzf_clone'

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
function mcd() { mkdir -p $1 && cd $1 ;}

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
cd() { builtin cd "$@" && pwd && ls -lAh; }

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
alias gdrive='cd "/Users/cp/Google Drive/My Drive"'
alias dl="cd ~/Downloads/"
alias dv="cd ~/dev/"
alias notes="~/Dropbox/apps/byword/notes"

# Misc
alias l='pwd && ls -lAh'
alias lc='clear && pwd && ls -lAh'
alias cl='lc'
alias cp='cp -i'
alias mv='mv -i'
alias x='xargs'
alias e='echo'

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

if command -v pbcopy &>/dev/null; then
  # mac
  copy() { tr -d '\n' | pbcopy; }
elif command -v xclip &>/dev/null; then
  # linux (X11)
  copy() { tr -d '\n' | xclip -selection clipboard; }
fi
alias cwd='pwd | copy'

alias h='history'
alias ppath="echo $PATH | tr ':' '\n'" # print path
alias q="exit"
alias c="clear"

alias d="deactivate_venv"

# Tmux
alias qa='tmux kill-server && exit' # kill all tmux sessions
alias t8='tmuxinator'
alias t8s='tmuxinator start'

alias vc='nvim ~/.vimrc'
alias zc='nvim ~/.zshrc'
alias .zc='source ~/.zshrc'

alias v='nvim'
alias v.="nvim ."

alias c.='code .'

alias chrome='open -na "Google Chrome" --args' # example usage: chrome "https://example.xyz"

# Yarn
alias y='yarn'
alias ys='yarn start'
alias yt='yarn test'
alias ytw='yarn test:watch'

# Github
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
alias gom='(git show-ref --quiet refs/heads/master && git checkout master) || (git show-ref --quiet refs/heads/main && git checkout main) || echo "No master or main branch found."' # checkout main / master branch
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
function gcm() {
    # If arguments are provided, use them as the commit message
    if [[ -n "$*" ]]; then
        git commit -m "$*"
        return
    fi

    # Check if sgpt is installed
    if ! command -v sgpt &>/dev/null; then
        echo "sgpt is not installed. Opening the standard editor for the commit message."
        git commit
        return
    fi

    # Combine unstaged and staged diffs
    local diff_output
    diff_output=$(git diff && git diff --cached)

    # If no diff is available, fallback to the standard editor
    if [[ -z "$diff_output" ]]; then
        echo "No changes detected. Opening the standard editor for the commit message."
        git commit
        return
    fi

    # Generate a commit message using sgpt
    local commit_message
    commit_message=$(echo "$diff_output" | sgpt "Generate a concise and meaningful one-line commit message \
        describing these changes. Be as specific as possible while remaining within the on-line limit.\
        Reply only with the suggested message - do not enclose it in quotation marks" 2>/dev/null)

    # Fallback if sgpt fails or generates an empty response
    if [[ -z "$commit_message" ]]; then
        echo "sgpt failed to generate a commit message. Opening the standard editor."
        git commit
        return
    fi

    # Display the suggested commit message with formatting
    echo -e "\n\033[1;34mSuggested commit message:\033[0m"
    echo -e "\033[1;32m$commit_message\033[0m\n"
    echo -n "Press Enter to accept, or type an alternative commit message: "

    # Prompt the user for input
    read -r user_input

    # Use the suggested message if the user presses Enter, otherwise use the provided input
    git commit -m "${user_input:-$commit_message}"
}
function gcnvm () { [[ $@ != '' ]] && { COMMIT_MESSAGE="$@" ; git commit --no-verify -m "$COMMIT_MESSAGE" } || git commit --no-verify ;}
function gcam () { [[ $@ != '' ]] && { COMMIT_MESSAGE="$@" ; git commit --amend -m "$COMMIT_MESSAGE" } || git commit --amend ;}
function gcamp () { COMMIT_MESSAGE=$(git reflog -1 | sed 's/^.*: //') ; gcam "$COMMIT_MESSAGE" ;}

alias gcd='$(git rev-parse --show-toplevel)' # cd to repo root
alias gbn="git rev-parse --abbrev-ref HEAD" # return current branch name
alias gfiles='echo "$(git ls-files --others --exclude-standard ; git diff --name-only; git diff --staged --name-only)"' # list modified files
alias gbranches='git for-each-ref --format="%(refname:short)" refs/' # list all branches
alias gbranches_raw='{branches=$(gbranches); echo ${branches//origin\/};}' # list all branches, sans 'origin/' prefix

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
function gac() { ga. ; gcm "$@" ;}
function gacp() { ga. ; gcm "$@" ; gp ;}
function gacpu() { ga. ; gcm "$@" ; gpu ;}
function gacnvp() { ga. ; gcnvm "$@" ; gp ;}
function gacnvpu() { ga. ; gcnvm "$@" ; gpu ;}

alias gtree='git ls-tree -r --name-only HEAD | tree --fromfile'

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

# ==== #
# Path #
# ==== #

# neovim
export PATH="$PATH:/opt/nvim-linux64/bin"

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

# The next line sets up pyenv for managing multiple Python versions
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# The next line enables shell command completion for gcloud.
if [ -f '/Users/cp/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/cp/google-cloud-sdk/completion.zsh.inc'; fi

# Open tmux, ensuring
#   1. `tmux` exists on system
#   2. we are inside an interactive shell
#   3. `tmux` doesn't run inside iteself
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# Local Node.js via `n`
export N_PREFIX="$HOME/.n"
export PATH="$N_PREFIX/bin:$PATH"

# Codename Goose
export PATH="$HOME/.local/bin:$PATH"

# Shell-GPT integration ZSH v0.2
_sgpt_zsh() {
if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    BUFFER+="⌛"
    zle -I && zle redisplay
    BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd" --no-interaction)
    zle end-of-line
fi
}
zle -N _sgpt_zsh
bindkey '^o' _sgpt_zsh
# Shell-GPT integration ZSH v0.2

# Import keys
source ~/.files/.keys

# Import ad-hoc aliases
source ~/.files/.scratch
