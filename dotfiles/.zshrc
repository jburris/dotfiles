#!/bin/zsh

# ---- CUSTOM SETTINGS ---- #

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
