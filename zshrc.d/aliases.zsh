# aliases.zsh

# Enable color support of ls and also add handy aliases
if [ -x "$(which dircolors)" ] ; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'

	alias grep='grep --color=auto'
fi

# ls aliases
alias ll='ls -l'
alias la='ls -la'
alias l='ls -CF'
alias lt='ls -lt'
alias ltr='ls -ltr'

# Shortcuts
alias h=history
alias vir='vim -R'

# Git aliases
unalias gl
gl () {
  git --no-pager log --oneline --decorate --graph -n ${1:-20}
}

# Lowercase uuid on mac
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'

alias allmain='find ~/workbench -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} switch main \; -exec git -C {} pull \;'

alias kcd='kubectl --context=arn:aws:eks:eu-west-1:308172169369:cluster/kappa-dev-eks-cluster'
alias kcq='kubectl --context=arn:aws:eks:eu-west-1:308172169369:cluster/kappa-qa-eks-cluster'
alias kcp='kubectl --context=arn:aws:eks:eu-west-1:308172169369:cluster/kappa-prod-eks-cluster'

alias jql='jq -c '\''[.time, .level, .package, .function, .error, .message]'\'''
alias jqlr='jq -c '\''[.time, .level, .caller, .method, .path, .status, .request_id, .error, .message]'\'''
alias jqlv='jq -c '\''[.time, .level, .trace.id, .package, .function, .caller, .user_id, .entity_id, .transaction_id, .error, .message]'\'''
