#=========================#
# Yamakuzuryu ZSH Aliases #
#=========================#

# Variables
DIR_APPLE_CLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
DIR_GOOGLE_CLOUD="$HOME/Google Drive/My Drive"

# Directories
alias dir.appleCloud='cd "$DIR_APPLE_CLOUD"'
alias dir.appleCloud.dots='cd "$DIR_APPLE_CLOUD"/Dotfiles'
alias dir.googleCloud='cd "$DIR_GOOGLE_CLOUD"'

# Yarn
alias y.i='yarn install'
alias y.c='yarn cache clean'
alias y.s='yarn start'
alias y.t='yarn types'
alias y.y='rm -rf node_modules && y.i && y.s'

# Git
alias g.a='git add .'

alias g.br='git branch' # list local branches or create a new branch
alias g.br.all='git branch -a' # list all branches
alias g.br.create='git checkout -b' # create new branch and switch to it
alias g.br.delete='git branch -d' # delete local branch
alias g.br.deleteForce='git branch -D' # delete local branch by force
alias g.br.deleteRemote='git push origin -d' # delete remote branch
alias g.br.deleteMerged='git branch --merged master | grep -v "master" | xargs git branch -D' # delete merged local branches
alias g.br.deleteMergedRemote='git branch -r --merged origin/master | grep mbohman | cut -d"/" -f 2-| xargs -pL1 git push origin --delete' # delete merged remote branches

alias g.ch='git checkout' # switch branch

alias g.co='git commit -a' # stages files for commit
alias g.co.merge='git commit -a --no-verify' # stages files for commit without running pre-commit hooks
alias g.co.message='git commit -am' # stages files for commit with message
alias g.co.amend='git commit --amend --reuse-message=HEAD'

alias g.d='git diff'
alias g.d.owners='git diff origin/HEAD...HEAD --name-only'
alias g.dt='git difftool .'
alias g.dt.committed='git difftool origin `git_current_branch`..HEAD'
alias g.dt.staged='git difftool --staged'

alias g.f='git fetch --all --prune'

alias g.m='git merge'
alias g.mm='g.f && g.m origin/HEAD'
alias g.mt='git mergetool'

alias g.mv='git mv' # move files and keep history

alias g.p='git fetch --all --prune && git pull'
alias g.pu='git push'
alias g.pub='git push --set-upstream origin `git_current_branch`'

alias g.s='git status'

alias g.rm='git rm -r' # recursively removes files from the working tree and from the index

alias g.reset='git reset --hard'
alias g.reset.origin='git reset --hard origin/HEAD'

alias g.wt.list='git worktree list'
alias g.wt.add='git worktree add'
alias g.wt.remove='git worktree remove'
alias g.wt.prune='git worktree prune'
alias g.wt.prune.all='git worktree prune --all'
alias g.wt.prune.all.force='git worktree prune --all --force'
alias g.wt.prune.all.force.all='git worktree prune --all --force --all'
alias g.wt.prune.all.force.all.force='git worktree prune --all --force --all --force'

## Git Misc
alias g.cherry='git cherry-pick' # cherry pick a commit to another branch

alias g.contribs='git shortlog -sn --no-merges --all'
alias g.contribs.merges='git shortlog -sn --all'
alias g.contribs.lines='git log --author="mbohman@bamboohr.com" --author="mikebohman@gmail.com" --pretty=tformat: --numstat | awk '\''{ adds += $1; subs += $2; loc += $1 - $2 } END { printf "Added: %s \nDeleted: %s \nTotal: %s \n", adds, subs, loc; if (subs != 0) printf "Added/Deleted Ratio: %s\n", adds/subs; else print "Added/Deleted Ratio: N/A (no deletions)\n" }'\'' -'


alias g.log='git log --all --decorate --oneline --graph'
alias g.log.pretty='g.log --date=short --no-merges --pretty=format:"%C(bold blue)%h%C(reset) - %C(bold green)%ad%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)"'

alias g.stash='git stash -u' # stash working directory of changes including untracked files
alias g.stash.apply='git stash apply' # applies stash but leaves it in the list
alias g.stash.clear='git stash clear' # removes all stashes from the list
alias g.stash.drop='git stash drop' # removes stash from the list
alias g.stash.list='git stash list' # show list of stashes
alias g.stash.pop='git stash pop' # applies stash and removes it from the list
alias g.stash.save='git stash save -u' # stash working directory of changes including untracked files with a specified name
alias g.stash.show='git stash show' # show stash differences

# Misc
alias kill.node='sudo killall node'

# Source Files
alias source.gitconfig='source ~/.gitconfig'
alias source.zshrc='source ~/.zshrc'
