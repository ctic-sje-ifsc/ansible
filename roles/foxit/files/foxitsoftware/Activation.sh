#!/bin/sh
 appname=`basename $0 | sed s,\.sh$,,`
 selfpath=$(cd "$(dirname "$0")"; pwd)
 dirname=`dirname $0`
 tmp="${dirname#?}"
 
 if [ "${dirname%$tmp}" != "/" ]; then
 dirname=$PWD/$dirname
 fi
 LD_LIBRARY_PATH=$selfpath/lib:$selfpath/platforms:$selfpath/printsupport:$selfpath/sensors:$selfpath/imageformats:$selfpath/platforminputcontexts:$LD_LIBRARY_PATH
 export LD_LIBRARY_PATH

 #chmod +x $dirname/$appname
 $dirname/$appname "$@"
