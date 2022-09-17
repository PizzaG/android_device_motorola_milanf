#!/vendor/bin/sh

wlan_log_path="/data/vendor/wifi/wlan_logs/"
wlan_log_dest_path="/data/vendor/bug2go/wlan_logs"
diag_log_path="/data/vendor/diag_mdlog/logs"
mdm2_log_path="/data/vendor/diag_mdlog/logs/mdm2"
wlan_dump_path="/data/vendor/tombstones/rfs/modem"

cp -r $wlan_log_path $wlan_log_dest_path
chmod g+rwX $wlan_log_dest_path

if [ -d $wlan_dump_path ]
   then echo "Get PD dump file"
   for file in $(ls -1r $wlan_dump_path );
      do cp $wlan_dump_path/$file $wlan_log_dest_path/$file
   done
fi

if [ -d $mdm2_log_path ]
    then echo "Get diag logs"
    for f in $diag_log_path/*.qmdl{,2}
        do
        cp $f $wlan_log_dest_path
        done
    cp -r $mdm2_log_path $wlan_log_dest_path
    chmod g+X $wlan_log_dest_path/mdm2
fi

chmod -R g+rw $wlan_log_dest_path
chown -R log:log $wlan_log_dest_path
