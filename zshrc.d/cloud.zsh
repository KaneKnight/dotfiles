# google-cloud-sdk.zsh

if [ -d "${HOME}/root/opt/google-cloud-sdk/bin" ] ; then
	PATH="${HOME}/root/opt/google-cloud-sdk/bin${PATH:+:${PATH}}"
fi
