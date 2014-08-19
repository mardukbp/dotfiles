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

alias units='units -1 -s -q'

alias setxkblatam='setxkbmap latam -option 'caps:super' -option 'numpad:mac''

alias tcmount='truecrypt --mount ~/Personal/archivero_fiscal /media/truecrypt1 && cd /media/truecrypt1'
alias tcunmount='truecrypt --dismount /media/truecrypt1'

alias ftpmount='curlftpfs 192.168.100.5:2121 ~/WellFTP && cd ~/WellFTP'
alias ftpunmount='fusermount -u ~/WellFTP'

alias sympy='isympy -Iq'
alias pylab='ipython2 --no-banner --pylab'

alias bc='bc -q -l'
alias pong='ping -c3 www.google.com'
alias open='xdg-open'

#alias octave='octave -q --traditional'

# In order to always save attachments in temp
alias mutt='cd ~/temp && mutt'

alias ls='ls --color=auto --group-directories-first' 
alias ln='ln -r'
alias cd='cd -P'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'
alias grep='grep -i' # Case insensitive grep
alias sudo='sudo '

alias sleep='sudo systemctl suspend'
alias sdown='sudo systemctl poweroff'

alias bashrc='vim ~/.bashrc'
alias vimrc='vim ~/.vimrc'
#alias ranrc='vim ~/.config/ranger/rc.conf'
#alias muttrc='vim ~/.mutt/muttrc'
alias hosts='sudo vim /etc/hosts'

#alias pacman='sudo pacman'
alias pacup='sudo pacman -Syu '
#alias aurin='pacaur -S '
#alias aurse='pacaur -Ss '
alias aurup='pacaur -u '

alias texup='sudo tlmgr update --all'
alias texhelp='texdoc latex2e-help-texinfo'

alias pdfxv='open ~/Desktop/PDF-XChange\ Viewer.desktop &'

alias ed='emacsclient -c'
alias emacsd='(emacs --daemon &)'

# }}}

# {{{ Environment variables

#export EDITOR="(if [[ -n $DISPLAY ]]; then echo 'gedit'; else echo 'vim'; fi)"
export EDITOR='vim'
export VISUAL='gedit'

#export PATH="/home/marduk/anaconda/bin":$PATH

export PATH="/home/marduk/bin":$PATH
export PATH=$PATH:"/usr/local/texlive/2014/bin/x86_64-linux"

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

OPEN_FILES_DIR="/home/marduk/.open_files/"
WIN_WS_DIR="/home/marduk/.windows_workspaces/"

stor() {
    # List of files currently open in zathura.

    ps aux | grep zathura | egrep "(\.pdf|\.djvu)" | sed 's/^.* \//\//g' | sed 's/.*/zathura \"&\" \&> \/dev\/null \&/' > $OPEN_FILES_DIR/$1

    # Save list of windows and their corresponding workspace
    # Requires libwnck3, python2-libwnck
    window_position.py -s $WIN_WS_DIR/$1
}

# Open recent files

rstor() {

    local PS3="Choose a file: "
    IFS_OLD=$IFS
    IFS=$'\n' # Use a newline character as field separator

    OPEN_FILES_DIR="/home/marduk/.open_files/"
    WIN_WS_DIR="/home/marduk/.windows_workspaces/"
    cd "$OPEN_FILES_DIR"

    select opt in $(find * -printf "%f\n") quit
    do
        if [[ $opt = "quit" ]]
        then
           break
        fi

        bash $OPEN_FILES_DIR/$opt

        # Move windows to corresponding workspace
        sleep 8
        window_position.py -r $WIN_WS_DIR/$opt

        break
        
    done
    IFS=$IFS_OLD # Restore field separator variable
}

# }}}

# {{{ Fast find file

alias upd8='updatedb -l 0 -o ~/Library/Libros/libros.db -U ~/Library/Libros/Calibre\ Library/'

loc8() {
    local PS3="Choose a file or directory: "
    IFS_OLD=$IFS
    IFS=$'\n' # Use a newline character as field separator

    db_loc="/home/marduk/Library/Libros/libros.db"
    sed_dir="\/home\/marduk\/Library\/Libros\/Calibre\ Library\/"
    base_dir="/home/marduk/Library/Libros/Calibre Library"
    
    # -i: case insensitive, -e: file exists, -l: list N results
    #select opt in $(locate -d $db_loc -i -e -l 10 *"$1"*.djvu | sed "s/$sed_dir//") quit
    select opt in $(find $base_dir -iname *"$1"*.djvu -printf "%f\n" -o -iname *"$1"*.pdf -printf "%f\n") quit
    do
        if [[ $opt = "quit" ]]
        then
           break
        fi

        open "$(find $base_dir -iname "$opt")" &#> /dev/null    
        export TMOUT=1
        break
        read -p "Choose [e]dit, [o]pen , [p]arent, [v]isit:" -s var_option
	
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

# Extract pages from a PDF file
# pdfex file.pdf p1-pn output.pdf
pdfex () { qpdf "$1" --pages "$1" "$2" -- "$3"; }

zathura () { /usr/bin/zathura "$(realpath "$1")"; }

lnabs () { /usr/bin/ln -s "$(realpath "$1")" "$2"; }

timer() { /usr/bin/utimer -c "$1" && mplayer -quiet -nolirc /usr/share/sounds/freedesktop/stereo/complete.oga; }

# Added by Canopy installer on 2013-07-10
# VIRTUAL_ENV_DISABLE_PROMPT can be set to '' to make bashprompt show that Canopy is active, otherwise 1
#VIRTUAL_ENV_DISABLE_PROMPT=1 source /home/marduk/Enthought/Canopy_64bit/User/bin/activate
