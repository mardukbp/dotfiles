#!/bin/sh

# Author: John Eikenberry <jae@zhar.net>
# Modified by: Marduk Bolaños <mardukbp@gmail.com>
# License: GPL 3.0 <http://www.gnu.org/licenses/gpl.txt>

# Unpacks all attached files and kicks off an image view on the directory 
# Cleans up the images/directory afterwards.
#
# To use from mutt include this keybinding (replace <F9> with your preference) 
# in the appropriate config file.
#
## view a bunch of attached images
#macro index,pager <F9> "<pipe-message>~/.mutt/view_images.sh<enter>" "View images"

# munpack requires mpack. an equivalent is metamail -wy

#Change this to your favorite image viewer (e.g. gqview, feh)
viewer=viewnior

mbox=`mktemp -t mutt-html-mbox.XXXXXXXXXX` || exit 1
cat - > $mbox
tmpdir=`mktemp -d -t mutt-view-html.XXXXXXXXXX` || exit 1

trap 'cleanup_on_error' 0
cleanup_on_error () {
    if [ "$?" -ne 0 ]; then
	rm -f $files $mbox
	rmdir $tmpdir
    fi
}

cd $tmpdir
files=`munpack -q -t -C $tmpdir $mbox | sed 's/([^()]\+)//g'`

(trap 'cleanup' 0
cleanup () {
    rm -f $files $mbox
    rmdir $tmpdir
}
$viewer $tmpdir) > /dev/null 2>&1 &

## vim: ft=sh
