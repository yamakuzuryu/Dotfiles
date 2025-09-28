#===============================#
# Yamakuzuryu Git Configuration #
#===============================#

[core]
	excludesfile = ~/.gitignore

[diff]
	tool = Kaleidoscope
[difftool]
	prompt = false
[difftool "Kaleidoscope"]
	cmd = ksdiff --partial-changeset --relative-path \"$MERGED\" -- \"$LOCAL\" \"$REMOTE\"

[merge]
	tool = Kaleidoscope
[mergetool]
	prompt = false
[mergetool "Kaleidoscope"]
	cmd = ksdiff --merge --output \"$MERGED\" --base \"$BASE\" -- \"$LOCAL\" --snapshot \"$REMOTE\" --snapshot
	trustexitcode = true

[user]
	email = mbohman@gmail.com
	name = Mike Bohman

[includeIf "gitdir:~/repos/"]
	path = ~/.gitconfig-work
