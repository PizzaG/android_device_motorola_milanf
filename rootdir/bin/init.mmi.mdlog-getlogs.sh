#!/vendor/bin/sh

getlogs_opts="/data/vendor/bug2go/getlogs.opts"
edof_trigger="/data/vendor/bug2go/edof_identfier"
mdlog_user_opts="/data/vendor/diag_mdlog/user3.opts"
qdb_file="/firmware/image/qdsp6m.qdb"
qdb_file_alt="/vendor/firmware_mnt/image/qdsp6m.qdb"

arg_output="/data/vendor/bug2go/modem"
log_file=$arg_output/"getlogs.log"
mkdir $arg_output
chmod g+rwX $arg_output

# The output arg is fixed,
# use the cutomized opts from file if it exists
if [ -f $getlogs_opts ]; then
   args=`cat $getlogs_opts`
   # allow opts_file to be used only once
   mv -f $getlogs_opts $arg_output/
else
   # default value
   args="-b 419430400"
fi

diag_mdlog-getlogs -o $arg_output $args &> $log_file
if [ -f $mdlog_user_opts ]; then
    cp $mdlog_user_opts $arg_output/
fi

# copy qdsp6m.qdb
if [ -f $qdb_file ]; then
    cp $qdb_file $arg_output/
else
   # copy qdsp6m.qdb from alternate folder
   if [ -f $qdb_file_alt ]; then
       cp $qdb_file_alt $arg_output/
   fi
fi

chmod -R g+rw $arg_output
chmod g+X $arg_output/mdm
chmod g+X $arg_output/mdm2

if [ -f $edof_trigger ]; then
   rm -rf /data/vendor/diag_mdlog/logs/*
   rm -f $edof_trigger
fi
