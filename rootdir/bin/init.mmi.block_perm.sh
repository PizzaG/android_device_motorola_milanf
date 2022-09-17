#!/vendor/bin/sh

block_by_name=/dev/block/bootdevice/by-name
utags=${block_by_name}/utags
utags_backup=${block_by_name}/utagsBackup
CHMOD_L_FLAG=-L

# Set correct permissions for UTAGS
/vendor/bin/chown -L root:system $utags
/vendor/bin/chown -L root:system $utags_backup
/vendor/bin/chmod ${CHMOD_L_FLAG} 0660 $utags
if [ $? -ne 0 ]; then
  CHMOD_L_FLAG=" "
  /vendor/bin/chmod ${CHMOD_L_FLAG} 0660 $utags
fi
/vendor/bin/chmod ${CHMOD_L_FLAG} 0660 $utags_backup


# HOB/DHOB
hob=${block_by_name}/hob
dhob=${block_by_name}/dhob
/vendor/bin/chown -L radio:radio $hob
/vendor/bin/chown -L radio:radio $dhob
/vendor/bin/chmod ${CHMOD_L_FLAG} 0660 $hob
/vendor/bin/chmod ${CHMOD_L_FLAG} 0660 $dhob

# CLOGO
clogo=${block_by_name}/clogo
/vendor/bin/chown -L root:vendor_tcmd $clogo
/vendor/bin/chmod ${CHMOD_L_FLAG} 0660 $clogo

#CID
cid=${block_by_name}/cid
/vendor/bin/chown -L root:vendor_tcmd $cid
/vendor/bin/chmod ${CHMOD_L_FLAG} 0660 $cid

#BL logs
logs=${block_by_name}/logs
if [ -f $logs ]; then
  /vendor/bin/chown -L root:system $logs
  /vendor/bin/chmod ${CHMOD_L_FLAG} 0640 $logs
fi
