#!/bin/sh
#
# description:	DNA Server startup script.
#

# Get install path
abs_path()
{
    local path=$1
    local basename=$(basename $path)
    local dirname=$(dirname $path)
    cd $dirname
    if [ -h $basename ]
    then
        path=$(readlink $basename)
        abs_path $path
    else
        pwd
    fi
}

# Init vars
javapath=${PWD}/jre/bin/java
if [ ! -x $javapath ];then
	javapath='java'
fi
jqlog=`date '+%F_%H%M%S'`
install_path="$(abs_path $0)"
cmd=$javapath
params="-Xmx2500m -Xss512m  -Dosgi.console.blockOnReady=true -Dcom.jiuqi.dna.ui.theme=sky -DvncServer=112.74.43.195 -DconsoleServer=112.74.43.195 -DrmServer=120.77.156.215 -Dcustomer=QS  -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5001"
new_jarfile="$install_path/bundles/com.jiuqi.dna.launcher_1.0.0.jar"
old_jarfile="$install_path/thr/com.jiuqi.dna.launcher_1.0.0.jar"
jarfile=$new_jarfile
if [ -f "$new_jarfile" ]
then
    jarfile=$new_jarfile
else
    jarfile=$old_jarfile
fi

# Configuration
ulimit -n 65535

# Run
#"$cmd" $params -jar "$jarfile"
# Run as daemon
nohup "$cmd" $params -jar "$jarfile">>"$install_path/work/$jqlog.log" 2>&1 &
