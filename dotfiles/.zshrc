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
alias be='bundle exec'

## ZSH Options ####

# please save my history ZSH
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.history_zsh

# Use keychain to start and manage ssh-agent
sj_setup_ssh_agent() {
    local kcfiles file keyhost
    keyhost=jburris # use a fixed hostname, no nfs here

    if [[ `whoami` == 'jburris' ]]; then
        kcfiles=()
        for file in id_rsa id_rsa.zeevex ; do
            [[ -r ~/.ssh/$file ]] && kcfiles+="$file"
        done
        if [[ -n $kcfiles ]] ; then
            keychain --agents ssh --host "$keyhost" -q "$kcfiles[@]"
            source "$HOME/.keychain/${keyhost}-sh"
        else
            fgrep ForwardAgent ~/.ssh/config >&| /dev/null || \
                echo "No keyfiles for ssh_agent or ForwardAgent!"
        fi
    fi
}

sj_setup_ssh_agent
>>>>>>> 44759586e4f82eac2789a749d52917e5b583ab6a
