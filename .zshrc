# .zshrc

autoload -Uz compinit
compinit

HISTSIZE=1000000
SAVEHIST=$HISTSIZE

setopt hist_reduce_blanks
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt inc_append_history
setopt share_history


# Kane
for file in ~/workbench/dotfiles/zshrc.d/*; do
    source "$file"
done

# theme
source ~/workbench/dotfiles/themes/agnoster-zsh-theme/agnoster.zsh-theme

# plugin
source ~/workbench/dotfiles/plugins/z/z.plugin.zsh
source ~/workbench/dotfiles/plugins/git/git.plugin.zsh

# Drop duplicates from PATH
typeset -aU path
