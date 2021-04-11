#!/bin/tcsh

# Usage Example:
#  ~/rcat/backup.csh 1G /tmp/worlds/jt2 remote:weeklies/tmp_worlds_jt2.tar
#  ~/rcat/backup.csh 100M auth.txt remote:dailies/minetest/worlds/jt2/auth.txt.tar

set CACHE_PATH = "/home/share"
set CHUNK_SIZE = $1
set LOCAL_PATH = $2
set CLOUD_PATH = $3:h
set CHUNK_NAME = $3:t:r

echo "Starting multipart backup for $CHUNK_NAME.tar"

if ( $CHUNK_SIZE =~ *M ) then
	@ CHUNK_SIZE = $CHUNK_SIZE:s/M// * 1024
else if ( $CHUNK_SIZE =~ *G ) then
	@ CHUNK_SIZE = $CHUNK_SIZE:s/G// * 1024 * 1024
endif

echo "1" > $CACHE_PATH/rclone.seq

/bin/tar -L $CHUNK_SIZE -F "$0:h/transfer.csh upload $CACHE_PATH $CHUNK_NAME $CLOUD_PATH" -cvf $CACHE_PATH/rclone.tar $LOCAL_PATH && $0:h/transfer.csh upload $CACHE_PATH $CHUNK_NAME $CLOUD_PATH

rm $CACHE_PATH/rclone.seq
rm $CACHE_PATH/rclone.tar

echo "Finished."
