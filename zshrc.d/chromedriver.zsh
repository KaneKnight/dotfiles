# chromedrivern.zsh

if [ -d "${HOME}/root/opt/chromedriver" ] ; then
	PATH="${HOME}/root/opt/chromedriver${PATH:+:${PATH}}"
fi
