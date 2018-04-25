#! /bin/sh
/usr/bin/x11vnc -auth guess -noxdamage -rfbport 5900 -shared -forever -bg -xkb -nopw -accept popup:0 &> /dev/null
