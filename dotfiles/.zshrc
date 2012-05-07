# ---- oh-my-zsh ---- #
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
# Set name of the theme to load.
ZSH_THEME="afowler"
# red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(brew)
source $ZSH/oh-my-zsh.sh

# ---- CUSTOM SETTINGS ---- #
alias emacs='open ~/Applications/Emacs.app'

#!/bin/zsh
#
# Use keychain to start and manage ssh-agent
#

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
