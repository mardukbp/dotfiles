#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# {{{ Prompt

PS1='\[\e[38;5;103m\][\u@\h \W]\$\[\e[0;93m\] '

# Different colors for text entry and console output
trap 'echo -ne "\e[0m"' DEBUG

# }}}

# Required for Java apps: muCommander, JabRef
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

# {{{ Aliases

alias sympy='isympy -Iq'
alias bc='bc -q -l'

alias ls='ls --color=auto --group-directories-first' 
alias pong='ping -c3 www.google.com'
alias ed='emacsclient -c'
alias open='xdg-open'
alias sudo='sudo '

alias octave='octave -q --traditional'

alias pylab='ipython --no-banner --pylab'

alias grep='grep -i' # Case insensitive grep

# In order to always save attachments in temp
alias mutt='cd ~/temp && mutt'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'

alias muttrc='vim ~/.mutt/muttrc'

alias sleep='sudo systemctl suspend'
alias sdown='sudo shutdown -h now'

alias bashrc='emacsclient -c ~/.bashrc'
alias vimrc='vim ~/.vimrc'
alias ranrc='vim ~/.config/ranger/rc.conf'
alias hosts='sudo emacsclient -c /etc/hosts'

#alias pacman='sudo pacman'
alias pacup='sudo pacman -Syu '

alias aurin='pacaur -S '
alias aurse='pacaur -Ss '
alias aurup='pacaur -u '

alias texup='sudo tlmgr update --all'

alias pdfxv='wine ~/.wine/drive_c/Program\ Files/Tracker\ Software/PDF\ Viewer/PDFXCview.exe' 

alias emacsd='(emacs --daemon &)'

alias pynbtesis='ipython notebook --pylab inline --profile=tesis'

alias pynb='ipython notebook --pylab=inline --profile=default'

# }}}

# {{{ Environment variables

export EDITOR="emacsclient -c"

#export PATH="/home/marduk/anaconda/bin":$PATH

export PATH="/home/marduk/bin":$PATH
export PATH="/usr/local/texlive/2013/bin/x86_64-linux":$PATH

# This will source environment variables for gpg daemon 
#if [ -f "${HOME}/.gnupg/gpg-agent.env" ]; then 
#  . "${HOME}/.gnupg/gpg-agent.env" 
#fi 

#export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
#export PATH=/opt/cuda/bin/:$PATH


# }}}

# Bash bookmarks
source ~/.bashDirB

# {{{ Save and restore zathura session

OPEN_FILES="/home/marduk/.open_files"
WIN_WS="/home/marduk/.windows_workspaces"

stor() {
    # List of files currently open in zathura.

    ps aux | grep zathura | egrep "(\.pdf|\.djvu)" | sed 's/^.* \//\//g' | sed 's/.*/zathura \"&\" \&> \/dev\/null \&/' > $OPEN_FILES

    # Save list of windows and their corresponding workspace
    # Requires libwnck3, python2-libwnck
    window_position.py -s $WIN_WS
}

# Open recent files

rstor() {

    bash $OPEN_FILES

    # Move windows to corresponding workspace
    sleep 8
    window_position.py -r $WIN_WS
}

# }}}

# {{{ Fast find file

alias upd8='updatedb -l 0 -o ~/Documents/archivos.db -U ~/Documents/Archivos'

loc8() {
    local PS3="Choose a file or directory: "
    IFS_OLD=$IFS
    IFS=$'\n' # Use a newline character as field separator

    db_loc="/home/marduk/Documents/archivos.db"
    sed_dir="\/home\/marduk\/Documents\/Archivos\/"
    base_dir="/home/marduk/Documents/Archivos"
    
    # -i: case insensitive, -e: file exists, -l: list N results
    select opt in $(locate -d $db_loc -i -e -l 30 "$1" | sed "s/$sed_dir//") quit
    do
        if [[ $opt = "quit" ]]
        then
           break
        fi
	
        read -p "Choose [e]dit, [o]pen , [p] parent, [v]isit:" -s var_option
	
        if [[ $var_option == "e" ]]
	then
	    nano "$base_dir/$opt"
            break
	elif [[ $var_option == "o"  ]]
	then
            open "$base_dir/$opt" &> /dev/null
            break
        elif [[ $var_option == "p" ]]
	then
	    parent=${opt%/*}
	    cd "$base_dir/$parent"
	    break
        elif [[ $var_option == "v" ]]
        then
            cd "$base_dir/$opt"
            break
        fi
    done
    IFS=$IFS_OLD # Restore field separator variable
}

# }}}

source ~/Personal/private/icn
source ~/Personal/private/iimas

# Color man ouput
man() {
    env LESS_TERMCAP_mb=$(printf "\e[38;5;208m") \
	LESS_TERMCAP_md=$(printf "\e[38;5;208m") \
	LESS_TERMCAP_me=$(printf "\e[0m") \
	LESS_TERMCAP_se=$(printf "\e[0m") \
	LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
	LESS_TERMCAP_ue=$(printf "\e[0m") \
	LESS_TERMCAP_us=$(printf "\e[38;5;148m") \
	man "$@"
}

cdl () { cd "$1" && ls; }
encpdf () { pdftk "$1" cat output "$2" user_pw "$3"; }
pacinfo () { pacman -Qi "$1" | less; }
pdfex () { qpdf "$1" --pages "$1" "$2" -- "$3"; }

# Added by Canopy installer on 2013-07-10
# VIRTUAL_ENV_DISABLE_PROMPT can be set to '' to make bashprompt show that Canopy is active, otherwise 1
#VIRTUAL_ENV_DISABLE_PROMPT=1 source /home/marduk/Enthought/Canopy_64bit/User/bin/activate
