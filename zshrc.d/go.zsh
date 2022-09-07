# go.zsh

# if installed manually
if [ -d "${HOME}/root/opt/go/bin" ]; then
	echo "installed go manually"
	export GOROOT="${HOME}/root/opt/go"
	export GOPATH="${HOME}/workbench/go"

	PATH="${GOROOT}/bin:${GOPATH}/bin${PATH:+:${PATH}}"
fi

# if installed via brew install
if [ -f "/usr/local/bin/go" ]; then
	echo "installed go via brew"
	export GOROOT="/usr/local/opt/go/libexec"
	export GOPATH="${HOME}/go"

	PATH="${GOROOT}/bin:${GOPATH}/bin${PATH:+:${PATH}}"
fi
