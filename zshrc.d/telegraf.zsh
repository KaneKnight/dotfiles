# telegraf.zsh

if [ -d "${HOME}/root/opt/telegraf" ] ; then
	PATH="${HOME}/root/opt/telegraf${PATH:+:${PATH}}"
fi
