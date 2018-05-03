#!/bin/sh
 appname="FoxitReader"

 selfpath="/opt/foxitsoftware/foxitreader"
 LD_LIBRARY_PATH=$selfpath/lib:$selfpath/platforms:$selfpath/printsupport:$selfpath/rmssdk:$selfpath/sensors:$selfpath/imageformats:$selfpath/platforminputcontexts:$LD_LIBRARY_PATH
 export LD_LIBRARY_PATH
 exec "$selfpath/$appname" "$@"
