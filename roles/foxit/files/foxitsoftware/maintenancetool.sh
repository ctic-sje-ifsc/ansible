#!/bin/sh
 curuser=/home
 user=$(whoami)
 homedir=/home/$user
 selfpath=$(cd "$(dirname "$0")"; pwd)
 appname=`basename $0 | sed s,\.sh$,,`
 dirname=`dirname $0`
 tmp="${dirname#?}" 
 issuse=$(cat /etc/issue | grep SUSE)
 desktopdir=/home/$user/Desktop/FoxitReader.desktop
 defaultfile=${curuser}/$user/.local/share/applications/defaults.list
 mimefile=${curuser}/$user/.local/share/applications/mimeapps.list
 desktopfile=${curuser}/$user/.local/share/applications/FoxitReader.desktop
    
defaultopen()
{
	#ubuntu os
#	if [ "x$isubuntu" != "x" ]; then
#		rm ${selfpath}/lib/libssl.so.1.0.0
#	fi
	#suse os
	if [ "x$issuse" != "x" ]; then
                xdg-mime default okular.desktop application/pdf
        fi
	#redhat7 os
#	if [ "x$isubuntu" = "x" ] && [ "x$issuse" = "x" ] ; then
#		rm ${selfpath}/lib/libsecret-1.so
#		rm ${selfpath}/lib/libsecret-1.so.0
#		rm ${selfpath}/lib/libsecret-1.so.0.0.0
#	fi
}
    
 if [ "${dirname%$tmp}" != "/" ]; then
    dirname=$PWD/$dirname
 fi
 LD_LIBRARY_PATH=$dirname:$PWD/platforms:$PWD/printsupport;
 export LD_LIBRARY_PATH

 #chmod +x $dirname/$appname
 $dirname/$appname "$@"

 if [ -f "$desktopfile" ]; then 
     rm $desktopfile
 fi
  
 if [ -f "$defaultfile" ]; then 
    sed -i '/application\/pdf=FoxitReader.desktop/d' $defaultfile
    sed -i '/application\/octet-stream=FoxitReader.desktop/d' $defaultfile
 fi 
 
 if [ -f "$mimefile" ]; then 
    sed -i '/application\/pdf=FoxitReader.desktop/d' $mimefile
    sed -i '/application\/octet-stream=FoxitReader.desktop/d' $mimefile
 fi 
 
 #if [ -f "$desktopdir" ]; then
 #   rm $desktopdir
 #fi
 
 if [ "x$user" = "xroot" ]; then
    rm /usr/share/applications/FoxitReader.desktop
    rm $user/.local/share/applications/FoxitReader.desktop
 fi
 
defaultopen;
 
 exit 0