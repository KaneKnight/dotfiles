# postgres.zsh

if [ -d "${HOME}/root/opt/pgsql/bin" ] ; then
	PATH="${HOME}/root/opt/pgsql/bin${PATH:+:${PATH}}"
fi
