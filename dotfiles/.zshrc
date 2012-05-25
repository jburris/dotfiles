# ZSH init file
# Invaluable resource :
# http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html
#
# Much of this has been taken from :
# https://github.com/sudish/dotfiles/blob/master/.zshrc

# All parameters subsequently defined are automatically exported.
set -a

# location of zsh configs & etc
ZDIR=~/.zsh.d

# Additional functions and completions
fpath+=$ZDIR/funcitons

autoload -Uz add-zsh-hook #autoload loads the function when its executed, not on startup

# Load ZSH init files, prioritized by name
for file in $ZDIR/init.d/S[0-9][0-9]_*; do
  source $file
done
unset file

alias emacs='open ~/Applications/Emacs.app'

## ZSH Options ####

# please save my history ZSH
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.history_zsh

# Lets get some prompt action going on
PROMPT='%n@%m :: %3c '

