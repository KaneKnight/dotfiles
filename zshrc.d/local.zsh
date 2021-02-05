# local.zsh

p=
if [ -d "${HOME}/root/opt/bin" ] ; then
	p="${p:+${p}:}${HOME}/root/opt/bin"
fi


PATH=${p:+${p}:}${PATH}

