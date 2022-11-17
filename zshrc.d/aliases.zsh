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

# Redis
alias redis='docker run -d --name redis -p 127.0.0.1:6379:6379 redis:5-alpine'

# Arango
alias arango='docker run -d --name arangodb -e ARANGO_NO_AUTH=1 -p 127.0.0.1:8529:8529 arangodb:3.7'

# Lowercase uuid on mac
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'

# tunnel to elwood-dev
alias devtunnel='gcloud compute ssh --zone "europe-west2-c" "kane-knight-temp" --tunnel-through-iap --project "elwood-dev" -- -N -L 2222:localhost:22'

# tunnel to elwood-venues-non-prod
alias venuestunnel='gcloud compute ssh --zone "europe-west2-c" "kane-vm" --tunnel-through-iap --project "elwood-venues-non-prod" -- -N -L 2223:localhost:22'
