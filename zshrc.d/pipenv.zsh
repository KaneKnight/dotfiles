# pipenv.zsh

if [ -d "${HOME}/root/opt/pipenv" ] ; then
	PATH="${HOME}/root/opt/pipenv${PATH:+:${PATH}}"
fi
