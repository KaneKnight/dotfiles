# .zshrc

HISTSIZE=1000000
SAVEHIST=$HISTSIZE

setopt hist_reduce_blanks
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt inc_append_history
setopt share_history

# zplug
source ~/workbench/dotfiles/init.zsh

# Kane
zplug KaneKnight/dotfiles, use:"zshrc.d/*", defer:2
zplug "themes/agnoster", from:oh-my-zsh, as:theme
zplug "agkozak/zsh-z"
zplug "plugins/git", from:oh-my-zsh

# [zplug] load plugins
zplug load


# Drop duplicates from PATH
typeset -aU path
