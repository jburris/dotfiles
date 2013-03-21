# Lets have a beautiful path ladies and gentlemen
unsetopt ksh_arrays
d=( ~/bin
    /Applications/Postgres.app/Contents/MacOS/bin
    ~/.rbenv/shims
    /usr/local/share/npm/bin
    /usr/local/share/python
    /usr/local/sbin
    /usr/local/bin
    /sw/sbin
    /sw/bin
    /opt/local/apache2/bin
    /opt/local/sbin
    /opt/local/bin
    /usr/sbin
    /usr/bin
    /sbin
    /bin
    ${(s.:.)${PATH}} )       # zsh pukes if i do this in a typeset
typeset -U d                 # Remove duplicates

s=()
for dir in "$d[@]"; do       # Remove nonexistant dirs
    [[ -d $dir && $dir != '.' ]] && s=($s $dir)
done

PATH=${(j.:.)${s}}           #TODO : Learn what this command is exactly doing
unset d s dir

# ---- RBENV ---- #
eval "$(rbenv init -)"
jb_rbenv_present=1
