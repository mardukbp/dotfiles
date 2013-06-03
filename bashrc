#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# {{{ Prompt

PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0;93m\] '

# Different colors for text entry and console output
trap 'echo -ne "\e[0m"' DEBUG

# }}}

# Required for muCommander
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

# {{{ Aliases

alias ls='ls --color=auto'
alias pong='ping -c3 www.google.com'
alias ed='emacsclient -c'
alias open='xdg-open'
alias sudo='sudo '

alias octave='octave -q --traditional'

alias pylab='ipython --no-banner --pylab'
alias pynb='ipython notebook --pylab=inline --notebook-dir=/media/Archivos/Documents/pynb'

alias grep='grep -i' # Case insensitive grep

# In order to always save attachments in temp
alias mutt='cd /media/Archivos/temp && mutt'

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

alias pacman='sudo pacman'
alias pacup='sudo pacman -Syu '

alias aurin='pacaur -S '
alias aurse='pacaur -Ss '
alias aurup='pacaur -u '

alias texup='sudo tlmgr update --all'

alias pdfxv='wine ~/.wine/drive_c/Program\ Files/Tracker\ Software/PDF\ Viewer/PDFXCview.exe' 


# }}}

# {{{ Environment variables

export EDITOR="emacsclient -c"

#export PATH="/home/marduk/anaconda/bin":$PATH

export PATH="/media/Archivos/bin":$PATH
export PATH="/usr/local/texlive/2012/bin/x86_64-linux":$PATH
export PATH="/media/Archivos/bin/usr/bin":$PATH
export PATH="/home/marduk/Downloads/nbconvert":$PATH

# This will source environment variables for gpg daemon 
if [ -f "${HOME}/.gnupg/gpg-agent.env" ]; then 
  . "${HOME}/.gnupg/gpg-agent.env" 
fi 

#export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
#export PATH=/opt/cuda/bin/:$PATH


# }}}

# Bash bookmarks
source ~/.bashDirB

# {{{ Save and restore zathura session

OPEN_FILES="/home/marduk/open_files.txt"
WIN_WS="/home/marduk/windows_workspaces.txt"

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

alias upd8='updatedb -o /media/Archivos/Documents/archivos.db -U /media/Archivos/Documents/Archivos'

loc8() {
    local PS3="Choose a file or directory: "
    IFS_OLD=$IFS
    IFS=$'\n' # Use a newline character as field separator

    db_loc="/media/Archivos/Documents/archivos.db"
    sed_dir="\/media\/Archivos\/Documents\/Archivos\/"
    base_dir="/media/Archivos/Documents/Archivos"
    
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

source ~/private/icn

encpdf () { pdftk "$1" cat output "$2" user_pw "$3"; }

