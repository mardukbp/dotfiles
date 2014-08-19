export DE=generic

# Natural scrolling
xinput set-button-map 16 1 2 3 5 4 6 7 8 9 10 11 12
xinput set-button-map 11 1 2 3 5 4 6 7

(sh ~/.screenlayout/monitor.sh)
#(setxkbmap es -option 'numpad:mac') &
(~/bin/setxkblatam) &
conky &
(~/bin/moin/wikiserver.py) &
(cd ~/Tesis/IPython && ipython2 notebook --pylab=inline --profile=tesis) &
(cd ~/IPyNb && ipython2 notebook --pylab=inline --profile=default) &
(cd ~/Julia && ipython notebook --profile julia) &
(synclient TapButton1=0 && synclient PalmDetect=1) &
(xbacklight -set 40)&
volumeicon &
udiskie &
urxvtd &
emacs --daemon &
exec awesome
