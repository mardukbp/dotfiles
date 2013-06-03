export DE=xfce

# Natural scrolling
xinput set-button-map 16 1 2 3 5 4 6 7 8 9 10 11 12
xinput set-button-map 11 1 2 3 5 4 6 7

(sh ~/.screenlayout/monitor.sh)
qxkb &
conky &
(python2 ~/moin-1.9.4/wikiserver.py) &
(synclient TapButton1=0 && synclient PalmDetect=1) &
(xbacklight -set 40)&
volumeicon &
udiskie &
urxvtd &
emacs --daemon &
exec awesome
