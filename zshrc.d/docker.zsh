# docker.zsh

if [ -d "${HOME}/root/opt/docker" ] ; then
	PATH="${HOME}/root/opt/docker${PATH:+:${PATH}}"
fi
