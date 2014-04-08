export DE=xfce

# Natural scrolling
xinput set-button-map 16 1 2 3 5 4 6 7 8 9 10 11 12
xinput set-button-map 11 1 2 3 5 4 6 7

(sh ~/.screenlayout/monitor.sh)
(setxkbmap es -option 'numpad:mac') &
#(setxkbmap us -option 'caps:super' -option 'numpad:mac') &
(xmodmap -e "keycode 66 = Shift_L NoSymbol Shift_L") &
conky &
(~/bin/moin/wikiserver.py) &
(ipython2 notebook --pylab=inline --profile=tesis) &
(ipython2 notebook --pylab=inline --profile=default) &
(synclient TapButton1=0 && synclient PalmDetect=1) &
(xbacklight -set 40)&
volumeicon &
udiskie &
urxvtd &
emacs --daemon &
exec awesome
