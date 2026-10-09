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
alias g.br.delete-force='git branch -D' # delete local branch by force

# Delete local branches already contained in a base ref.
# Usage: g.br.delete-merged [origin/HEAD|main|master]
g.br.delete-merged() {
	local base="${1:-origin/HEAD}"
	local short current name
	local -a victims

	git rev-parse --verify --quiet "${base}^{commit}" >/dev/null || {
		print -u2 "base ref not found: $base (try: g.f)"
		return 1
	}

	short=$(git rev-parse --abbrev-ref "$base")
	short=${short#origin/}
	current=$(git branch --show-current)

	while IFS= read -r name; do
		[[ -z $name || $name == "$current" || $name == "$short" ]] && continue
		victims+=("$name")
	done < <(git branch --merged "$base" --format='%(refname:short)')

	if (( ${#victims} == 0 )); then
		print "No branches merged into $base."
		return 0
	fi

	print "Deleting branches merged into $base:"
	print -l "${victims[@]}"
	git branch -D "${victims[@]}"
}

alias g.ch='git checkout' # switch branch

alias g.co='git commit -a' # stages files for commit
alias g.co.merge='git commit -a --no-verify' # stages files for commit without running pre-commit hooks
alias g.co.message='git commit -am' # stages files for commit with message
alias g.co.amend='git commit --amend --reuse-message=HEAD'

alias g.d='git diff'
alias g.d.owners='git diff origin/HEAD...HEAD --name-only'
alias g.dt='git difftool .'
alias g.dt.committed='git difftool origin "$(git branch --show-current)"..HEAD'
alias g.dt.staged='git difftool --staged'

alias g.f='git fetch --all --prune'

alias g.m='git merge'
alias g.mm='g.f && g.m origin/HEAD'
alias g.mt='git mergetool'

alias g.mv='git mv' # move files and keep history

alias g.p='git fetch --all --prune && git pull'
alias g.pu='git push'
alias g.pub='git push --set-upstream origin "$(git branch --show-current)"'

alias g.s='git status'

alias g.rm='git rm -r' # recursively removes files from the working tree and from the index

alias g.reset='git reset --hard'
alias g.reset.origin='git reset --hard origin/HEAD'

alias g.wt.list='git worktree list'
alias g.wt.add='git worktree add'
alias g.wt.delete='git worktree remove'
alias g.wt.delete.force='git worktree remove --force --force'
alias g.wt.prune='git worktree prune'
alias g.wt.prune.now='git worktree prune --expire now -v'

# Delete linked worktrees whose branch is already merged into a base ref.
# Usage: g.wt.delete-merged [origin/HEAD|main|master]
g.wt.delete-merged() {
	local base="${1:-origin/HEAD}"
	local short main current line wt="" head="" branch="" name
	local -a remove
	local -A merged
	local b

	git rev-parse --verify --quiet "${base}^{commit}" >/dev/null || {
		print -u2 "base ref not found: $base (try: g.f)"
		return 1
	}

	short=$(git rev-parse --abbrev-ref "$base")
	short=${short#origin/}

	while IFS= read -r b; do
		[[ -n $b ]] && merged[$b]=1
	done < <(git branch --merged "$base" --format='%(refname:short)')

	main=$(git worktree list --porcelain | awk '/^worktree / { sub(/^worktree /, ""); print; exit }')
	current=$(git rev-parse --show-toplevel)

	while IFS= read -r line || [[ -n $line ]]; do
		if [[ -n $line ]]; then
			case $line in
				'worktree '*) wt=${line#worktree } ;;
				'HEAD '*) head=${line#HEAD } ;;
				'branch '*) branch=${line#branch } ;;
				detached) branch="" ;;
			esac
			continue
		fi

		if [[ -n $wt && $wt != $main && $wt != $current ]]; then
			if [[ -n $branch ]]; then
				name=${branch#refs/heads/}
				if [[ $name != "$short" && $name != "$base" && -n ${merged[$name]} ]]; then
					remove+=("$wt")
				fi
			elif [[ -n $head ]] && git merge-base --is-ancestor "$head" "$base"; then
				remove+=("$wt")
			fi
		fi
		wt="" head="" branch=""
	done < <(git worktree list --porcelain)

	if (( ${#remove} == 0 )); then
		print "No merged worktrees to remove."
		return 0
	fi

	local p
	for p in "${remove[@]}"; do
		print "Removing $p"
		git worktree remove "$p" || print -u2 "Left in place (dirty, locked, or has submodules): $p"
	done
}

# Delete every linked worktree, including dirty and locked ones.
g.wt.delete-all-force() {
	local main current line wt=""
	local -a remove

	main=$(git worktree list --porcelain | awk '/^worktree / { sub(/^worktree /, ""); print; exit }')
	current=$(git rev-parse --show-toplevel)

	while IFS= read -r line || [[ -n $line ]]; do
		if [[ $line == 'worktree '* ]]; then
			wt=${line#worktree }
		elif [[ -z $line && -n $wt ]]; then
			[[ $wt != $main && $wt != $current ]] && remove+=("$wt")
			wt=""
		fi
	done < <(git worktree list --porcelain)

	if (( ${#remove} == 0 )); then
		print "No linked worktrees to remove."
		return 0
	fi

	print "Force-removing ${#remove} worktree(s). Uncommitted and untracked files in those checkouts will be deleted."
	local p
	for p in "${remove[@]}"; do
		print "Removing $p"
		git worktree remove --force --force "$p" || print -u2 "Failed: $p"
	done
}

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
